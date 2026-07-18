return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- mason = false removes clangd from mason-lspconfig's ensure_installed AND
      -- automatic_enable bookkeeping entirely, so the custom `setup.clangd` below
      -- is the ONLY code path that can ever call vim.lsp.enable("clangd").
      -- Relying on mason-lspconfig's automatic_enable.exclude alone isn't
      -- version-safe: on some mason-lspconfig/LazyVim version combos it still
      -- races with this override and attaches clangd twice (two "clangd"
      -- clients, same root dir, in :LspInfo).
      clangd = { mason = false },
    },
    setup = {
      -- Force a single, deterministic enable path for clangd.
      clangd = function(server, server_opts)
        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
        return true -- tell LazyVim not to let mason-lspconfig also auto-enable it
      end,
    },
  },
}
