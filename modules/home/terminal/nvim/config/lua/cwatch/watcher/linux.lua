local ffi = require("ffi")
local bit = require("bit")

ffi.cdef [[
int inotify_init(void);
int inotify_add_watch(int fd, const char *pathname, uint32_t mask);
int inotify_rm_watch(int fd, int wd);
int read(int fd, void *buf, size_t count);
int close(int fd);

char *strerror(int errnum);

struct inotify_event {
    int      wd;
    uint32_t mask;
    uint32_t cookie;
    uint32_t len;
    char     name[];
};

static const int IN_CLOSE_WRITE = 0x00000008;
]]

local C = ffi.C

-- Convert errno to a readable string
local function strerror()
	local err = ffi.errno()
	return ffi.string(C.strerror(err))
end

---@class INotifyWatcher : Watcher
---@field fd integer
---@field paths table<string, integer>
---@field wds table<integer, string>
---@field uv_poll integer
local Watcher = {}

---Create a new watcher (does not watch anything yet)
---@return INotifyWatcher
function Watcher.new()
	local fd = C.inotify_init()
	if fd < 0 then
		error("inotify_init failed: " .. strerror())
	end

	local uv_poll = vim.uv.new_poll(fd)
	local obj = setmetatable({
		fd = fd,
		paths = {},
		wds = {},
		uv_poll = uv_poll,
	}, { __index = Watcher })

	vim.uv.poll_start(uv_poll, "r", function(...) obj:on_inotify_readable(...) end)
	return obj
end

---Watch a specific file for IN_CLOSE_WRITE
---@param full_path string
---@return string? err
function Watcher:watch(full_path)
	if self.paths[full_path] then
		return "already watching: " .. full_path
	end

	local wd = C.inotify_add_watch(self.fd, full_path, C.IN_CLOSE_WRITE)
	if wd < 0 then
		return string.format("inotify_add_watch(%s) failed: %s", full_path, strerror())
	end

	self.paths[full_path] = wd
	self.wds[wd] = full_path
	return nil
end

---Stop watching one file
---@param full_path string
function Watcher:unwatch(full_path)
	local wd = self.paths[full_path]
	if not wd then return end
	if C.inotify_rm_watch(self.fd, wd) < 0 then
		vim.notify(
			string.format("warning: inotify_rm_watch(%s) failed: %s\n", full_path, strerror()),
			vim.log.levels.WARN
		)
	end
	self.paths[full_path] = nil
	self.wds[wd] = nil
end

---Stop watching all files
function Watcher:unwatch_all()
	for path, _ in pairs(self.paths) do
		self:unwatch(path)
	end
end

---List all watched paths
---@return string[]
function Watcher:list_watched()
	local list = {}
	for path in pairs(self.paths) do
		list[#list + 1] = path
	end
	return list
end

function Watcher:on_inotify_readable(err, uv_ev)
	if err then
		vim.notify_once("poll error: " .. err, vim.log.levels.ERROR)
	end

	local bufsize = 1024
	local buf = ffi.new("uint8_t[?]", bufsize)
	local n = C.read(self.fd, buf, bufsize)
	if n < ffi.sizeof("struct inotify_event") then
		return nil, "read failed: " .. strerror()
	end

	local event = ffi.cast("struct inotify_event*", buf)
	if bit.band(event.mask, C.IN_CLOSE_WRITE) ~= 0 then
		local path = self.wds[event.wd]
		vim.schedule(function()
			vim.cmd("checktime")
			vim.cmd.cgetfile(path)
		end)
	end
	return nil, "unexpected event mask: " .. tostring(event.mask)
end

---Close and clean up
function Watcher:close()
	self:unwatch_all()
	if self.fd >= 0 then
		if C.close(self.fd) < 0 then
			io.stderr:write("warning: close(inotify fd) failed: " .. strerror() .. "\n")
		end
		self.fd = -1
	end
end

return Watcher
