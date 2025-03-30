# Davide's Neovim Configuration

This repository contains my personal Neovim configuration files.

## Installation

1.  **Clone the repository:**
    ```bash
    git clone git@github.com:dpasca/nvim-config.git ~/.config/nvim
    ```

2.  **Install Plugins:**
    *   Launch Neovim (`nvim`).
    *   The `lazy.nvim` plugin manager should automatically bootstrap itself and install all the configured plugins. You might see progress messages.
    *   Run `:checkhealth lazy` to ensure everything installed correctly.
    *   You might need to run `:TSUpdate` to install/update Treesitter parsers.

## Plugin Overview

This configuration uses [`lazy.nvim`](https://github.com/folke/lazy.nvim) to manage plugins. Key plugins include:

**Core & UI:**
*   [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter): Advanced syntax highlighting and code parsing.
*   [`vim-airline`](https://github.com/vim-airline/vim-airline): Status line customization.
*   [`vim-airline-themes`](https://github.com/vim-airline/vim-airline-themes): Themes for vim-airline.
*   [`ListToggle`](https://github.com/Valloric/ListToggle): Toggle quickfix/location lists.
*   [`vim-colorscheme-switcher`](https://github.com/xolox/vim-colorscheme-switcher): Helper for switching themes.
*   [`srcery-vim`](https://github.com/srcery-colors/srcery-vim): Srcery colorscheme.
*   [`gruvbox`](https://github.com/morhetz/gruvbox): Gruvbox colorscheme.

**Git Integration:**
*   [`vim-fugitive`](https://github.com/tpope/vim-fugitive): Comprehensive Git wrapper.
*   [`vim-gitgutter`](https://github.com/airblade/vim-gitgutter): Shows Git diff markers in the sign column.
*   [`vim-eunuch`](https://github.com/tpope/vim-eunuch): Vim sugar for UNIX shell commands.

**Development & Language Support:**
*   LSP Configuration (`lua/config/plugin_setup_lsp.lua`): Handles Language Server Protocol setup (likely includes `nvim-lspconfig`, `nvim-cmp`, etc. - *confirm details if needed*).
*   [`vim-cpp-modern`](https://github.com/bfrg/vim-cpp-modern): C++ syntax highlighting improvements.
*   [`vim-javascript`](https://github.com/pangloss/vim-javascript): JavaScript syntax highlighting.
*   [`jupytext.vim`](https://github.com/goerz/jupytext.vim): Jupyter notebook support via text formats.

**Editing & Navigation:**
*   [`nerdtree`](https://github.com/scrooloose/nerdtree): File system explorer.
*   [`vim-fswitch`](https://github.com/derekwyatt/vim-fswitch): Switch between source/header files.
*   [`vim-operator-highlight`](https://github.com/Valloric/vim-operator-highlight): Highlight the region an operator acts on.
*   [`vim-expand-region`](https://github.com/terryma/vim-expand-region): Visually expand selection.
*   [`vim-tmux-navigator`](https://github.com/christoomey/vim-tmux-navigator): Navigate between Vim splits and Tmux panes.
*   [`vim-table-mode`](https://github.com/dhruvasagar/vim-table-mode): Create and edit tables.

**Utility & Tools:**
*   [`vim-qargs`](https://github.com/henrik/vim-qargs): Use quickfix list entries as arguments.
*   [`ZFVimDirDiff`](https://github.com/ZSaberLv0/ZFVimDirDiff): Directory diff tool.
*   [`asyncrun.vim`](https://github.com/skywind3000/asyncrun.vim): Run commands asynchronously.
*   [`vim-better-whitespace`](https://github.com/ntpeters/vim-better-whitespace): Highlight trailing whitespace.
*   [`vim-localvimrc`](https://github.com/embear/vim-localvimrc): Project-specific Vim settings.
*   [`editorconfig-vim`](https://github.com/editorconfig/editorconfig-vim): EditorConfig support.
*   [`ifdef-highlighting`](https://github.com/vim-scripts/ifdef-highlighting): Highlight inactive `#ifdef` blocks.

**AI Assistance:**
*   [`copilot.vim`](https://github.com/github/copilot.vim): GitHub Copilot integration.
*   [`codecompanion.nvim`](https://github.com/olimorris/codecompanion.nvim): AI coding assistance (configured for Anthropic).

## Key Features

*   LSP integration via `nvim-lspconfig`
*   Completion via `nvim-cmp` (Assuming based on standard setups)
*   Theme switching between `srcery` (dark) and `shine` (light) via `:ToggleTheme`
*   CodeCompanion integration

## Key Mappings

Core key mappings are defined in `lua/config/keymaps.lua`.

**Modes:** `n` = Normal, `i` = Insert, `v` = Visual, `t` = Terminal

**General:**
*   `n ;` -> `:` (Enter command mode)
*   `n _` -> `^` (Move to first non-blank character)
*   `n <CR>` -> `:noh<CR><CR>` (Clear search highlight)
*   `n <leader>stw` -> `:%s/\s\+$//e<CR>` (Strip trailing whitespace)

**Separator Macros (Insert Mode):**
*   `i ////` -> `//==================================================================` (C++ style comment separator)
*   `i ####` -> `#==================================================================` (Python style comment separator)

**Quickfix List Navigation:**
*   `n <A-j>` or `n √™` -> `:cnext<CR>` (Next item)
*   `n <A-k>` or `n √´` -> `:cprevious<CR>` (Previous item)
*   `n <A-c>` or `n √£` -> `:cclose<CR>` (Close list)

**Tab Navigation:**
*   `n gr` or `n <S-Tab>` or `n M` -> `:tabprevious<CR>` (Previous tab)
*   `n ,` -> `:tabnext<CR>` (Next tab)

**Split Navigation (GUI only, requires `vim-tmux-navigator` disabled):**
*   `n/i <C-h>` -> `<C-w><C-h>` (Move left)
*   `n/i <C-j>` -> `<C-w><C-j>` (Move down)
*   `n/i <C-k>` -> `<C-w><C-k>` (Move up)
*   `n/i <C-l>` -> `<C-w><C-l>` (Move right)

**Terminal Mode Navigation:**
*   `t <C-h>` -> `<C-\\><C-N><C-w><C-h>` (Navigate left out of terminal)
*   `t <C-l>` -> `<C-\\><C-N><C-w><C-l>` (Navigate right out of terminal)

**Completion Menu Navigation (Insert Mode):**
*   `i <C-j>` -> `<C-n>` (Next completion item)
*   `i <C-k>` -> `<C-p>` (Previous completion item)

**Search:**
*   `n <leader>wf` -> `:grep -w <cword>` (If `rg` installed) or `:Ggrep -w <cword>` (If `rg` not installed - searches word under cursor)
*   `n <leader>f` -> `:grep` (If `rg` installed) or `:Ggrep` (If `rg` not installed - starts search)

**Navigation & File Operations:**
*   `n <leader>g` -> `:tag <cword>` (Jump to tag definition)
*   `n <leader>cd` -> `:cd %:p:h` (Change directory to current file's directory)
*   `n <Leader>o` -> `:FSHere` (Invoke FSHere plugin)

**Execution & Async:**
*   `n <F9>` -> `!python %` (Execute current Python file)
*   `n <F5>` -> Repeat last `:AsyncRun` command

**Visual Mode / Region Expansion:**
*   `v v` -> Expand visual selection (vim-expand-region)
*   `v <C-v>` -> Shrink visual selection (vim-expand-region)

**CodeCompanion:**
*   `n/v <C-a>` -> `<cmd>CodeCompanionActions<cr>` (Show actions menu)
*   `n/v <localleader>a` -> `<cmd>CodeCompanionChat Toggle<cr>` (Toggle chat window)
*   `v ga` -> `<cmd>CodeCompanionChat Add<cr>` (Add visual selection to chat)

**Other:**
*   `:ToggleTheme` (User command) -> Switch between light (shine) and dark (srcery) themes.
*   `:Arun {cmd}` (User command) -> Run `{cmd}` asynchronously via AsyncRun (enables `<F5>` repeat).
*   `cab cc CodeCompanion` (Command abbreviation) -> Type `cc` instead of `CodeCompanion`.

## Configuration Management (Git Sync)

This configuration includes custom commands to manage synchronization with its Git repository directly from Neovim. These commands operate on the configuration directory (`~/.config/nvim`).

*   `:ConfigPull`: Pulls the latest changes from the remote repository (`git pull`).
*   `:ConfigPush [commit_message]`: Stages all changes (`git add .`), commits them with the optional `[commit_message]`, and pushes to the remote repository (`git push`). If no message is provided, it only performs `git push`.
*   `:ConfigStatus`: Shows the current `git status` in a floating window.
*   `:ConfigDiff`: Shows the current `git diff` in a floating window.
*   `:ConfigCd`: Changes Neovim's current working directory to the configuration directory (`~/.config/nvim`).

## Dependencies

*   `git`
*   `ripgrep` (`rg`) (Optional, for faster searching with `:grep`)
