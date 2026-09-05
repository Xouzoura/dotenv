return {
  "atiladefreitas/bloocky",
    lazy=false,
  config = function()
    require("bloocky").setup {
      sync = {
        enabled = true,
        accounts = {
          {
            id = "gcal",
            provider = "google",
            client_id = "937291058622-ephe9r3eq6eekr0enagoskrdpk2qlcln.apps.googleusercontent.com",
            client_secret_cmd = { "secret-tool", "lookup", "service", "bloocky", "key", "google" },
          },
        },
      },
    }
  end,
}
