-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- 1. Combined Installer & Config
    { 
      "williamboman/mason.nvim", 
      config = function()
        require("mason").setup()
      end 
    },
    
    -- 2. Bridge & TS Server
    { 
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "williamboman/mason.nvim" }, -- Ensures Mason loads first
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = { "vtsls" }
        })
      end
    },

    -- 3. LSP Configs
    { "neovim/nvim-lspconfig" },

    -- 4. Prettier
    {
      "stevearc/conform.nvim",
      opts = {
        -- Define your formatters by filetype
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
        },
        -- Enable "format on save"
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
      },
    },

    -- 5. LSPKind 
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "onsails/lspkind.nvim",      -- The icon plugin
        "hrsh7th/cmp-nvim-lsp",      -- LSP source for cmp
        "L3MON4D3/LuaSnip",          -- Snippets
      },
      config = function()
        local cmp = require('cmp')
        local lspkind = require('lspkind')

        cmp.setup({
          formatting = {
            format = lspkind.cmp_format({
              mode = 'symbol_text',  -- shows icon + name (e.g.    Function)
              maxwidth = 50,
            })
          },
          -- Basic mappings to make the menu work
          mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = {
            { name = 'nvim_lsp' },
          },
        })
      end
    },

    -- 6. Telescope plugin

    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.8', -- Use the latest stable version
      dependencies = { 
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
      },
      config = function()
        require('telescope').setup({
          -- Optional: add your custom telescope settings here
        })
        -- Load the fast fzf extension if it's installed
        pcall(require('telescope').load_extension, 'fzf')
      end
    },

    -- 7. TSC Plugin
    {
      "dmmulroy/tsc.nvim",
      config = function()
        require("tsc").setup({
          auto_open_qflist = true, -- Automatically open the quickfix list if errors are found
        })
      end,
    },

    -- 8. Beautiful notifications
    {
      "rcarriga/nvim-notify",
      config = function()
        local notify = require("notify")
        notify.setup({
          background_colour = "#000000", -- Better for transparent terminals
          timeout = 3000,                -- Auto-dismiss after 3 seconds
        })
        -- Set Neovim's default notification to use this plugin
        vim.notify = notify
      end,
    },

    -- 9. Center the prompt
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
      opts = {
        -- This moves the command line to the center and uses notify for messages
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.set_autocmd_ roundtable"] = true,
          },
        },
      },
    },

  },
  rocks = { enabled = false }, -- Keep this to avoid the LuaRocks error
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },

})

-- DEFAULT KEY BINDING
-- Set the leader key to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local builtin = require('telescope.builtin')

-- Basic file and text search
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })

-- TypeScript/LSP specific search
vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = 'Go to References' })
vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'Go to Definition' })
vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = 'Document Symbols' })

-- Keybinding to trigger project-wide TypeScript type-checking
vim.keymap.set('n', '<leader>tc', ':TSC<CR>', { desc = 'Run Project-Wide Type-Check' })

-- IMPORTANT: Remove any require("mason").setup() lines from the bottom of your file!
-- The configuration is now handled inside the block above.
