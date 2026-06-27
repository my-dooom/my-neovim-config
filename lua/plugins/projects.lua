local function load_project_session(choice)
  local persistence = require("persistence")
  vim.cmd("cd " .. vim.fn.fnameescape(choice))
  local session_file = persistence.current()

  if vim.fn.filereadable(session_file) == 1 then
    persistence.load()

    local bufs = vim.api.nvim_list_bufs()
    for i = #bufs, 1, -1 do
      local bufnr = bufs[i]
      if vim.api.nvim_buf_is_valid(bufnr)
          and vim.api.nvim_buf_get_name(bufnr) == ""
          and not vim.api.nvim_buf_get_option(bufnr, "modified")
          and vim.api.nvim_buf_get_option(bufnr, "buftype") == "" then
        pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
      end
    end
  else
    vim.notify("No saved persistence session for this project.", vim.log.levels.INFO)
  end
end

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
              load_project_session(choice)
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
              load_project_session(choice)
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
