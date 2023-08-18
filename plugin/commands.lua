NOTES_BUFFER_NUMBER = nil;

local function is_notes_buffer_open()
	print('is_notes_buffer_open')
	print(NOTES_BUFFER_NUMBER ~= nil)
	return NOTES_BUFFER_NUMBER ~= nil
end

local function open_notes_buffer()
	print('open_notes_buffer')
	print(NOTES_BUFFER_NUMBER)
	if not is_notes_buffer_open() then
		print('open_notes_buffer - opening')
		vim.cmd('vnew')
		NOTES_BUFFER_NUMBER = vim.api.nvim_get_current_buf()
	end
	print('open_notes_buffer finished')
end

vim.api.nvim_create_user_command('NotesStart', open_notes_buffer, {})

-- autocommand to close notes buffer if open on leaving vim
