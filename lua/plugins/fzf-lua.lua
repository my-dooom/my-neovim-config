return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")
        fzf.setup({})

        vim.keymap.set("n", "<leader>gb", fzf.git_bcommits, { noremap = true, silent = true, desc = "Git FZF (B)commits" })
        vim.keymap.set("n", "<leader>gs", fzf.git_status, { noremap = true, silent = true, desc = "Git FZF (S)tatus" })

        -- Make `gI` (goto implementation) work reliably per-buffer.
        -- Only bind fzf-lua's implementation picker when the attached server
        -- actually supports `textDocument/implementation`; otherwise fall back
        -- to definitions so the key is always useful for debugging.
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("fzf_lua_lsp_impl", { clear = true }),
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then
                    return
                end
                local supports = client.supports_method
                        and client:supports_method("textDocument/implementation")
                local fn = supports and fzf.lsp_implementations or fzf.lsp_definitions
                vim.keymap.set("n", "gI", fn, {
                    buffer = args.buf,
                    noremap = true,
                    silent = true,
                    desc = supports and "Goto Implementation (FZF)" or "Goto Definition (FZF, no impl)",
                })
            end,
        })
    end,
}
