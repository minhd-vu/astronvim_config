--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key
local config = {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_reload = true, -- automatically reload and sync packer after a successful update
    auto_quit = false, -- automatically quit the current session after a successful update
    -- remotes = { -- easily add new remotes to track
    --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
    --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
    --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    -- },
  },

  -- Set colorscheme to use
  colorscheme = "material",

  -- set vim options here (vim.<first_key>.<second_key> = value)
  options = {
    opt = {
      -- set to true or false etc.
      relativenumber = false, -- sets vim.opt.relativenumber
      number = true, -- sets vim.opt.number
      spell = true, -- sets vim.opt.spell
      signcolumn = "auto", -- sets vim.opt.signcolumn to auto
      wrap = false, -- sets vim.opt.wrap
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
      autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
      cmp_enabled = true, -- enable completion at start
      autopairs_enabled = true, -- enable autopairs at start
      diagnostics_enabled = true, -- enable diagnostics at start
      status_diagnostics_enabled = true, -- enable diagnostics in statusline
      icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    },
  },

  -- If you need more control, you can use the function()...end notation
  -- options = function(local_vim)
  --   local_vim.opt.relativenumber = true
  --   local_vim.g.mapleader = " "
  --   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
  --   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
  --
  --   return local_vim
  -- end,

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  -- Mapping data with "desc" stored directly by vim.keymap.set().
  --
  -- Please use this mappings table to set keyboard mapping since this is the
  -- lower level configuration and more robust one. (which-key will
  -- automatically pick-up stored data by this setting.)
  mappings = {
    -- first key is the mode
    n = {
      -- second key is the lefthand side of the map
      L = {
        function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
        desc = "Next buffer",
      },
      H = {
        function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
        desc = "Previous buffer",
      },

      -- vertical movement
      ["<C-d>"] = { "<C-d>zz", desc = "Move down half a page and center cursor" },
      ["<C-u>"] = { "<C-u>zz", desc = "Move up half a page and center cursor" },

      -- color column
      ["<leader>uc"] = {
        function()
          local value = vim.api.nvim_get_option_value("colorcolumn", {})
          vim.api.nvim_set_option_value("colorcolumn", value == "" and "81" or "", {})
        end,
        desc = "Toggle color column",
      },

      -- harpoon
      ["<leader>h"] = { false, desc = "🎣 Harpoon" },
    },
  },

  -- Configure plugins
  plugins = {
    {
      "marko-cerovac/material.nvim",
      init = function() vim.g.material_style = "darker" end,
      config = function()
        require("material").setup {
          contrast = {
            terminal = true, -- Enable contrast for the built-in terminal
            sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
            floating_windows = false, -- Enable contrast for floating windows
            cursor_line = false, -- Enable darker background for the cursor line
            non_current_windows = true, -- Enable darker background for non-current windows
            filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
          },
          plugins = { -- Uncomment the plugins that you use to highlight them
            -- Available plugins:
            "dap",
            "dashboard",
            "gitsigns",
            -- "hop",
            "indent-blankline",
            -- "lspsaga",
            -- "mini",
            "neogit",
            "nvim-cmp",
            -- "nvim-navic",
            "nvim-tree",
            -- "sneak",
            "telescope",
            -- "trouble",
            "which-key",
          },
        }
      end,
    },
    {
      "jinh0/eyeliner.nvim",
      config = function()
        require("eyeliner").setup {
          highlight_on_key = true,
        }
      end,
      keys = { "f", "F", "t", "T" },
    },
    {
      "rlane/pounce.nvim",
      keys = {
        { "s", "<cmd>Pounce<cr>", mode = { "n", "v", "o" }, desc = "Pounce somewhere" },
        { "S", "<cmd>PounceRepeat<cr>", mode = { "n" }, desc = "Repeat last pounce" },
      },
    },
    {
      "petertriho/nvim-scrollbar",
      event = "User AstroFile",
      config = function() require("scrollbar").setup() end,
    },
    {
      -- https://github.com/iamcco/markdown-preview.nvim/issues/552
      "iamcco/markdown-preview.nvim",
      ft = "markdown",
      build = function() vim.fn["mkdp#util#install"]() end,
      keys = {
        { "<leader>um", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown preview" },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      event = "User AstroFile",
    },
    {
      "ThePrimeagen/harpoon",
      config = function() require("telescope").load_extension "harpoon" end,
      keys = {
        { "<leader>ha", "<cmd>:lua require('harpoon.mark').add_file()<cr>", desc = "Add harpoon mark" },
        { "<leader>hd", "<cmd>:lua require('harpoon.mark').rm_file()<cr>", desc = "Delete harpoon mark" },
        { "<leader>hc", "<cmd>:lua require('harpoon.mark').clear_all()<cr>", desc = "Clear all harpoon marks" },
        { "<leader>hh", "<cmd>:Telescope harpoon marks<cr>", desc = "Harpoon menu" },
        -- { "<C-h>", "<cmd>:lua require('harpoon.ui').nav_prev()<cr>", desc = "Previous harpoon file" },
        -- { "<C-l>", "<cmd>:lua require('harpoon.ui').nav_next()<cr>", desc = "Next harpoon file" },
      },
    },
    { -- override nvim-cmp plugin
      "hrsh7th/nvim-cmp",
      -- override the options table that is used in the `require("cmp").setup()` call
      opts = function(_, opts)
        -- opts parameter is the default options table
        -- the function is lazy loaded so cmp is able to be required
        local cmp = require "cmp"
        -- modify the mapping part of the table
        opts.confirm_opts.behavior = cmp.ConfirmBehavior.Insert
        opts.mapping["<Tab>"] = nil
        opts.mapping["<S-Tab>"] = nil

        -- return the new table to be used
        return opts
      end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = function(_, opts)
        opts.window.mappings["H"] = "prev_source"
        opts.window.mappings["L"] = "next_source"
      end,
    }
  },
}

return config
