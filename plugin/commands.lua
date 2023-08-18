-- TODO: app a command Notes which opens an empty buffer (maybe with a set buffer number? or with a random buffer number we'll store? We'll need to interact with it specifically later)
vim.api.nvim_create_user_command('SayHelloJack', 'lua print(\'Hello Jack\')', {})
