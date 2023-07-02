local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.backspace = "2"
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

-- spaces for tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

-- split position
vim.opt.splitbelow = true
vim.opt.splitright = true

-- :terminal shell
if (vim.loop.os_uname().sysname == "Linux")
then
  vim.opt.shell = "bash"
else 
  vim.opt.shell = "pwsh"
end

-- nvimtree
vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", opts)

-- splits
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>", opts)

-- resize split
vim.keymap.set("n", "<Left>", ":vertical resize +1<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize -1<CR>", opts)
vim.keymap.set("n", "<Up>", ":resize -1<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +1<CR>", opts)

-- make split
vim.keymap.set("n", "nsv", ":vsplit<CR>", opts)
vim.keymap.set("n", "nsh", ":split<CR>", opts)

-- terminal
vim.keymap.set("n", "<leader>t", ":split<CR> <BAR> :terminal<CR>")

-- exit terminal with esc
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", opts)
