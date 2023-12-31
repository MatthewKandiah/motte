local NOTES_BUFFER_NUMBER = nil;

local NEXT_NOTE_LINE_NUMBER = 0;

-- a note is a table containing:
-- text = string
local NOTES = {}

local function reset()
	if NOTES_BUFFER_NUMBER ~= nil then
		vim.api.nvim_buf_delete(NOTES_BUFFER_NUMBER, { force = true });
	end
	NOTES = {}
	NOTES_BUFFER_NUMBER = nil
end

local function is_notes_buffer_open()
	return NOTES_BUFFER_NUMBER ~= nil
end

local function open_notes_buffer()
	if is_notes_buffer_open() then
		print('Notes buffer already open')
		return
	end
	vim.cmd('vnew')
	NOTES_BUFFER_NUMBER = vim.api.nvim_get_current_buf()
	vim.api.nvim_set_option_value('modifiable', 0, { buf = NOTES_BUFFER_NUMBER })
end

local function update_notes_buffer()
	vim.api.nvim_set_option_value('modifiable', 1, { buf = NOTES_BUFFER_NUMBER })
	vim.api.nvim_buf_set_lines(NOTES_BUFFER_NUMBER, 0, -1, false, {})
	NEXT_NOTE_LINE_NUMBER = 0
	for i = 1, #NOTES do
		vim.api.nvim_buf_set_lines(NOTES_BUFFER_NUMBER, NEXT_NOTE_LINE_NUMBER, NEXT_NOTE_LINE_NUMBER, true, {i .. '. ' .. NOTES[i].text})
		vim.api.nvim_buf_set_lines(NOTES_BUFFER_NUMBER, NEXT_NOTE_LINE_NUMBER + 1, NEXT_NOTE_LINE_NUMBER + 1, true, {''})
		NEXT_NOTE_LINE_NUMBER = NEXT_NOTE_LINE_NUMBER + 2
	end
	vim.api.nvim_set_option_value('modifiable', 0, { buf = NOTES_BUFFER_NUMBER })
end

local function create_new_note()
	if not is_notes_buffer_open() then
		print('Cannot create note before notes buffer opened, try :NotesStart')
		return
	end
	vim.ui.input({ prompt = 'Note: ' }, function(input)
		if input ~= nil and input ~= '' then
			table.insert(NOTES, { text = input })
			update_notes_buffer()
		end
	end)
end

local function delete_note(number)
	if tonumber(number) <= #NOTES then
		table.remove(NOTES, number)
		update_notes_buffer()
	else
		print('ERROR: attempting to delete note ' .. number .. ' when only ' .. #NOTES .. 'notes exist')
	end
end

vim.api.nvim_create_user_command('NotesStart', open_notes_buffer, {})
vim.api.nvim_create_user_command('NewNote', create_new_note, {})
vim.api.nvim_create_user_command('DelNote', function() vim.ui.input({ prompt = 'Number: ' }, delete_note) end, {})

vim.api.nvim_create_autocmd('QuitPre', { callback = reset, buffer = NOTES_BUFFER_NUMBER })
