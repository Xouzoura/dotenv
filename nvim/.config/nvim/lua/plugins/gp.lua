return {
  -- chatgpt in the nvim config
  "robitx/gp.nvim",
  lazy = false,
  config = function()
    local SYSTEM_PROMPT = "You are a general AI assistant working for a senior software engineer, so focus more on code and limit the explanation. Be as precise as possible, avoid repeating, structuring the reply or repeating code you have received, When asked to explain, be brief, when asked to code, be brief providing only code.\n\n"
      .. "- Please provide a brief, concise answer using as few words as possible.\n"
      .. "- Focus on code first. Try to limit the explanation to the code, and the words to a minimum. Answer strictly the question\n"
      .. "- The user provided the additional info about how they would like you to respond:\n"
      .. "- If you're unsure don't guess and say you don't know instead.\n"
      .. "- Only reply with as concise information as possible so if not requested do not provide lots of information.\n"
      .. "- Ask question if you need clarification to provide better answer.\n"
      .. "- Zoom out first to see the big picture and then zoom in to details.\n"
    local endpoint
    if os.getenv "AZURE_OPENAI_ENDPOINT" == nil then
      endpoint =
        -- does not work
        "https://<...>/openai/deployments/{{model}}/chat/completions?api-version=2024-12-01-preview"
    else
      -- Assuming AZURE_OPENAI_ENDPOINT is as https://___.openai.azure.com
      endpoint = os.getenv "AZURE_OPENAI_ENDPOINT"
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
          endpoint = endpoint,
          secret = os.getenv "AZURE_OPENAI_KEY", -- KEEP IN MIND THAT YOU NEED THIS AS A SYSTEM ENVIRONMENT VARIABLE
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
          system_prompt = SYSTEM_PROMPT,
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
          system_prompt = SYSTEM_PROMPT,
        },
        {
          -- Works only with the bypass that is the dispatcher.prepare_payload
          -- doing.
          provider = "azure",
          name = "o3-mini",
          chat = true,
          command = false,
          model = { model = "o3-mini", temperature = 1.1, top_p = 1 },
          system_prompt = SYSTEM_PROMPT,
          -- disable = true,
        },
        {
          provider = "azure",
          name = "o1-mini",
          chat = true,
          command = false,
          model = { model = "o1-mini", temperature = 1.1, top_p = 1 },
          system_prompt = SYSTEM_PROMPT,
          disable = true, -- DOES NOT WORK
        },
        -- Last one is the default always
        {
          provider = "azure",
          name = "gpt4o",
          chat = true,
          command = false,
          model = { model = "gpt4o", temperature = 1.1, top_p = 1 },
          system_prompt = SYSTEM_PROMPT,
        },
      },
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
    local function goToNextQuestion()
      -- Search for the next "💬:" symbol
      vim.fn.search("💬:", "W") -- 'W' ensures it wraps around to the start of the file
    end
    local function goToPreviousQuestion()
      -- Search for the next "💬:" symbol
      vim.fn.search("💬:", "bW") -- 'W' ensures it wraps around to the start of the file
    end
    local function goToNextAnswer()
      -- Search for the next "💬:" symbol
      vim.fn.search("🤖", "W") -- 'W' ensures it wraps around to the start of the file
    end
    local function goToPreviousAnswer()
      -- Search for the next "💬:" symbol
      vim.fn.search("🤖:", "bW") -- 'W' ensures it wraps around to the start of the file
    end
    local map = vim.keymap.set
    map({ "n", "i" }, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions "New Chat")
    -- map({ "n", "i" }, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions "Toggle Chat")
    map({ "n", "i" }, "<C-g>;", "<cmd>GpChatToggle<cr>", keymapOptions "Toggle Chat")
    map({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions "Chat Finder")
    map({ "n" }, "<C-g>]", goToNextQuestion, keymapOptions "Go to next question")
    map({ "n" }, "<C-g>[", goToPreviousQuestion, keymapOptions "Go to previous question")
    map({ "n" }, "<C-g>}", goToNextAnswer, keymapOptions "Go to next answer")
    map({ "n" }, "<C-g>{", goToPreviousAnswer, keymapOptions "Go to previous answer")

    map("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions "Visual Chat New")
    map("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions "Visual Chat Paste")
    map("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions "Visual Toggle Chat")
    map({ "n", "i" }, "<C-g>gp", "<cmd>GpPopup<cr>", keymapOptions "Popup")
    map({ "n", "i", "v", "x" }, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions "Stop")
    map({ "n", "i", "v", "x" }, "<C-g>n", "<cmd>GpNextAgent<cr>", keymapOptions "Next Agent")
  end,
}
