local cc = require('codecompanion')

cc.setup({
  adapters = {
    deepseek = function()
      return require("codecompanion.adapters").extend("deepseek", {
        env = {
          api_key = function()
            return os.getenv("DEEPSEEK_API_KEY")
          end,
        },
        schema = {
          model = {
            default = "deepseek-chat",
          },
        },
      })
    end,
  },
  interactions = {
    chat = { adapter = "deepseek" },
    inline = { adapter = "deepseek" },
  },
})
