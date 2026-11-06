vim.g.fold_text = function()
    local line = vim.fn.getline(vim.v.foldstart)
    local num_lines = vim.v.foldend - vim.v.foldstart + 1
    return string.format("%s    %d lines", line, num_lines)
end
vim.g.console = function()
    vim.cmd("terminal")
    vim.cmd("startinsert")
    vim.defer_fn(function()
        vim.cmd([[
        silent! file term://console
    ]])
    end, 500)
end
vim.g.ipython = function()
    vim.cmd("terminal ipython")
    vim.cmd("startinsert")
    vim.defer_fn(function()
        vim.cmd([[
        silent! file term://ipython
    ]])
    end, 500)
end
vim.g.obu_sim_log = function(no_rename_buffer)
    vim.cmd("terminal tail -n 1000 -f /opt/bind/dev/dbgitlab/atoc-test-runner/log/OBUSim.log")
    vim.cmd("normal! G")
    vim.opt_local.relativenumber = false
    vim.opt_local.number = true
    if not no_rename_buffer then
        vim.defer_fn(function()
            vim.cmd([[
            silent! file term://OBUSim.log3
        ]])
        end, 500)
        vim.defer_fn(function()
            vim.cmd([[
            silent! file term://OBUSim.log2
        ]])
        end, 500)
        vim.defer_fn(function()
            vim.cmd([[
            silent! file term://OBUSim.log
        ]])
        end, 500)
    end
end
vim.g.opencode = function(no_rename_buffer)
    vim.cmd("terminal opencode")
    vim.cmd("startinsert")
    if not no_rename_buffer then
        vim.defer_fn(function()
            vim.cmd([[
            silent! file term://opencode3
        ]])
        end, 500)
        vim.defer_fn(function()
            vim.cmd([[
            silent! file term://opencode2
        ]])
        end, 500)
        vim.defer_fn(function()
            vim.cmd([[
            silent! file term://opencode
        ]])
        end, 500)
    end
end
vim.g.terminal = function()
    vim.cmd.terminal()
    vim.cmd("startinsert")
    vim.defer_fn(function()
        vim.cmd([[
        silent! file term://terminal
    ]])
    end, 500)
end
vim.g.top = function()
    vim.cmd("terminal top")
    vim.cmd("startinsert")
    vim.defer_fn(function()
        vim.cmd([[
        silent! file term://top
    ]])
    end, 500)
end
vim.g.FormatCode = function()
    vim.cmd("pyfile ~/engine-room/dotfiles/nvim-config/jopilot/src/jopilot/format.py")
    -- if vim.bo.filetype == "python" then
    --     if next(vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf(), method = "textDocument/codeAction" }) ~= nil then
    --         local has_code_action = false
    --         vim.lsp.buf.code_action {
    --             context = { only = { "source.organizeImports.ruff" } },
    --             filter = function(_)
    --                 if not has_code_action then
    --                     has_code_action = true
    --                     return true
    --                 end
    --                 return false
    --             end,
    --             apply = true,
    --         }
    --     end
    -- end
end
vim.g.WorkingTimesCompute = function()
    vim.api.nvim_command("write")
    local proc = vim.system(
        { "uv", "run", "python", "-m", "working_times" },
        { cwd = os.getenv("HOME") .. "/dev/github/working-times" }
    ):wait()
    if proc.code == 0 then
        vim.api.nvim_command("edit")
    else
        print("Error: " .. proc.stdout)
    end
end
