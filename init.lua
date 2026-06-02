-- Prevent re-sourcing when a local init.lua exists in CWD
if vim.g.did_nvim_init then
  return
end
vim.g.did_nvim_init = true

-- Leader keys must be set before lazy.nvim
vim.g.mapleader = ","
vim.g.maplocalleader = ";"

-- Check Neovim version
require("usr.version")

-- Load all plugin and base config (was `lua require 'usr'` in init.vim)
require("usr.init")

--- ============================================================
--- Ported from init.vim / vim/misc.vim
--- ============================================================

-- Autoread: detect external file changes
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})

-- Autowrite: save on focus lost
vim.opt.autowrite = true
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  pattern = "*",
  command = "silent! update",
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Terminal: Esc to normal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- System clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')

-- OSCYank: remote clipboard sync
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator:match("^[yd]$") and vim.v.event.regname == "+" then
      vim.cmd("OSCYankRegister +")
    end
  end,
})

-- Keyboard shortcuts
vim.keymap.set("n", "<leader>q", "q", { desc = "Macro recording" })
vim.keymap.set("n", "xx", "x", { desc = "Workaround for nvim-treesitter-textobjects" })
vim.keymap.set("n", "<Space>bc", "<cmd>BDelete hidden<cr>", { desc = "Delete hidden buffers" })

-- Expand tab to spaces
vim.opt.expandtab = true
vim.opt.shiftwidth = 2

-- Open browser with gx
vim.g.netrw_nogx = 1
vim.keymap.set("n", "gx", "<Plug>(openbrowser-smart-search)")
vim.keymap.set("v", "gx", "<Plug>(openbrowser-smart-search)")

-- Auto-close Neovim if only nvim-tree window remains
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.fn.bufname():match("NvimTree_") then
      vim.cmd("quit")
    end
  end,
})

-- Misc plugin globals (was in vim/misc.vim)
vim.g.loaded_perl_provider = 0
vim.g.table_mode_corner = "|"
vim.g.mkdp_auto_close = 0
vim.g.bookmark_auto_close = 1
vim.g.bookmark_save_per_working_dir = 1
vim.g.bookmark_no_default_key_mappings = 1
vim.g.git_messenger_always_into_popup = true
vim.g.git_messenger_no_default_mappings = true
vim.g.gitblame_delay = 1500
vim.g.gitblame_ignored_filetypes = { "lua", "markdown", "sh" }

-- Pre-recorded macros
vim.cmd([[let @j = 'ysiw`\<Esc>']])
vim.cmd([[let @k = 'ysiw"\<Esc>']])

-- Source remaining vimscript configs (wildmenu, debug helpers)
local config_dir = vim.fn.stdpath("config")
vim.cmd("source " .. config_dir .. "/vim/debug.vim")
vim.cmd("source " .. config_dir .. "/vim/wilder.vim")
