-- my custom tasks
return {
  docker_up = {
    name = "docker compose up",
    builder = function()
      return {
        cmd = { "docker-compose" },
        args = { "up", "-d" },
        components = { "default" },
      }
    end,
    condition = {
      callback = function()
        return vim.fn.executable "docker-compose" == 1
      end,
    },
  },

  docker_down = {
    name = "docker compose down",
    builder = function()
      return {
        cmd = { "docker-compose" },
        args = { "down" },
        components = { "default" },
      }
    end,
  },
}
