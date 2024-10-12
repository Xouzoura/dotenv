return {
  -- chatgpt in the nvim config
  "robitx/gp.nvim",
  lazy = false,
  config = function()
    local config = require "configs.gp-config"
    local SYSTEM_PROMPT = "You are a general AI assistant working for a senior software engineer, so focus more on code and limit the explanation.\n\n"
      .. "The user provided the additional info about how they would like you to respond:\n\n"
      .. "- If you're unsure don't guess and say you don't know instead.\n"
      .. "- Focus on code first. Try to limit the explanation to the code, and the words to a minimum. Answer strictly the question\n"
      .. "- Only reply with as concise information as possible so if not requested do not provide lots of information.\n"
      .. "- Ask question if you need clarification to provide better answer.\n"
      .. "- Think deeply and carefully from first principles step by step.\n"
      .. "- Zoom out first to see the big picture and then zoom in to details.\n"
      .. "- Use Socratic method to improve your thinking and coding skills.\n"
      .. "- Don't elide any code from your output if the answer requires coding.\n"
      .. "- Take a deep breath; You've got this!\n"
    -- SYSTEM_PROMPT = config["SYSTEM_PROMPT"]
    -- print(SYSTEM_PROMPT)
    local config = {

      cmd_prefix = "Gp",
      curl_params = {},
      state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/persisted",
      providers = {
        azure = {
          disable = false,
          endpoint = "https://endaprime-ai-sw.openai.azure.com/openai/deployments/{{model}}/chat/completions?api-version=2023-03-15-preview",
          secret = os.getenv "AZURE_OPENAI_KEY",
        },
      },

      agents = {
        {
          name = "ChatGPT4o",
          disable = true,
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        {
          provider = "openai",
          name = "ChatGPT4o-mini",
          disable = true,
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4o-mini", temperature = 1.1, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        {
          name = "gpt4o",
          provider = "azure",
          chat = true,
          command = false,
          model = { model = "gpt4o", temperature = 1.1, top_p = 1 },
          system_prompt = SYSTEM_PROMPT,
        },
        -- {
        --   name = "o1-preview",
        --   provider = "azure",
        --   chat = true,
        --   command = false,
        --   model = { model = "o1-preview", temperature = 1.1, top_p = 1 },
        --   -- system_prompt = SYSTEM_PROMPT,
        -- },
      },
    }
    require("gp").setup(config)
    local function keymapOptions(desc)
      return {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "GPT prompt " .. desc,
      }
    end
    local map = vim.keymap.set
    map({ "n", "i" }, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions "New Chat")
    map({ "n", "i" }, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions "Toggle Chat")
    map({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions "Chat Finder")

    map("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions "Visual Chat New")
    map("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions "Visual Chat Paste")
    map("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions "Visual Toggle Chat")
    map({ "n", "i" }, "<C-g>gp", "<cmd>GpPopup<cr>", keymapOptions "Popup")
    map({ "n", "i", "v", "x" }, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions "Stop")
    map({ "n", "i", "v", "x" }, "<C-g>n", "<cmd>GpNextAgent<cr>", keymapOptions "Next Agent")
  end,
}
