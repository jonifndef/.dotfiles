local state = {
    floating = {
        buf = -1,
        win = -1,
    },
    small = {
        buf = -1,
        win = -1,
    }
}

local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
    }

    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

local function create_small_window(opts)
    opts = opts or {}
    local height = opts.width or math.floor(vim.o.lines * 0.22)

    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    local win_config = {
        split = "below",
        height = height,
    }

    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

local toggle_floating_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window({ buf = state.floating.buf })
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

local toggle_small_terminal = function()
    if not vim.api.nvim_win_is_valid(state.small.win) then
        state.small = create_small_window({ buf = state.small.buf })
        if vim.bo[state.small.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
        end
    else
        vim.api.nvim_win_hide(state.small.win)
    end
end

vim.api.nvim_create_user_command("Floatingterminal", toggle_floating_terminal, {})
vim.api.nvim_create_user_command("Smallterminal", toggle_floating_terminal, {})

vim.keymap.set({'n', 't'}, "<leader>ft", toggle_floating_terminal)
vim.keymap.set({'n', 't'}, "<leader>st", toggle_small_terminal)
