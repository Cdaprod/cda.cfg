" ---- Core Settings ----
set nocompatible
set mouse=a
set termguicolors
set number relativenumber          " Show line numbers relative to the current line
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set expandtab
set smartindent
set tabstop=4
set softtabstop=4
set cmdheight=2
set updatetime=50
set signcolumn=yes
set clipboard=unnamed,unnamedplus
set shortmess+=I                  " Skip intro screen

" Highlight Yank
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

" Map leader key to spacebar
let mapleader = " "

" iPhone Specific Keybindings
" Map Ctrl + x to save and quit (write and quit)
nnoremap <C-x> :wq<CR>
" Map Ctrl + c to quit without saving (force quit)
nnoremap <C-c> :q!<CR>

" ---- Disable Unnecessary Providers ----
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

" ---- Plugin Management with vim-plug ----
call plug#begin('~/.config/nvim/plugged')

" ---- Plugins List ----
Plug 'nvim-lualine/lualine.nvim'                " Lualine status line
Plug 'tpope/vim-sensible'                       " Sensible defaults
Plug 'sainnhe/edge'                             " Color schemes
Plug 'neovim/nvim-lspconfig'                    " LSP
Plug 'SirVer/ultisnips'                         " Code snippets
Plug 'honza/vim-snippets'                       " Code snippets
Plug 'nvim-lua/popup.nvim'                      " Fuzzy finder dependencies
Plug 'nvim-lua/plenary.nvim'                    " Fuzzy finder dependencies
Plug 'nvim-telescope/telescope.nvim'            " Fuzzy finder
Plug 'nvim-telescope/telescope-dap.nvim'        " Debugging integration
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Syntax highlighting
Plug 'nvim-treesitter/playground'               " Syntax playground
Plug 'kyazdani42/nvim-web-devicons'             " File explorer icons
Plug 'kyazdani42/nvim-tree.lua'                 " File explorer
Plug 'mfussenegger/nvim-dap'                    " Debugging
Plug 'mfussenegger/nvim-dap-python'             " Python debugging
Plug 'pwntester/octo.nvim'                      " GitHub integration
Plug 'zbirenbaum/copilot.lua'                   " GitHub Copilot
Plug 'hrsh7th/nvim-cmp'                         " Nvim CMP (Completions)
Plug 'hrsh7th/cmp-nvim-lsp'                     " LSP completions
Plug 'hrsh7th/cmp-buffer'                       " Buffer completions
Plug 'hrsh7th/cmp-path'                         " Path completions
Plug 'hrsh7th/cmp-cmdline'                      " Cmdline completions
Plug 'L3MON4D3/LuaSnip'                         " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip'                 " LuaSnip completions
Plug 'zbirenbaum/copilot-cmp'                   " Copilot completion
Plug 'janoamaral/tokyo-night-tmux'              " Tokyo Night TMUX theme
Plug 'akinsho/toggleterm.nvim'                  " Toggle Term
Plug 'rcarriga/nvim-dap-ui'                     " DAP UI
Plug 'nvim-neotest/nvim-nio'                    " Required by nvim-dap-ui
Plug 'tmux-plugins/tpm'                         " Tmux Plugin Manager
Plug 'tmux-plugins/tmux-sensible'               " Tmux sensible defaults
Plug 'tmux-plugins/tmux-resurrect'              " Tmux resurrect
Plug 'tmux-plugins/tmux-sessionist'             " Tmux session management
Plug 'junegunn/fzf.vim'                         " Fzf integration for Vim

call plug#end()

" Automatically install missing plugins on startup
augroup auto_install_plugins
  autocmd!
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) | PlugInstall --sync | q | endif
augroup END

" ---- Plugin Configuration ----

" Lualine Configuration
lua << EOF
require('lualine').setup {
  options = {
    theme = 'tokyo-night',  -- Use Tokyo Night theme for Lualine
    section_separators = {'', ''},
    component_separators = {'', ''}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
}
EOF

" Treesitter Configuration
lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
  }
}
EOF

" Copilot and CMP Configuration
lua << EOF
-- Copilot Configuration
require("copilot").setup({
  suggestion = { enabled = true },
  panel = { enabled = true },
})

-- Copilot CMP Configuration
require("copilot_cmp").setup()

-- Nvim CMP Configuration
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'copilot' },    -- Copilot as a completion source
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Additional CMP Source Configuration (Optional)
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})

-- Cmdline completions
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
EOF

" Normal mode keybinding for Copilot panel and status
nnoremap <leader>cp :Copilot panel<CR>
nnoremap <leader>cs :Copilot status<CR>

" Insert mode keybinding to accept Copilot suggestions
inoremap <C-Space> <C-R>=copilot#Accept("<CR>")<CR>
inoremap <C-\> <C-R>=copilot#Accept("<Tab>")<CR>

" LSP Configuration
lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

  if client.server_capabilities.documentFormattingProvider then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
  end

  if client.server_capabilities.documentHighlightProvider then
    vim.cmd [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end
end

local servers = {'pyright', 'gopls', 'rust_analyzer'}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
  }
end
EOF

" ---- nvim-tree Configuration ----
lua << EOF
require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  auto_close          = true,
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable  = true,
    update_cwd = true,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  view = {
    width = 30,
    side = 'left',
    auto_resize = true,
    mappings = {
      custom_only = false,
      list = {}
    }
  }
}
EOF

" ---- Custom Keybindings ----

