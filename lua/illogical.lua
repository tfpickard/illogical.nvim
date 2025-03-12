-- illogical.lua
local M = {}

-- Define toggle pairs in a two-column format (only store lowercase)
local toggle_pairs = {
    { "true",   "false" },
    { "yes",    "no" },
    { "1",      "0" },
    { "enable", "" },
}

-- Function to match a word in the toggle table and return its counterpart
local function get_toggle_value(word)
    local lower_word = word:lower()
    local replacement = nil

    -- Look up the lowercase word in the toggle table
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
        return nil
    end -- No match found

    -- Determine case style
    local cap = false
    local all_upper = true

    for i = 1, #word do
        local char = word:sub(i, i)
        if char:match("%l") then -- Contains a lowercase letter
            all_upper = false
            break
        end
    end

    if word:sub(1, 1):match("%u") then
        cap = true
    end

    -- Apply correct case formatting
    if all_upper then
        return replacement:upper()                           -- ALL CAPS
    elseif cap then
        return replacement:sub(1, 1):upper() .. replacement:sub(2) -- Capitalized
    else
        return replacement                                   -- Lowercase
    end
end

-- Toggle function: Replace logical words dynamically.
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
    local start_col, end_col = col, col
    while start_col > 1 and line:sub(start_col - 1, start_col - 1):match("[%w_]") do
        start_col = start_col - 1
    end
    while end_col <= #line and line:sub(end_col, end_col):match("[%w_]") do
        end_col = end_col + 1
    end

    -- Replace only the word at the cursor's position
    local before = line:sub(1, start_col - 1)
    local after = line:sub(end_col)
    vim.api.nvim_set_current_line(before .. replacement .. after)
end

-- Set default keybindings.
vim.api.nvim_set_keymap("n", "<leader>=", ":lua require('illogical').toggle()<CR>", { noremap = true, silent = true })

-- Which-key support if installed.
local has_which_key, which_key = pcall(require, "which-key")
if has_which_key then
    which_key.register({
        ["<leader>`"] = "Toggle logical value",
    })
end

return M
