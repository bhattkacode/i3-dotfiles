return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            -- 'WhoIsSethDaniel/mason-tool-installer.nvim',

        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    --  To jump back, press <C-t>.
                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('gs', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('gS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    -- map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                    -- Opens a popup that displays documentation about the word under your cursor
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    -- local client = vim.lsp.get_client_by_id(event.data.client_id)
                    -- if client and client.server_capabilities.documentHighlightProvider then
                    --     vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    --         buffer = event.buf,
                    --         callback = vim.lsp.buf.document_highlight,
                    --     })
                    --
                    --     vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    --         buffer = event.buf,
                    --         callback = vim.lsp.buf.clear_references,
                    --     })
                    -- end
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            -- Enable the following language servers
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                clangd = {

                    cmd = {
                        "clangd",
                        "--fallback-style=webkit",
                    },
                    capabilities = {
                        textDocument = {
                            completion = {
                                completionItem = {
                                    snippetSupport = false,
                                },
                            },
                        },
                    },
                },
                pylsp = {
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

                },

                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                            diagnostics = {
                                disable = { 'missing-fields' },
                                globals = { 'vim' }
                            },
                        },
                    },
                },
            }

            --  You can press `g?` for help in this menu.
            require('mason').setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                -- 'stylua', -- Used to format Lua code
                'lua_ls',
                'bashls',
                'clangd',
                'pylsp',
            })

            require('mason-lspconfig').setup { ensure_installed = ensure_installed }

            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }

            -- DIAGNOSTICS

            vim.diagnostic.config({
                underline = {
                    severity = { min = vim.diagnostic.severity.ERROR }
                },
                virtual_text = {
                    severity = { min = vim.diagnostic.severity.WARN },
                    -- prefix = '●'
                    prefix = '•'
                },
                float = { border = "rounded" },
            })
            local hi
            vim.cmd [[
            " sign define DiagnosticSignError text= texthl=DiagnosticError
            " sign define DiagnosticSignWarning text= texthl=DiagnosticWarning
            " sign define DiagnosticSignInfo text= texthl=DiagnosticInfo
            " sign define DiagnosticSignHint text= texthl=DiagnosticHint
            "
            " sign define DiagnosticSignError text= texthl=DiagnosticError
            " sign define DiagnosticSignWarning text= texthl=DiagnosticWarning
            " sign define DiagnosticSignInfo text= texthl=DiagnosticInfo
            " sign define DiagnosticSignHint text= texthl=DiagnosticHint

            sign define DiagnosticSignError text=▍ texthl=DiagnosticError
            sign define DiagnosticSignWarn text=▍ texthl=DiagnosticWarn
            sign define DiagnosticSignInfo text=▍ texthl=DiagnosticInfo
            sign define DiagnosticSignHint text=▍ texthl=DiagnosticHint

            ]]

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
            })
        end,
    },
    {
        'stevearc/conform.nvim',
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- local disable_filetypes = { c = true, cpp = true }
                return {
                    timeout_ms = 500,
                    -- lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                    lsp_fallback = true,
                }
            end,
            -- formatters_by_ft = {
            --   lua = { 'stylua' },
            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- You can use a sub-list to tell conform to run *until* a formatter
            -- is found.
            -- javascript = { { "prettierd", "prettier" } },
            -- },
        },
    },

    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
                    {
                        'rafamadriz/friendly-snippets',
                        config = function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                        end,
                    },
                },
            },
            'saadparwaiz1/cmp_luasnip',

            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
        },
        config = function()
            -- See `:help cmp`
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            luasnip.config.setup {}
            local ELLIPSIS_CHAR = '…'
            local MAX_LABEL_WIDTH = 20
            local MIN_LABEL_WIDTH = 20

            local cmp_autopairs = require('nvim-autopairs.completion.cmp')

            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                completion = { completeopt = 'menu,menuone,noinsert' },

                mapping = cmp.mapping.preset.insert {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),

                    ['<C-Space>'] = cmp.mapping.confirm { select = true },

                    -- Manually trigger a completion from nvim-cmp.
                    -- ['<C-Space>'] = cmp.mapping.complete {},

                    -- ['<Tab>'] = cmp.mapping(function()
                    --     if luasnip.expand_or_locally_jumpable() then
                    --         luasnip.expand_or_jump()
                    --     end
                    -- end, { 'i', 's' }),
                    --
                    -- ['<S-Tab>'] = cmp.mapping(function()
                    --     if luasnip.locally_jumpable(-1) then
                    --         luasnip.jump(-1)
                    --     end
                    -- end, { 'i', 's' }),

                    ['<Down>'] = cmp.mapping(function(fallback)
                        cmp.close()
                        fallback()
                    end, { "i" }),
                    ['<Up>'] = cmp.mapping(function(fallback)
                        cmp.close()
                        fallback()
                    end, { "i" }),

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                            -- that way you will only jump inside the snippet region
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'buffer' },
                },

                formatting = {
                    format = function(entry, vim_item)
                        local label = vim_item.abbr
                        local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
                        if truncated_label ~= label then
                            vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
                        elseif string.len(label) < MIN_LABEL_WIDTH then
                            local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
                            vim_item.abbr = label .. padding
                        end
                        return vim_item
                    end,
                },
            }

            local unlink_group = vim.api.nvim_create_augroup('UnlinkSnippet', {})
            vim.api.nvim_create_autocmd('ModeChanged', {
                group = unlink_group,
                -- when going from select mode to normal and when leaving insert mode
                pattern = { 's:n', 'i:*' },
                callback = function(event)
                    if
                        luasnip.session
                        and luasnip.session.current_nodes[event.buf]
                        and not luasnip.session.jump_active
                    then
                        luasnip.unlink_current()
                    end
                end,
            })
        end,
    },
}
