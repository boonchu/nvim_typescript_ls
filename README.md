#### Install NeoVim Plugin TS

- Adding Lua Rocks, Find files, RipGrep
```
brew install luarocks fd ripgrep
```

- Create directory
```
mkdir -p ~/.config/nvim
rsync -a init.lua ~/.config/nvim/
```

- Run this after launching neovim
  - Run `:Lazy` to see if all plugins have a checkmark.
  - Run `:Mason` to see if `vtsls` is installed.Open a .ts file 
  - Run `:checkhealth lazy` and `:checkhealth mason`
  - Run `:checkhealth lsp` to confirm the client is attached.
  - Run `:checkhealth noice` to confirm notify is attached.

- For Local LLM service
  - Run `:MasonInstall llm-ls` to install LLM client

- Tips
  - Default `<leader>` is space bar
  - LSPKind plugin custom keys
    - Use 'Ctrl-w+d' to see why code fail with the line starting with 'E'
  - Telescope plugin custom keys
    - `<space>+<ff>` 'Find Files'
    - `<space>+<fg>` 'Live Grep'
    - `<space>+<fb>` 'Find buffer'
    - `<space>+<fh>` 'Help Tags'
  - TSC plugin custom keys
    - `<space>+<tc>` ':TSC<enter>'

- For linux wsl2 user on windows:
  - When use clipboard after you highlight what need to go, you have to use this `:'<,'>w !clip.exe`
  - After launching terminal with Linux shell, you can hit Ctl+',' to launch settings and run setup to disable Ctrl+'v' and Ctrl+'c' as Linux uses keys for different purpose.
