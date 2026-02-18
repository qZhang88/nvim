-- Leader 键必须在加载 lazy.nvim 之前设置！
vim.g.mapleader = ","
vim.g.maplocalleader = ";"

-- 1. 加载你的基础配置和快捷键 (包含上面转写过来的 init.vim)
require("usr.options")

-- 2. 启动 lazy.nvim (所有插件的加载由它接管)
require("usr.lazy")

-- 3. 其他少量的全局配置
vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function()
    vim.cmd("sleep 10m")
  end,
})
