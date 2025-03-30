-- lua/config/keymaps.lua

local map = vim.keymap.set

-- General mappings
map('n', ';', ':', { noremap = true })
map('n', '_', '^', { noremap = true }) -- Move to first non-blank character (standard but somehow not working)
map('n', '<CR>', ':noh<CR><CR>', { noremap = true, silent = true })
map('n', '<leader>stw', [[:%s/\s\+$//e<CR>]], { noremap = true, silent = true })

-- Separator macros
-- For C++ style comments (when typing ///// in insert mode)
vim.cmd([[
inoremap <expr> / getline('.') =~ '\v^/+$' && len(getline('.')) >= 4 && len(getline('.')) < 5 ? 
      \ "<BS><BS><BS><BS>//==================================================================" : '/'
]])

-- For Python style comments (when typing ##### in insert mode)
vim.cmd([[
inoremap <expr> # getline('.') =~ '\v^#+$' && len(getline('.')) >= 4 && len(getline('.')) < 5 ? 
      \ "<BS><BS><BS><BS>#==================================================================" : '#'
]])

-- Quickfix navigation
map('n', '<A-j>', ':cnext<CR>', { silent = true })
map('n', '<A-k>', ':cprevious<CR>', { silent = true })
map('n', '<A-c>', ':cclose<CR>', { silent = true })

-- Alternative mappings for terminal case
map('n', '√™', ':cnext<CR>', { silent = true })
map('n', '√´', ':cprevious<CR>', { silent = true })
map('n', '√£', ':cclose<CR>', { silent = true })

-- Tab navigation
map('n', 'gr', ':tabprevious<CR>', { noremap = true })
map('n', '<s-tab>', ':tabprevious<CR>', { noremap = true })
map('n', 'M', ':tabprevious<CR>', { noremap = true })
map('n', ',', ':tabnext<CR>', { noremap = true })

-- Split navigation (when not using vim-tmux-navigator)
if vim.fn.has('gui_running') == 1 then
    local directions = { h = 'h', j = 'j', k = 'k', l = 'l' }
    for key, direction in pairs(directions) do
        -- Normal mode
        map('n', '<C-'..key..'>', '<C-w><C-'..direction..'>', { noremap = true })
        -- Insert mode
        map('i', '<C-'..key..'>', '<C-w><C-'..direction..'>', { noremap = true })
    end
end

-- Terminal mode mappings
map('t', '<C-h>', '<C-\\><C-N><C-w><C-h>', { noremap = true })
map('t', '<C-l>', '<C-\\><C-N><C-w><C-l>', { noremap = true })
-- Disabled j/k since they conflict with FZF panel
-- map('t', '<C-j>', '<C-\\><C-N><C-w><C-j>', { noremap = true })
-- map('t', '<C-k>', '<C-\\><C-N><C-w><C-k>', { noremap = true })

-- Completion navigation
map('i', '<C-j>', 'pumvisible() ? "\\<C-n>" : "j"', { noremap = true, expr = true })
map('i', '<C-k>', 'pumvisible() ? "\\<C-p>" : "k"', { noremap = true, expr = true })

-- Search mappings
if vim.fn.executable("rg") == 1 then
    map('n', '<leader>wf', ':grep -w <cword> ', { noremap = true })
    map('n', '<leader>f', ':grep ', { noremap = true })
else
    -- Use Fugitive's :Ggrep when rg is not available
    map('n', '<leader>wf', ':Ggrep --recurse-submodules -w <cword><CR>', { noremap = true })
    map('n', '<leader>f', ':Ggrep --recurse-submodules ', { noremap = true })
end

-- Tag navigation and directory changing
map('n', '<leader>g', ':exec("tag ".expand("<cword>"))<CR>', { noremap = true })
map('n', '<leader>cd', ':cd %:p:h<CR>', { noremap = true })

-- FSHere mapping
map('n', '<Leader>o', ':FSHere<cr>', { noremap = true, silent = true })

-- Python execution
map('n', '<F9>', ':exec "!python" shellescape(@%, 1)<cr>', { noremap = true, buffer = true })

-- vim-expand-region mappings
map('v', 'v', '<Plug>(expand_region_expand)', {})
map('v', '<C-v>', '<Plug>(expand_region_shrink)', {})

-- Function to toggle theme
vim.api.nvim_create_user_command('ToggleTheme', function()
    local current_bg = vim.o.background
    if current_bg == 'dark' then
        vim.o.background = 'light'
        vim.cmd('colorscheme shine')
    else
        vim.o.background = 'dark'
        vim.cmd('colorscheme srcery')
    end
end, {})

-- AsyncRun repeat functionality
local last_async_command = nil

-- Create the Arun command
vim.api.nvim_create_user_command('Arun', function(opts)
    last_async_command = opts.args
    vim.cmd('AsyncRun ' .. opts.args)
end, { nargs = '+' })

-- F5 to repeat last async command
map('n', '<F5>', function()
    if last_async_command then
        vim.cmd('AsyncRun ' .. last_async_command)
    else
        print('No previous AsyncRun command found')
    end
end, { noremap = true })

-- CodeCompanion keymaps
-- Core functionality
map('n', '<C-a>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
map('v', '<C-a>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
map('n', '<localleader>a', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
map('v', '<localleader>a', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
map('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })

-- Command line abbreviation for CodeCompanion
vim.cmd([[cab cc CodeCompanion]])
