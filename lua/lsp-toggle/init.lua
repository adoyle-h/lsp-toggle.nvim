local M = {}


-- check if null-ls is installed, since it's optional
local has_null_lsp, _ = pcall(require, 'null-ls')

local toggleLSP = require('lsp-toggle.lsp')
local toggleNullLSP = require('lsp-toggle.null-lsp')

local lsp_group = vim.api.nvim_create_augroup('lspconfig', { clear = false })

-- Auto start LSP only when filetype set
local function autoStartLSP(server)
	local pattern = server.filetypes and table.concat(server.filetypes, ',') or '*'

	vim.api.nvim_create_autocmd('FileType', {
		pattern = pattern,
		callback = function()
			server.manager.try_add_wrapper()
		end,
		group = lsp_group,
		desc = string.format(
			'[lsp-toggle] Checks whether server %s should start a new instance or attach to an existing one.',
			server.name),
	})
end

local function makeCommand(ext)
	local name = ext.name
	vim.api.nvim_create_user_command(name, function()
		local items = ext.command()

		local ok, telescope = pcall(require, 'telescope')
		if ok then
			telescope.extensions[name][name]()
		else
			vim.ui.select(items, {
				prompt = name,
				format_item = function(item)
					return item.text
				end,
			}, function(selection)
				if selection then ext.onSubmit(selection) end
			end)
		end
	end, { desc = ext.desc })
end

local function defaultOpts(opts)
	return vim.tbl_extend('keep', opts or {},
		{ create_cmds = true, telescope = true, autostart = false })
end

function M.setup(opts)
	opts = defaultOpts(opts)

	if opts.autostart then
		local lspconfig = require('lspconfig')
		local serverNames = lspconfig.util.available_servers()
		for _, name in pairs(serverNames) do autoStartLSP(lspconfig[name]) end
	end

	if opts.create_cmds then
		makeCommand(toggleLSP)
		if has_null_lsp then
			makeCommand(toggleNullLSP)
		end
	end

	if opts.telescope then
		local ok, telescope = pcall(require, 'telescope')
		if ok then
			telescope.load_extension(toggleLSP.name)
			if has_null_lsp then
				telescope.load_extension(toggleNullLSP.name)
			end
		else
			error(
				'[lsp-toggle] Not found telescope. If you don\'t want load telescope extensions, please set opts.telescope=false.')
		end
	end
end

return M
