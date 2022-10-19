return {
	name = 'ToggleLSP',
	-- The dettached LSP will reattach after refresh file,

	desc = 'Disable/Enable LSP for current buffer',

	command = function()
		local buf = vim.api.nvim_get_current_buf()
		local ft = vim.o.ft
		local lspconfig = require('lspconfig')

		local clients = vim.lsp.get_active_clients({ bufnr = buf })

		local activeMap = {}
		local list = vim.tbl_map(function(client)
			activeMap[client.name] = true
			return { text = ' ' .. client.name, client = client }
		end, clients)

		local servers = lspconfig.util.available_servers()

		if not activeMap['null-ls'] then list[#list + 1] = { text = ' null-ls', server = 'null-ls' } end

		for _, serverName in pairs(servers) do
			if not activeMap[serverName] then
				local server = lspconfig[serverName]
				if (not server.filetypes) or vim.tbl_contains(server.filetypes, ft) then
					list[#list + 1] = { text = ' ' .. serverName, server = server }
				end
			end
		end

		return list
	end,

	onSubmit = function(selection)
		local buf = vim.api.nvim_get_current_buf()

		if selection.client then
			local clientId = selection.client.id
			vim.lsp.buf_detach_client(buf, clientId)
			vim.lsp.util.buf_clear_references(buf)
		else
			local server = selection.server

			if server == 'null-ls' then
				require('null-ls.client').try_add()
			else
				server.manager.try_add(buf)
			end
		end
	end,

	sorting_strategy = 'ascending',

	layout_config = {
		height = { 0.4, min = 10, max = 30 },
		width = { 0.3, min = 30, max = 120 },
		prompt_position = 'top', -- top or bottom
	},
}
