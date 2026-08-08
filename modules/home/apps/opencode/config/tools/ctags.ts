import { tool } from "@opencode-ai/plugin"
import { existsSync, readFileSync } from "node:fs"
import { join, isAbsolute } from "node:path"

function resolveTagFiles(worktree: string): string[] {
  const tagsFiles = join(worktree, "tagsfiles")

  if (!existsSync(tagsFiles)) {
    return [join(worktree, "tags")]
  }

  return readFileSync(tagsFiles, "utf8")
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line && !line.startsWith("#"))
    .map((line) => (isAbsolute(line) ? line : join(worktree, line)))
}

export default tool({
  description:
    "Look up a symbol in the repository's tags index. " +
	"If the `tags` or `tagsfiles` file is available in the project root, " +
	"use this to find definitions, declarations, and other symbol locations " +
    "without searching the entire source tree.",

  args: {
    symbol: tool.schema
      .string()
      .describe("Symbol name to look up, e.g. foo, MyClass, handle_request"),

    kind: tool.schema
      .string()
      .optional()
      .describe(
        "Optional ctags kind filter, e.g. function, class, struct, variable"
      ),

    exact: tool.schema
      .boolean()
      .optional()
      .default(true)
      .describe("Whether to perform an exact symbol lookup"),
  },

  async execute(args, context) {
    const tagFiles = resolveTagFiles(context.worktree).filter(existsSync)

    if (tagFiles.length === 0) {
      return [
        "No tags files found.",
        "Generate one with Universal Ctags, for example:",
        "",
        "  ctags -R -f tags .",
      ].join("\n")
    }

    // readtags' query syntax is passed as an argument rather than
    // interpolated into a shell command, so there is no shell injection.
    const query = args.exact
      ? args.symbol
      : `^${args.symbol}`

    const command = tagFiles.flatMap((tagFile) => ["-t", tagFile])
    command.push(query)

    if (args.kind) {
      command.push("-Q", `(eq? $kind "${args.kind}")`)
    }

    try {
      const proc = Bun.spawn(command, {
        cwd: context.worktree,
        stdout: "pipe",
        stderr: "pipe",
      })

      const [stdout, stderr, exitCode] = await Promise.all([
        new Response(proc.stdout).text(),
        new Response(proc.stderr).text(),
        proc.exited,
      ])

      if (exitCode !== 0) {
        if (stderr.trim()) {
          return `readtags failed: ${stderr.trim()}`
        }

        return `No matches found for symbol '${args.symbol}'.`
      }

      const result = stdout.trim()

      if (!result) {
        return `No matches found for symbol '${args.symbol}'.`
      }

      return result
    } catch (error) {
      return [
        "Unable to execute readtags.",
        "",
        "Make sure Universal Ctags/readtags is installed and available in PATH.",
        "",
        `Error: ${error instanceof Error ? error.message : String(error)}`,
      ].join("\n")
    }
  },
})
