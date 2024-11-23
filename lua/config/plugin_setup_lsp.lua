local M = {
  -- Completion engine dependencies
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = false,  -- Load this plugin immediately
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",  -- LSP completion
      "hrsh7th/cmp-buffer",    -- Buffer completion
      "hrsh7th/cmp-path",      -- Path completion
      "L3MON4D3/LuaSnip",      -- Snippet engine
      "saadparwaiz1/cmp_luasnip", -- Snippet completion
    },
    lazy = false,  -- Load immediately
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Mason for managing LSP servers
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason-lspconfig bridges Mason with the lspconfig plugin
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",    -- Lua
          "pyright",   -- Python
          "clangd",    -- C/C++
          "typescript-language-server",  -- TypeScript/JavaScript
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Wait for cmp_nvim_lsp to be loaded
      local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = has_cmp and cmp_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

      -- LSP settings
      local lspconfig = require("lspconfig")

      -- Setup each LSP server
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        pyright = {},
        -- Disable clangd diagnostics, because it's a nightmare with MSVC
        clangd = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=never",
            "--compile-commands-dir=build"  -- Looks for compile_commands.json in build directory
          },
          init_options = {
            compilationDatabasePath = "build",  -- Path to compilation database
            fallbackFlags = {
              "-DDEBUG",
              "-DUSE_TORCH",
            }
          },
        },
        typescript_language_server = {},
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        -- Disable semantic tokens (syntax highlighting) from LSP
        config.on_attach = function(client, bufnr)
          client.server_capabilities.semanticTokensProvider = nil
        end
        lspconfig[server].setup(config)
      end

      -- LSP keymaps (unchanged)
      vim.keymap.set("n", "<leader>g", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
    end,
  },

  -- Telescope for fuzzy finding
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          file_ignore_patterns = {
            "node_modules",
            ".git",
            "target",
            "build",
          },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>s", builtin.lsp_document_symbols, { desc = "Find document symbols" })
      vim.keymap.set("n", "<leader>S", builtin.lsp_workspace_symbols, { desc = "Find workspace symbols" })
      vim.keymap.set("n", "<leader>h", builtin.oldfiles, { desc = "Find recently opened files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })

      -- Keep old FZF grep mappings but use Telescope instead
      if vim.fn.executable("rg") == 1 then
        vim.keymap.set("n", "<leader>wf", function()
          builtin.grep_string({ word_match = "-w" })
        end, { desc = "Grep word under cursor" })
        vim.keymap.set("n", "<leader>f", function()
          builtin.live_grep()
        end, { desc = "Live grep" })
      end
    end,
  },
}

return M
