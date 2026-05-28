return {
  -- Project detection (uses .git to identify projects)
  {
    "ahmedkhalf/project.nvim",
    opts = {
      detection_methods = { "pattern" },
      patterns = { ".git" },
      -- Restore session instead of opening file finder
      silent_chdir = true,
      manual_mode = true,
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("project_nvim").setup(opts)

      -- Override the default Telescope projects action to restore session
      local telescope = require("telescope")
      telescope.load_extension("projects")
    end,
  },

  -- Make persistence.nvim restore session on project switch
  {
    "folke/persistence.nvim",
    keys = {
      {
        "<leader>fp",
        function()
          local contents = require("project_nvim").get_recent_projects()
          vim.ui.select(contents, { prompt = "Select Project:" }, function(choice)
            if choice then
              -- Close all buffers first
              vim.cmd("%bdelete!")
              -- Change to the project directory
              vim.cmd("cd " .. choice)
              -- Restore the session for that directory
              require("persistence").load()
            end
          end)
        end,
        desc = "Recent Projects (restore session)",
      },
    },
  },

  -- Add projects to the snacks dashboard (LazyVim v8+)
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      table.insert(opts.dashboard.preset.keys, 5, {
        icon = "󰣞 ",
        key = "p",
        desc = "Projects",
        action = function()
          local contents = require("project_nvim").get_recent_projects()
          vim.ui.select(contents, { prompt = "Select Project:" }, function(choice)
            if choice then
              vim.cmd("%bdelete!")
              vim.cmd("cd " .. choice)
              require("persistence").load()
            end
          end)
        end,
      })
    end,
  },

  -- Keymap to open projects from anywhere
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "ahmedkhalf/project.nvim" },
    keys = {
      {
        "<leader>fP",
        "<cmd>Telescope projects<cr>",
        desc = "Recent Projects (find files)",
      },
    },
  },
}
