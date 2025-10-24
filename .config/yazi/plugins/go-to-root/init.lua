return {
  entry = function()
    ya.manager_add_action("go_to_git_root", function()
      local h = io.popen("git rev-parse --show-toplevel 2>/dev/null")
      local root = h and h:read("*l") or nil
      if h then h:close() end
      if root and #root > 0 then
        ya.manager_set_cwd(root)
      else
        ya.notify("Not in a git repo", "warn")
      end
    end)
  end,
}

