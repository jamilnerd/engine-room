vim.g.augroup_jar = vim.api.nvim_create_augroup("augroup_jar", { clear = true })

local function colorize_logs()
    vim.cmd.highlight("LogDebug", "guifg=#767676")
    vim.cmd.highlight("LogWarning", "guifg=#c6c43f")
    vim.cmd.highlight("LogError", "guifg=#bb281b")
    vim.cmd.highlight("LogCritical", "guifg=#bb281b")
    -- Below, the `20` matches the century of the datetime stamp in a log file.
    -- Use priority -1 (less than hlsearch's 0) to not override search highlighting
    vim.fn.matchadd('LogDebug', '.*20.*DEBUG.*', -1)
    vim.fn.matchadd('Special', '.*20.*INFO.*', -1)
    vim.fn.matchadd('LogWarning', '.*20.*WARN.*', -1)
    vim.fn.matchadd('LogError', '.*20.*ERROR.*', -1)
    vim.fn.matchadd('LogCritical', '.*20.*CRITICAL.*', -1)
end
local setup_treesitter = function()
    pcall(function()
        vim.treesitter.start()
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end)
end
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    desc = "Setup treesitter-based folding and disable for csv or large files",
    group = vim.g.augroup_jar,
    pattern = { "*" },
    callback = function(args)
        if vim.fn.fnamemodify(args.file, ":e") == "csv" then
            return
        end
        setup_treesitter()
        local file_size_kb = vim.fn.getfsize(args.file) / 1024
        if file_size_kb > 5000 then
            vim.opt_local.foldmethod = "manual"
        end
    end,
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    desc = "Set filetype to sshconfig for engine-room SSH config file",
    group = vim.g.augroup_jar,
    pattern = { "**/ssh/config" },
    callback = function(args)
        vim.opt_local.filetype = "sshconfig"
        setup_treesitter()
    end
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    desc = "Set filetype to xml for Capella files",
    group = vim.g.augroup_jar,
    pattern = { "*.aird", "*.capella" },
    callback = function(args)
        vim.opt_local.filetype = "xml"
        setup_treesitter()
    end
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    desc = "Set foldlevel=3 for ATO OBU SIM (OpenAPI spec)",
    group = vim.g.augroup_jar,
    pattern = { "**/ato-ob-sim/**/api.json" },
    callback = function(args)
        vim.opt_local.foldlevel = 3
    end
})
vim.api.nvim_create_autocmd('FileType', {
    desc = "Setup treesitter-based folding",
    group = vim.g.augroup_jar,
    pattern = { "aichat" },
    callback = function()
        setup_treesitter()
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    desc = "Enable spell check",
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = { "en_us", "en_gb" }
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    desc = "Setup indention for Markdown files",
    pattern = { "markdown" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.tabstop = 2
    end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    desc = "Use heading-based folding for Markdown files",
    group = vim.g.augroup_jar,
    pattern = { "*.md", "*.markdown" },
    callback = function(args)
        if vim.bo[args.buf].filetype ~= "markdown" then
            return
        end
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr =
        "v:lua.require'init.markdown_folds'.foldexpr()"
    end,
})
vim.api.nvim_create_autocmd({ "LspAttach" }, {
    desc = "Disable ruff LSP for specific .py files",
    group = vim.g.augroup_jar,
    pattern = { "**/*cookiecutter.__project_slug_dash*/**/*.py", "_version.py" },
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "ruff" then
            vim.lsp.buf_detach_client(args.buf, args.data.client_id)
        end
    end
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    desc = "Disable copilot for .env files",
    group = vim.g.augroup_jar,
    pattern = { ".env" },
    callback = function(_)
        vim.b.copilot_enabled = false
    end
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    desc = "Jump to last edit position",
    group = vim.g.augroup_jar,
    callback = function(arg)
        local mark = vim.api.nvim_buf_get_mark(arg.buf, '"')
        local lcount = vim.api.nvim_buf_line_count(arg.buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    desc = "Colorize log files",
    group = vim.g.augroup_jar,
    pattern = { "*.log" },
    callback = function(_)
        colorize_logs()
    end
})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
    desc = "Colorize log output in terminal buffers",
    group = vim.g.augroup_jar,
    callback = function(_)
        colorize_logs()
    end
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    desc = "Set dockerfile filetype for engine-room image files",
    group = vim.g.augroup_jar,
    pattern = { "**/engine-room/images/*" },
    command = "set filetype=dockerfile",
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = vim.g.augroup_jar,
    pattern = { "**/vim-ai-roles.ini" },
    command = "setlocal wrap"
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = vim.g.augroup_jar,
    pattern = { "**/snippets/*.json" },
    command = "setlocal foldlevel=1"
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = vim.g.augroup_jar,
    pattern = { "COMMIT_EDITMSG" },
    callback = function()
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
        vim.cmd.startinsert()
    end,
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = vim.g.augroup_jar,
    pattern = { "MANIFEST.MF" },
    command = "setlocal colorcolumn=72"
})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
    group = vim.g.augroup_jar,
    command = "setlocal colorcolumn=0 nomodified nonumber ruler norelativenumber"
})
vim.api.nvim_create_autocmd({ "TermClose" }, {
    group = vim.g.augroup_jar,
    callback = function()
        vim.o.ruler = true
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true))
    end,
})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    desc = "Format on save",
    group = vim.g.augroup_jar,
    nested = true,
    callback = function()
        -- Skip formatting
        local filename = vim.fn.expand('%:t')
        if filename == "AGENTS.md" or filename == "CHEATSHEET.md" or filename == "p10k.zsh" then
            return
        end
        local format_on_save = {
            bash = true,
            dockerfile = true,
            lua = true,
            markdown = true,
            python = true,
            toml = true,
            sh = true,
            zsh = true,
        }
        if format_on_save[vim.bo.filetype] then
            if next(vim.lsp.get_clients { bufnr = 0, method = "textDocument/formatting" }) ~= nil then
                vim.g.FormatCode()
            end
        end
    end
})
vim.api.nvim_create_autocmd({ "InsertEnter", "TermEnter" }, {
    desc = "Set cursor style in insert/terminal mode",
    group = vim.g.augroup_jar,
    command = "setlocal guicursor=i-t-c-ci-ve:ver25-blinkon500-blinkoff500"
})
vim.api.nvim_create_autocmd({ "InsertLeave", "TermLeave" }, {
    desc = "Set cursor style in normal mode",
    group = vim.g.augroup_jar,
    command = "setlocal guicursor=i-t-c-ci-ve:ver25-blinkon500-blinkoff500,n-v:block-blinkon500-blinkoff500"
})
vim.api.nvim_create_autocmd({ "LspAttach" }, {
    desc = "LSP keymaps and settings",
    group = vim.g.augroup_jar,
    callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set("n", "<leader>ltb", "<cmd>lua vim.lsp.buf.typehierarchy('subtypes')<cr>", opts)
        vim.keymap.set("n", "<leader>ltp", "<cmd>lua vim.lsp.buf.typehierarchy('supertypes')<cr>", opts)
        vim.keymap.set("n", "<leader>lS", "<cmd>lua require('jdtls').super_implementation()<cr>", opts)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method("textDocument/definition") then
            vim.keymap.set("n", "grd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        end
        if client:supports_method("textDocument/formatting") then
            vim.keymap.set("n", "grF", "<cmd>lua vim.lsp.buf.format({timeout_ms = 20000})<cr>", opts)
        end
        if client:supports_method("textDocument/publishDiagnostics") then
            vim.keymap.set("n", "]d",
                "<cmd>lua vim.diagnostic.goto_next{wrap=false,popup_opts={border='rounded'}}<cr>", opts)
            vim.keymap.set("n", "[d",
                "<cmd>lua vim.diagnostic.goto_prev{wrap=false,popup_opts={border='rounded'}}<cr>", opts)
            vim.keymap.set("n", "grl", "<cmd>lopen<cr><cmd>wincmd k<cr>", opts)
            vim.keymap.set("n", "grL", "<cmd>lclose<cr>", opts)
            vim.keymap.set("n", "<leader>WS",
                "<cmd>lua vim.diagnostic.setqflist({buffer = false})<cr><cr><cmd>foldopen!<cr>", opts)
        end
        if client:supports_method("workspace/symbol") then
            vim.keymap.set("n", "grs", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", opts)
        end
        -- if vim is in normal mode:
        if vim.api.nvim_get_mode().mode == "n" then
            vim.cmd.normal("zx")
        end
    end
})
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    desc = "Show cursorline only in active window",
    group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
    callback = function() vim.opt_local.cursorline = true end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    desc = "Hide cursorline in inactive window",
    group = "active_cursorline",
    callback = function() vim.opt_local.cursorline = false end,
})
local sev_name = {
    E = 'E', -- Error
    W = 'W', -- Warning
    I = 'I', -- Information
    H = 'H', -- Hint
}

