-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Insert new line above without going into insert mode
vim.keymap.set("n", "<CR>", "moO<Esc>`o", { desc = "Insert new line above (stay in normal mode)" })
