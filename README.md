# ace-1125/nvim

My daily-driver Neovim config — rebuilt from scratch for Neovim 0.12+ with Lazy.nvim. Designed to be fast, modular, and platform-agnostic across Linux and WSL.

Built around:

- `lazy.nvim` for plugin management
- `tokyonight-moon` with selective transparency
- `blink.cmp` for completion
- `nvim-lspconfig` + Mason for LSP/tooling
- Native Treesitter APIs for highlighting/folding, with `nvim-treesitter` for parser updates
- Telescope / Neo-tree / Harpoon for navigation
- Custom autosave script
- Conform for _manual_ formatting
  - Manual formatting due to autosave
- nvim-dap for Python debugging
- neotest + vitest for JS/TS testing
- Snacks dashboard with `fastfetch`
- render-markdown, LeetCode, and no-neck-pain for focused workflows

---

## Requirements

- **Neovim 0.12+** (built with `CMAKE_BUILD_TYPE=Release`)
- Git
- A [Nerd Font](https://www.nerdfonts.com/)
- `ripgrep` for Telescope grep
- `make` for telescope-fzf-native
- `tree-sitter-cli` (`npm install -g tree-sitter-cli`)
- `fastfetch` for the Snacks dashboard

Useful external tools:

- Mason installs `stylua`, `prettier`, and `pyright`
- Formatting also expects `black` and `taplo` when working with Python/TOML

---

## Install

```bash
# backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# clone
git clone https://github.com/ace-1125/nvim ~/.config/nvim

# launch — Lazy installs everything on first run
nvim
```

Or run alongside an existing config:

```bash
git clone https://github.com/ace-1125/nvim ~/.config/nvim-ace
NVIM_APPNAME=nvim-ace nvim
```

---

## Repo Layout

```
.
├── init.lua                     # Core options, clipboard, folding, diagnostics
└── lua/ace/
    ├── autosave.lua             # Auto-save on InsertLeave/CursorHold
    ├── lazy.lua                 # Lazy.nvim bootstrap
    ├── remap.lua                # Core keymaps (no plugin deps)
    └── plugins/
        ├── blink.lua            # Completion (blink.cmp)
        ├── color-theme.lua      # TokyoNight Moon + custom highlights
        ├── colorizer.lua        # Inline color previews
        ├── conform.lua          # Formatting (manual only)
        ├── dap.lua              # Python debugger (debugpy)
        ├── git-diff.lua         # Diffview
        ├── git-signs.lua        # Gutter signs + blame
        ├── guess-indent.lua     # Auto-detect indent
        ├── harpoon.lua          # File pinning/jumping
        ├── indent-blankline.lua # Visual indent guides
        ├── leetcode.lua         # LeetCode.nvim
        ├── lspConfig.lua        # LSP + Mason setup
        ├── mini-nvim.lua        # ai, surround, statusline, pairs
        ├── neogen.lua           # Docstring generation
        ├── neotest.lua          # Vitest runner (monorepo-aware)
        ├── neotree.lua          # File explorer
        ├── no-neck-pain.lua     # Centered/zen editing mode
        ├── render-markdown.lua  # Markdown rendering
        ├── snacks.lua           # Dashboard + fastfetch pane
        ├── telescope.lua        # Fuzzy finder + LSP pickers
        ├── todo-comments.lua    # TODO/FIXME highlighting
        ├── treesitter.lua       # Parser management
        ├── treesitter-context.lua # Sticky context header
        └── which-key.lua        # Keybinding hints
```

---

## Keybindings

Leader: `<Space>`

### Navigation

| Key                | Action                                    |
| ------------------ | ----------------------------------------- |
| `<leader>sf`       | Find files                                |
| `<leader>ss`       | Find git files                            |
| `<leader>sg`       | Live grep                                 |
| `<leader>sG`       | Grep (manual input)                       |
| `<leader>sw`       | Grep word under cursor                    |
| `<leader>se`       | Find files (everything, including hidden) |
| `<leader>s/`       | Grep in open files                        |
| `<leader>/`        | Fuzzy search current buffer               |
| `<leader><leader>` | Find open buffers                         |
| `<leader>sr`       | Resume last search                        |
| `<leader>s.`       | Recent files                              |
| `<leader>su`       | Undo tree                                 |
| `<leader>sh`       | Help tags                                 |
| `<leader>sk`       | Keymaps                                   |
| `<leader>sb`       | Telescope builtins                        |
| `<leader>sd`       | Diagnostics                               |
| `<leader>sc`       | Commands                                  |
| `<leader>sn`       | Search neovim config                      |
| `<leader>e`        | Toggle Neo-tree filesystem                |
| `<leader>be`       | Toggle Neo-tree buffers                   |

### Harpoon

| Key                       | Action       |
| ------------------------- | ------------ |
| `<leader>a`               | Add file     |
| `<leader>j`               | Toggle menu  |
| `<leader>1`–`9`           | Jump to slot |
| `<C-1>`–`<C-9>`           | Jump to slot |
| `<leader>h` / `<leader>l` | Prev / next  |

### Git

| Key          | Action         |
| ------------ | -------------- |
| `<leader>gd` | Open Diffview  |
| `<leader>gq` | Close Diffview |

### LSP

| Key           | Action                      |
| ------------- | --------------------------- |
| `grn`         | Rename                      |
| `gra`         | Code action                 |
| `grD`         | Goto declaration            |
| `H`           | Hover                       |
| `<leader>grr` | References (Telescope)      |
| `<leader>grd` | Definition (Telescope)      |
| `<leader>gri` | Implementation (Telescope)  |
| `<leader>grt` | Type definition (Telescope) |
| `<leader>gO`  | Document symbols            |
| `<leader>gW`  | Workspace symbols           |

### Formatting

| Key         | Action                                |
| ----------- | ------------------------------------- |
| `<leader>f` | Format buffer/selection (manual only) |

### DAP (Python)

| Key          | Action            |
| ------------ | ----------------- |
| `<F5>`       | Continue          |
| `<F6>`       | Step over         |
| `<F8>`       | Step into         |
| `<S-F11>`    | Step out          |
| `<F10>`      | Terminate         |
| `<leader>b`  | Toggle breakpoint |
| `<leader>B`  | Clear breakpoints |
| `<leader>du` | Toggle DAP UI     |
| `<leader>dl` | Run last          |

### Neotest (JS/TS)

| Key          | Action              |
| ------------ | ------------------- |
| `<leader>nt` | Run nearest test    |
| `<leader>nf` | Run test file       |
| `<leader>no` | Open test output    |
| `<leader>ns` | Toggle test summary |
| `<leader>nl` | Run last test       |

### Editing

| Key                        | Action                                |
| -------------------------- | ------------------------------------- |
| `<leader>t`                | Toggle terminal                       |
| `<Esc>` in terminal        | Exit terminal mode                    |
| `<leader>v`                | Visual block mode                     |
| `<leader>q`                | Open diagnostic quickfix list         |
| `<leader>d`                | Generate docstring                    |
| `<leader>m`                | Toggle markdown rendering             |
| `<leader>pc`               | Toggle inline color previews          |
| `<leader>ii`               | Toggle indent guides                  |
| `<leader>rf`               | Replace word in file                  |
| `<leader>rv`               | Replace word in selection             |
| `<leader>p` in visual mode | Paste without replacing yank register |
| `<leader>x`                | Make file executable                  |
| `V` then `J`/`K`           | Move selected lines                   |
| `<C-d>` / `<C-u>`          | Half-page scroll (centered)           |

### Toggles

| Key          | Action                     |
| ------------ | -------------------------- |
| `<leader>ua` | Toggle autosave            |
| `<leader>us` | Toggle spellcheck          |
| `<leader>uw` | Toggle word wrap           |
| `<leader>uc` | Toggle Treesitter context  |
| `[c`         | Jump to Treesitter context |
| `<leader>uz` | Toggle no-neck-pain        |

### Window Management

| Key                | Action                    |
| ------------------ | ------------------------- |
| `<C-h/j/k/l>`      | Move focus between splits |
| `<leader>wh/j/k/l` | Resize splits             |
| `<leader>wK`       | Maximize vertical         |
| `<leader>wL`       | Maximize horizontal       |

---

## Design Decisions

- **No format-on-save** — autosave is on, formatting is manual via `<leader>f`
- **Autosave skips config paths** — buffers under this Neovim config and `~/.config` are ignored
- **Transparent editor, solid everything else** — file buffers show your terminal background, neo-tree/floats/DAP stay solid
- **Mostly lazy-loaded plugins** — interactive tools load on events/keys/commands; core startup pieces like the colorscheme, dashboard, Treesitter, and LSP config are eager
- **Monorepo-aware testing** — neotest walks up to find vitest workspace files, package.json workspaces, or pnpm-workspace.yaml
- **OSC 52 clipboard** — works reliably over SSH into WSL/remote machines
- **`.venv` auto-detection** — DAP finds `.venv/bin/python` in the workspace root automatically

---

## Credits

Rebuilt from scratch, informed by:

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — the original starting point
- [lazy.nvim](https://github.com/folke/lazy.nvim) — plugin management
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) — colorscheme
