-- Rename the hovered file, copy the new name to the clipboard, then restore
-- the original name — useful for figuring out what a file *would* be named
-- without actually keeping the rename.

local get_hovered_url = ya.sync(function()
	local h = cx.active.current.hovered
	return h and h.url or nil
end)

local function notify(content, level)
	ya.notify({ title = "Rename & copy", content = content, timeout = 4, level = level or "info" })
end

local function entry()
	local url = get_hovered_url()
	if not url then
		notify("No file hovered", "warn")
		return
	end

	local old_name = url.name
	local value, event = ya.input({
		title = "Rename (copies new name, then restores original):",
		value = old_name,
		pos = { "top-center", y = 3, w = 60 },
	})
	if event ~= 1 or not value or value == "" or value == old_name then
		return
	end

	local parent = url.parent
	local new_url = parent:join(value)

	if fs.cha(new_url, false) then
		notify('A file named "' .. value .. '" already exists here, aborting', "error")
		return
	end

	local ok, err = fs.rename(url, new_url)
	if not ok then
		notify("Rename failed: " .. tostring(err), "error")
		return
	end

	ya.clipboard(value)

	local ok2, err2 = fs.rename(new_url, url)
	if not ok2 then
		notify(
			'Copied "' .. value .. '" to clipboard, but FAILED to restore original name "' .. old_name .. '": ' .. tostring(err2),
			"error"
		)
		return
	end

	notify('Copied "' .. value .. '" to clipboard, restored original name')
end

return { entry = entry }
