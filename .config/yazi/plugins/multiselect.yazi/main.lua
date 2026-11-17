-- Select many files at once by a comma-separated list of patterns.
--   58,47,32,42   -> numbers match as a whole number (42 does not hit 142 or 420)
--   40-45         -> numeric range
--   foo           -> anything else is a case-insensitive substring
-- Shows the list of matches, `y`/Enter selects them, `n`/Esc cancels.

local get_hovered = ya.sync(function()
	local h = cx.active.current.hovered
	return h and tostring(h.url) or nil
end)

local get_files = ya.sync(function()
	local out = {}
	for _, f in ipairs(cx.active.current.files) do
		out[#out + 1] = { name = f.name, url = tostring(f.url) }
	end
	return out
end)

local function notify(content, level)
	ya.notify({ title = "Multiselect", content = content, timeout = 3, level = level or "info" })
end

-- all whole numbers in a name, e.g. "Foto-42 (1).jpg" -> {42, 1}
local function numbers_of(name)
	local nums = {}
	for n in name:gmatch("%d+") do
		nums[#nums + 1] = tonumber(n)
	end
	return nums
end

local function parse(input)
	local matchers = {}
	for tok in input:gmatch("[^,%s]+") do
		local a, b = tok:match("^(%d+)%-(%d+)$")
		if a then
			a, b = tonumber(a), tonumber(b)
			if a > b then a, b = b, a end
			matchers[#matchers + 1] = function(_, nums)
				for _, n in ipairs(nums) do
					if n >= a and n <= b then return true end
				end
			end
		elseif tok:match("^%d+$") then
			local want = tonumber(tok)
			matchers[#matchers + 1] = function(_, nums)
				for _, n in ipairs(nums) do
					if n == want then return true end
				end
			end
		else
			local sub = tok:lower()
			matchers[#matchers + 1] = function(name)
				return name:lower():find(sub, 1, true) ~= nil
			end
		end
	end
	return matchers
end

local function entry()
	local value, event = ya.input({
		title = "Multiselect (58,47,40-45,foo):",
		pos = { "top-center", y = 3, w = 60 },
	})
	if event ~= 1 or not value or value:match("^%s*$") then
		return
	end

	local matchers = parse(value)
	local hits = {}
	for _, f in ipairs(get_files()) do
		local nums = numbers_of(f.name)
		for _, m in ipairs(matchers) do
			if m(f.name, nums) then
				hits[#hits + 1] = f
				break
			end
		end
	end

	if #hits == 0 then
		notify("Nothing matches: " .. value, "warn")
		return
	end

	local lines = {}
	for _, f in ipairs(hits) do
		lines[#lines + 1] = ui.Line(f.name)
	end
	local body = ui.Text(lines)

	local ok = ya.confirm({
		pos = { "center", w = 60, h = math.min(#hits + 4, 30) },
		title = string.format("Select %d file(s)?  [y/n]", #hits),
		body = body,
		content = body,
	})
	if not ok then
		return
	end

	-- `toggle <url>` ignores the url here and toggles the hovered file,
	-- so move the cursor onto each file first, then restore it.
	local back = get_hovered()
	for _, f in ipairs(hits) do
		ya.emit("reveal", { Url(f.url) })
		ya.emit("toggle", { state = "on" })
	end
	if back then
		ya.emit("reveal", { Url(back) })
	end
	notify(string.format("Selected %d file(s)", #hits))
end

return { entry = entry }
