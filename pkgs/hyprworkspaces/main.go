/*
 * Hyprland Workspaces
 * -------------------
 *
 * Listens on hyprland socket and writes workspace state to stdout when needed, in json format
 * Example output:
 *		[{ "index": 0, "state": 2}, { "index": 1, "state": 1}]
 *
 * Meaning of the key "state" can be found in `workspaceState` type constants
 *
 * Modifying/Scripting
 * -------------------
 *
 * To modify the output format, change the `printJson` function
 *
 * ...Why not bash?
 * ----------------
 *
 * Well the bash script I was using was lagging ever so slightly and it irked me enough to rewrite it in go
 **/
package main

// TODO: race conditions exist: do not use hyprctl for queries and track
// workspace state completely internally using only info from socket2
// plus hyprctl is probably a speed bottleneck

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"os/exec"
	"reflect"
	"strconv"
	"strings"
)

var gHyprlandSockPath string
var gLogPath string

const PERSISTENT_WORKSPACES = 6

type workspaceState int

const (
	INACTIVE workspaceState = 0 // No windows in this workspace
	ACTIVE                  = 1 // Has window in this workspace
	FOCUSED                 = 2 // Workspace is focused
)

type hyprState struct {
	workspaces []workspaceState
	changed    bool
}

type server struct {
}

type Server interface {
	startServer()
}

type event struct {
	name, arg string
}
type cmd string

// hyprctl query json return structs
type workspaceJson struct {
	Id int `json:"id"`
	// Name            string `json:"name"`
	// Monitor         string `json:"monitor"`
	// Windows         int    `json:"windows"`
	// Hasfullscreen   bool   `json:"hasfullscreen"`
	// Lastwindow      string `json:"lastwindow"`
	// Lastwindowtitle string `json:"lastwindowtitle"`
}

type clientJson struct {
	// Address   string `json:"address"`
	// At        [2]int `json:"at"`
	// Size      [2]int `json:"size"`
	Workspace struct {
		Id int `json:"id"`
		// Name string `json:"name"`
	} `json:"workspace"`
	// Floating bool   `json:"floating"`
	// Monitor  int    `json:"monitor"`
	// Class    string `json:"class"`
	// Title    string `json:"title"`
	// Pid      int    `json:"pid"`
}

type monitorJson struct {
	Id int `json:"id"`
	// Name string `json:"name"`
	// Desc string `json:"description"`
	ActiveWorspace struct {
		Id   int    `json:"id"`
		Name string `json:"name"`
	} `json:"activeWorkspace"`
}

// (*hyprState).workspacesChanged should be called whenever the workspaceState is
// changed
//
// @param focus int The 0-indexed workspace number to focus, negative indicates to use previously focused workspace
func (hs *hyprState) workspacesChanged(focus int) {
	occupiedWorkspaces, err := hyprqueryWorkspaces()
	if err != nil {
		log.Printf("Error qureying workspaces: %s", err)
		return
	}
	owsID := make([]int, len(occupiedWorkspaces))
	for i, ws := range occupiedWorkspaces {
		owsID[i] = ws.Id
	}

	ws := make([]workspaceState, max(append(owsID, PERSISTENT_WORKSPACES)))

	for _, ows := range occupiedWorkspaces {
		if ows.Id > len(ws) {
			ws = append(ws, make([]workspaceState, ows.Id-len(ws))...)
		} else if ows.Id < 0 {
			// special workspaces start from id -99, -98...
			// these are ignored
			continue
		}

		ws[ows.Id-1] = ACTIVE
	}

	if focus < 0 {
		focus = index(hs.workspaces, FOCUSED)
		if focus < 0 { // no previous focus found
			return
		}
	}
	// try harder to not break
	if focus >= len(ws) {
		// TODO this is so jank
		focus = len(ws) - 1
	}

	ws[focus] = FOCUSED

	if reflect.DeepEqual(ws, hs.workspaces) {
		return
	}

	hs.workspaces = ws
	hs.changed = true
}