" General key mappings
nnoremap <Space>v :e ~/.config/nvim/init.vim<CR>

" Leader Keybindings (Normal mode)
nnoremap <leader>ff :Telescope find_files<CR>          " Find files
nnoremap <leader>fb :Telescope buffers<CR>             " List buffers
nnoremap <leader>gs :Git status<CR>                    " Git status (using fugitive)
nnoremap <leader>gd :Git diff<CR>                      " Git diff (using fugitive)
nnoremap <leader>tt :NvimTreeToggle<CR>                " Toggle file explorer
nnoremap <leader>e :lua vim.diagnostic.open_float()<CR> " Show diagnostics
nnoremap <leader>f :lua vim.lsp.buf.format({ async = true })<CR>   " Format code
nnoremap <leader>dr :lua require'dap'.repl.open()<CR>  " Open DAP repl

" Control Keybindings (All modes)
nnoremap <C-x> :wq<CR>                                 " Save and quit in Normal mode
inoremap <C-x> <Esc>:wq<CR>                            " Save and quit in Insert mode
vnoremap <C-x> <Esc>:wq<CR>                            " Save and quit in Visual mode
snoremap <C-x> <Esc>:wq<CR>                            " Save and quit in Select mode
xnoremap <C-x> <Esc>:wq<CR>                            " Save and quit in Visual mode
onoremap <C-x> <Esc>:wq<CR>                            " Save and quit in Operator mode

nnoremap <C-c> :q!<CR>                                 " Force quit without saving in Normal mode
inoremap <C-c> <Esc>:q!<CR>                            " Force quit without saving in Insert mode
vnoremap <C-c> <Esc>:q!<CR>                            " Force quit without saving in Visual mode
snoremap <C-c> <Esc>:q!<CR>                            " Force quit without saving in Select mode
xnoremap <C-c> <Esc>:q!<CR>                            " Force quit without saving in Visual mode
onoremap <C-c> <Esc>:q!<CR>                            " Force quit without saving in Operator mode

" Wnnoremap <silent> <F5> :lua require'dap'.continue()<CR>
nnoremap <silent> <leader>dd :lua require('dap').continue()<CR>
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dl :lua require'dap'.repl.run_last()<CR>
nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR>
vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>

" Clean startup no message windows
augroup clean_startup
  autocmd!
  autocmd VimEnter * silent! redraw!
augroup END

let $PATH .= ':/usr/bin'          " Corrected path appending

emap = tlua << EOF
-- Keybindings for DAP
vim.api.nvim_set_keymap('n', '<F5>', ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F11>', ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F12>', ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>B', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dr', ":lua require'dap'.repl.open()<CR>", { noremap = true, silent = true })
EOF
>>>>>>>+origin/rpi5-1/a
ind_docker_compose_dir()
    local current_dir = vim.fn.expand('%:p:h')  -- Get the directory of the current file

    -- Loop upwards until we find docker-compose.yaml or reach the" ShellFish Integration
if $LC_TERMINAL ==# 'ShellFish'
    set clipboard=unnamed,unnamedplus  " Use iOS clipboard
>>>>>>>-rpi5-1/aarch64

       " Function to search upward for docker-compose.yml 
lua << EOF
local function find_docker_compose_dir()
    local current_dir = vim.fn.expand('%:p:h')  -- Get the directory of the current file

dir = vim.fn.fnamemodify(current_dir, ':h')
        if parent_dir == current_dir then
            -- If we're at the root directory, stop searching
            break
        end
        current_dir = parent_dir
    end

    return nil  -- Return nil if no docker-compose.yaml was found
end

-- Custom command to run Docker Compose in the nearest directory with docker-compose.yaml
vim.api.nvim_create_user_command('DockerComposeUp', function()
    local docker_compose_dir = find_docker_compose_dir()

    if docker_compose_dir then
        vim.fn.jobstart('docker-compose up -d', {
            cwd = docker_compose_dir,  -- Run the command in the found directory
            on_exit = function(job_id, exit_code, event_type)
                print("Docker Compose exited with code: " .. exit_code)
            end,
            on_stdout = function(job_id, data, event_type)
                if data then
                    print("Docker Compose output: " .. table.concat(data, "\n"))
                end
            end,
            on_stderr = function(job_id, data, event_type)
                if data then
                    print("Docker Compose error: " .. table.concat(data, "\n"))
                end
            end,
        })
    else
        print("No docker-compose.yaml found in the current or parent directories.")
    end
end, {})

-- Optional: Key mapping for Docker Compose Up
vim.api.nvim_set_keymap('n', '<leader>du', ':DockerComposeUp<CR>', { noremap = true, silent = true })
EOF

" ---- Clean startup no message windows ----
augroup clean_startup
  autocmd!
  autocmd VimEnter * silent! redraw!
augroup END

let $PATH .= ':/usr/bin'          " Corrected path appending

" Enable TrueColor
if exists('$COLORTERM')
    if $COLORTERM ==# 'truecolor'
        set termguicolors
    endif
endif

" ShellFish Integration
if $LC_TERMINAL ==# 'ShellFish'
    set clipboard=unnamed,unnamedplus  " Use iOS clipboard

    " Ensure ShellFish can handle tmux properly
    if exists('$TMUX')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        " Enable mouse mode in tmux
        set mouse=a
    endif
endif

" ---- Open a terminal window on startup ----
augroup open_terminal
  autocmd!
  autocmd VimEnter * :terminal zsh
  autocmd TermOpen * startinsert
augroup END