-- lua/config/autocmds.lua

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Automatically refresh changed files
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = augroup("CheckTime"),
    pattern = "*",
    callback = function()
        if vim.fn.mode() ~= "c" then
            vim.cmd("checktime")
        end
    end,
})

-- Notification after file change
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = augroup("FileChangedNotify"),
    pattern = "*",
    callback = function()
        vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
    end,
})

-- File type specific settings
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("FileTypeSettings"),
    pattern = "*",
    callback = function()
        -- Disable auto comment on newline
        vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
    end,
})

-- Custom syntax setup
local function setup_custom_syntax()
    if vim.fn.has('autocmd') == 1 and vim.fn.has('syntax') == 1 then
        vim.cmd([[
            syn match Braces display '[{}()\[\]<>]' containedin=ALL
            syn match LogicalOperator display '\(&&\|||\|!\)' containedin=ALL
            syn keyword cppSTLtype c_auto
        ]])
    end
end

-- Highlighting setup based on background
local function setup_highlighting()
    if vim.o.background == 'light' then
        -- Light theme settings
        vim.cmd([[
            highlight Braces guifg=#900000 gui=bold
            highlight link Operator Normal
            highlight link LogicalOperator Normal
            highlight link OperatorHighlight Normal
            highlight link vimOperator Normal
            highlight Normal guibg=#ffffff guifg=#000000
            highlight LineNr guifg=#505050 guibg=#e0e0e0
            highlight Search guibg=#ffff00 guifg=#000000
        ]])
        vim.g.airline_theme = 'solarized'
        vim.g.ophigh_disable = 1
        vim.g.ophigh_color_gui = "#a01000"
    else
        -- Dark theme settings
        vim.cmd([[
            highlight Braces guifg=#a0ff60 gui=bold
            highlight Operator guifg=#F6FF00 gui=bold
            highlight LogicalOperator guifg=#F6FF00 gui=bold
            highlight OperatorHighlight guifg=#F6FF00 gui=bold
            highlight vimOperator guifg=#F6FF00 gui=bold
            highlight Normal guibg=#080808
            highlight Search guibg=#700000 guifg=NONE
        ]])
        vim.g.airline_theme = 'base16_adwaita'
        vim.g.ophigh_disable = 1
        vim.g.ophigh_color_gui = "#F6FF00"
    end

    -- Refresh operator highlighting if available
    if vim.fn.exists('*OperatorHighlight#Refresh') == 1 then
        vim.fn['OperatorHighlight#Refresh']()
    end
end

-- Apply custom syntax with delay
local function apply_custom_syntax_later()
    vim.defer_fn(setup_custom_syntax, 100)
    vim.defer_fn(setup_highlighting, 150)
end

-- Setup events for syntax and highlighting
vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup("CustomSyntax"),
    callback = apply_custom_syntax_later,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup("ColorSchemeCustomization"),
    callback = apply_custom_syntax_later,
})

-- Terminal settings
vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup("TerminalSettings"),
    callback = function()
        if vim.bo.buftype == 'terminal' then
            vim.opt_local.bufhidden = 'hide'
        end
    end,
})

-- File type associations
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("FileTypeAssociations"),
    pattern = { "*.asc", "*.sl", "*.hlsl" },
    callback = function()
        vim.bo.syntax = "cpp"
    end,
})

-- GLSL file type detection
local function set_glsl_filetype()
    local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
    for _, line in ipairs(lines) do
        if line:match("#version 400") then
            vim.bo.filetype = "glsl400"
            break
        else
            vim.bo.filetype = "glsl330"
            break
        end
    end
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = augroup("GLSLDetection"),
    pattern = { "*.frag", "*.vert", "*.tesc", "*.tese", "*.fp", "*.vp", "*.glsl", "*.sl" },
    callback = set_glsl_filetype,
})

-- GitGutter highlights
vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup("GitGutterColors"),
    callback = function()
        vim.cmd([[
            highlight GitGutterAdd    guifg=#00aa00
            highlight GitGutterChange guifg=#aaaa00
            highlight GitGutterDelete guifg=#ff2222
        ]])
    end,
})

