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
  "clangd",
  -- "ccls",
  -- "nixd",
  -- "rnix",
  -- "tsserver",
}

local handlers = require("usr.lsp.handlers")

require("mason").setup()

vim.lsp.config("*", {
  on_attach = handlers.on_attach,
  capabilities = handlers.capabilities,
})

for _, server in ipairs(servers) do
  server = vim.split(server, "@")[1]
  local ok, settings = pcall(require, "usr.lsp.settings." .. server)
  if ok then
    vim.lsp.config(server, settings)
  end
end

require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_enable = true,
})
