-- Per-file timestamp bookmarks, all stored in one shared CSV-like file
-- (path|time_seconds|label), so bookmarks sync across machines via dotfiles.
--
-- Bindings mirror the smplayer hotkeys already used for bookmarks:
--   Ctrl+a  add bookmark at current position
--   Ctrl+n  jump to next bookmark
--   Ctrl+b  jump to previous bookmark
--   B       show all bookmarks for this file (OSD)
--
-- Bookmarks file location: pass --script-opts=bookmarks-file=<path>,
-- otherwise defaults to ~/dotfiles/apps/mpv/bookmarks.

local mp = require("mp")
local utils = require("mp.utils")

local bookmarks_file = mp.get_opt("bookmarks-file")
    or (os.getenv("HOME") .. "/dotfiles/apps/mpv/bookmarks")

local function current_path()
    local path = mp.get_property("path")
    if not path then
        return nil
    end
    if path:sub(1, 1) ~= "/" then
        path = utils.join_path(mp.get_property("working-directory"), path)
    end
    return path
end

local function format_time(pos)
    local h = math.floor(pos / 3600)
    local m = math.floor((pos % 3600) / 60)
    local s = math.floor(pos % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function read_bookmarks(path)
    local list = {}
    local f = io.open(bookmarks_file, "r")
    if not f then
        return list
    end
    for line in f:lines() do
        if line:sub(1, 1) ~= "#" then
            local p, t, label = line:match("^(.-)|(.-)|(.*)$")
            if p == path then
                table.insert(list, { time = tonumber(t), label = label })
            end
        end
    end
    f:close()
    table.sort(list, function(a, b) return a.time < b.time end)
    return list
end

local function add_bookmark()
    local path = current_path()
    if not path then
        return
    end
    local pos = mp.get_property_number("time-pos", 0)
    local label = format_time(pos)
    local f = io.open(bookmarks_file, "a")
    if not f then
        mp.osd_message("bookmarks: cannot write " .. bookmarks_file)
        return
    end
    f:write(string.format("%s|%.3f|%s\n", path, pos, label))
    f:close()
    mp.osd_message("Bookmark saved: " .. label, 2)
end

local function jump(forward)
    local path = current_path()
    if not path then
        return
    end
    local list = read_bookmarks(path)
    if #list == 0 then
        mp.osd_message("No bookmarks for this file", 2)
        return
    end
    local pos = mp.get_property_number("time-pos", 0)
    local target
    if forward then
        for _, bm in ipairs(list) do
            if bm.time > pos + 0.5 then
                target = bm
                break
            end
        end
        target = target or list[1]
    else
        for i = #list, 1, -1 do
            if list[i].time < pos - 0.5 then
                target = list[i]
                break
            end
        end
        target = target or list[#list]
    end
    mp.commandv("seek", target.time, "absolute")
    mp.osd_message("Bookmark: " .. target.label, 2)
end

local function list_bookmarks()
    local path = current_path()
    if not path then
        return
    end
    local list = read_bookmarks(path)
    if #list == 0 then
        mp.osd_message("No bookmarks for this file", 2)
        return
    end
    local lines = {}
    for i, bm in ipairs(list) do
        table.insert(lines, string.format("%d. %s", i, bm.label))
    end
    mp.osd_message(table.concat(lines, "\n"), 5)
end

mp.add_key_binding("Ctrl+a", "bookmark-add", add_bookmark)
mp.add_key_binding("Ctrl+n", "bookmark-next", function() jump(true) end)
mp.add_key_binding("Ctrl+b", "bookmark-prev", function() jump(false) end)
mp.add_key_binding("B", "bookmark-list", list_bookmarks)
