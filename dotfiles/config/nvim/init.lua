-- =============================================================================
-- Bootstrap lazy.nvim
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- Options
-- =============================================================================
vim.opt.encoding       = "utf-8"
vim.opt.mouse          = "a"
vim.opt.hidden         = true
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.ruler          = true
vim.opt.wrap           = false
vim.opt.colorcolumn    = "85"
vim.opt.listchars      = { tab = "▸ ", eol = "¬", trail = "·" }
vim.opt.list           = true
vim.opt.exrc           = true
vim.opt.undofile       = true
vim.opt.swapfile       = false
vim.opt.writebackup    = false
vim.opt.textwidth      = 85
vim.opt.formatoptions:append("c")
vim.opt.formatoptions:remove("t")
vim.opt.ignorecase     = true
vim.opt.hlsearch       = true
vim.opt.smartcase      = true
vim.opt.incsearch      = true
vim.opt.splitbelow     = true
vim.opt.splitright     = true
vim.opt.history        = 10000
vim.opt.wildmenu       = true
vim.opt.autowrite      = true
vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.smarttab       = true
vim.opt.cmdheight      = 2
vim.opt.updatetime     = 300
vim.opt.shortmess:append("c")
vim.opt.shortmess:remove("S")
vim.opt.signcolumn     = "yes"
vim.opt.foldlevel      = 99
vim.opt.laststatus     = 2
vim.opt.statusline     = "%f"

-- Leader must be set before plugins load
vim.g.mapleader = ","

-- =============================================================================
-- Autocommands
-- =============================================================================
local autocmd = vim.api.nvim_create_autocmd

