-- =========================================================================
-- 1. 全局变量 (Globals)
-- =========================================================================
-- 禁用 perl provider 提升一点速度
vim.g.loaded_perl_provider = 0

-- Floaterm 配置
vim.g.floaterm_width = 0.7
vim.g.floaterm_height = 0.7
vim.g.floaterm_keymap_prev   = "<C-p>"
vim.g.floaterm_keymap_new    = "<C-n>"
vim.g.floaterm_keymap_toggle = "<C-t>"

-- GitBlame 配置
vim.g.gitblame_delay = 1500
vim.g.gitblame_ignored_filetypes = { "lua", "markdown", "sh" }

-- =========================================================================
-- 2. 基础设置 (Options)
-- =========================================================================
local options = {
  autoread = true,           -- 开启文件自动读取
  autowrite = true,          -- 失去焦点自动保存
  backup = false,            -- 不创建备份文件
  cmdheight = 1,             -- 命令行高度
  completeopt = { "menuone", "noselect" }, -- 补全菜单设置
  conceallevel = 0,          -- markdown 中可见 ``
  cursorline = true,         -- 高亮当前行
  expandtab = true,          -- 将 tab 转换为空格
  fileencoding = "utf-8",    -- 文件写入编码
  fileencodings = "utf-8,ucs-bom,gb18030,gbk,gb2312,cp936", -- 文件读取编码尝试列表
  guifont = "monospace:h17", -- GUI 字体
  hlsearch = true,           -- 高亮所有搜索结果
  laststatus = 3,            -- 全局唯一的状态栏 (Global statusline)
  linebreak = true,          -- 单词间折行，不打断单词
  number = true,             -- 显示行号
  pumheight = 10,            -- 弹出菜单的最大高度
  shiftwidth = 2,            -- 缩进空格数
  showmode = false,          -- 状态栏不显示 -- INSERT -- 等模式提示
  signcolumn = "yes",        -- 始终显示标志列，避免文本抖动
  smartcase = true,          -- 智能大小写
  splitbelow = true,         -- 强制水平切分窗口在下方
  splitright = true,         -- 强制垂直切分窗口在右方
  swapfile = false,          -- 不创建 swap 文件
  termguicolors = true,      -- 开启终端真彩色
  timeoutlen = 300,          -- 快捷键等待时间 (毫秒)
  undofile = true,           -- 开启持久化撤销历史
  updatetime = 300,          -- 提升补全和 CursorHold 触发速度
  whichwrap = "bs<>[]hl",    -- 允许这些键跨行移动
  wrap = false,              -- 不要自动折行
  writebackup = false,       -- 其他程序编辑时不允许写入备份

  -- 折叠设置 (Treesitter)
  foldlevelstart = 99,
  foldmethod = "expr",
  foldexpr = "nvim_treesitter#foldexpr()",
}

-- 集中设置普通选项
for k, v in pairs(options) do
  vim.opt[k] = v
end

-- 追加和移除特定选项
vim.opt.shortmess:append("c") -- 不显示补全菜单的冗长提示
vim.opt.iskeyword:append("-") -- 将连字符视为单词的一部分
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- 阻止回车或用 o/O 换行时自动延续注释
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles") -- 隔离 vim 和 neovim 插件

-- =========================================================================
-- 3. 快捷键映射 (Keymaps)
-- =========================================================================
local map = vim.keymap.set

-- 终端模式
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- 宏录制与常规映射
map("n", "<leader>q", "q", { desc = "Macro recording" })
map("n", "xx", "x", { desc = "Workaround for nvim-treesitter-textobjects" })
map("n", "<Space>bc", "<cmd>BDelete hidden<cr>", { desc = "Delete hidden buffers" })

-- 系统剪贴板交互
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<leader>d", '"+d', { desc = "Delete to system clipboard" })

-- =========================================================================
-- 4. 自动命令 (Autocmds)
-- =========================================================================
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true }) -- 使用 augroup 避免重复挂载

-- 文件外部修改自动检测
autocmd({ "FocusGained", "BufEnter" }, {
  group = augroup,
  pattern = "*",
  command = "checktime",
  desc = "Auto check for external file changes",
})

-- 失去焦点自动保存
autocmd({ "FocusLost", "BufLeave" }, {
  group = augroup,
  pattern = "*",
  command = "silent! update",
  desc = "Auto save on focus lost",
})

-- 打开文件时记住上次光标位置
autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Restore cursor position",
})

-- OSCYank 配置 (远程服务器剪贴板同步)
autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    local op = vim.v.event.operator
    local reg = vim.v.event.regname
    -- 合并了复制 (y) 和删除 (d) 到 '+' 寄存器的逻辑
    if (op == "y" or op == "d") and reg == "+" then
      vim.cmd("OSCYankRegister +")
    end
  end,
  desc = "Sync to remote clipboard via OSCYank",
})

-- =========================================================================
-- 5. 加载遗留 Vim 脚本 (Legacy Vim Scripts)
-- =========================================================================
local config_path = vim.fn.stdpath("config")
local legacy_scripts = { "misc.vim", "debug.vim" }

for _, script in ipairs(legacy_scripts) do
  local file = config_path .. "/vim/" .. script
  if vim.fn.filereadable(file) == 1 then
    vim.cmd("source " .. file)
  end
end
