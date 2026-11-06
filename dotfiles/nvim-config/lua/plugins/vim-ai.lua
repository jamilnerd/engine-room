vim.g.startChat = function()
    vim.cmd.setlocal("filetype=aichat")
    vim.cmd.startinsert()
end
return {
    -- https://github.com/madox2/vim-ai (ChatGPT in Neovim) {{{
    {
        "madox2/vim-ai",
        disable = true,
        cmd = { "AI", "AIChat", "AIEdit", "AINewChat", "AIRedo", "AIUtilRolesOpen", "AIUtilDebugOff", "AIUtilDebugOn" },
        ft = "aichat",
        keys = {
            { "<leader>bc", "<cmd>normal zt<cr><cmd>AIChat<cr>" },
            { "<leader>br", "<cmd>AIRedo<cr>" },
            { "<leader>Bt", "<cmd>AIC /t<cr>" },
            { "<leader>Bb", "<cmd>below new<cr><cmd>wincmd k<cr><cmd>close<cr><cmd>lua vim.g.startChat()<cr>" },
            { "<leader>Bh", "<cmd>AIC /h<cr>" },
            { "<leader>Bj", "<cmd>AIC /j<cr>" },
            { "<leader>Bk", "<cmd>AIC /k<cr>" },
            { "<leader>Bl", "<cmd>AIC /l<cr>" },
        },
        config = function()
            vim.g.vim_ai_async_chat = 0
            vim.g.vim_ai_debug = 0
            vim.g.vim_ai_debug_log_file = "/tmp/vim_ai_debug.log"
            vim.g.vim_ai_roles_config_file = os.getenv("HOME") .. "/.config/nvim/vim-ai-roles.ini"
        end,
    }
}
