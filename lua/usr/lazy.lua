local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- 基础
  "nvim-lua/plenary.nvim",        -- 很多 lua 插件依赖的库
  "nvim-tree/nvim-web-devicons",  -- 显示图标
  {
    "folke/which-key.nvim",       -- 用于配置和提示快捷键
    event = "VeryLazy",
    config = function() require("usr.which-key") end,
  },
  "kkharji/sqlite.lua",           -- 数据库

  -- 补全
  {
    "hrsh7th/nvim-cmp",           -- the completion plugin
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-cmdline",      -- 核心：命令行补全
      "hrsh7th/cmp-buffer",       -- 在命令行搜索时提供 buffer 里的词汇
      "hrsh7th/cmp-path",         -- 在命令行输入路径时提供补全
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/snippets/" })
        end,
      },
    },
    config = function() require("usr.cmp") end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "nvimtools/none-ls.nvim",
      "mattn/efm-langserver",         -- 支持 bash
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
        config = function() require("fidget").setup() end,
      },
      {
        "SmiteshP/nvim-navic",
        config = function() require("nvim-navic").setup() end,
      },
      {
        "kosayoda/nvim-lightbulb",
        config = function() require("nvim-lightbulb").update_lightbulb() end,
      },
      {
        "utilyre/barbecue.nvim",    -- for formatters and linters
        config = function() require("barbecue").setup() end,
      },
    },
    config = function() require("usr.lsp") end,
  },
  -- LSP 增强
  {
    "jackguo380/vim-lsp-cxx-highlight", -- ccls 高亮
    ft = { "c", "cpp" }
  },
  {
    "gbrlsnchs/telescope-lsp-handlers.nvim",
    event = "LspAttach"
  },
  {
    "jakemason/ouroboros",          -- quickly switch between header and source file in C/C++ project
    ft = { "c", "cpp" },
    cmd = "Ouroboros"
  },

  -- LLM
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    config = function() require("usr.codecompanion") end,
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function() require("usr.nvim-treesitter") end,
  },
  {
    "cshuaimin/ssr.nvim",         -- 结构化查询和替换
    keys = {
      { "<leader>r", function() require("ssr").open() end, mode = { "n", "x" }, desc = "Structural Replace" }
    },
  },

  -- UI & Navigation
  {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" }, -- 敲命令时才加载文件树
    config = function() require("usr.nvim-tree") end,
  },
  {
    "stevearc/aerial.nvim",       -- 导航栏
    cmd = { "AerialToggle", "AerialNavToggle" },
    config = function()
      require("aerial").setup({
        backends = { "markdown", "man", "lsp", "treesitter" },
        layout = { max_width = { 30, 0.15 }, placement = "edge", default_direction = "left" },
        attach_mode = "global",
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",    -- buffer
    event = "VeryLazy",
    config = function() require("usr.bufferline") end,
  },
  {
    "nvim-lualine/lualine.nvim",  -- 状态栏
    event = "VeryLazy",
    config = function() require("lualine").setup() end,
  },
  {
    "kazhala/close-buffers.nvim", -- 一键删除不可见 buffer
    cmd = { "BDelete", "BWipeout" }
  },
  {
    "xiyaowong/nvim-transparent", -- 可以移除掉背景色，让 vim 透明
    cmd = "TransparentToggle"
  },
  {
    "goolord/alpha-nvim",         -- 启动时展示的 Dashboard
    event = "VimEnter",
    config = function() require("usr.alpha") end
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- Noice 的核心美化预设
      presets = {
        bottom_search = true, -- 搜索框依然在底部（很多人习惯这样，如果设为 false 则会在屏幕中间弹出）
        command_palette = false, -- 将命令行和补全菜单组合成类似 VSCode 命令面板的样式
        long_message_to_split = true, -- 极长的报错信息会在新分屏显示，而不会卡住屏幕
        inc_rename = false,
        lsp_doc_border = true, -- 为悬浮文档添加边框
      },
      cmdline = {
        view = "cmdline",
      },
      -- 确保 Noice 接管 cmp 的弹出菜单
      popupmenu = {
        enabled = true,
        backend = "cmp",
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  -- 颜色主题
  "folke/tokyonight.nvim",
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function() require("usr.colorscheme") end
  },

  -- git 管理
  {
    "tpope/vim-fugitive",         -- 显示 git blame，实现一些基本操作的快捷执行
    cmd = { "Git", "G", "Gdiff", "Gblame" }
  },
  {
    "rhysd/git-messenger.vim",      -- 利用 git blame 显示当前行的 commit message
    cmd = "GitMessenger",
  },
  {
    "f-person/git-blame.nvim",    -- 显示 git blame 信息
    event = { "BufReadPre", "BufNewFile" }
  },
  {
    "lewis6991/gitsigns.nvim",    -- 显示改动的信息
    event = { "BufReadPre", "BufNewFile" },
    config = function() require("gitsigns").setup({ signcolumn = false, numhl = true }) end,
  },

  -- 基于 telescope 的搜索
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",             -- 敲命令时才唤醒 Telescope
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
      },
      "nvim-telescope/telescope-frecency.nvim",
      "xiyaowong/telescope-emoji.nvim",
    },
    config = function() require("usr.telescope") end,
  },

  -- 运行与终端
  {
    "voldikss/vim-floaterm",      -- 终端
    cmd = { "FloatermNew", "FloatermToggle" }
  },
  {
    "akinsho/toggleterm.nvim",    -- 性能好点，但是易用性和稳定性都比较差
    cmd = "ToggleTerm"
  },
  { "samjwill/nvim-unception", lazy = false }, -- 嵌套 nvim 自动 offload 到 host 中，防止嵌套 Neovim，通常需要 lazy=false
  {
    "CRAG666/code_runner.nvim",   -- 一键运行代码
    cmd = { "RunCode", "RunFile", "RunProject" },
    config = function() require("usr.code_runner") end,
  },

  -- markdown
  -- 如果发现插件有问题， 可以进入到 ~/.local/share/nvim/lazy/markdown-preview.nvim/app && npm install
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreview" },
  --   ft = { "markdown" },
  --   build = "cd app && npm install",
  -- },
  {
    "mzlogin/vim-markdown-toc",   -- 自动目录生成
    ft = "markdown", cmd = { "GenTocGFM", "UpdateToc" }
  },
  {
    "dhruvasagar/vim-table-mode", -- 快速编辑 markdown 的表格
    ft = "markdown", cmd = "TableModeToggle"
  },

  -- 高效编辑
  { "tpope/vim-commentary", keys = { "gc", "gcc" } },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "mbbill/undotree", cmd = "UndotreeToggle" },
  { "mg979/vim-visual-multi", keys = { "<C-n>", "<C-Down>", "<C-Up>" } },
  { "honza/vim-snippets", event = "InsertEnter" },
  { "windwp/nvim-spectre", cmd = "Spectre" },
  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("nvim-surround").setup() end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require("nvim-autopairs").setup() end,
  },
  {
    "AckslD/nvim-neoclip.lua",
    event = "VeryLazy",
    config = function() require('neoclip').setup() end,
  },

  -- 高亮
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup({ "css", "javascript", "vim", html = { mode = "foreground" } })
    end,
  },
  { "andymass/vim-matchup", event = { "BufReadPost", "BufNewFile" } },
  { "azabiong/vim-highlighter", cmd = "Hi" },

  -- 时间管理
  -- {
  --   "nvim-neorg/neorg",
  --    lazy = false,
  --    -- version = "*",              -- Pin Neorg to the latest stable release
  --    version = false,            -- get latest on branch
  --    ft = "norg",                -- 只有打开 .norg 文件才加载
  --    cmd = "Neorg",              -- 或者输入 :Neorg 命令时加载
  --    dependencies = {
  --      'nvim-neorg/lua-utils.nvim',
  --      'pysan3/pathlib.nvim',
  --      'nvim-neotest/nvim-nio',
  --      -- "nvim-neorg/tree-sitter-norg"
  --    },
  --    config = function() require("usr.neorg") end,
  -- },

  -- 其他
  -- {
  --   url = "https://codeberg.org/andyg/leap.nvim",
  --   event = "VeryLazy",
  --   config = function() require("leap").add_default_mappings() end,
  -- },
  {
    "crusj/bookmarks.nvim",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("bookmarks").setup({
        mappings_enabled = false,
        virt_pattern = { "*.lua", "*.md", "*.c", "*.h", "*.sh" },
      })
    end,
  },
  {
    "tyru/open-browser.vim",      -- 使用 gx 打开链接
    keys = { { "gx", mode = { "n", "x" } } }
  },
  { "dstein64/vim-startuptime", cmd = "StartupTime" }, -- 分析 nvim 启动时间
  { "voldikss/vim-translator", cmd = { "Translate", "TranslateW" } },
  {
    "olimorris/persisted.nvim",
    lazy = false,
    config = function() require("persisted").setup({ autoload = true }) end,
  },
  {
    "nvimtools/hydra.nvim",       -- 消除重复快捷键，可以用于调整 window 大小等
    event = "VeryLazy",
    config = function() require("usr.hydra") end,
  },
  {
    "OscarCreator/rsync.nvim",    -- 自动同步代码远程
    cmd = { "RsyncUp", "RsyncDown" },
    build = "make",               -- 实在不行，进入到 ~/.local/share/nvim/lazy/rsync.nvim 中执行下 make
  },
}, {
  -- -- 全局配置字典开始
  -- change_detection = {
  --   enabled = true,
  --   notify = true,
  -- },
  -- performance = {
  --   cache = {
  --     enabled = true,
  --   },
  --   reset_packpath = true, -- 强制重置包路径，防止重复加载
  -- },
})
