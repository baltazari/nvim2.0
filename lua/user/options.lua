-- General editor options.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = false
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.signcolumn = "number"
opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.updatetime = 250
opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.showmode = false
-- Needed for the built-in completion menu to behave nicely (Neovim 0.12).
opt.completeopt = "menu,menuone,noselect,popup"
