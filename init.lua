vim.g.mapleader = " "

-- packages
-- guter Guide: https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack.html
vim.pack.add({
 { src = 'https://github.com/echasnovski/mini.pick' }, -- fuzzy finder
 { src = 'https://github.com/nvim-mini/mini.extra' }, -- extra queries insb. document_symbols für mini.pick + anderer shit

 { src = 'https://github.com/nvim-treesitter/nvim-treesitter',
   checkout = 'main',
 },

 { src = 'https://github.com/folke/tokyonight.nvim'},

 { src = 'https://github.com/neovim/nvim-lspconfig' },
 {
   src = 'https://github.com/Saghen/blink.cmp',
   version = 'v1.10.2', --V1 version: V2 ist ein großer rewrite, der für nvim.12 aber bald sinn machen könnte
 },

})

-- ==== AUSSEHEN ====
-- colorscheme
vim.cmd.colorscheme('tokyonight-night')

-- ==== FUZZY FINDER ====
-- mini.pick : fuzzy finder
local pick = require('mini.pick').setup()
local pick = require('mini.extra').setup()

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

vim.keymap.set('n', '<leader>ss', ':Pick lsp scope="document_symbol"<cr>', {
  desc = 'Document symbols',
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

-- blink.cmp für autocompletion
require('blink.cmp').setup({
  keymap = {
    preset = 'super-tab',
  },
  completion = {
    documentation = { --zeigt doku automatisch nach einer Weile an
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
})
-- ==== BASICS ====
-- basic optionen für vanilla nvim
require('options') -- lua/options.lua
