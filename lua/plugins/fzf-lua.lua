return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local fzf = require("fzf-lua")
            fzf.setup({})

            vim.keymap.set("n", "<leader>gb", fzf.git_bcommits, { noremap = true, silent = true, desc = "Git FZF (B)commits" })
            vim.keymap.set("n", "<leader>gs", fzf.git_status, { noremap = true, silent = true, desc = "Git FZF (S)tatus" })
        end,
    },

    -- Make `gI` always useful. Pyright/basedpyright (and many other servers)
    -- do NOT implement `textDocument/implementation`, so a plain implementation
    -- keymap errors or stays unbound. This dispatcher uses fzf-lua's real
    -- implementation picker where the server supports it (Go/C++/Rust/Java)
    -- and falls back to definitions otherwise (e.g. Python), so `gI` always
    -- jumps somewhere useful for debugging.
    {
        "neovim/nvim-lspconfig",
        opts = function()
            local keys = require("lazyvim.plugins.lsp.keymaps").get()
            keys[#keys + 1] = {
                "gI",
                function()
                    local fzf = require("fzf-lua")
                    local opts = { jump_to_single_result = true }
                    for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                        local caps = c.server_capabilities
                        if caps and caps.implementationProvider then
                            return fzf.lsp_implementations(opts)
                        end
                    end
                    return fzf.lsp_definitions(opts)
                end,
                desc = "Goto Implementation / Definition (FZF)",
            }
        end,
    },
}
