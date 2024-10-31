-- Set language and messages to English
vim.cmd('language en_US.UTF-8')
vim.opt.langmenu = 'en_US.UTF-8'
vim.env.LANG = 'en_US.UTF-8'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set "space" as leader key (before lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic options
vim.opt.compatible = false
vim.opt.termguicolors = true

-- Clipboard settings
vim.opt.clipboard:append('unnamedplus') -- Use system clipboard
if vim.fn.has('win32') == 1 then
    vim.opt.clipboard:append('unnamed')  -- Windows specific clipboard setting
end

-- Enable persistent undo
local function ensure_undodir()
  local undodir = ""
  if vim.fn.has('win32') == 1 then
    undodir = vim.fn.expand("$USERPROFILE") .. "\\.vim\\undodir"
  else
    undodir = vim.fn.expand("~/.vim/undodir")
  end

  -- Create the .vim directory if it doesn't exist
  local vimdir = vim.fn.fnamemodify(undodir, ":h")
  if vim.fn.isdirectory(vimdir) == 0 then
    vim.fn.mkdir(vimdir, "p")
  end

  -- Create the undodir directory if it doesn't exist
  if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
  end

  return undodir
end

-- Call the function and set undodir
local undodir = ensure_undodir()
vim.opt.undodir = undodir

-- Enable persistent undo and set undo levels
vim.opt.undofile = true         -- Enable persistent undo
vim.opt.undolevels = 5000       -- Maximum number of changes that can be undone
vim.opt.undoreload = 50000      -- Maximum number of lines to save for undo on buffer reload

-- Tab and indent settings
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.tabstop = 4          -- Number of spaces tabs count for
vim.opt.softtabstop = 4      -- Number of spaces for a tab while editing
vim.opt.shiftwidth = 4       -- Size of an indent
vim.opt.smarttab = true      -- Insert tabstop number of spaces when pressing tab
vim.opt.autoindent = true    -- Copy indent from current line when starting new line
vim.opt.smartindent = true   -- Smart autoindenting when starting a new line

-- File-type specific indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "lua",          -- Lua files
    "javascript",   -- JavaScript
    "typescript",   -- TypeScript
    "json",         -- JSON
    "yaml",         -- YAML
    "html",         -- HTML
    "css",          -- CSS
    "scss",         -- SCSS
    "vim",          -- Vim script
    "toml",         -- TOML
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = '..' }  -- Show tabs as dots

-- More Basic options
vim.opt.compatible = false
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hidden = true
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.fileformats = "unix,dos"
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.scrolloff = 1
vim.opt.laststatus = 2
vim.opt.cursorline = true

-- Plugin specifications
require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          "lua",
          "vim",
          "javascript",
          "typescript",
          "python",
          "cpp",
          "c",
          "markdown",
          "markdown_inline",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    }
  },

  -- Completion and syntax
  {
    "othree/vim-autocomplpop",
    dependencies = { "eparreno/vim-l9" }
  },

  -- Colorschemes
  {
    "xolox/vim-colorscheme-switcher",
    dependencies = { "xolox/vim-misc" }
  },
  { "srcery-colors/srcery-vim" },
  { "morhetz/gruvbox" },

  -- Search and navigation
  { "henrik/vim-qargs" },
  -- Git grep
  { "tjennings/git-grep-vim" },

  require("config.plugin_setup_lsp"),

  -- File explorer and switching
  {
    "scrooloose/nerdtree",
    keys = {
      { "<leader>p", ":NERDTreeFind<CR>", desc = "NERDTree Find" }
    }
  },
  { "derekwyatt/vim-fswitch" },

  -- Syntax and highlighting
  { "Valloric/vim-operator-highlight" },
  { "bfrg/vim-cpp-modern" },
  { "pangloss/vim-javascript" },

  -- UI and Git
  {
    "Valloric/ListToggle",
    config = function()
      vim.g.lt_location_list_toggle_map = '<leader>l'
      vim.g.lt_quickfix_list_toggle_map = '<leader>q'
    end
  },
  {
    "ZSaberLv0/ZFVimDirDiff",
    dependencies = {
      "ZSaberLv0/ZFVimJob",
      "ZSaberLv0/ZFVimIgnore"
    }
  },

  -- Git integration
  { "tpope/vim-fugitive" },
  { "tpope/vim-eunuch" },
  {
    "airblade/vim-gitgutter",
    config = function()
      vim.g.gitgutter_async = 1
      vim.g.gitgutter_realtime = 1
      vim.g.gitgutter_eager = 1

      -- GitGutter keymaps
      vim.keymap.set('n', 'ghs', '<Plug>(GitGutterStageHunk)')
      vim.keymap.set('n', 'ghu', '<Plug>(GitGutterUndoHunk)')
      vim.keymap.set('n', 'ghp', '<Plug>(GitGutterPreviewHunk)')
    end
  },

  -- Status line
  {
    "vim-airline/vim-airline",
    dependencies = { "vim-airline/vim-airline-themes" },
    config = function()
      vim.g.airline_theme = 'base16_adwaita'
      vim.g.airline_section_a = ''
      vim.g.airline_section_x = ''
      vim.g.airline_section_y = ''
      vim.g.airline_section_z = ''
    end
  },

  -- Region expansion and ifdef highlighting
  { "terryma/vim-expand-region" },
  { "vim-scripts/ifdef-highlighting" },

  -- Async running and whitespace
  { "skywind3000/asyncrun.vim" },
  { "ntpeters/vim-better-whitespace" },

  -- Project-specific settings
  {
    "embear/vim-localvimrc",
    config = function()
      vim.g.localvimrc_sandbox = 0
      vim.g.localvimrc_ask = 0
    end
  },
  { "editorconfig/editorconfig-vim" },

  -- AI assistance
  -- NOTE: Avante wants to include .lua version, but that
  --  doesn't work for us in Windows (chat ok, but not autocomplete)
  { "github/copilot.vim" },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "claude",
      auto_suggestions_provider = "claude",
      -- NOTE: copilot.lua seems broken in Windows
      --provider = "copilot",
      --auto_suggestions_provider = "copilot",
    },

    build = vim.fn.has("win32") == 1
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      --"zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },

  -- TMux integration
  { "christoomey/vim-tmux-navigator" },

  -- Table formatting
  { "dhruvasagar/vim-table-mode" },

  -- Jupyter notebook support
  {
    "goerz/jupytext.vim",
    config = function()
      vim.g.jupytext_fmt = 'py'
    end
  }
})

-- Set colorscheme
--vim.cmd('colorscheme srcery')
vim.cmd('colorscheme gruvbox')

-- Font configuration
local os_name = vim.loop.os_uname().sysname

if os_name == "Windows_NT" then
    vim.opt.guifont = "Iosevka:h10"
elseif os_name == "Darwin" then
    vim.opt.guifont = "Iosevka:h10"
elseif os_name == "Linux" then
    vim.opt.guifont = "Iosevka 10"
end

-- FZF configuration for Windows
if vim.fn.has('win32') == 1 then
  -- Use PowerShell instead of cmd.exe
  vim.g.fzf_launcher = 'powershell'

  -- Use ripgrep if available
  if vim.fn.executable('rg') == 1 then
    vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  end

  -- Configure layout
  vim.g.fzf_layout = {
    window = {
      width = 0.9,
      height = 0.8,
      highlight = 'Comment'
    }
  }
end

-- Load additional configurations
require('config.keymaps')
require('config.autocmds')

