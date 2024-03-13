local extension = vim.fn.expand("%:e")
return {
    'VonHeikemen/lsp-zero.nvim',
    event = { "BufReadPre", "BufNewFile" },
    branch = 'v2.x',
    lazy = true,
    -- cond = (extension ~= "" and extension or nil) ~= "txt" and (extension ~= "" and extension or nil) ~= "md" and (extension ~= ""),
    dependencies = {
        -- LSP Support
        'neovim/nvim-lspconfig',             -- Required
        'williamboman/mason.nvim',           -- Optional
        'williamboman/mason-lspconfig.nvim', -- Optional
        -- "smjonas/inc-rename.nvim",
        "hrsh7th/cmp-path",                  -- source for file system paths
        "hrsh7th/cmp-buffer",
        "onsails/lspkind.nvim",
        "rafamadriz/friendly-snippets", -- useful snippets


        -- Autocompletion
        { 'hrsh7th/nvim-cmp', event = 'InsertEnter', }, -- Required
        'hrsh7th/cmp-nvim-lsp',                         -- Required
        'L3MON4D3/LuaSnip',                             -- Required
        'saadparwaiz1/cmp_luasnip'
    },

    config = function()
        local lsp = require("lsp-zero")

        lsp.preset("recommended")

        lsp.nvim_workspace()

        lsp.ensure_installed {
            -- 'eslint',
            'lua_ls',
            'bashls',
            -- 'pyright',
            'clangd',
            'pylsp',
        }

        require('lspconfig').pylsp.setup({
            settings = {
                pylsp = {
                    plugins = {
                        mccabe = {
                            threshold = 50
                        },
                        -- jedi_completion = { include_params = true },
                        -- jedi_hover = { enabled = true },
                        -- jedi_references = { enabled = true },
                        -- jedi_signature_help = { enabled = true },
                        -- jedi_symbols = { enabled = true }
                    }
                }
            }
        })
        require("lspconfig").clangd.setup({
            cmd = {
                "clangd",
                "--fallback-style=webkit"
            }
        })

        local cmp = require('cmp')
        local luasnip = require("luasnip")
        local cmp_action = require('lsp-zero').cmp_action()
        local cmp_format = require('lsp-zero').cmp_format()
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')

        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )
        -- local lspkind = require("lspkind")

        -- load vs-code like snippets from plugins (e.g. friendly-snippets)

        require('luasnip.loaders.from_vscode').lazy_load()

        vim.opt.completeopt = "menu,menuone,noselect"
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
        })


        local cmp_select = { behaviour = cmp.SelectBehavior.Select }
        local cmp_mappings = lsp.defaults.cmp_mappings({
            ['<up>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<down>'] = cmp.mapping.select_next_item(cmp_select),
            ['<Tab>'] = cmp_action.luasnip_supertab(),
            -- ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
            ['<Tab>'] = vim.NIL,
            ['<S-Tab>'] = vim.NIL,
            ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
            ["<C-e>"] = cmp.mapping.abort(),
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
        })

        lsp.set_sign_icons({
            error = "▊",
            hint = "▉",
            warn = "▉",
            info = "▉",
        })

        lsp.setup_nvim_cmp({
            mapping = cmp_mappings
        })

        lsp.setup()
        cmp.setup({
            formatting = {
                fields = { 'abbr', 'kind', 'menu' },
                format = require('lspkind').cmp_format({
                    -- mode = 'symbol',       -- show only symbol annotations
                    maxwidth = 50,         -- prevent the popup from showing more than provided characters
                    ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
                })
            }
        })

        cmp.setup({
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
            },
        })
        cmp.setup({
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            }
        })
        vim.diagnostic.config({
            underline = {
                severity = { min = vim.diagnostic.severity.ERROR }
            },
            virtual_text = {
                severity = { min = vim.diagnostic.severity.WARN }
            }
        })

        -- auto format on save
        lsp.on_attach(function(client, bufnr)
            lsp.default_keymaps({ buffer = bufnr })
            lsp.buffer_autoformat()
        end)
        -- -- format on keybind (already implemented in remap.lua)
        -- lsp.on_attach(function(client, bufnr)
        --     local opts = { buffer = bufnr }
        --
        --     vim.keymap.set({ 'n', 'x' }, 'fm', function()
        --         vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
        --     end, opts)
        -- end)
    end
}
