-- Leader keys must be set before lazy.nvim
vim.g.mapleader = ","
vim.g.maplocalleader = ";"

-- Prevent re-sourcing — lazy.nvim's own flag is the single source of truth.
if vim.g.lazy_did_setup then
  return
end

-- Load base config
require("usr.options")

-- Check Neovim version (inline — was a lazy plugin with recursive dir spec)
require("usr.version")

-- Load lazy.nvim
require("usr.lazy")

-- VimLeave workaround
vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function()
    vim.cmd("sleep 10m")
  end,
})
