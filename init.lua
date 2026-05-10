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
			end,
		},

		-- 2. Bridge & TS Server
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "williamboman/mason.nvim" }, -- Ensures Mason loads first
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = {
						"vtsls", -- Your TypeScript server
					},
				})
			end,
		},

		-- 3. LSP Configs
		{
			"neovim/nvim-lspconfig",
			config = function()
				-- Apply it to your vtsls setup
			end,
		},

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
					lua = { "stylua" },
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
				"onsails/lspkind.nvim", -- The icon plugin
				"hrsh7th/cmp-nvim-lsp", -- LSP source for cmp
				"L3MON4D3/LuaSnip", -- Snippets
			},
			config = function()
				local cmp = require("cmp")
				local lspkind = require("lspkind")

				cmp.setup({
					formatting = {
						format = lspkind.cmp_format({
							mode = "symbol_text", -- shows icon + name (e.g.    Function)
							maxwidth = 50,
						}),
					},
					-- Basic mappings to make the menu work
					mapping = cmp.mapping.preset.insert({
						["<C-Space>"] = cmp.mapping.complete(),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
					}),
					sources = {
						{ name = "nvim_lsp" },
					},
				})
			end,
		},

		-- 6. Telescope plugin

		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8", -- Use the latest stable version
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			},
			config = function()
				require("telescope").setup({
					-- Optional: add your custom telescope settings here
				})
				-- Load the fast fzf extension if it's installed
				pcall(require("telescope").load_extension, "fzf")
			end,
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
					timeout = 3000, -- Auto-dismiss after 3 seconds
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
						["vim.lsp.util.stylize_markdown"] = true,
					},
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "wmsg",
						find = "position_encoding param is required in vim.lsp.util.make_position_params.",
					},
					opts = { skip = true },
				},
			},
		},

		-- 10. treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "master",
			build = ":TSUpdate", -- Automatically update parsers when the plugin updates
			config = function()
				local configs = require("nvim-treesitter.configs")
				configs.setup({
					ensure_installed = { "lua", "vim", "bash" },
					sync_install = false,
					highlight = { enable = true },
					indent = { enable = true },
				})
			end,
		},

		-- 11. LLM client
		-- {
		-- 	"huggingface/llm.nvim",
		-- 	dependencies = { "nvim-lua/plenary.nvim" },
		-- 	config = function()
		-- 		require("llm").setup({
		-- 			api_token = "xxx",
		-- 			backend = "llamacpp",
		-- 			url = "http://localhost:8080/v1/chat", -- Where your llama-server is running
		-- 			model = "gemma4:E4B",
		-- 			request_body = {
		-- 				temperature = 0.2,
		-- 				top_p = 0.95,
		-- 			},
		-- 			lsp = {
		-- 				-- This is the crucial path from Step 3
		-- 				bin_path = vim.fn.stdpath("data") .. "/mason/bin/llm-ls",
		-- 			},
		-- 			debounce_ms = 150,
		-- 			accept_keymap = "<C-j>", -- Ctrl+j to accept
		-- 			dismiss_keymap = "<C-e>", -- Ctrl+e to ignore
		-- 		})
		-- 	end,
		-- },
	},

	rocks = { enabled = false }, -- Keep this to avoid the LuaRocks error
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
})

-- GLOBAL TAB SETTINGS
vim.opt.tabstop = 2 -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 2 -- Number of spaces for auto-indent
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.softtabstop = 2 -- Number of spaces a <Tab> counts for while editi

-- Detect if running in WSL or native Windows
local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
local is_wsl = vim.fn.has("unix") == 1 and vim.fn.readfile("/proc/version")[1]:match("Microsoft") ~= nil

-- DEFAULT KEY BINDING
-- Set the leader key to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local builtin = require("telescope.builtin")

-- Basic file and text search
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })

-- TypeScript/LSP specific search
vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Go to References" })
vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to Definition" })
vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "Document Symbols" })

-- Keybinding to trigger project-wide TypeScript type-checking
vim.keymap.set("n", "<leader>tc", ":TSC<CR>", { desc = "Run Project-Wide Type-Check" })

-- Detect if running in WSL or native Windows
local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
local is_wsl = vim.fn.has("unix") == 1 and vim.fn.readfile("/proc/version")[1]:match("Microsoft") ~= nil

-- DEFAULT LINIX WSL2
-- install win32yank.exe from github and move .exe to /usr/local/bin
-- echo "hello brave new world!" | win32yank.exe -i # paste with [shift]+[ins]
if is_windows or is_wsl then
	vim.opt.clipboard = "unnamedplus"
	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
end

-- IMPORTANT: Remove any require("mason").setup() lines from the bottom of your file!
-- The configuration is now handled inside the block above.
