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

wilder.set_option('renderer', wilder.popupmenu_renderer({
  highlighter = wilder.basic_highlighter(),
}))

wilder.set_option('renderer', wilder.renderer_mux({
  [':'] = wilder.popupmenu_renderer({
    highlighter = wilder.lua_fzy_highlighter(),
  }),
  ['/'] = wilder.wildmenu_renderer({
    highlighter = wilder.lua_fzy_highlighter(),
  }),
}))

vim.api.nvim_set_keymap('c', '<Tab>', [[wilder#next()]], {noremap = true, expr = true})
vim.api.nvim_set_keymap('c', '<S-Tab>', [[wilder#previous()]], {noremap = true, expr = true})
