return {
    {
        -- https://github.com/tpope/vim-fugitive
        "tpope/vim-fugitive",
        cmd = { "G", "Git", "Gclog", "Gwrite", "Gread", "Gdiff", "GBrowse" },
        keys = {
            { "<leader>Gb", "<cmd>G<cr>",                                  desc = "Open Git status" },
            { "<leader>Gt", "<cmd>tabedit +G<cr><cmd>TabooRename Git<cr>", desc = "Git status in new tab" },
        },
    },
    {
        -- https://github.com/lewis6991/gitsigns.nvim
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                diff_opts = {
                    vertical = false
                }
            })
            vim.keymap.set('n', '<leader>gd', '<cmd>Gitsigns diffthis<cr>', { silent = true })
            -- vim.keymap.set('n', '[c', '<cmd>Gitsigns nav_hunk prev<cr>', { silent = true })
            -- vim.keymap.set('n', ']c', '<cmd>Gitsigns nav_hunk next<cr>', { silent = true })
            vim.keymap.set('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', { silent = true })
            vim.keymap.set('n', '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', { silent = true })
            vim.keymap.set('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', { silent = true })
        end
    },
}

