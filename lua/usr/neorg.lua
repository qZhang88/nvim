require("neorg").setup {
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.concealer"] = {}, -- Adds pretty icons to your documents
    ["core.dirman"] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
	  work = "~/ws/code/neovim/notes/work",
	  home = "~/ws/code/neovim/notes/home",
	},
      },
    },
    ["core.ui.calendar"] = {},
  },
}

