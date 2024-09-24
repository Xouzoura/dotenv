SYSTEM_PROMPT = "You are a general AI assistant working for a senior software engineer, so focus more on code and limit the explanation.\n\n"
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
      name = "gpt4o",
      provider = "azure",
      chat = true,
      command = false,
      model = { model = "gpt4o", temperature = 1.1, top_p = 1 },
      system_prompt = SYSTEM_PROMPT,
    },
  },
}
return config
