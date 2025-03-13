-- illogical.lua
local M = {}

local toggle_pairs = {

	-- Logical and bipolar pairs
	{ "accept", "reject" },
	{ "add", "remove" },
	{ "advance", "retreat" },
	{ "agree", "disagree" },
	{ "alive", "dead" },
	{ "allow", "deny" },
	{ "always", "never" },
	{ "amplify", "dampen" },
	{ "ascend", "descend" },
	{ "attach", "detach" },
	{ "awake", "asleep" },
	{ "before", "after" },
	{ "begin", "end" },
	{ "big", "small" },
	{ "bind", "unbind" },
	{ "birth", "death" },
	{ "black", "white" },
	{ "bold", "timid" },
	{ "bright", "dim" },
	{ "build", "destroy" },
	{ "buy", "sell" },
	{ "check", "uncheck" },
	{ "clean", "dirty" },
	{ "clear", "cloudy" },
	{ "close", "open" },
	{ "cold", "hot" },
	{ "connect", "disconnect" },
	{ "correct", "incorrect" },
	{ "create", "delete" },
	{ "dark", "light" },
	{ "day", "night" },
	{ "decrease", "increase" },
	{ "deep", "shallow" },
	{ "enable", "disable" },
	{ "enter", "exit" },
	{ "even", "odd" },
	{ "expand", "collapse" },
	{ "fast", "slow" },
	{ "fill", "empty" },
	{ "find", "lose" },
	{ "first", "last" },
	{ "fix", "break" },
	{ "float", "sink" },
	{ "forward", "backward" },
	{ "freeze", "melt" },
	{ "full", "empty" },
	{ "gain", "lose" },
	{ "greater", "less" },
	{ "happy", "sad" },
	{ "hard", "soft" },
	{ "high", "low" },
	{ "ignore", "acknowledge" },
	{ "import", "export" },
	{ "increase", "decrease" },
	{ "inside", "outside" },
	{ "install", "uninstall" },
	{ "integer", "float" },
	{ "invert", "restore" },
	{ "join", "split" },
	{ "left", "right" },
	{ "lengthen", "shorten" },
	{ "less", "more" },
	{ "lock", "unlock" },
	{ "loud", "quiet" },
	{ "maximize", "minimize" },
	{ "merge", "separate" },
	{ "modern", "classic" },
	{ "mount", "unmount" },
	{ "move", "copy" },
	{ "muted", "unmuted" },
	{ "new", "old" },
	{ "next", "previous" },
	{ "on", "off" },
	{ "open", "close" },
	{ "pass", "fail" },
	{ "pause", "resume" },
	{ "permit", "forbid" },
	{ "play", "stop" },
	{ "positive", "negative" },
	{ "press", "release" },
	{ "public", "private" },
	{ "push", "pull" },
	{ "read", "write" },
	{ "real", "fake" },
	{ "record", "erase" },
	{ "reduce", "expand" },
	{ "reject", "accept" },
	{ "right", "wrong" },
	{ "rise", "fall" },
	{ "save", "discard" },
	{ "select", "deselect" },
	{ "send", "receive" },
	{ "show", "hide" },
	{ "smooth", "rough" },
	{ "start", "stop" },
	{ "success", "failure" },
	{ "take", "give" },
	{ "true", "false" },
	{ "turn on", "turn off" },
	{ "unlock", "lock" },
	{ "up", "down" },
	{ "visible", "hidden" },
	{ "win", "lose" },
	{ "yes", "no" },
	{ "zero", "one" },
	{ "arch", "ubuntu" },

	-- other useful pairs
	{ "apt-get install", "paru -Syyu" },
	{ "bitcoin", "fiat" },
	{ "brainstorm", "brainfart" },
	{ "car", "bike" },
	{ "cats", "dogs" },
	{ "cli", "gui" },
	{ "coffee", "tea" },
	{ "console", "pc" },
	{ "ethernet", "fiber" },
	{ "ethernet", "wifi" },
	{ "fizz", "buzz" },
	{ "foo", "bar" },
	{ "git pull", "git reset --hard origin/main" },
	{ "hamburger", "hotdog" },
	{ "java", "not a literal waste of resources" },
	{ "json", "yaml" },
	{ "kde", "gnome" },
	{ "laptop", "desktop" },
	{ "left handed", "right handed" },
	{ "light mode", "dark mode" },
	{ "linux", "windows" },
	{ "lisp", "c" },
	{ "mac", "pc" },
	{ "monolithic", "microservices" },
	{ "nasa", "spacex" },
	{ "nvidia", "amd" },
	{ "pacman -Syu", "apt update && apt upgrade" },
	{ "printf", "cout" },
	{ "pull", "push" },
	{ "python", "perl" },
	{ "real programmer", "javascript developer" },
	{ "rebase", "merge" },
	{ "rust", "go" },
	{ "soccer", "football" },
	{ "space", "tab" },
	{ "sqlite", "postgres" },
	{ "systemctl", "service" },
	{ "tabs", "four spaces" },
	{ "tabs", "spaces" },
	{ "tcp", "icmp" },
	{ "tcp", "udp" },
	{ "true fan", "traitor" },
	{ "ubuntu", "debian" },
	{ "usb-c", "lightning" },
	{ "vi", "nano" },
	{ "vim", "emacs" },
	{ "vim", "helix" },
	{ "paru -Syy", "apt-get update" },
	{ "paru -Syyu", "apt-get upgrade" },
}

-- Forward declarations to resolve circular dependencies
local get_toggle_value, transform_inflection, match_case

