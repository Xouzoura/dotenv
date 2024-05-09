local plugins = {
    {
        -- Plugin that creates directories etc
         'stevearc/oil.nvim',
         lazy=false,
         opts = {},
         dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        -- Toggle with <space>pr to show what is the best combination to reach X
        'tris203/precognition.nvim',
        lazy=false,
    },
    {
        -- Tmux to work together with nvim
        'alexghergh/nvim-tmux-navigation',
        config = function()

            local nvim_tmux_nav = require('nvim-tmux-navigation')

            nvim_tmux_nav.setup {
                disable_when_zoomed = true -- defaults to false
            }

            vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
            vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
            vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
            vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
            vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
            vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)

        end
    },
    {
      -- Preview of the functions/classes on the right side of the screen (leader+a)
      "hedyhli/outline.nvim",
      lazy=false,
      config = function()
        -- Example mapping to toggle outline
        vim.keymap.set("n", "<leader>a", "<cmd>Outline<CR>",
          { desc = "Toggle Outline" })

        require("outline").setup {
          -- Your setup opts here (leave empty to use defaults)
            -- outline_window = {    -- 
            --     position='left',
            -- },
            symbols={
                -- filter={"String", "Constant", "Variable", exclude=true}
            }
        }
      end,
    },
    {
        -- Auto select when on visual mode the text object of parents etc (v+.)
        "RRethy/nvim-treesitter-textsubjects",
        -- visual press . , i;
        lazy=false,
        config = function()
            require('nvim-treesitter.configs').setup {
                textsubjects = {
                    enable = true,
                    prev_selection = ',', -- (Optional) keymap to select the previous selection
                    keymaps = {
                        ['.'] = 'textsubjects-smart',
                        [';'] = 'textsubjects-container-outer',
                        ['i;'] = 'textsubjects-container-inner',
                    },
                },
            }
        end
    },
    {
        -- Toggle dictionaries etc to be inline or folded. (< leader >+to)
          'Wansmer/treesj',
          dependencies = { 'nvim-treesitter/nvim-treesitter' },
          lazy=false,
          config = function()
            require('treesj').setup({})
          end,
    },
    {
        -- Way to jump between the edits that I have made (ctrl+q, ctrl+e, leader+oq, leader+oe)
      'bloznelis/before.nvim',
        lazy=false,
          config = function()
            local before = require('before')
            before.setup()

            -- Jump to previous entry in the edit history
            vim.keymap.set('n', '<C-q>', before.jump_to_last_edit, {})

            -- Jump to next entry in the edit history
            vim.keymap.set('n', '<C-e>', before.jump_to_next_edit, {})

            -- Look for previous edits in quickfix list
            vim.keymap.set('n', '<leader>oq', before.show_edits_in_quickfix, {})

            -- Look for previous edits in telescope (needs telescope, obviously)
            vim.keymap.set('n', '<leader>oe', before.show_edits_in_telescope, {})
          end
    },
    {
        -- Preview of any Markdown with :MarkdownPreview
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
        -- Highlight the arguments of the function in a specific color to know that it is provided.
        'm-demare/hlargs.nvim',
        lazy=false,
        config = function()
            require('hlargs').setup()
        end
    },
    {
        -- With the <space>TD(L+R) you can see the todo list
          "folke/todo-comments.nvim",
          lazy=false,
          dependencies = { "nvim-lua/plenary.nvim" },
          opts = {
          }
    },
    {
        -- Go to a specific row when :32 without actually going there
        'nacro90/numb.nvim',
        lazy=false,
        config = function()
            require('numb').setup()
        end
    },
    {
        -- Easy replacer for the word under the cursor
        -- space + R + options to replace within a file/buffer
          "roobert/search-replace.nvim",
          lazy=false,
          config = function()
            require("search-replace").setup({
              -- optionally override defaults
              default_replace_single_buffer_options = "gcI",
              default_replace_multi_buffer_options = "egcI",
            })
          end,
    },
    {
        -- Color highlither for different modes
        'mvllow/modes.nvim',
        lazy=false,
        tag = 'v0.2.0',
        config = function()
            require('modes').setup()
        end
    },
    -- {
    --     -- Popup of cmd in the middle of the screen + Notifications on the side
    --   "folke/noice.nvim",
    --   event = "VeryLazy",
    --   -- lazy=false,
    --   opts = {
    --     -- add any options here
    --   },
    --   dependencies = {
    --     "MunifTanjim/nui.nvim",
    --     "rcarriga/nvim-notify",
    --     },
    --     setup = function()
    --         require("noice").setup({
    --           lsp = {
    --             override = {
    --               ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    --               ["vim.lsp.util.stylize_markdown"] = true,
    --               ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    --               -- ["config.lsp.hover.enabled"] = false,
    --               -- ["config.lsp.signature.enabled"] = false,
    --             },
    --           },
    --           -- you can enable a preset for easier configuration
    --           presets = {
    --             bottom_search = true, -- use a classic bottom cmdline for search
    --             command_palette = true, -- position the cmdline and popupmenu together
    --             long_message_to_split = true, -- long messages will be sent to a split
    --             inc_rename = false, -- enables an input dialog for inc-rename.nvim
    --             lsp_doc_border = false, -- add a border to hover docs and signature help
    --           },
    --             views = {
    --               cmdline_popup = {
    --                 position = {
    --                   row = 5,
    --                   col = "50%",
    --                 },
    --                 size = {
    --                   width = 60,
    --                   height = "auto",
    --                 },
    --               },
    --               popupmenu = {
    --                 relative = "editor",
    --                 position = {
    --                   row = 8,
    --                   col = "50%",
    --                 },
    --                 size = {
    --                   width = 60,
    --                   height = 10,
    --                 },
    --                 border = {
    --                   style = "rounded",
    --                   padding = { 0, 1 },
    --                 },
    --                 win_options = {
    --                   winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
    --                 },
    --               },
    --             },
    --             routes = {
    --               {
    --                 view = "cmdline",
    --                 filter = { event = "msg_showmode" },
    --               },
    --             },
    --         })
    --     end
    -- },
    {
        -- Show a scrollbar at the right side of the screen
        "petertriho/nvim-scrollbar",
        lazy=false,
        config = function()
            require("scrollbar").setup()
        end
    },
    -- {
    --     -- Marks, but using the arrow at the moment
    --     'chentoast/marks.nvim',
    --     lazy=false,
    --     config = function()
    --         require("marks").setup({
    --               -- whether to map keybinds or not. default true
    --               default_mappings = true,
    --               -- which builtin marks to show. default {}
    --               builtin_marks = { ".", "<", ">", "^" },
    --               -- whether movements cycle back to the beginning/end of buffer. default true
    --               cyclic = true,
    --               -- whether the shada file is updated after modifying uppercase marks. default false
    --               force_write_shada = false,
    --               -- how often (in ms) to redraw signs/recompute mark positions. 
    --               -- higher values will have better performance but may cause visual lag, 
    --               -- while lower values may cause performance penalties. default 150.
    --               refresh_interval = 250,
    --               -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
    --               -- marks, and bookmarks.
    --               -- can be either a table with all/none of the keys, or a single number, in which case
    --               -- the priority applies to all marks.
    --               -- default 10.
    --               sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
    --               -- disables mark tracking for specific filetypes. default {}
    --               excluded_filetypes = {},
    --               -- disables mark tracking for specific buftypes. default {}
    --               excluded_buftypes = {},
    --               -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
    --               -- sign/virttext. Bookmarks can be used to group together positions and quickly move
    --               -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
    --               -- default virt_text is "".
    --               bookmark_0 = {
    --                 sign = "⚑",
    --                 virt_text = "hello world",
    --                 -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
    --                 -- defaults to false.
    --                 annotate = false,
    --               },
    --               mappings = {}
    --             })
    --     end
    -- },
    {
        -- Separate the windows with a color around them
          "nvim-zh/colorful-winsep.nvim",
          config = true,
          event = { "WinNew" },
    },
    {
        -- Autocomplete suggestions for cmd
          'smolck/command-completion.nvim',
          lazy=false,
            config = function()
                require("command-completion").setup()
            end,
    },
    {
        -- Autocomplete with tab for the cmd
        'gelguy/wilder.nvim',
        lazy=false,
        after = "nvim-cmp",
        config = function()
            require("wilder").setup({
                modes = {"/"}
            })
        end,
    },
    {
        -- ysiw" to surround the word with "
        -- ds" to remove the surrounding"
        -- cs"' to change the surrounding to '
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
            })
        end
    },
    {
        -- In python to make strings to fstrings
	    "chrisgrieser/nvim-puppeteer",
        lazy = false,
    },
    {
        -- Highlight the undo
        'tzachar/highlight-undo.nvim',
        lazy=false,
    },
    {
        -- preview with gp
        'rmagatti/goto-preview',
        lazy=false,
        config = function()
            require('goto-preview').setup {
                default_mappings = true,
                -- mappings: gp + d,D,i,r,t
            }
        end
    },
    {
        -- Default folder with zA to fold current function
        "kevinhwang91/nvim-ufo",
        event="BufEnter",
        dependencies = {
            "kevinhwang91/promise-async",
            -- Second dependency is to remove the useless numbers on the side.
            {
              "luukvbaal/statuscol.nvim",
              config = function()
                local builtin = require("statuscol.builtin")
                require("statuscol").setup(
                  {
                    relculright = true,
                    segments = {
                      {text = {builtin.foldfunc}, click = "v:lua.ScFa"},
                      {text = {"%s"}, click = "v:lua.ScSa"},
                      {text = {builtin.lnumfunc, " "}, click = "v:lua.ScLa"}
                    }
                  }
                )
              end
            }
        },

        config=function ()
            require("ufo").setup({
                -- zA to fold ``
                provider_selector = function(_bufnr, _filetype, _buftype)
                    return {"treesitter", "indent"}
                end,
            })
        end,
    },
    {
        -- Search and replace within all the files
	    'nvim-pack/nvim-spectre',
        config=function ()
            require('spectre').setup({
                -- mapping space + S, sw, sp,
                result_padding = '',
                default = {
                    replace = {
                        cmd = "sed"
                    }
                }
            })
        end
    },
    {
        -- See all the issues in the file with <space>xx 
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    {
        -- s + word to start search with 2 keystrokes
        "ggandor/leap.nvim",
        lazy = false,
        config = function() require("leap").set_default_keymaps() end
    },
    {
        -- Defualt marks with ; 
        "otavioschwanck/arrow.nvim",
        lazy = false,
        opts = {
              show_icons= true,
              leader_key = ";",


              always_show_path = false,
              separate_by_branch = false, -- Bookmarks will be separated by git branch
              hide_handbook = false, -- set to true to hide the shortcuts on menu.
              save_path = function()
                return vim.fn.stdpath("cache") .. "/arrow"
              end,
              mappings = {
                edit = "e",
                delete_mode = "d",
                clear_all_items = "C",
                toggle = "s", -- used as save if separate_save_and_remove is true
                open_vertical = "|",
                open_horizontal = "-",
                quit = "q",
                remove = "x", -- only used if separate_save_and_remove is true
                next_item = "]",
                prev_item = "["
              },
              -- custom_actions = {
              --   open = function(target_file_name, current_file_name) end, -- target_file_name = file selected to be open, current_file_name = filename from where this was called
              --   split_vertical = function(target_file_name, current_file_name) end,
              --   split_horizontal = function(target_file_name, current_file_name) end,
              -- },
              window = { -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
                width = "auto",
                height = "auto",
                row = "auto",
                col = "auto",
                border = "double",
              },
              per_buffer_config = {
                lines = 4, -- Number of lines showed on preview.
                sort_automatically = true, -- Auto sort buffer marks.
                satellite = { -- defualt to nil, display arrow index in scrollbar at every update
                  enable = false,
                  overlap = true,
                  priority = 1000,
                },
                zindex = 10, --default 50
                treesitter_context = nil, -- it can be { line_shift_down = 2 }, currently not usable, for detail see https://github.com/otavioschwanck/arrow.nvim/pull/43#issue-2236320268
              },
              separate_save_and_remove = false, -- if true, will remove the toggle and create the save/remove keymaps.
              save_key = "cwd", -- what will be used as root to save the bookmarks. Can be also `git_root`.
              global_bookmarks = false, -- if true, arrow will save files globally (ignores separate_by_branch)
              index_keys = "123456789zxcbnmZXVBNM,afghjklAFGHJKLwrtyuiopWRTYUIOP", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
              full_path_list = { "update_stuff" }, -- filenames on this list will ALWAYS show the file path too.
              buffer_leader_key = 'm', -- Per Buffer Mappings
        }
    },
    {
        -- The bar on the top of the file that shows the current function/directory
        'Bekaboo/dropbar.nvim',
        lazy=false,
        dependencies = {
            'nvim-telescope/telescope-fzf-native.nvim'
        }
    },
    {
        -- Highlight the current word
        'RRethy/vim-illuminate',
        lazy=false,
    },
    -- {
    --     -- Cursor to match the color of the word
    --     'mawkler/modicator.nvim',
    --     lazy=false,
    --     dependencies = 'mawkler/onedark.nvim', -- Add your colorscheme plugin here
    --     init = function()
    --         -- These are required for Modicator to work
    --         vim.o.cursorline = true
    --         vim.o.number = true
    --         vim.o.termguicolors = true
    --     end,
    --     opts = {}
    -- },
    {
        -- Ai copilot
        'github/copilot.vim',
        lazy=false
    },
    {
        -- git
        "sindrets/diffview.nvim",
        lazy=false,

    },

    -- DAP Plugins

    -- {
    --     "rcarriga/nvim-dap-ui",
    --     dependencies = {
    --         "mfussenegger/nvim-dap",
    --         "nvim-neotest/nvim-nio",
    --         },
    --     config = function()
    --         local dap = require("dap")
    --         local dapui = require("dapui")
    --         dapui.setup()
    --         dap.listeners.after.event_initialized["dapui_config"] = function()
    --             dapui.open()
    --         end
    --         dap.listeners.before.event_terminated["dapui_config"] = function()
    --             dapui.close()
    --         end
    --         dap.listeners.before.event_exited["dapui_config"] = function()
    --             dapui.close()
    --         end
    --     end
    -- },
    -- {
    --     "mfussenegger/nvim-dap",
    --     config = function(_, opts)
    --         require ("core.utils").load_mappings("dap")
    --     end
    -- },
    -- {
    --     'theHamsta/nvim-dap-virtual-text',
    --     config = function()
    --         require('dap-virtual-text').setup()
    --     end
    -- },
    -- {
    --     "mfussenegger/nvim-dap-python",
    --     ft="python",
    --     dependencies= {
    --         "mfussenegger/nvim-dap",
    --         "rcarriga/nvim-dap-ui",
    --     },
    --     config = function(_, opts)
    --         local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
    --         require("dap-python").setup(path)
    --         require("core.utils").load_mappings("dap_python")
    --     end,
    -- },

    -- LSP and installation plugins
    --
    {
        "jose-elias-alvarez/null-ls.nvim",
        ft = {"python"},
        opts = function()
            return require "custom.configs.null-ls"
        end,
    },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "black",
                "debugpy",
                "pyright",
                "mypy",
                "ruff",
                "isort",

            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end,
    },
}
return plugins
