
-- illogical.lua
local M = {}

-- Base mapping with lowercase keys.
local toggle_map_base = {
  ["true"]  = "false",
  ["false"] = "true",
  ["1"]     = "0",
  ["0"]     = "1",
  ["yes"]   = "no",
  ["no"]    = "yes",
}

-- Adjust the case of the replacement to match the original word.
local function adjust_case(word, replacement)
  if word:upper() == word then
    return replacement:upper()  -- All letters uppercase.
  elseif word:sub(1, 1):upper() == word:sub(1, 1) and word:sub(2):lower() == word:sub(2) then
    -- Only the first letter is uppercase.
    return replacement:sub(1, 1):upper() .. replacement:sub(2)
  else
    return replacement  -- All lowercase (or any other case, fallback to base replacement).
  end
end

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

return M

