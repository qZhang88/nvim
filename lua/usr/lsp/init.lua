require("usr.lsp.mason")
require("usr.lsp.handlers").setup()

-- vim.lsp.config("ccls", {
--   init_options = {
--     -- compilationDatabaseDirectory = "build";
--     index = {
--       threads = 0;
--     };
--     clang = {
--       excludeArgs = { "-frounding-math"} ;
--     };
--     highlight = {
--       lsRanges = true;
--     };
--   }
-- })
-- vim.lsp.enable('ccls')
vim.lsp.enable('clangd')
