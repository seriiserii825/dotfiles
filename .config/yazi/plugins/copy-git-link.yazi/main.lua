-- Copies a browser link to the hovered file/directory (GitHub, GitLab, Bitbucket).
-- The link points to the upstream branch, so it only works once the file is pushed.
-- With the "repo" argument copies the repository root link instead: the repo of the
-- hovered directory if it is inside one, otherwise the repo of the current directory.

local get_hovered = ya.sync(function()
	local cwd = tostring(cx.active.current.cwd)
	local hovered = cx.active.current.hovered
	if not hovered then
		return cwd, nil, nil
	end
	return cwd, hovered.name, hovered.cha.is_dir and tostring(hovered.url) or nil
end)

local function notify(content, level)
	ya.notify({ title = "Git link", content = content, timeout = 3, level = level or "info" })
end

local function git(cwd, args)
	local output = Command("git"):arg(args):cwd(cwd):stdout(Command.PIPED):stderr(Command.PIPED):output()
	if not output or not output.status.success then
		return nil
	end
	return (output.stdout:gsub("%s+$", ""))
end

-- Turns any remote form into a web base URL, dropping credentials and ports:
-- git@host:user/repo.git, ssh://git@host:22/user/repo.git, https://token@host/user/repo.git
local function web_base(remote)
	local scheme, rest = remote:match("^(%a[%w+.-]*)://(.+)$")
	local host, path
	if scheme then
		host, path = rest:gsub("^[^@/]*@", ""):match("^([^/]+)/(.+)$")
		if host and scheme ~= "http" and scheme ~= "https" then
			host = host:gsub(":%d+$", "")
		end
	else
		host, path = remote:gsub("^[^@/]*@", ""):match("^([^:/]+):(.+)$")
	end
	if not host then
		return nil
	end
	path = path:gsub("/+$", ""):gsub("%.git$", "")
	return string.format("%s://%s/%s", scheme == "http" and "http" or "https", host, path), host
end

local function encode(s)
	return (s:gsub("[^%w%-._~/]", function(c)
		return string.format("%%%02X", c:byte())
	end))
end

local function blob_segment(host)
	if host:find("gitlab", 1, true) then
		return "-/blob"
	elseif host:find("bitbucket", 1, true) then
		return "src"
	end
	return "blob"
end

local function copy(link)
	ya.clipboard(link)
	notify(link .. " is copied")
end

local function copy_repo_link(cwd, hovered_dir)
	local dir = hovered_dir and git(hovered_dir, { "rev-parse", "--show-toplevel" }) and hovered_dir or cwd
	if not git(dir, { "rev-parse", "--show-toplevel" }) then
		return notify("Not a git repository", "warn")
	end

	local upstream = git(dir, { "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}" })
	local remote = upstream and upstream:match("^([^/]+)/") or "origin"
	local remote_url = git(dir, { "remote", "get-url", remote })
	if not remote_url then
		return notify("Remote not found: " .. remote, "warn")
	end

	local base = web_base(remote_url)
	if not base then
		return notify("Can't build a web URL from remote: " .. remote_url, "error")
	end
	copy(base)
end

return {
	entry = function(_, job)
		local cwd, name, hovered_dir = get_hovered()
		if job.args[1] == "repo" then
			return copy_repo_link(cwd, hovered_dir)
		end
		if not name then
			return
		end

		local prefix = git(cwd, { "rev-parse", "--show-prefix" })
		if not prefix then
			return notify("Not a git repository", "warn")
		end

		local upstream = git(cwd, { "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}" })
		if not upstream then
			return notify("Current branch has no upstream, push it first", "warn")
		end
		local remote, branch = upstream:match("^([^/]+)/(.+)$")

		local remote_url = git(cwd, { "remote", "get-url", remote })
		local base, host = web_base(remote_url or "")
		if not base then
			return notify("Can't build a web URL from remote: " .. (remote_url or remote), "error")
		end

		local path = prefix .. name
		local tracked = git(cwd, { "ls-tree", "--full-tree", "--name-only", upstream, "--", path })
		if not tracked or tracked == "" then
			return notify("Not on " .. upstream .. " yet, push it first", "warn")
		end

		copy(string.format("%s/%s/%s/%s", base, blob_segment(host), encode(branch), encode(path)))
	end,
}