-- Applies the original word’s case formatting to the replacement.
function match_case(original, replacement)
	if original == original:upper() then
		return replacement:upper() -- ALL CAPS
	elseif original:sub(1, 1):upper() == original:sub(1, 1) then
		return replacement:sub(1, 1):upper() .. replacement:sub(2) -- Capitalized
	else
		return replacement -- Lowercase
	end
end

-- Transforms words with inflectional endings.
function transform_inflection(word)
	if word:match("ied$") then
		-- e.g. "denied": convert "ied" to "y" to get base "deny"
		local stripped = word:sub(1, -4) .. "y" -- "denied" becomes "deny"
		local base_toggle = get_toggle_value(stripped)
		if not base_toggle then
			return nil
		end
		return match_case(word, base_toggle .. "ed")
	elseif word:match("ing$") then
		local stripped = word:sub(1, -4) -- Remove "ing"
		local base_toggle = get_toggle_value(stripped)
		if not base_toggle then
			return nil
		end
		if base_toggle:match("e$") then
			return match_case(word, base_toggle:sub(1, -2) .. "ing")
		else
			return match_case(word, base_toggle .. "ing")
		end
	elseif word:match("ed$") then
		local stripped = word:sub(1, -3) -- Remove "ed"
		local base_toggle = get_toggle_value(stripped)
		if not base_toggle then
			stripped = stripped .. "e" -- Try appending an "e"
			base_toggle = get_toggle_value(stripped)
			if not base_toggle then
				return nil
			end
		end
		if base_toggle:match("y$") then
			return match_case(word, base_toggle:sub(1, -2) .. "ied")
		elseif not base_toggle:match("e$") then
			return match_case(word, base_toggle .. "ed")
		else
			return match_case(word, base_toggle .. "d")
		end
	elseif word:match("ies$") then
		-- e.g. "denies": convert "ies" to "y"
		local stripped = word:sub(1, -4) .. "y" -- "denies" becomes "deny"
		local base_toggle = get_toggle_value(stripped)
		if not base_toggle then
			return nil
		end
		if base_toggle:match("y$") then
			return match_case(word, base_toggle:sub(1, -2) .. "ies")
		else
			return match_case(word, base_toggle .. "s")
		end
	elseif word:match("s$") then
		-- Handle plural forms (that do not end with "ies")
		local stripped = word:sub(1, -2) -- Remove "s"
		local base_toggle = get_toggle_value(stripped)
		if not base_toggle then
			return nil
		end
		if base_toggle:match("y$") then
			return match_case(word, base_toggle:sub(1, -2) .. "ies")
		else
			return match_case(word, base_toggle .. "s")
		end
	elseif word:match("er$") then
		local stripped = word:sub(1, -3) -- Remove "er"
		local base_toggle = get_toggle_value(stripped)
		if not base_toggle then
			return nil
		end
		return match_case(word, base_toggle .. "er")
	end
	return nil
end

-- Returns the toggled value of a word based on the defined pairs.
function get_toggle_value(word)
	local lower_word = word:lower()
	local replacement = nil

	for _, pair in ipairs(toggle_pairs) do
		if pair[1] == lower_word then
			replacement = pair[2]
			break
		elseif pair[2] == lower_word then
			replacement = pair[1]
			break
		end
	end

	if not replacement then
		return transform_inflection(word)
	end

	return match_case(word, replacement)
end

-- Toggle function: Replace the word under the cursor with its toggled counterpart.

M.toggle = function()
	local cword = vim.fn.expand("<cword>")
	local replacement = get_toggle_value(cword)
	if not replacement then
		print("No toggle found for '" .. cword .. "'")
		return
	end

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	-- Find the start and end of the word under the cursor
	local start_col, end_col = col + 1, col + 1 -- Default to cursor position (1-based index)

	-- Move `start_col` back until reaching a non-word character or the beginning of the line
	while start_col > 1 and line:sub(start_col - 1, start_col - 1):match("[%w_]") do
		start_col = start_col - 1
	end

	-- Move `end_col` forward until reaching a non-word character or the end of the line
	while end_col <= #line and line:sub(end_col, end_col):match("[%w_]") do
		end_col = end_col + 1
	end

	-- Ensure proper substring extraction
	local before = line:sub(1, start_col - 1) -- Text before the word
	local after = line:sub(end_col) -- Text after the word

	-- Replace the word completely instead of appending
	vim.api.nvim_set_current_line(before .. replacement .. after)

	-- Adjust cursor position to remain at the start of the new word
	vim.api.nvim_win_set_cursor(0, { row, start_col - 1 })
end
M.ttoggle = function()
	local cword = vim.fn.expand("<cword>")
	local replacement = get_toggle_value(cword)
	if not replacement then
		print("No toggle found for '" .. cword .. "'")
		return
	end

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	local start_col, end_col = col, col
	while start_col > 1 and line:sub(start_col - 1, start_col - 1):match("[%w_]") do
		start_col = start_col - 1
	end
	while end_col <= #line and line:sub(end_col, end_col):match("[%w_]") do
		end_col = end_col + 1
	end

	local before = line:sub(1, start_col - 1)
	local after = line:sub(end_col)
	vim.api.nvim_set_current_line(before .. replacement .. after)
end

-- Set default keybinding: <leader>= toggles the logical word.
-- vim.api.nvim_set_keymap("n", "<leader>=", ":lua require('illogical').toggle()<CR>", { noremap = true, silent = true })

local has_which_key, which_key = pcall(require, "which-key")
if has_which_key then
	which_key.add({
		{
			"<leader>=",
			":lua require('illogical').toggle()<CR>",
			desc = "Toggle logical value",
		},
		-- ["<leader>="] = "Toggle logical value",
	})
end

return M
