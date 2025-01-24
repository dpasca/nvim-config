-- lua/config/git_sync.lua

local M = {}

-- Function to execute git commands in the nvim config directory
local function execute_git_command(command)
    -- Get the config directory path
    local config_dir = vim.fn.stdpath('config')

    -- Create the full command with cd
    local full_command = string.format('cd %s && git %s', config_dir, command)

    -- Execute the command
    local output = vim.fn.system(full_command)

    -- Show the output
    if output and output ~= "" then
        vim.notify(output, vim.log.levels.INFO)
    end

    return output
end

-- Function to change to nvim config directory
function M.cd_config()
    local config_dir = vim.fn.stdpath('config')
    -- Change Neovim's current directory
    vim.cmd('cd ' .. config_dir)
    -- Show confirmation
    vim.notify('Changed to: ' .. config_dir, vim.log.levels.INFO)

    -- If in terminal buffer, also change the terminal's directory
    if vim.bo.buftype == 'terminal' then
        local shell = vim.o.shell
        local cd_cmd = shell:match("cmd") and "cd" or "cd "  -- Special case for Windows cmd.exe
        vim.api.nvim_chan_send(vim.b.terminal_job_id, cd_cmd .. config_dir .. "\n")
    end
end

-- Function to check if there are changes to commit
local function has_changes()
    local status = execute_git_command('status --porcelain')
    return status ~= ""
end

-- Function to show git status
local function show_status()
    local status = execute_git_command('status')
    -- Display status in a floating window
    local lines = vim.split(status, '\n')
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Calculate window size and position
    local width = 80
    local height = #lines
    local win_height = math.min(height, 20) -- Max height of 20 lines

    local win_opts = {
        relative = 'editor',
        width = width,
        height = win_height,
        row = math.floor((vim.o.lines - win_height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        border = 'rounded'
    }

    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')

    -- Close window with q or <Esc>
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', { noremap = true, silent = true })

    return win
end

-- Function to pull changes
function M.pull_changes()
    execute_git_command('pull')
end

-- Function to commit and push changes
function M.commit_and_push(commit_msg)
    -- If no commit message provided, just push
    if not commit_msg or commit_msg == "" then
        execute_git_command('push')
        return
    end

    -- If commit message provided, do the full commit+push flow
    -- First show status
    local status_win = show_status()

    -- Check if there are changes to commit
    if not has_changes() then
        vim.notify('No changes to commit', vim.log.levels.WARN)
        return
    end

    -- Add all changes
    execute_git_command('add .')

    -- Commit with message
    execute_git_command(string.format('commit -m "%s"', commit_msg))

    -- Push changes
    execute_git_command('push')
end

-- Function to show diff of changes
function M.show_diff()
    local diff = execute_git_command('diff')
    if diff == "" then
        vim.notify('No changes to show', vim.log.levels.INFO)
        return
    end

    -- Display diff in a floating window
    local lines = vim.split(diff, '\n')
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Calculate window size
    local width = 90
    local height = #lines
    local win_height = math.min(height, 20) -- Max height of 20 lines

    local win_opts = {
        relative = 'editor',
        width = width,
        height = win_height,
        row = math.floor((vim.o.lines - win_height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        border = 'rounded'
    }

    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'diff')

    -- Close window with q or <Esc>
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', { noremap = true, silent = true })
end

-- Create user commands
vim.api.nvim_create_user_command('ConfigPull', M.pull_changes, {})
vim.api.nvim_create_user_command('ConfigPush', function(opts)
    M.commit_and_push(opts.args)
end, { nargs = '?' })
vim.api.nvim_create_user_command('ConfigStatus', show_status, {})
vim.api.nvim_create_user_command('ConfigDiff', M.show_diff, {})
vim.api.nvim_create_user_command('ConfigCd', M.cd_config, {})

return M