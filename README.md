# Neovim configuration

Personal Neovim configuration managed with Neovim's built-in `vim.pack`.

## Requirements

- Neovim 0.12 or newer
- Git
- `codex` in `PATH` to use the Codex terminal mapping (`<leader>act`)
- Zig is optional; on Windows it is used by the Tree-sitter parser build helper when available. Otherwise, use a working MSVC C toolchain.
- `tree-sitter` CLI 0.26.1+ and a C compiler for parser builds
- Crystal 1.18.2+ and `shards` to build the Crystal LSP
- `lua-language-server` in `PATH` for Lua
- Node.js/npm (`npx`) or a TypeScript 7 `tsc` binary for TypeScript; `uvx` or `basedpyright-langserver` for BasedPyright
- `ruff` in `PATH`, or `uvx` as a fallback, for Python linting and formatting
- `ripgrep` for Telescope's project text search (`<leader>df`)

## Install

Back up or move your current Neovim configuration directory, then clone this repository to Neovim's config path:

```powershell
git clone https://github.com/mikeoz32/nvim-config.git "$env:LOCALAPPDATA\nvim"
```

The first Neovim startup installs the plugins listed in `lua/config/pack.lua`.

The config uses Neovim's native path handling and works on Windows as well. On Windows, npm's `.cmd` shims are launched through `cmd.exe`, and executable paths use the `.exe` suffix where needed.

## Language servers

Python and TypeScript servers start only for matching buffers. When the first Python buffer opens, `uvx --from basedpyright basedpyright-langserver --stdio` creates or reuses uv's cached environment. To keep BasedPyright installed persistently instead, run `uv tool install basedpyright`; the `uvx` command can use that installed tool. Ruff uses a `ruff` executable already on `PATH`, falling back to `uvx ruff server` if needed.

For JavaScript and TypeScript, `npx --yes --package typescript@7 tsc --lsp --stdio` fetches TypeScript 7 into npm's cache when needed. To install it persistently, run `npm install --global typescript@7`; the configuration falls back to the `tsc` executable if `npx` is unavailable. LuaLS remains a standalone binary on `PATH`; on Windows, the LuaLS project provides a Scoop package and prebuilt releases.

## Crystal

Crystal filetype detection and the custom Tree-sitter parser are configured locally. The parser is installed from a pinned `crystal-lang-tools/tree-sitter-crystal` commit through the new `nvim-treesitter` custom-parser API. Neovim's built-in LSP client starts `mikeoz32/cr-analyzer`; there is no Crystal editor plugin or Crystalline dependency.

The analyzer is built from the current local source checkout instead of downloading a release binary. If needed, clone it first, then build it into Neovim's data directory.

On Linux:

```sh
# Only needed if the checkout does not already exist.
git clone https://github.com/mikeoz32/cr-analyzer.git ~/cr-analyzer
bash ~/.config/nvim/scripts/install-cr-analyzer.sh
```

On Windows, run the PowerShell installer from the config directory:

```powershell
Set-Location "$env:LOCALAPPDATA\nvim"
# Optional when the checkout is not at $HOME\cr-analyzer:
$env:CR_ANALYZER_ROOT = "$HOME\cr-analyzer"
.\scripts\install-cr-analyzer.ps1
```

Both scripts build the current checkout and its locked Shards dependencies without updating the checkout. The default output paths are Neovim's data directory: `~/.local/share/nvim/cr-analyzer/cr-analyzer` on Linux and `$env:LOCALAPPDATA\nvim-data\cr-analyzer\cr-analyzer.exe` on Windows. Set `CR_ANALYZER_ROOT` to select another source checkout or `CR_ANALYZER_BIN` to use a prebuilt binary. Run the platform's installer again after updating the source checkout.

Crystal's Windows toolchain is currently a preview; building the analyzer there requires the matching Crystal/Shards toolchain and C build tools. See the [official Windows installation notes](https://crystal-lang.org/install/on_windows/) for prerequisites.

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
