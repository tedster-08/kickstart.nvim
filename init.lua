vim.g.mapleader = ' '      -- [space] leader key
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

	{ 'tpope/vim-commentary' },
	{ 'norcalli/nvim-colorizer.lua' },
	{ 'windwp/nvim-autopairs',              opts = {} },
	{ 'junegunn/rainbow_parentheses.vim' },
	{ 'tridactyl/vim-tridactyl' },
	{ 'jose-elias-alvarez/buftabline.nvim', opts = {} },
	{ 'voldikss/vim-floaterm' },
	{ 'mhartington/formatter.nvim' },
	{ 'folke/which-key.nvim',               opts = {} },

	{
		'RRethy/nvim-base16',
		config = function()
			vim.cmd.colorscheme 'base16-ocean'
		end
	},
	{
		'lewis6991/gitsigns.nvim',
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

	{
		'nvim-lualine/lualine.nvim',
		opts = {
			options = {
				icons_enabled = false,
				theme = 'base16',
				component_separators = '|',
				section_separators = '',
			},
		},
	},

	{
		'lukas-reineke/indent-blankline.nvim',
		main = "ibl",
		opts = {},
	},
	{
		'nvim-telescope/telescope.nvim',
		version = '*',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		config = function()
			pcall(require('nvim-treesitter.install').update { with_sync = true })
		end,
	},

	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			{ 'j-hui/fidget.nvim', opts = {} },

			'folke/neodev.nvim',
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		}
	}
})

-- Plugin Setups --
require("ibl").setup {
	indent = {
		char = '╏'
	}
}
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
vim.o.tabstop = 4
vim.api.nvim_set_hl(0, "CursorLineNr", { foreground = "#ebcb8b", bold = true })


-- Keymaps --
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<leader>/', ':Commentary<enter>')
vim.keymap.set('v', '<leader>/', ':Commentary<enter>')

vim.keymap.set('n', '<leader>cc', ':FloatermNew cht.sh --shell<enter>')

--  Highlight on yank --
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

-- Treesitter Config --

require('nvim-treesitter.configs').setup {

	modules = {},
	sync_install = false,
	ignore_install = {},


	ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vim', 'ruby' },
	auto_install = false,

	highlight = { enable = true },
	indent = { enable = true, disable = { 'python' } },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = '<c-space>',
			node_incremental = '<c-space>',
			scope_incremental = '<c-s>',
			node_decremental = '<M-space>',
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['aa'] = '@parameter.outer',
				['ia'] = '@parameter.inner',
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']m'] = '@function.outer',
				[']]'] = '@class.outer',
			},
			goto_next_end = {
				[']M'] = '@function.outer',
				[']['] = '@class.outer',
			},
			goto_previous_start = {
				['[m'] = '@function.outer',
				['[['] = '@class.outer',
			},
			goto_previous_end = {
				['[M'] = '@function.outer',
				['[]'] = '@class.outer',
			},
		},
		swap = {
			enable = true,
			swap_next = {
				['<leader>a'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>A'] = '@parameter.inner',
			},
		},
	},
}

-- LSP Config --

local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

local servers = {
	-- clangd = {},
	-- gopls = {},
	basedpyright = {},
	-- rust_analyzer = {},
	-- tsserver = {},

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- Setup neovim lua configuration
require('neodev').setup()

require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		}
	end,
}
