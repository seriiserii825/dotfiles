local history_file = os.getenv("HOME") .. "/.yazi_history"
local max_entries = 100

local function append_to_history(cwd)
    local file = io.open(history_file, "a+")
    if file then
        file:write(cwd .. "\n")
        file:close()
    end
    -- Trim history to max_entries
    local lines = {}
    file = io.open(history_file, "r")
    if file then
        for line in file:lines() do
            table.insert(lines, line)
        end
        file:close()
        if #lines > max_entries then
            file = io.open(history_file, "w")
            if file then
                for i = #lines - max_entries + 1, #lines do
                    file:write(lines[i] .. "\n")
                end
                file:close()
            end
        end
    end
end

return {
    entry = function()
        local cwd = cx.active.current.cwd
        append_to_history(cwd)
    end,
}
