local ih = require('inlay-hints')
ih.setup()

local lsp = require('lsp-zero').preset({})

lsp.ensure_installed({
	'tsserver',
	'eslint',
	'rust_analyzer',
	'clangd',
	'tailwindcss',
})

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({buffer = bufnr})
end)

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mapping = lsp.defaults.cmp_mappings({
	['<C-p'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y'] = cmp.mapping.confirm({select = true}),
	['<C-Space'] = cmp.mapping.complete(),
})

lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup({
    lsp.nvim_lua_ls(),
    on_attach = function(client, bufnr )
        ih.on_attach(client, bufnr)
    end,
    settings = {
        Lua = {
            hint = true,
        },
    }
})

lsp.skip_server_setup({'rust_analyzer'})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

local rust_tools = require('rust-tools')

rust_tools.setup({
  server = {
    on_attach = function()
      vim.keymap.set('n', '<leader>ca', rust_tools.hover_actions.hover_actions, {buffer = bufnr})
    end
  }
})
