local wilder = require('wilder')

wilder.setup({
  modes = { ':', '/', '?' },
})

wilder.set_option('use_python_remote_plugin', 0)

wilder.set_option('pipeline', {
  wilder.branch(
    wilder.cmdline_pipeline({
      fuzzy = 1,
      fuzzy_filter = wilder.lua_fzy_filter(),
    }),
    wilder.vim_search_pipeline()
  )
})

-- 设置渲染器
wilder.set_option('renderer', wilder.renderer_mux({
  [':'] = wilder.popupmenu_renderer(
    -- 使用 popupmenu_border_theme 增加边框
    wilder.popupmenu_border_theme({
      highlighter = wilder.lua_fzy_highlighter(),
      -- 边框样式，可选：'single', 'double', 'rounded'（圆角）或 'solid'
      border = 'rounded',
      -- 边框的高亮组（可选，如果不设置则跟随默认）
      highlights = {
        border = 'Normal', -- 或者你可以设为 'FloatBorder'
      },
      -- 设置弹窗的偏移量（可选，调整弹框位置）
      -- left = { ' ', wilder.popupmenu_devicons() }, -- 如果你想加图标可以取消注释
      -- right = { ' ', wilder.popupmenu_scrollbar() }, -- 添加滚动条
    })
  ),
  ['/'] = wilder.wildmenu_renderer({
    highlighter = wilder.lua_fzy_highlighter(),
  }),
}))

vim.api.nvim_set_keymap('c', '<Tab>', [[wilder#next()]], {noremap = true, expr = true})
vim.api.nvim_set_keymap('c', '<S-Tab>', [[wilder#previous()]], {noremap = true, expr = true})
