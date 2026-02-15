local servers = {
  "bashls",
  "cssls",
  "html",
  "lua_ls",
  "pyright",
  "rust_analyzer",
  "jsonls",
  "yamlls",
  "efm",
  "vimls",
  "marksman",
  -- "ccls",
  -- "nixd",
  -- "rnix",
  -- "tsserver",
}

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = true,
})
