-- illogical.lua
local M = {}

-- Base mapping with lowercase keys.
local toggle_map_base = {
	["true"] = "false",
	["false"] = "true",
	["1"] = "0",
	["0"] = "1",
	["yes"] = "no",
	["no"] = "yes",
}

-- Adjust the case of the replacement to match the original word.
local function adjust_case(word, replacement)
	if word:upper() == word then
		return replacement:upper() -- All letters uppercase.
	elseif word:sub(1, 1):upper() == word:sub(1, 1) and word:sub(2):lower() == word:sub(2) then
		-- Only the first letter is uppercase.
		return replacement:sub(1, 1):upper() .. replacement:sub(2)
	else
		return replacement -- All lowercase (or other cases fallback).
	end
end

-- Toggle function: Replace logical words using our base map.
M.toggle = function()
	local cword = vim.fn.expand("<cword>")
	local lower_word = cword:lower()
	local base = toggle_map_base[lower_word]
	if base then
		local replacement = adjust_case(cword, base)
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local line = vim.api.nvim_get_current_line()
		local start = col - #cword + 1
		local before = line:sub(1, start - 1)
		local after = line:sub(start + #cword)
		vim.api.nvim_set_current_line(before .. replacement .. after)
	else
		print("No toggle found for '" .. cword .. "'")
	end
end

-- Cycle function: Cycle "true" through "true" -> "True" -> "TRUE" -> "true".
M.cycle = function()
	local cword = vim.fn.expand("<cword>")
	local cycle = { "true", "True", "TRUE" }
	local idx = nil
	for i, v in ipairs(cycle) do
		if cword == v then
			idx = i
			break
		end
	end
	if not idx then
		print("Word is not in the cycle: '" .. cword .. "'")
		return
	end
	local next_idx = (idx % #cycle) + 1
	local replacement = cycle[next_idx]
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local start = col - #cword + 1
	local before = line:sub(1, start - 1)
	local after = line:sub(start + #cword)
	vim.api.nvim_set_current_line(before .. replacement .. after)
end

-- Set default keybindings.
-- <leader>` to toggle logical values.
-- <leader>~ to cycle through "true" variants.
vim.api.nvim_set_keymap("n", "<leader>`", ":lua require('illogical').toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>~", ":lua require('illogical').cycle()<CR>", { noremap = true, silent = true })

return M
