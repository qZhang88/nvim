require'nvim-treesitter'.install {
  "bash",
  "c",
  "comment", -- 更好的高亮 TODO XXX NOTE FIXME ，但是其让 url 的高亮过于明显
  "cpp",
  "diff",
  "go",
  "java",
  'javascript',
  "lua",
  "rust",
  "python",
  "markdown",
  "markdown_inline", -- 让 markdown 里面的代码段可以高亮
  "yaml",
  "vim",
}