-- Strip trailing whitespace on save
autocmd("BufWritePre", { pattern = "*", command = [[%s/\s\+$//e]] })

-- Save on lost focus
autocmd("BufLeave", { pattern = "*", command = "silent! wall" })

-- YAML uses 2-space indent
autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.opt_local.tabstop    = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab  = true
  end,
})

-- =============================================================================
-- Keymaps
-- =============================================================================
local map  = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Switch between last two files
map("n", "<leader><leader>", "<C-^>", opts)

-- Edit / reload config
map("n", "<leader>ev", ":edit $MYVIMRC<CR>",   opts)
map("n", "<leader>ee", ":source $MYVIMRC<CR>", opts)

-- Save / quit
map("n", "<leader>s", ":w<CR>",  opts)
map("n", "<leader>q", ":x<CR>",  opts)

-- Clear search highlight
map("n", "<leader><space>", ":nohlsearch<CR>", opts)

-- Keep selection after indent
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Command typo aliases
vim.cmd("command W w")
vim.cmd("command Wq wq")
vim.cmd("command Q q")

-- Search for visually selected text with //
map("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], opts)

-- Split navigation without C-w prefix
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize splits
map("n", "+", ":exe 'resize ' . (winheight(0) * 3/2)<CR>", opts)
map("n", "-", ":exe 'resize ' . (winheight(0) * 2/3)<CR>", opts)

-- Insert blank lines without entering insert mode
map("n", "<leader>O", "O<Esc>j", opts)
map("n", "<leader>o", "o<Esc>k", opts)

-- Terminal: Esc exits terminal mode; C-t opens a vertical split terminal
map("t", "<Esc>", "<C-\\><C-n>", opts)
map("n", "<C-t>", ":vsplit term://zsh<CR>", opts)

-- =============================================================================
-- Go abbreviations
-- =============================================================================
vim.cmd([[
  iab tfunc func Test(t *testing.T){}<esc>3k2e
  iab trun t.Run(,func(t *testing.T){})<esc>2ke
  iab ierr if err != nil {}<esc>ko
]])

-- =============================================================================
-- Plugins
-- =============================================================================
require("lazy").setup({

  -- ── Colorscheme ─────────────────────────────────────────────────────────────
  {
    "morhetz/gruvbox",
    lazy     = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme gruvbox")
      vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 236 })
      vim.api.nvim_set_hl(0, "NonText",     { ctermfg = 239 })
      vim.api.nvim_set_hl(0, "SpecialKey",  { ctermfg = 239 })
    end,
  },

  -- ── Treesitter: syntax + folding ────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "go", "typescript", "tsx", "javascript", "rust",
        "json", "yaml", "toml", "lua", "markdown",
      },
      highlight = { enable = true },
      indent    = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
    end,
  },

  -- ── LSP: mason manages server installation ──────────────────────────────────
  { "williamboman/mason.nvim",           build = ":MasonUpdate" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls", "ts_ls", "rust_analyzer",
          "jsonls", "yamlls", "html", "cssls",
        },
        automatic_installation = true,
      })

      -- Requiring lspconfig registers its default server configs (cmd, filetypes,
      -- root_markers) into vim.lsp.config without the deprecated .setup() calls.
      require("lspconfig")

      -- Global: capabilities + keymaps applied to every LSP attach
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(_, bufnr)
          local bopts = { noremap = true, silent = true, buffer = bufnr }
          map("n", "gd",         vim.lsp.buf.definition,     bopts)
          map("n", "gy",         vim.lsp.buf.type_definition, bopts)
          map("n", "gi",         vim.lsp.buf.implementation,  bopts)
          map("n", "gr",         vim.lsp.buf.references,      bopts)
          map("n", "K",          vim.lsp.buf.hover,           bopts)
          map("n", "<leader>rn", vim.lsp.buf.rename,          bopts)
          map("n", "<leader>ac", vim.lsp.buf.code_action,     bopts)
          map("n", "[c",         vim.diagnostic.goto_prev,    bopts)
          map("n", "]c",         vim.diagnostic.goto_next,    bopts)
          map("n", "<space>a",   vim.diagnostic.setloclist,   bopts)
          map("n", "<space>o",   vim.lsp.buf.document_symbol, bopts)
        end,
      })

      -- Per-server overrides
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt         = true,
            usePlaceholders = true,
            buildFlags      = { "-tags=e2e" },
          },
        },
      })

      vim.lsp.enable({ "gopls", "ts_ls", "rust_analyzer", "jsonls", "yamlls", "html", "cssls" })
    end,
  },

  -- ── Completion ──────────────────────────────────────────────────────────────
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
          ["<CR>"]    = cmp.mapping.confirm({ select = false }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- ── Formatting (goimports, prettier, rustfmt) ───────────────────────────────
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          go              = { "goimports" },
          javascript      = { "prettier" },
          javascriptreact = { "prettier" },
          typescript      = { "prettier" },
          typescriptreact = { "prettier" },
          rust            = { "rustfmt" },
          json            = { "prettier" },
          yaml            = { "prettier" },
        },
        format_on_save = { timeout_ms = 2000, lsp_fallback = true },
      })
    end,
  },

  -- ── Linting (eslint on save for JS/TS) ──────────────────────────────────────
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        javascript      = { "eslint" },
        javascriptreact = { "eslint" },
        typescript      = { "eslint" },
        typescriptreact = { "eslint" },
      }
      autocmd("BufWritePost", {
        callback = function() require("lint").try_lint() end,
      })
    end,
  },

  -- ── Fuzzy finder (replaces ctrlp) ───────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/", "%.swp", "%.zip" },
        },
      })
      map("n", "<C-p>",      "<cmd>Telescope find_files hidden=true<CR>", opts)
      map("n", "<C-p>b",     "<cmd>Telescope buffers<CR>",                opts)
      map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",              opts)
    end,
  },

  -- ── File tree (replaces NERDTree) ────────────────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Disable netrw so nvim-tree takes over
      vim.g.loaded_netrw       = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        filters = { dotfiles = false },
        git     = { enable = true },
      })
      map("n", "<C-n>",  "<cmd>NvimTreeToggle<CR>",   opts)
      map("n", "<C-n>f", "<cmd>NvimTreeFindFile<CR>", opts)
    end,
  },

  -- ── Go (keep for test/run/generate/alternate commands) ──────────────────────
  {
    "fatih/vim-go",
    ft = "go",
    config = function()
      vim.g.go_fmt_command         = "goimports"
      vim.g.go_auto_type_info      = 1
      vim.g.go_def_mapping_enabled = 0  -- LSP handles gd

      autocmd("FileType", { pattern = "go", callback = function()
        local go_opts = { noremap = true, silent = true, buffer = 0 }
        map("n", "<leader>r",  "<Plug>(go-run)",             go_opts)
        map("n", "<leader>t",  ":wa<CR>:!clear;go test -v ./%:h<CR>", go_opts)
        map("n", "<leader>T",  "<cmd>GoTestFunc<CR>",        go_opts)
        map("n", "<leader>a",  "<Plug>(go-alternate-edit)",  go_opts)
        map("n", "<leader>ah", "<Plug>(go-alternate-split)", go_opts)
        map("n", "<leader>av", "<Plug>(go-alternate-vertical)", go_opts)
        map("n", "<leader>d",  "<cmd>GoDeclsDir<CR>",        go_opts)
        map("n", "<leader>g",  "<Plug>(go-generate)",        go_opts)
        map("n", "<leader>?",  "<cmd>GoDoc<CR>",             go_opts)
        map("n", "<leader>n",  "<cmd>GoRename<CR>",          go_opts)
        map("n", "<leader>b",  function()
          local file = vim.fn.expand("%")
          if file:match("^.+_test%.go$") then
            vim.fn["go#test#Test"](0, 1)
          elseif file:match("^.+%.go$") then
            vim.fn["go#cmd#Build"](0)
          end
        end, go_opts)
        map("n", "<leader>c", function()
          vim.fn["go#coverage#BufferToggle"](not vim.g.go_jump_to_error)
          vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 235 })
          vim.api.nvim_set_hl(0, "NonText",     { ctermfg = 239 })
          vim.api.nvim_set_hl(0, "SpecialKey",  { ctermfg = 239 })
          vim.api.nvim_set_hl(0, "goSameId",    { bold = true, ctermbg = 250, ctermfg = 239 })
        end, go_opts)
      end})
    end,
  },

  -- ── Rust ────────────────────────────────────────────────────────────────────
  {
    "rust-lang/rust.vim",
    ft = "rust",
    config = function()
      vim.g.rustfmt_autosave = 1
      autocmd("FileType", { pattern = "rust", callback = function()
        local rust_opts = { noremap = true, silent = true, buffer = 0 }
        map("n", "<leader>b", "<cmd>Ccheck<CR>", rust_opts)
        map("n", "<leader>r", "<cmd>Crun<CR>",   rust_opts)
        map("n", "<leader>t", "<cmd>Ctest<CR>",  rust_opts)
      end})
    end,
  },

  -- ── Git ─────────────────────────────────────────────────────────────────────
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- ── Editing utilities ────────────────────────────────────────────────────────
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "AndrewRadev/splitjoin.vim",

  -- ── Markdown preview ─────────────────────────────────────────────────────────
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
    ft    = { "markdown" },
  },

}, {
  ui = { border = "rounded" },
})
