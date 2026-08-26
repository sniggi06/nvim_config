-- packages
vim.pack.add({
 { src = 'https://github.com/echasnovski/mini.pick' },
})

vim.g.mapleader = " "

-- mini.pick : fuzzy finder
local pick = require('mini.pick').setup()


vim.keymap.set('n', '<leader><leader>', function()
  MiniPick.builtin.files()
end)

vim.keymap.set('n', '<leader>sh', function()
  MiniPick.builtin.help()
end)


vim.keymap.set('n', '<leader>sv', ":Pick files tool='git'<CR>", {
  desc = 'Git files',
})

vim.keymap.set('n', '<leader>sg', ':Pick grep_live<CR>', {
  desc = 'Live grep',
})

require('options') -- lua/options.lua
