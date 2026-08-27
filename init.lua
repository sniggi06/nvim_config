vim.g.mapleader = " "

-- packages
-- guter Guide: https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack.html
vim.pack.add({
 { src = 'https://github.com/echasnovski/mini.pick' },

 { src = 'https://github.com/nvim-treesitter/nvim-treesitter',
   checkout = 'main',
 },

 { src = 'https://github.com/folke/tokyonight.nvim'},

 { src = 'https://github.com/neovim/nvim-lspconfig' },
})

-- ==== AUSSEHEN ====
-- colorscheme
vim.cmd.colorscheme('tokyonight-night')

-- ==== FUZZY FINDER ====
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

-- ==== TREESITTER CORE UND PLUGIN ====
-- nvim-treesitter: treesitter parser und queries installieren
require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}
-- C und lua sind schon in core dabei
require('nvim-treesitter').install{'cpp','haskell','python'}


-- ==== LSP ====
vim.lsp.enable({'clangd', 'pyright'})
-- pyright ist mit npm installiert

vim.diagnostic.config({
  virtual_text = true,
})

-- ==== BASICS ====
-- basic optionen für vanilla nvim
require('options') -- lua/options.lua
