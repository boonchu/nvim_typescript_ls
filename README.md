#### Install NeoVim Plugin TS

- Adding Lua Rocks
```
brew install luarocks
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

- Tips
  - Use 'Ctrl-w+d' to see why code fail with the line starting with 'E'
