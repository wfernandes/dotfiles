# dotfiles

## Install

Single command to bootstrap a new machine:

```sh
./install.sh
```

This will:
1. Install **Homebrew** (if not already installed)
2. Run `brew bundle` to install all packages
3. Install **oh-my-zsh** (if not already installed)
4. Link dotfiles into `$HOME` via **rcm** (`rcup`)
5. Sync **Neovim** plugins via lazy.nvim
6. Install the tmux-256color terminfo entry

Or via Make:

```sh
make install
```

### Individual targets

| Command | What it does |
|---|---|
| `make brew` | Run `brew bundle` only |
| `make link-dotfiles` | Re-link dotfiles via rcup |
| `make init-nvim` | Sync Neovim plugins headlessly |

---

## Shell

- **zsh** is the primary shell with [oh-my-zsh](https://ohmyzsh.github.io)
- Theme: `apple` (provides the  prompt character via `toon`)
- Plugins: `autojump`, `direnv`, `colored-man-pages`
- Node version management via **Volta** (configured in `~/.zshenv`)

---

## Neovim

Config lives at `~/.config/nvim/init.lua`.

### Plugin manager

[lazy.nvim](https://github.com/folke/lazy.nvim) — self-bootstrapping, no
manual install required. On first launch it will download and install all
plugins automatically.

### LSP

Uses Neovim's native LSP (`vim.lsp.config` / `vim.lsp.enable` — Neovim 0.11+
API). [mason.nvim](https://github.com/williamboman/mason.nvim) automatically
installs language servers on first open.

**Servers installed automatically:**

| Language | Server |
|---|---|
| Go | `gopls` |
| TypeScript / JavaScript | `ts_ls` |
| Rust | `rust_analyzer` |
| JSON | `jsonls` |
| YAML | `yamlls` |
| HTML / CSS | `html`, `cssls` |

> **Note:** Go must be installed (`brew install go`) before `gopls` can be
> installed by mason.

### Key plugins

| Plugin | Purpose |
|---|---|
| nvim-treesitter | Syntax highlighting + folding |
| nvim-cmp + LuaSnip | Completion |
| conform.nvim | Format on save (goimports, prettier, rustfmt) |
| nvim-lint | eslint on save for JS/TS |
| telescope.nvim | Fuzzy file/buffer/grep search |
| nvim-tree | File browser (`<C-n>` to toggle) |
| vim-go | Go test/run/generate/alternate commands |
| vim-fugitive | Git |
| gitsigns.nvim | Git gutter signs |
| vim-surround / vim-commentary | Editing utilities |

### Key mappings (leader = `,`)

| Mapping | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `,rn` | Rename symbol |
| `,ac` | Code action |
| `[c` / `]c` | Previous / next diagnostic |
| `<C-p>` | Find files (Telescope) |
| `<C-p>b` | Find buffers |
| `,fg` | Live grep |
| `<C-n>` | Toggle file tree |
| `<C-t>` | Open terminal (vertical split) |

### Go abbreviations (insert mode)

| Abbreviation | Expands to |
|---|---|
| `tfunc` | `func Test(t *testing.T){}` |
| `trun` | `t.Run(, func(t *testing.T){})` |
| `ierr` | `if err != nil {}` |

---

## Alacritty

Config: `~/.config/alacritty/alacritty.toml`

- Font: Source Code Pro, size 17
- Theme: Gruvbox dark
- Shell: `/bin/zsh --login`
- Install the font with: `brew install --cask font-source-code-pro` (included
  in Brewfile)

---

## Tmux

- Prefix: `Ctrl-B`
- Mouse support enabled
- Vi-mode keybindings
- Pane navigation: `h/j/k/l`
- History limit: 20,000 lines
- The tmux-256color terminfo entry is installed automatically by `install.sh`

### Tmate

If using tmate alongside tmux, alias tmux to point directly at the conf:

```sh
alias tmux='tmux -f $HOME/workspace/dotfiles/dotfiles/tmux.conf'
```

tmate ships with an older tmux version, so `tmate.conf` is kept separate in
`$HOME` to avoid copy/paste conflicts between the two.

---

## Git

- GPG signing enabled
- `push.autoSetupRemote = true` — no need to specify upstream on first push
- Useful aliases: `lol` (log graph), `p` (pull --rebase), `rum` (rebase
  upstream/master)
- GitHub SSH remapping: `https://github.com` → `git@github.com:`
- Git LFS enabled
