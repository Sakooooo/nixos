local builtin = require('telescope.builtin')

vim.keymap.set('n', '<Space><Space>', builtin.find_files, {})
-- vim.keymap.set('n', '<Space><p>', builtin.oldfiles, {})
vim.keymap.set('n', '<Space>fg', builtin.live_grep, {})
vim.keymap.set('n', '<Space>fh', builtin.help_tags, {})
