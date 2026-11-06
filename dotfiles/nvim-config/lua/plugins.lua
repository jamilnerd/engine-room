return {
    {
        -- https://github.com/willothy/flatten.nvim
        "willothy/flatten.nvim",
        enabled = false,
        cond = function() return true end,
        lazy = false,
        priority = 1001,
        opts = {
            window = { open = "alternate" },
            pipe_path = function() return vim.env.NVIM end,
            one_per = { kitty = false },
        },
    },
    {
        -- https://github.com/mechatroner/rainbow_csv
        "mechatroner/rainbow_csv",
        ft = "csv",
        config = function()
            vim.g.rcsv_colorpairs = { { "108", "#87af87" }, { "108", "#87af87" }, { "lightgrey", "lightgrey" }, { "green", "green" }, { "grey", "grey" }, { "yellow", "yellow" }, { "173", "#d7875f" }, { "243", "#767676" } }
        end,
    },
    {
        -- https://github.com/tpope/vim-repeat
        "tpope/vim-repeat",
        event = "VeryLazy"
    },
    {
        -- https://github.com/tpope/vim-surround
        -- (e. g. cs"' to replace double by single quotes)
        "tpope/vim-surround",
        event = "VeryLazy"
    },
    {
        -- https://github.com/tpope/vim-speeddating
        "tpope/vim-speeddating",
        event = "VeryLazy",
        config = function() vim.cmd(":SpeedDatingFormat %A") end,
    }
}