func handleHyprEvents(conn net.Conn, hs *hyprState) {
	for {
		var buf [1024]byte
		n, err := conn.Read(buf[:])

		if err != nil {
			if err == io.EOF {
				log.Printf("reading from socket: %s", err)
				return
			}
			log.Printf("reading from socket: %s", err)
		}

		msgs := strings.Split(string(buf[:n]), "\n")

		for _, msg := range msgs {
			if msg == "" {
				continue
			}
			sep := strings.Index(msg, ">>")
			if sep == -1 { // TODO idk why there's so many empty messages
				log.Printf("WARN: skipping invalid message: %s", msg)
				continue
			}

			ev := event{
				msg[:sep],
				msg[sep+2:],
			}

			switch ev.name {
			case "workspace":
				if ws, err := strconv.Atoi(ev.arg); err == nil {
					hs.workspacesChanged(ws - 1)
				} else {
					log.Printf("Error converting event arg to int: %s", err)
					hs.workspacesChanged(-1)
				}
			case "createworkspace", "destroyworkspace":
				hs.workspacesChanged(-1)
			case "openwindow", "closewindow", "movewindow":
				hs.workspacesChanged(-1)

			case "focusedmon":
			case "activewindow":
			case "fullscreen":
			case "monitorremoved":
			case "monitoradded":
			case "activelayout":
			case "openlayer":
			case "closelayer":

			default:
				//log.Printf("WARN: got unrecognized event: %s", ev.name)

			}
		}

		if hs.changed {
			hs.printJson()
		}
	}
}

func startServer() {
	hs := hyprState{
		workspaces: make([]workspaceState, PERSISTENT_WORKSPACES),
	}

	monitors, err := hyprqueryMonitors()
	if err != nil {
		log.Printf("Error getting monitor info: %s", err)
	} else if len(monitors) == 0 {
		log.Printf("Error hyprctl returned zero monitors: %s", err)
	}

	hs.workspacesChanged(monitors[0].ActiveWorspace.Id - 1)

	hs.printJson()

	conn := connect(gHyprlandSockPath)
	defer conn.Close()

	handleHyprEvents(conn, &hs)
}

func assertStr(s string) string {
	if s == "" {
		panic("assertion failed: empty string")
	}
	return s
}

func main() {
	hyprSig := os.Getenv("HYPRLAND_INSTANCE_SIGNATURE")
	if hyprSig == "" {
		os.Stderr.Write([]byte("No Hyprland instance found! Exiting..."))
		os.Exit(1)
	}

	gHyprlandSockPath = "/tmp/hypr/" + hyprSig + "/.socket2.sock"
	gHyprlandSockPath = fmt.Sprintf(
		"%s/hypr/%s/.socket.sock",
		assertStr(os.Getenv("XDG_RUNTIME_DIR")),
		hyprSig,
	)
	gLogPath = "/tmp/hypr/" + hyprSig + "/hyprcmd.log"

	// f, err := os.OpenFile(gLogPath, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0600)
	// if err != nil {
	// 	panic(err)
	// }
	// defer f.Close()
	// log.SetOutput(f)
	log.Printf("logging started")

	startServer()
	log.Printf("bye!")

	// flag.Parse()
	// cmd := flag.Args()
	// sendRequest(strings.Join(cmd, " "))
}

// utils
func hyprqueryMonitors() ([]monitorJson, error) {
	cmd := exec.Command("hyprctl", "-j", "monitors")
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		return nil, err
	}
	if err := cmd.Start(); err != nil {
		return nil, err
	}

	monitors := make([]monitorJson, 0)

	if err := json.NewDecoder(stdout).Decode(&monitors); err != nil {
		return nil, err
	}

	if err := cmd.Wait(); err != nil {
		return nil, err
	}

	return monitors, err
}

func hyprqueryWorkspaces() (res []workspaceJson, err error) {
	cmd := exec.Command("hyprctl", "-j", "workspaces")
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		return nil, err
	}
	if err := cmd.Start(); err != nil {
		return nil, err
	}

	ws := make([]workspaceJson, 0)

	if err := json.NewDecoder(stdout).Decode(&ws); err != nil {
		return nil, err
	}

	if err := cmd.Wait(); err != nil {
		return nil, err
	}

	return ws, err
}

func connect(path string) net.Conn {
	conn, err := net.Dial("unix", path)
	if err != nil {
		log.Panicf("connect to %s: %s", path, err)
	}

	return conn
}

func (hs *hyprState) printJson() {
	hs.changed = false

	var builder strings.Builder
	builder.WriteString(fmt.Sprintf(`[{"index":%d, "state":%d}`, 0, hs.workspaces[0]))
	for i, state := range hs.workspaces[1:] {
		builder.WriteString(fmt.Sprintf(`, {"index":%d, "state":%d}`, i+1, state))
	}
	builder.WriteRune(']')

	fmt.Println(builder.String())
}

func max(xs []int) int {
	m := xs[0]
	for _, x := range xs[1:] {
		if x > m {
			m = x
		}
	}

	return m
}

// Returns the index of the first found wokrspace matching a given state.
//
// returns -1 if not found
func index(slice []workspaceState, needle workspaceState) int {
	for i, x := range slice {
		if x == needle {
			return i
		}
	}
	return -1
}
