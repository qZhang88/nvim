-- Prevent re-sourcing when a local init.lua exists in CWD
if vim.g.did_nvim_init then
  return
end
vim.g.did_nvim_init = true

-- Leader 键必须在加载 lazy.nvim 之前设置！
vim.g.mapleader = ","
vim.g.maplocalleader = ";"

-- 1. 加载你的基础配置和快捷键 (包含上面转写过来的 init.vim)
require("usr.options")

-- 检查 Neovim 版本
require("usr.version")

-- 2. 启动 lazy.nvim (所有插件的加载由它接管)
require("usr.lazy")

-- 3. 其他少量的全局配置
vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function()
    vim.cmd("sleep 10m")
  end,
})
