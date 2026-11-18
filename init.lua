-- nvim-tree statt netrw als Datei-Explorer verwenden
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

-- packages
-- guter Guide: https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack.html
vim.pack.add({
 { src = 'https://github.com/echasnovski/mini.pick' }, -- fuzzy finder
 { src = 'https://github.com/nvim-mini/mini.extra' }, -- extra queries insb. document_symbols für mini.pick + anderer shit

 { src = 'https://github.com/nvim-treesitter/nvim-treesitter',
   checkout = 'main',
 },

 { src = 'https://github.com/nvim-tree/nvim-tree.lua' }, --file tree
 { src = 'https://github.com/nvim-tree/nvim-web-devicons' }, -- icons für file tree

 { src = 'https://github.com/folke/tokyonight.nvim'},

 { src = 'https://github.com/neovim/nvim-lspconfig' },
 {
   src = 'https://github.com/Saghen/blink.cmp',
   version = 'v1.10.2', --V1 version: V2 ist ein großer rewrite, der für nvim.12 aber bald sinn machen könnte
 },
 { src = 'https://github.com/lewis6991/gitsigns.nvim' }, -- an Zeilen sehen was dort bzgl. git los ist

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
require('nvim-treesitter').install{'cpp','haskell','python','java'}


-- ==== LSP ====
vim.filetype.add({
  extension = {
    tpp = 'cpp',
    hpp = 'cpp',
  },
})

-- clangd: AVR-Unterstützung für SPOS beim PSP
vim.lsp.config('clangd', {
  cmd = {
    'clangd',
    '--query-driver=/usr/bin/avr-gcc',
  },
})

-- java: jdtls (muss separat installiert werden, siehe unten)
local jdtls_home = vim.fn.expand('~/.local/share/jdtls')
local launcher = vim.fn.glob(jdtls_home .. '/plugins/org.eclipse.equinox.launcher_*.jar', 1, 1)
launcher = type(launcher) == 'table' and launcher[1] or launcher

-- jdtls muss auf java 21 laufen (java 25 bricht dessen gradle-toolkit ab:
-- "Unsupported class file major version 69")
local java21 = vim.fn.expand('~/.local/share/jdks/jdk-21.0.5+11/bin/java')

vim.lsp.config('jdtls', {
  cmd = {
    java21,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', launcher,
    '-configuration', jdtls_home .. '/config_linux',
    '-data', vim.fn.expand('~/.cache/jdtls-workspace'),
  },
  filetypes = { 'java' },
  root_markers = { 'pom.xml', 'build.gradle', 'settings.gradle', '.git' },
})

vim.lsp.enable({'clangd', 'pyright', 'jdtls'})

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


-- ==== nvim-tree dateibaum ====
require('nvim-tree').setup({
  view = {
    side = 'left',
    width = 34,
  },

  renderer = {
    group_empty = false,
  },

  filters = {
    dotfiles = false,
    git_ignored = true,
  },

  update_focused_file = {
    enable = true,
    update_root = false,
  },
})

vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', {
  desc = 'Toggle nvim-tree',
})

-- ==== GIT SIGNS ====
require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },

  current_line_blame = false,
})
-- Git blame für aktuelle Zeile
vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns blame_line<CR>', {
  desc = 'Git blame line',
})

-- Inline-Blame ein-/ausschalten
vim.keymap.set('n', '<leader>gB', '<cmd>Gitsigns blame<CR>', {
  desc = 'Git blame file',
})

-- Änderung des aktuellen Hunks anzeigen
vim.keymap.set('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<CR>', {
  desc = 'Preview Git hunk',
})

-- Diff zur Git-Version anzeigen
vim.keymap.set('n', '<leader>gd', '<cmd>Gitsigns diffthis<CR>', {
  desc = 'Git diff',
})

-- ==== BASICS ====
-- FIX: weil kmonad einen ganz kurzen esc hold->release mit der CAPS-Makro schickt
vim.o.ttimeout = true
vim.o.ttimeoutlen = 0 --MUSS weniger als der "around" in kmonad sein

-- Splits resizen
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<CR>')
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<CR>')
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<CR>')

-- basic optionen für vanilla nvim
require('options') -- lua/options.lua

-- custom keybinds
require('custom.keybinds') -- lua/custom/keybinds.lua
