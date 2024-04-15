vim.g.mapleader = ' ' -- [space] leader key
vim.g.maplocalleader = ' ' -- ^^^ 

-- Install package manager
--    https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	'tpope/vim-sleuth',

	{ 'RRethy/nvim-base16',
	  config = function()
	    vim.cmd.colorscheme 'base16-ocean'
	  end
	},
	{ 'folke/which-key.nvim', opts = {} },
	{ 'lewis6991/gitsigns.nvim',
	  opts = {
	    signs = {
	      add = { text = '+' },
	      change = { text = '~' },
	      delete = { text = '_' },
	      topdelete = { text = '‾' },
	      changedelete = { text = '~' },
	    },
	  },
	},

      { 'nvim-lualine/lualine.nvim',
	opts = {
	  options = {
	    icons_enabled = false,
	    theme = 'base16',
	    component_separators = '|',
	    section_separators = '',
	  },
	},
      },

})

vim.o.hlsearch = false
vim.wo.number = true
vim.wo.cursorline = true
vim.wo.cursorlineopt = "number"
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.o.hidden = true
vim.o.ruler = true
vim.o.cmdheight = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.formatoptions = "jql"
vim.o.showmode = false
vim.o.scrolloff = 8
