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
require('tokyonight').setup({
  style = 'night',

  on_colors = function(colors)
    -- Editor-Hintergrund
    colors.bg = '#171717'

    -- Dunklere Hintergrundflächen
    colors.bg_dark = '#202020'
    colors.bg_dark1 = '#141414'

    -- Popups, Floats und Statusleiste
    colors.bg_float = '#202020'
    colors.bg_popup = '#202020'
    colors.bg_sidebar = '#202020'
    colors.bg_statusline = '#202020'

    -- Dezente, neutrale Rahmen
    colors.border = '#303030'
    colors.border_highlight = '#454545'

    -- Dezente Hervorhebungsfläche
    colors.bg_highlight = '#282828'
  end,
})

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

-- Nur im aktuellen Buffer suchen
vim.keymap.set('n', '<leader>sl', function()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local items = {}

  for lnum, line in ipairs(lines) do
    table.insert(items, {
      bufnr = buf,
      lnum = lnum,
      text = string.format('%4d: %s', lnum, line),
    })
  end

  MiniPick.start({
    source = {
      name = 'Current buffer lines',
      items = items,
    },
  })
end, { desc = 'Search current buffer' })

-- Nur offene Buffer durchsuchen
vim.keymap.set('n', '<leader>so', function()
  MiniPick.builtin.buffers()
end, { desc = 'Open buffers' })



-- ==== TREESITTER CORE UND PLUGIN ====
-- nvim-treesitter: treesitter parser und queries installieren
require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}
-- C und lua sind schon in core dabei
require('nvim-treesitter').install{'cpp','haskell','python'}


-- ==== LSP ====
vim.filetype.add({
  extension = {
    tpp = 'cpp',
    hpp = 'cpp',
  },
})

vim.lsp.enable({'clangd', 'pyright'})

-- LSP keymaps
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
      buffer = ev.buf,
      desc = 'LSP: Go to definition',
    })

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
      buffer = ev.buf,
      desc = 'LSP: Go to declaration',
    })

    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, {
      buffer = ev.buf,
      desc = 'LSP: Go to type definition',
    })

    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {
      buffer = ev.buf,
      desc = 'LSP: Go to implementation',
    })

    vim.keymap.set('n', 'gr', vim.lsp.buf.references, {
      buffer = ev.buf,
      desc = 'LSP: Find references',
    })
  end,
})
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
-- FIX: weil kmonad einen ganz kurzen esc hold->release mit der CAPS-Makro schickt
vim.o.ttimeout = true
vim.o.ttimeoutlen = 0 --MUSS weniger als der "around" in kmonad sein

-- basic optionen für vanilla nvim
require('options') -- lua/options.lua
