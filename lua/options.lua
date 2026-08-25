-- tab und indentation
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.wrap = false
vim.o.smartindent = true

-- split view 
vim.o.splitbelow = true
vim.o.splitright = true

-- case sensitivity der suche
vim.opt.ignorecase = true --suche nur mit kleinbuchstaben ist case-agnostic
vim.opt.smartcase = true --sobald ein Großbuchstabe dabei: case-sensitive

-- aus dem terminal mit 2xESC raus kommen
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })


--- VISUAL GUIDES ----

-- line numbers und sign collumn
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

-- cursor kram
vim.o.scrolloff = 10
vim.o.cursorline = true 

-- substitution live preview
vim.o.inccommand = 'split'

-- search-highlighting geht weg, nachdem man ESC drückt
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- highlight bei yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Hightlight when yanking text",
    callback = function()
        vim.hl.on_yank()
    end,
})

-- zeigt whitespace character an
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
