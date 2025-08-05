require("core")
-- lsp
-- virtual text
vim.diagnostic.config({
	virtual_text = true,
})

-- capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config('*', {
	capabilities = capabilities
})

-- lsp attach
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if not client:supports_method('textDocument/willSaveWaitUntil')
		    and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end
})

-- enabled lsp servers
vim.lsp.enable({ 'jedi', 'lua_ls', 'rust-analyzer' })
