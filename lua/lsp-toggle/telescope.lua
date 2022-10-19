local M = {}

local telescope = require('telescope')
local actions = require('telescope.actions')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local action_state = require('telescope.actions.state')
local previewers = require('telescope.previewers')

function M.extCallback(ext, opts)
	local results = {}
	local items = {}

	ext = vim.tbl_extend('keep', ext, {
		prompt_title = ext.name,
		previewer = false,
		wrap_results = true,
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				local item = items[selection.index]
				if ext.onSubmit then ext.onSubmit(item) end
			end)

			return true
		end,
	})

	local previewer = ext.previewer
	if type(previewer) == 'string' then ext.previewer = previewers[previewer].new(opts or {}) end

	local command = ext.command

	if type(command) == 'function' then
		local r = command()
		for _, item in pairs(r) do --
			local text = item.text
			if #text > 0 then
				table.insert(results, text)
				table.insert(items, item)
			end
		end
	else
		local r = vim.api.nvim_exec(command, true)

		for _, text in pairs(vim.split(r, '\n')) do --
			if #text > 0 then
				table.insert(results, text)
				table.insert(items, { text = text })
			end
		end
	end

	if ext.finder then
		ext.finder = ext.finder { results = results }
	else
		ext.finder = finders.new_table { results = results }
	end

	if ext.default_selection_index == -1 then ext.default_selection_index = #results end

	-- https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#first-picker
	pickers.new(opts, ext):find()
end

function M.register(extension)
	return telescope.register_extension({
		setup = function(ext_config, config)
		end,

		exports = {
			[extension.name] = function(opts)
				M.extCallback(extension, opts)
			end,
		},
	})
end

return M
