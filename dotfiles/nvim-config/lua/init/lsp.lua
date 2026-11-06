-- https://github.com/bash-lsp/bash-language-server
vim.lsp.config("bashls", {
    cmd = { "bash-language-server", "start" },
    settings = {
        bashIde = {
            globPattern = vim.env.GLOB_PATTERN or "*@(.bash|.command|.inc|.sh|.zsh)",
        },
    },
    root_markers = { ".git", "pyproject.toml" },
    filetypes = { "bash", "sh", "zsh" },
})
-- https://code.visualstudio.com/docs/languages/css
vim.lsp.config("cssls", {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    init_options = { provideFormatter = false },
    settings = {
        css = {
            lint = {
                unknownAtRules = "ignore",
            },
            validate = true
        },
        scss = { validate = true },
        less = { validate = true },
    },
    root_markers = { ".git", "pyproject.toml" },
})
-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/cucumber_language_server.lua
vim.lsp.config("cucumber_language_server", {
    cmd = { 'cucumber-language-server', '--stdio' },
    filetypes = { 'cucumber' },
    root_markers = { '.git' },
})
-- https://github.com/iamcco/diagnostic-languageserver
vim.lsp.config("diagnosticls", {
    cmd = { "diagnostic-languageserver", "--stdio" },
    root_markers = { ".git", "pyproject.toml" },
    filetypes = {
        "markdown",
    },
    init_options = {
        linters = {
            markdownlint = {
                command = 'markdownlint',
                rootPatterns = { '.git' },
                isStderr = true,
                debounce = 100,
                args = {
                    '--stdin',
                    '--disable',
                    'MD013', -- line length
                    'MD024', -- no-duplicate-heading (want to be able to have # step x with ## inputs and ## outputs for multiple steps in a single file)
                },
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = 'markdownlint',
                securities = {
                    undefined = 'hint'
                },
                formatLines = 1,
                formatPattern = {
                    '^.*:(\\d+)\\s+(.*)$',
                    {
                        line = 1,
                        column = -1,
                        message = 2,
                    }
                }
            }
        },
        filetypes = {
            markdown = { "markdownlint" }
        },
    }
})
-- https://github.com/rcjsuen/dockerfile-language-server-nodejs
vim.lsp.config("dockerls", {
    cmd = { "docker-langserver", "--stdio" },
    filetypes = { "dockerfile" },
    root_markers = { ".git", "pyproject.toml" },
})
vim.lsp.config("gh_actions_ls", {
    filetypes = { 'yaml' },
    root_dir = function(bufnr, on_dir)
        local parent = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
        if
            vim.endswith(parent, '/.github/workflows')
            or vim.endswith(parent, '/.forgejo/workflows')
            or vim.endswith(parent, '/.gitea/workflows')
        then
            on_dir(parent)
        end
    end,
    handlers = {
        ['actions/readFile'] = function(_, result)
            if type(result.path) ~= 'string' then
                return nil, nil
            end
            local file_path = vim.uri_to_fname(result.path)
            if vim.fn.filereadable(file_path) == 1 then
                local f = assert(io.open(file_path, 'r'))
                local text = f:read('*a')
                f:close()

                return text, nil
            end
            return nil, nil
        end,
    },
    init_options = {}, -- needs to be present https://github.com/neovim/nvim-lspconfig/pull/3713#issuecomment-2857394868
    capabilities = {
        workspace = {
            didChangeWorkspaceFolders = {
                dynamicRegistration = true,
            },
        },
    },
})
vim.lsp.config("jinja_lsp", {
    cmd = { "jinja-lsp" },
    filetypes = { "j2", "jinja", "jinja2", "jinja.html", "htmldjango", "django-html" },
    root_markers = { ".git", "pyproject.toml" },
})
vim.lsp.config("jsonls", {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { '.git' },
    init_options = {
        provideFormatter = false,
    },
})
-- https://github.com/LuaLS/lua-language-server
vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".git" },
    settings = {
        Lua = {
            codeLens = { enable = true },
            diagnostics = {
                globals = {
                    "use", -- packer
                    "vim"  -- nvim lua development
                },
            },
            hint = { enable = true, semicolon = "Disable" },
            telemetry = {
                enable = false,
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = "space", -- or "tab"
                    indent_size = "4",      -- or any other number of spaces
                },
            },
        },
    },
})
vim.lsp.config("pylsp", {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", ".git" },
    flags = {
        debounce_text_changes = 250,
    },
    settings = {
        pylsp = {
            plugins = {
                autopep8 = { enabled = false },
                flake8 = { enabled = false },
                jedi_completion = { enabled = true, fuzzy = true },
                mccabe = { enabled = false },
                -- https://pycodestyle.pycqa.org/en/latest/intro.html#error-codes
                pycodestyle = {
                    enabled = false,
                    convention = "numpy",
                    -- select blank line error code category (E301-E306):
                    select = { "E3" }
                },
                pydocstyle = {
                    enabled = false,
                    convention = "numpy"
                },
                pyflakes = { enabled = false },
                pylint = {
                    enabled = false,
                    executable = "pylint",
                    args = { "--load-plugins=pylint.extensions.mccabe", "--max-complexity=14" },
                },                                                           -- https://github.com/PyCQA/pylint
                -- pyls_black = { enabled = true, executable = "black" },
                black = { enabled = false, line_length = 79, timeout = 10 }, -- https://github.com/python-lsp/python-lsp-black
                isort = { enabled = false },
                mypy = { enabled = false },                                  -- https://github.com/python/mypy, https://github.com/python-lsp/pylsp-mypy
                yapf = { enabled = false },
            },
        },
    },
})
vim.lsp.config("ruff", {
    -- https://github.com/astral-sh/ruff/blob/main/docs/editors/settings.md
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", ".git", "ruff.toml", ".ruff.toml" },
    init_options = {
        settings = {
            configurationPreference = "filesystemFirst",
            lineLength = 79,
            logLevel = "warn",
            showSyntaxErrors = true,
        }
    }
})
vim.lsp.config("tailwindcss", {
    cmd = { "tailwindcss-language-server", "--stdio" },
    root_markers = { ".git", "pyproject.toml" },
    filetypes = {
        "css",
        "django-html",
        "gohtml",
        "gohtmltmpl",
        "html",
        "htmlangular",
        "htmldjango",
        "javascript",
        "javascriptreact",
        "jinja",
        "less",
        "php",
        "postcss",
        "sass",
        "scss",
        "svelte",
        "templ",
        "typescript",
        "typescriptreact",
        "vue",
    },
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
    settings = {
        tailwindCSS = {
            validate = true,
            lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidScreen = "error",
                invalidVariant = "error",
                invalidConfigPath = "error",
                invalidTailwindDirective = "error",
                recommendedVariantOrder = "warning",
            },
            classAttributes = {
                "class",
                "className",
                "class:list",
                "classList",
                "ngClass",
            },
            includeLanguages = {
                eelixir = "html-eex",
                elixir = "phoenix-heex",
                eruby = "erb",
                heex = "phoenix-heex",
                htmlangular = "html",
                templ = "html",
            },
        },
    },
})
-- https://github.com/astral-sh/ty
vim.lsp.config("ty", {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", ".git", "ty.toml" },
    settings = {
        ty = {
            -- https://github.com/astral-sh/ty/blob/main/docs/reference/editor-settings.md
            showSyntaxErrors = false,
        }
    }
})
-- https://github.com/redhat-developer/yaml-language-server
vim.lsp.config("yamlls", {
    cmd = { "yaml-language-server", "--stdio" },
    root_markers = { "pyproject.toml", ".git" },
    filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
    on_init = function(client)
        client.server_capabilities.documentFormattingProvider = true
    end,
    settings = {
        completion = { enable = true },
        hover = { enable = true },
        redhat = { telemetry = { enabled = false } },
        schemaDownload = { enable = true },
        schemaStore = { enable = true },
        validate = { enable = true },
        yaml = {
            format = { enable = true },
            schemas = {
                [os.getenv("HOME") .. "/dev/dbgitlab/mddocgen/builddesc_schema.json"] = "/builddesc*.yml",
                ["/mnt/volume/data/dotfiles/openapi_schema.yaml"] = "**/openapi/*.yaml"
            },
        },
    }
})
-- :h lspconfig-all
vim.lsp.enable({
    "bashls",
    "cssls",
    "cucumber_language_server",
    "diagnosticls",
    "dockerls",
    "gh_actions_ls",
    "jinja_lsp",
    "jsonls",
    "lua_ls",
    "ruff",
    "tailwindcss",
    "ty",
    "yamlls",
})
vim.lsp.log.set_level("warn") -- error, warn, info, debug, trace
