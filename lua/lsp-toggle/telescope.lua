-- Copy from https://github.com/adoyle-h/telescope-extension-maker.nvim
local M = {}

local telescope = require('telescope')
local actions = require('telescope.actions')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local action_state = require('telescope.actions.state')
-- local previewers = require('telescope.previewers')
local sorters = require('telescope.sorters')

local entryMaker = function(item)
	local entry = item.entry or {}

	entry.display = entry.display or item.text
	entry.ordinal = entry.ordinal or item.text

	return entry
end

function M.extCallback(ext, opts)
	local items = {}

	local _finder = ext.finder or finders.new_table
	local newFinder = function()
		return _finder { results = items, entry_maker = entryMaker }
	end

	ext = vim.tbl_extend('keep', ext, {
		prompt_title = ext.name,
		previewer = false,
		sorter = sorters.get_generic_fuzzy_sorter {},
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

	local command = ext.command
	local r = command()
	for _, item in pairs(r) do
		local text = item.text
		if #text > 0 then table.insert(items, item) end
	end

	local selIdx = ext.default_selection_index
	if selIdx ~= nil and selIdx < 0 then ext.default_selection_index = #items + 1 + selIdx end

	ext.finder = newFinder()

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
