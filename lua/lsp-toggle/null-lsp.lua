local printf = string.format

return {
	name = 'ToggleNullLSP',

	desc = 'Disable/Enable NullLS source for all buffers',

	command = function()
		local nullLS_present, nullLS = pcall(require, 'null-ls')
		if not nullLS_present then
			nullLS_present, nullLS = pcall(require, 'none-ls')
			if nullLS_present then
				local S = require('none-ls.sources')
			end
		else
			local S = require('null-ls.sources')
		end

		if not nullLS then
			print('Neither null-ls nor none-ls present')
			return {}
		end

		local sources = nullLS.get_sources()
		local ft = vim.o.ft
		local results = {}

		-- source structure
		-- {
		-- 	name = "lua_format"
		-- 	id = 5,
		-- 	filetypes = {
		-- 		lua = true
		-- 	},
		-- 	generator = {
		-- 		async = true,
		-- 		opts = {
		-- 			args = { "-i" },
		-- 			command = "lua-format",
		-- 			ignore_stderr = true,
		-- 			name = "lua_format",
		-- 			to_stdin = true
		-- 		},
		-- 		source_id = 5  [n 7/8]
		-- 	},
		-- 	methods = {
		-- 		NULL_LS_FORMATTING = true
		-- 	},
		-- }
		for _, src in pairs(sources) do
			if src.filetypes[ft] or src.filetypes._all then
				local available = S.is_available(src, ft) and '󰄲' or '󰄱'
				local methods = vim.fn.join(vim.tbl_keys(src.methods), ',')
				table.insert(results,
					{ text = printf('%s %s (%s)', available, src.name, methods), src = src, ft = ft })
			end
		end

		return results
	end,

	onSubmit = function(item)
		local nullLS = require('null-ls')
		local S = require('null-ls.sources')

		local function handle(selection)
			local src = selection.src
			if S.is_available(src, item.ft) then
				nullLS.disable({ id = src.id })
				vim.schedule(function()
					print(printf('NullLS "%s" disabled', src.name))
				end)
			else
				nullLS.enable({ id = src.id })
				vim.schedule(function()
					print(printf('NullLS "%s" enabled', src.name))
				end)
			end
		end

		if vim.islist(item) then
			for _, selection in ipairs(item) do handle(selection) end
		else
			handle(item)
		end
	end,

	sorting_strategy = 'ascending',

	layout_config = {
		height = { 0.4, min = 10, max = 30 },
		width = { 0.5, min = 60, max = 120 },
		prompt_position = 'top', -- top or bottom
	},
}
