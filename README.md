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
  - RUn `:checkhealth provider` to confirm health status from provider

- For Local LLM service
  - Run `:MasonInstall llm-ls` to install LLM client

- For Keyboard Tips
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

- For Visual Muliline Plugin
  - Enable: 'Ctrl+n' enable multiline mode
  - Replace: 'Ctrl+n' and move cursor to word and press 'n' to keep search for replace and hit 'c' to replace word
  - Append: 'Ctrl+n' and 'Ctrl+ArrowDown/Up' to move lines, 'w' to move cursor each word, and append

- For linux wsl2 user on windows to copy to clipboard:
  - (From Windows to NEOVIM), use `Ctrl+Insert` for Copy and `Shift+Insert` for Paste from browser to neovim (windows, terminal -> neovim)
  - (From NEOVIM to NEOVIM), use `<space>+y` for copy and `<space>+p` for paste from neovim mouse highlight to new location in editor (neovim -> neovim)
  - (From NEOVIM to Windows):
      * Install win32yank.exe when needs to yank lines from editor when use mouse highlight
      * Validate health from neovim editor `:checkhealth provider` and look for `Clipboard` status
      * Run copy test from terminal to make sure `copy/paste` works
```
sudo mv win32yank.exe /usr/local/bin/
sudo chmod +x /usr/local/bin/win32yank.exe
echo "Hello from WSL terminal" | win32yank.exe -i --crlf
# Shift+Insert to paste in other editor
```
     
