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
  },
  rocks = { enabled = false }, -- Keep this to avoid the LuaRocks error
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-- IMPORTANT: Remove any require("mason").setup() lines from the bottom of your file!
-- The configuration is now handled inside the block above.
