return {
  -- chatgpt in the nvim config
  "robitx/gp.nvim",
  lazy = false,
  config = function()
    local SYSTEM_PROMPT = "You are a general AI assistant working for a senior software engineer, so focus more on code and limit the explanation, unless specifically requested. Be precise, concise, avoid repeating what I have asked, repeating code. When asked to explain, be explain what you are asked only, when asked to code, be brief providing only code.\n\n"
      .. "- When asked to explain, only explain what you are asked without repeating information and giving too much information.\n"
      .. "- Focus on code first. Try to limit the explanation to the code, and the words to a minimum. Answer strictly the question\n"
      .. "- The user provided the additional info about how they would like you to respond:\n"
      .. "- If you're unsure don't guess and say you don't know instead.\n"
      .. "- Ask question if you need clarification to provide better answer.\n"
      .. "- Zoom out first to see the big picture and then zoom in to details.\n"
    local azure_endpoint
    -- using _AZURE_OPENAI_ENDPOINT as a system environment variable
    if os.getenv "_AZURE_OPENAI_ENDPOINT" == nil then
      azure_endpoint =
        -- does not work, just doesn't throw errors
        "https://<...>/openai/deployments/{{model}}/chat/completions?api-version=2024-12-01-preview"
    else
      -- Assuming _AZURE_OPENAI_ENDPOINT is as https://___.openai.azure.com
      azure_endpoint = os.getenv "_AZURE_OPENAI_ENDPOINT"
        .. "/openai/deployments/{{model}}/chat/completions?api-version=2024-12-01-preview"
    end
    local config = {

      cmd_prefix = "Gp",
      curl_params = {},
      ---@type "popup" | "split" | "vsplit" | "tabnew"
      toggle_target = "vsplit", -- decide which one i like more
      -- toggle_target = "popup",
      chat_confirm_delete = false,
      state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/persisted",
      providers = {
        azure = {
          disable = false,
          endpoint = azure_endpoint,
          secret = os.getenv "_AZURE_OPENAI_KEY", -- KEEP IN MIND THAT YOU NEED THIS AS A SYSTEM ENVIRONMENT VARIABLE
        },
        pplx = {
          endpoint = "https://api.perplexity.ai/chat/completions",
          secret = os.getenv "PPLX_API_KEY",
        },
        -- googleai = {
        --   endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
        --   secret = os.getenv "GEMINI_API_KEY",
        -- },
      },

      agents = {
        --- DISABLE THE DEFAULT ONES BECAUSE THEY ARE STILL PICKED UP.
        {
          provider = "azure",
          name = "CodeGPT4o-mini",
          disable = true,
        },
        {
          provider = "azure",
          name = "ChatGPT4o",
          disable = true,
        },
        {
          provider = "azure",
          name = "ChatGPT4o-mini",
          disable = true,
        },
        {
          provider = "azure",
          name = "ChatGPT-o3-mini",
          disable = true,
        },
        {
          provider = "azure",
          name = "ChatGemini",
          disable = true,
        },
        {
          provider = "azure",
          name = "CodeGPT4o",
          disable = true,
        },
        {
          provider = "azure",
          name = "CodeGemini",
          disable = true,
        },
        {
          provider = "azure",
          name = "CodeGPT-o3-mini",
          disable = true,
        },
        {
          provider = "azure",
          name = "CodeGPT-o3-mini",
          disable = true,
        },
        { provider = "pplx", name = "ChatPerplexityLlama3.1-8B", disable = true },
        {
          -- Works only with the bypass that is the dispatcher.prepare_payload
          -- doing.
          provider = "azure",
          name = "o3-mini",
          chat = true,
          command = false,
          model = { model = "o3-mini", temperature = 1.1, top_p = 1 },
          system_prompt = SYSTEM_PROMPT,
          disable = true,
        },
        {
          provider = "pplx",
          name = "sonar",
          chat = true,
          command = false,
          model = { model = "sonar", temperature = 1.1, top_p = 1 },
          system_prompt = SYSTEM_PROMPT,
          -- disable = true,
        },
        -- {
        --   provider = "googleai",
        --   name = "ChatGemini",
        --   disable = true, -- because i don't want it from gp.nvim default config.
        --   chat = true,
        --   command = false,
        --   -- string with model name or table with model name and parameters
        --   model = { model = "gemini-pro", temperature = 1.1, top_p = 1 },
        --   -- system prompt (use this to specify the persona/role of the AI)
        --   system_prompt = require("gp.defaults").chat_system_prompt,
        -- },
        -- {
        --   provider = "googleai",
        --   name = "gemini-2.0-flash",
        --   chat = true,
        --   command = false,
        --   model = { model = "gemini-2.0-flash", temperature = 1.1, top_p = 1 },
        --   system_prompt = SYSTEM_PROMPT,
        -- },
        -- {
        --   provider = "googleai",
        --   name = "gemini-2.5-pro",
        --   disabled = true, -- because it's not for free.
        --   chat = true,
        --   command = false,
        --   model = { model = "gemini-2.5-pro-preview-03-25", temperature = 1.1, top_p = 1 },
        --   system_prompt = SYSTEM_PROMPT,
        -- },
        {
          provider = "azure",
          name = "gpt4o",
          chat = true,
          command = false,
          model = { model = "gpt4o", temperature = 1.1, top_p = 1 },
          system_prompt = SYSTEM_PROMPT,
        },
        --
        -- Last one is the default always
        --
        {
          provider = "azure",
          name = "gpt-4.1",
          chat = true,
          command = false,
          model = { model = "gpt-4.1", temperature = 1.1, top_p = 1 },
          system_prompt = SYSTEM_PROMPT,
        },
      },
      chat_user_prefix = "---------------------------- NEW 💬 ----------------------------",
      chat_assistant_prefix = { ">>> 🤖 : ", "[{{agent}}]", " <<<" },
    }
    require("gp").setup(config)
    -- https://github.com/Robitx/gp.nvim/issues/245 solution from the issue
    -- related to https://github.com/Robitx/gp.nvim/pull/246
    -- Monkey patch the dispatcher after setup
    local dispatcher = require "gp.dispatcher"
    local original_prepare_payload = dispatcher.prepare_payload
    dispatcher.prepare_payload = function(messages, model, provider)
      local output = original_prepare_payload(messages, model, provider)
      if provider == "azure" and (model.model:sub(1, 2) == "o3") then
        for i = #messages, 1, -1 do
          if messages[i].role == "system" then
            table.remove(messages, i)
          end
        end
        output.max_tokens = nil
        output.temperature = nil
        output.top_p = nil
        output.stream = true
      end
      return output
    end
    local function keymapOptions(desc)
      return {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "GPT prompt " .. desc,
      }
    end
    local q_symbol = config.chat_user_prefix
    local a_symbol = config.chat_assistant_prefix[1]
    local function goToPlace(symbol, direction)
      -- Search for the next "question"/"answer" symbol
      -- forward (W) or backward (bW)
      vim.fn.search(symbol, direction) -- 'W' ensures it wraps around to the start of the file
    end
    local map = vim.keymap.set
    map({ "n", "i" }, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions "New Chat")
    map({ "n", "i" }, "<C-g>;", "<cmd>GpChatToggle<cr>", keymapOptions "Toggle Chat")
    map({ "n", "i" }, "<C-g>o", "<cmd>GpChatToggle popup<cr>", keymapOptions "Toggle Chat Popup")
    map({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions "Chat Finder")
    map({ "n" }, "[<C-g>", function()
      goToPlace(q_symbol, "bW")
    end, keymapOptions "Go to prev question")
    map({ "n" }, "]<C-g>", function()
      goToPlace(q_symbol, "W")
    end, keymapOptions "Go to next question")
    map({ "n" }, "[g", function()
      goToPlace(a_symbol, "bW")
    end, keymapOptions "Go to previous answer")
    map({ "n" }, "]g", function()
      goToPlace(a_symbol, "W")
    end, keymapOptions "Go to next answer")
    -- map({ "n" }, "<C-g>]", goToNextQuestion, keymapOptions "Go to next question")
    -- map({ "n" }, "<C-g>[", goToPreviousQuestion, keymapOptions "Go to previous question")
    -- map({ "n" }, "<C-g>}", goToNextAnswer, keymapOptions "Go to next answer")
    -- map({ "n" }, "<C-g>{", goToPreviousAnswer, keymapOptions "Go to previous answer")

    map("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions "Visual Chat New")
    map("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions "Visual Chat Paste")
    map("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions "Visual Toggle Chat")
    -- map({ "n", "i" }, "<C-g>gp", "<cmd>GpPopup<cr>", keymapOptions "Popup")
    map({ "n", "i", "v", "x" }, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions "Stop")
    map({ "n", "i", "v", "x" }, "<C-g>n", "<cmd>GpNextAgent<cr>", keymapOptions "Next Agent")
  end,
}
