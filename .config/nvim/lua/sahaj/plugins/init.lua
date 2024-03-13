return {
    {'xiyaowong/telescope-emoji.nvim', cmd="Telescope emoji", opts={}, config=function ()
        require("telescope").load_extension("emoji")
    end},
    -- {"ziontee113/icon-picker.nvim", cmd={"IconPickerInsert", "IconPickerYank", "IconPickerNormal"}, opts={}},
    { "dhruvasagar/vim-table-mode", ft = "markdown" },
    { "jmbuhr/otter.nvim",          ft = "markdown" },
    { 'nvim-pack/nvim-spectre' },
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        dependencies = { "nvim-lua/plenary.nvim", },
        opts = {
            workspaces = { { name = "notes", path = "~/notes", }, },
            disable_frontmatter = true,
            -- daily_notes = {
            --     folder = "journal/daily",
            --     template = "daily.md",
            -- },
            templates = {
                subdir = "templates",
            },
        },
    },
    {
        "ThePrimeagen/vim-apm",
        config = function()
            local apm = require("vim-apm")

            apm:setup({})
            vim.keymap.set("n", "<leader>apm", function() apm:toggle_monitor() end)
        end

    },
    --    { 'declancm/cinnamon.nvim', opts = { default_delay = 4 } },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = { modes = { search = { enabled = false }, char = { enabled = false } } },
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            {
                "S",
                mode = { "n", "x", "o" },
                function() require("flash").treesitter() end,
                desc =
                "Flash Treesitter"
            },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc =
                "Remote Flash"
            },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc =
                "Treesitter Search"
            },
            {
                "<c-s>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc =
                "Toggle Flash Search"
            },
        },

    },
    {
        "Exafunction/codeium.vim",
        event = "BufEnter",
        config = function()
            vim.keymap.set('i', '<S-Tab>', function() return vim.fn['codeium#Accept']() end,
                { expr = true, silent = true })
            -- vim.keymap.set('i', '<F34>', function() return vim.fn['codeium#CycleCompletions'](1) end,
            --     { expr = true, silent = true })
            -- vim.keymap.set('i', '<F33>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
            --     { expr = true, silent = true })
            vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
        end
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "NeoTree",
        keys = {
            { "<leader>b", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
        },
        opts = {},
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    },
    {
        'numToStr/Comment.nvim',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require('Comment').setup {
                toggler = { line = '<leader>/', },
                opleader = { line = '<leader>/', }
            }
        end
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },

    {
        "m4xshen/hardtime.nvim",

        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        opts = {
            disabled_keys = {
                ["<Up>"] = {},
                ["<Down>"] = {},
                ["<Left>"] = {},
                ["<Right>"] = {},
            },
            max_count = 8,
            disable_mouse = false,
            max_time = 500,
            allow_different_key = true,
        },
    },
    {
        'theprimeagen/harpoon',
        branch = "harpoon2",
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
            vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
            vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set("n", "<leader>h", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<leader>j", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<leader>k", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<leader>l", function() harpoon:list():select(4) end)
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            require("ibl").setup {
                scope = { enabled = false },
            }
        end,
    },
    "mbbill/undotree",
    { "catppuccin/nvim",          name = "catppuccin", priority = 1000, },
    { "ThePrimeagen/vim-be-good", lazy = true,         cmd = "VimBeGood" },
    {
        'nvim-telescope/telescope-fzf-native.nvim',

        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {},

    },
    {
        "Eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
        event = "VeryLazy",
        keys = {
            { "<leader>mir", "<cmd>CellularAutomaton make_it_rain<CR>" } }
    },
    { 'kylechui/nvim-surround', event = "VeryLazy", opts = { keymaps = { visual = "Y", visual_line = "gY", }, }, },
    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup { user_default_options = {
                mode = "virtualtext" } }
        end,
        event = "VeryLazy",
    },
    -- {
    --     "max397574/colortils.nvim",
    --     cmd = "Colortils",
    --     config = function()
    --         require("colortils").setup()
    --     end,
    -- }
    -- {
    --     "tzachar/local-highlight.nvim",
    --     config = function()
    --         require('local-highlight').setup()
    --     end
    -- }
}
