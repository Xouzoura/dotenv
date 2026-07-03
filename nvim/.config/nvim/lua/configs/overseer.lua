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

  -- to run some projects on my own
  uv_run = {
    name = "uv run",
    builder = function()
      local entry = nil

      if vim.fn.filereadable "src/app/main.py" == 1 then
        entry = "src/app/main.py"
      elseif vim.fn.filereadable "src/main.py" == 1 then
        entry = "src/main.py"
      elseif vim.fn.filereadable "main.py" == 1 then
        entry = "main.py"
      end

      if not entry then
        return nil
      end
      print("STARTING ", entry)
      return {
        cmd = { "uv" },
        args = { "run", entry },
        components = { "default" },
      }
    end,
    condition = {
      callback = function()
        return vim.fn.executable "uv" == 1
      end,
    },
  },
}
