-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Insert new line above without going into insert mode
-- Only apply in normal file buffers, not in plugin UIs (neo-tree, telescope, quickfix, etc.)
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(ev)
    local bt = vim.bo[ev.buf].buftype
    local ft = vim.bo[ev.buf].filetype
    local special_fts = {
      NvimTree = true, ["neo-tree"] = true, TelescopePrompt = true,
      lazy = true, mason = true, qf = true, help = true,
    }
    if bt == "" and not special_fts[ft] then
      vim.keymap.set("n", "<CR>", "moO<Esc>`o", { desc = "Insert new line above (stay in normal mode)", buffer = ev.buf })
    end
  end,
})
