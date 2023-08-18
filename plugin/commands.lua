-- On NotesStart we need to:
--   - open a new notes buffer if one isn't already open
--   - switch focus to the notes buffer
vim.api.nvim_create_user_command('NotesStart', function() vim.cmd('vsplit .notes') end, {})

vim.api.nvim_create_autocmd('VimLeavePre', {pattern = '.notes', command = '!rm .notes'})

