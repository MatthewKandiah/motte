local NOTES_BUFFER_NUMBER = nil;

local function reset_notes_buffer_number()
	NOTES_BUFFER_NUMBER = nil
end

local function reset()
	if NOTES_BUFFER_NUMBER ~= nil then
		vim.api.nvim_buf_delete(NOTES_BUFFER_NUMBER, { force = true });
		reset_notes_buffer_number();
	end
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

local function create_new_note()
	if not is_notes_buffer_open() then
		print('Cannot create note before notes buffer opened, try :NotesStart')
		return
	end
	-- open dialog with field, close dialog on enter and return text, add note to NOTES with source location and update notes buffer
	print('now post a new note')
end

vim.api.nvim_create_user_command('NotesStart', open_notes_buffer, {})
vim.api.nvim_create_user_command('NewNote', create_new_note, {})

vim.api.nvim_create_autocmd('QuitPre', { callback = reset, buffer = NOTES_BUFFER_NUMBER })
