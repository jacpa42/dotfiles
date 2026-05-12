local M = {}

-- Returns the env variable or a default value. Always returns a number
M.envint = function(name, default)
	local value = os.getenv(name)
	if value ~= nil then
		return tonumber(value)
	else
		return default
	end
end

-- Checks whether or not the class matches one of the classes in the class list
M.is_terminal = function(window, terminal_popup_app_classes)
	for _, term_class in ipairs(terminal_popup_app_classes) do
		if term_class == window.class then
			return true
		end
	end
	return false
end

M.fuzzy_find_project_path = function(absolute)
	local projdir = os.getenv("PROJDIR") or "."
	local proc =
		io.popen('fd --format="{//}" -Hgtd .git ' .. projdir .. ' | fuzzel --dmenu --placeholder="Choose project"', "r")
	if proc == nil then
		error("Failed to find project path")
	end
	local project = proc:read("*l")

	if project == nil or project == "" then
		return ""
	elseif absolute == nil or absolute then
		return projdir .. "/" .. project
	else
		return project
	end
end

-- Closes all windows with the `class` matching `"tpopup"` and `title` not matching `ignore_title`
M.close_non_matching = function(initial_title, terminal_popup_app_classes)
	local windows = hl.get_windows({ floating = true })
	local matching = 0

	for _, window in ipairs(windows) do
		if M.is_terminal(window, terminal_popup_app_classes) then
			if initial_title == window.initial_title then
				matching = matching + 1
			else
				hl.dispatch(hl.dsp.window.close({ window = window }))
			end
		end
	end

	return matching
end

return M
