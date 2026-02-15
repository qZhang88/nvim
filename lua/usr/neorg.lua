require("neorg").setup {
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.concealer"] = {}, -- Adds pretty icons to your documents
    ["core.dirman"] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
          work = "~/Desktop/Projects/neovim/gtd/work",
	  home = "~/Desktop/Projects/neovim/gtd/home",
	},
        index = "index.norg",
      },
    },
    ["core.ui.calendar"] = {},
  },
}

