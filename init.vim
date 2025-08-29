" --- basics ---
set number
syntax on
set mouse=a
set clipboard=unnamedplus
set termguicolors

" Use space as <leader>, backslash as <localleader> (vimtex uses this)
let mapleader = " "
let maplocalleader = "\\"

" --- vimtex settings (macOS) ---
let g:vimtex_view_method = 'skim'
let g:vimtex_compiler_method = 'latexmk'
" optional: keep vimtex mappings on (default is 1)
let g:vimtex_mappings_enabled = 1

" --- plugins (single plug block!) ---
call plug#begin('~/.config/nvim/plugged')
  " theme & git
  Plug 'projekt0n/github-nvim-theme'
  Plug 'tpope/vim-fugitive'

  " LaTeX
  Plug 'lervag/vimtex'

  " Formatter
  Plug 'stevearc/conform.nvim'   " <--- added: Conform.nvim for formatting

  " Telescope + deps
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " optional speed-up

  " Start screen
  Plug 'goolord/alpha-nvim'
  Plug 'nvim-tree/nvim-web-devicons' " optional, for icons (use a Nerd Font)

  " Terminals inside Neovim
  Plug 'akinsho/toggleterm.nvim', { 'tag': '*' }
call plug#end()

" --- Spellcheck ---

" Enable spell check for writing filetypes
augroup SpellForWriting
  autocmd!
  autocmd FileType markdown,tex,text setlocal spell spelllang=en_us
augroup END

" Easy toggle in any buffer
nnoremap <silent> <leader>ss :setlocal spell! spell?<CR>

" --- Telescope setup & keymaps ---
lua << EOF
require('telescope').setup({})
pcall(require('telescope').load_extension, 'fzf')  -- loads if built
EOF

nnoremap <silent> <leader>ff <cmd>Telescope find_files<CR>
nnoremap <silent> <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <silent> <leader>fb <cmd>Telescope buffers<CR>
nnoremap <silent> <leader>fh <cmd>Telescope help_tags<CR>
nnoremap <silent> <leader>fr <cmd>Telescope oldfiles<CR>
nnoremap <silent> <leader>fR <cmd>Telescope oldfiles cwd_only=true<CR>

" --- Alpha keymap (open dashboard any time) ---
nnoremap <silent> <leader>fa :Alpha<CR>

" --- toggleterm setup & keymaps ---
lua << EOF
require('toggleterm').setup({
  size = 12,
  open_mapping = [[<c-\>]],        -- Ctrl+\ toggles last terminal
  start_in_insert = true,
  shade_terminals = true,
  persist_mode = false,            -- always enter insert in terminal
  direction = 'float',             -- default to a floating terminal
  float_opts = { border = 'curved' }
})
EOF

" Quick terminal toggles
nnoremap <silent> <leader>tt :ToggleTerm<CR>
nnoremap <silent> <leader>tf :ToggleTerm direction=float<CR>
nnoremap <silent> <leader>th :ToggleTerm direction=horizontal size=12<CR>
nnoremap <silent> <leader>tv :ToggleTerm direction=vertical size=60<CR>

" Better terminal-mode navigation (Esc to Normal; move between windows)
tnoremap <Esc>   <C-\><C-n>
tnoremap <C-h>   <C-\><C-n><C-w>h
tnoremap <C-j>   <C-\><C-n><C-w>j
tnoremap <C-k>   <C-\><C-n><C-w>k
tnoremap <C-l>   <C-\><C-n><C-w>l

" --- Conform.nvim setup (LaTeX formatting via latexindent) ---
lua << EOF
local ok, conform = pcall(require, 'conform')
if not ok then
  vim.notify('Conform.nvim not found', vim.log.levels.WARN)
else
  conform.setup({
    formatters_by_ft = {
      tex = { 'latexindent' },
    },
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 2000,
    },
    formatters = {
      latexindent = {
        prepend_args = { '-m', '-l' }, -- keep comments; use .latexindent.yaml if present
        -- If latexindent is in a non-standard path, uncomment and set:
        -- command = '/usr/local/texlive/2025/bin/universal-darwin/latexindent',
      },
    },
  })

  -- Manual format keymap: <leader>lf (normal & visual)
  vim.keymap.set({ 'n', 'v' }, '<leader>lf', function()
    conform.format({ async = true, lsp_fallback = true })
  end, { desc = 'Format with Conform' })

  -- Warn once if latexindent isn't on PATH
  if vim.fn.executable('latexindent') ~= 1 then
    vim.defer_fn(function()
      vim.notify('latexindent not found on PATH. Install MacTeX or add it to PATH.', vim.log.levels.WARN)
    end, 800)
  end
end
EOF

" --- alpha-nvim setup ---
lua << EOF
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
	[[                                                                         ]],
	[[                               :                                         ]],
	[[ L.                     ,;    t#,                                        ]],
	[[ EW:        ,ft       f#i    ;##W.              t                        ]],
	[[ E##;       t#E     .E#t    :#L:WE              Ej            ..       : ]],
	[[ E###t      t#E    i#W,    .KG  ,#D  t      .DD.E#,          ,W,     .Et ]],
	[[ E#fE#f     t#E   L#D.     EE    ;#f EK:   ,WK. E#t         t##,    ,W#t ]],
	[[ E#t D#G    t#E :K#Wfff;  f#.     t#iE#t  i#D   E#t        L###,   j###t ]],
	[[ E#t  f#E.  t#E i##WLLLLt :#G     GK E#t j#f    E#t      .E#j##,  G#fE#t ]],
	[[ E#t   t#K: t#E  .E#L      ;#L   LW. E#tL#i     E#t     ;WW; ##,:K#i E#t ]],
	[[ E#t    ;#W,t#E    f#E:     t#f f#:  E#WW,      E#t    j#E.  ##f#W,  E#t ]],
	[[ E#t     :K#D#E     ,WW;     f#D#;   E#K:       E#t  .D#L    ###K:   E#t ]],
	[[ E#t      .E##E      .D#;     G#t    ED.        E#t :K#t     ##D.    E#t ]],
	[[ ..         G#E        tt      t     t          E#t ...      #G      ..  ]],
	[[             fE                                 ,;.          j           ]],
	[[              ,                                                          ]],
	[[                                                                         ]],
}

-- color the whole header via a highlight group
dashboard.section.header.opts.hl = "AlphaHeader"

dashboard.section.buttons.val = {
  dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
  dashboard.button("g", "  Live grep", ":Telescope live_grep<CR>"),
  dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("n", "  New file", ":enew<CR>"),
  dashboard.button("c", "  Config", ":edit $MYVIMRC<CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}

alpha.setup(dashboard.config)
EOF

" --- colorscheme ---
colorscheme github_dark_default

" --- alpha header color (#34abeb) ---
lua << EOF
vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#34abeb", bold = true })
EOF

augroup AlphaHeaderHL
  autocmd!
  autocmd ColorScheme * lua vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#34abeb", bold = true })
augroup END

