local Hydra = require("hydra")

-- 首先按 c a ，然后就可以使用 hjkl 来调整窗口大小
Hydra({
  name = "Adjust Window Size",
  mode = "n",
  body = "ca",
  config = {
    color = "pink",
    invoke_on_body = true,
    on_enter = function()
      vim.o.virtualedit = "all"
    end,
  },
  heads = {
    { "h",     "<cmd>vertical resize +10<cr>", { desc = "Resize Right" } },
    { "l",     "<cmd>vertical resize -10<cr>", { desc = "Resize Left" } },
    { "<Esc>", nil,    { exit = true, desc = "Exit" } },
    { "<CR>",  nil,    { exit = true, desc = "Exit" } },
  },
})

-- 当想要修改一块代码的缩进的时候，使用 < 或者 > ，然后使用 . 来重复，这是 vim 的默认行为。
