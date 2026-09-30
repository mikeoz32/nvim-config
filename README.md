# Neovim configuration

Personal Neovim configuration managed with Neovim's built-in `vim.pack`.

## Requirements

- Neovim 0.12 or newer
- Git
- `codex` in `PATH` to use the Codex terminal mapping (`<leader>act`)
- Zig is optional; on Windows it is used by the Tree-sitter parser build helper when available

## Install

Back up or move your current Neovim configuration directory, then clone this repository to Neovim's config path:

```powershell
git clone https://github.com/mikeoz32/nvim-config.git "$env:LOCALAPPDATA\nvim"
```

The first Neovim startup installs the plugins listed in `lua/config/pack.lua`.

## Main keymaps

- `<leader>ds` — find files
- `<leader>df` — search project text
- `<leader>gs` — Git status
- `<leader>gc` — Git commits
- `<leader>cs` — code symbols
- `<leader>cc` — diagnostics
- `<leader>cr` — LSP references
- `<leader>tn` — create a terminal
- `<leader>ts` — choose a terminal
- `<leader>act` — toggle Codex
- `<leader>zz` — Zen Mode
