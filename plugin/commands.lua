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
	if not is_notes_buffer_open() then
		vim.cmd('vnew')
		NOTES_BUFFER_NUMBER = vim.api.nvim_get_current_buf()
		vim.api.nvim_set_option_value('modifiable', 0, { buf = NOTES_BUFFER_NUMBER })
	end
end

vim.api.nvim_create_user_command('NotesStart', open_notes_buffer, {})

vim.api.nvim_create_autocmd('WinClosed', { callback = reset, buffer = NOTES_BUFFER_NUMBER })
