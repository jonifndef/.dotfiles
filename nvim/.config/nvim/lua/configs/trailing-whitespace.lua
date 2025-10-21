--vim.api.nvim_set_hl(0, 'TrailingWhitespace', { bg='Red' })
--vim.api.nvim_create_autocmd('InsertLeavePre', {
--	pattern = '*',
--	command = [[
--		syntax clear TrailingWhitespace |
--		syntax match TrailingWhitespace "\_s\+$"
--	]]}
--)



--vim.cmd [[highlight ExtraWhitespace ctermbg=red guibg=#553333]]

--local function update_whitespace_highlight()
--  vim.fn.clearmatches()
--  local cur = vim.fn.line(".")
--  -- Match trailing whitespace on all lines except the current one
--  local pattern = string.format([[\s\+$\%%<%dl\|\%%>%dl]], cur, cur)
--  vim.fn.matchadd("ExtraWhitespace", pattern)
--end
--
--vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "InsertLeave" }, {
--  callback = update_whitespace_highlight,
--})

vim.cmd [[highlight ExtraWhitespace ctermbg=red guibg=#553333]]

local match_id = nil

local function safe_matchdelete(id)
  if not id then return end
  pcall(vim.fn.matchdelete, id)
end

local function update_whitespace_highlight()
  safe_matchdelete(match_id)
  local cur = vim.fn.line(".")
  -- Match trailing whitespace except on the current line
  local pattern = string.format([[\\%%<%dl\\s\\+$\\|\\%%>%dl\\s\\+$]], cur, cur)
  match_id = vim.fn.matchadd("ExtraWhitespace", pattern)
end

vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "InsertLeave", "BufWinEnter" }, {
  callback = update_whitespace_highlight,
})


TrimTrailingWS = function()
  local view = vim.fn.winsaveview()
  vim.cmd [[%s:\s\+$::e]]
  vim.fn.winrestview(view)
end

vim.keymap.set("n", "<leader>w", TrimTrailingWS, { desc = "Say hello" })