-- 2. the quick-fix formatting function ----------------------------
--    (must be global so that the location list can see it)
function _G.DiagnosticLoclistText(info)
    local items = vim.fn.getloclist(info.winid,
        { id = info.id, items = 0 }).items

    local out = {}
    for i = info.start_idx, info.end_idx do
        local it      = items[i]
        local udat    = it.user_data or {}
        out[#out + 1] = string.format(
            '%-7s │ %-10s │ %4d │ %s',
            sev_name[it.type] or '',
            udat.source or '',
            it.lnum,
            -- it.col,
            -- vim.fn.fnamemodify(vim.api.nvim_buf_get_name(it.bufnr), ':~:.'),
            it.text:gsub('[\n\r]', ' ')
        )
    end
    return out
end

-- 3. function that rebuilds the list -------------------------------
local function update_loclist(bufnr)
    local diags = vim.diagnostic.get(bufnr)
    if vim.tbl_isempty(diags) then
        vim.fn.setloclist(0, {}, "r", { title = "Diagnostics", items = {} }) -- clear the location list
        return
    end                                                                      -- nothing to show

    local items = {}
    for _, d in ipairs(diags) do
        -- Append diagnostic code to message if it exists
        local text = d.message
        if d.code then
            text = text .. " [" .. tostring(d.code) .. "]"
        end
        items[#items + 1] = {
            bufnr     = bufnr,
            lnum      = d.lnum + 1,
            col       = d.col + 1,
            text      = text,
            type      = ("EWHI"):sub(d.severity, d.severity), -- single-letter code
            user_data = {                                     -- <-- extra information lives here
                severity = d.severity,
                source   = d.source or '',
                code     = d.code,
            },
        }
    end

    -- Sort items by line number or column number (when line numbers are equal)
    table.sort(items, function(a, b)
        if a.lnum == b.lnum then
            return a.col < b.col
        end
        return a.lnum < b.lnum
    end)

    -- Replace (r) the location list of the current window and attach
    -- the custom text function defined above.
    vim.fn.setloclist(0, {}, "r", {
        title            = "Diagnostics",
        items            = items,
        quickfixtextfunc = "v:lua.DiagnosticLoclistText",
    })

    -- Open the list only once – if it is already open getloclist()
    -- returns its window id instead of 0.
    -- if vim.fn.getloclist(0, { winid = 0 }).winid == 0 then
    --     vim.cmd.lopen()
    -- end
end

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = vim.g.augroup_jar,
    callback = function(ev)
        -- ev.buf == buffer whose diagnostics changed
        update_loclist(ev.buf)
    end,
})
