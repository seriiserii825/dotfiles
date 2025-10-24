--- @sync entry
return {
  entry = function()
    local h = io.popen("git rev-parse --show-toplevel 2>/dev/null")
    local root = h and h:read("*l") or nil
    if h then h:close() end

    if root and #root > 0 then
      -- cd to git root (handles spaces safely)
      ya.emit("cd", { Url(root) })
    else
      ya.notify("Not in a git repo", "warn")
    end
  end,
}
