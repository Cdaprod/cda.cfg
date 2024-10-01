" ---- Core Settings ----
set mouse=a
set nocompatible
set termguicolors
set number relativenumber          " Changed 'nu rnu' to 'number relativenumber' for clarity
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
set shortmess+=I          " Skip intro screen

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

" ---- Plugin Management with vim-plug ----
let vimplug_exists = expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(vimplug_exists)
  if !executable('curl')
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  silent execute "!curl -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall
endif

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
Plug 'rcarriga/nvim-dap-ui'                      " DAP UI - Added missing plugin
call plug#end()

" Automatically install missing plugins on startup
augroup auto_install_plugins
  autocmd!
  autocmd VimEnter *
        \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync | q
        \| endif
augroup END

" ---- Plugin Configuration ----

" Lualine Configuration
lua << EOF
require('lualine').setup {
  options = {
    theme = 'onedark',
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
    enable = true
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false
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

" ---- nvim-web-devicons and nvim-tree Configuration ----
lua << EOF
require'nvim-web-devicons'.setup {
	default = true; -- enables default icons for file types 
}

-- ---- nvim-tree Configuration ----
require'nvim-tree'.setup {
    renderer = {
        icons = {
            show = {
                git = true,
                folder = true,
                file = true,
                folder_arrow = true,
            },
            glyphs = {
                default = '',
                symlink = '',
                folder = {
                    arrow_open = '',
                    arrow_closed = '',
                    default = '',
                    open = '',
                    empty = '',
                    empty_open = '',
                    symlink = '',
                    symlink_open = '',
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
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

" Window Navigation and Resizing
nnoremap <C-h> <C-w>h                                  " Move to left split
nnoremap <C-j> <C-w>j                                  " Move to below split
nnoremap <C-k> <C-w>k                                  " Move to above split
nnoremap <C-l> <C-w>l                                  " Move to right split

" Completion and Other Actions (Insert mode)
inoremap <C-Space> <cmd>lua require'cmp'.complete()<CR> " Trigger completion

" Alt (Meta) Keybindings (Normal mode)
nnoremap <M-b> :lua require'dap'.toggle_breakpoint()<CR> " Toggle breakpoint
nnoremap <M-d> :lua require'dap.ui.widgets'.hover()<CR>  " Show debug hover
nnoremap <M-w> :q<CR>                                    " Close the current window
nnoremap <M-s> :split<CR>                                 " Split window horizontally

" Debugging configuration
nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
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

" ---- nvim-dap Setup for Multiple Languages ----
lua << EOF
local dap = require('dap')

-- JavaScript/TypeScript configuration
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv("HOME") .. '/.vscode-node-debug2/out/src/nodeDebug.js'},
}

dap.configurations.javascript = {
  {
    name = "Launch file",
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
  {
    name = "Attach to process",
    type = "node2",
    request = "attach",
    processId = require('dap.utils').pick_process,
  },
}

dap.configurations.typescript = dap.configurations.javascript

-- Go configuration
dap.adapters.go = {
  type = "server",
  port = "${port}",
  executable = {
    command = "dlv",
    args = { "dap", "-l", "127.0.0.1:${port}" },
  }
}

dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "go",
    name = "Attach",
    mode = "remote",
    request = "attach",
    processId = require('dap.utils').pick_process,
    program = "${file}",
  }
}

-- Python configuration
dap.adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return '/usr/bin/python'  -- Adjust this to your Python path
    end,
  },
}

-- React Native / Chrome debugging
dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = { os.getenv("HOME") .. "/path-to/vscode-chrome-debug/out/src/chromeDebug.js" }
}

dap.configurations.javascriptreact = { -- React
  {
    name = "Debug React",
    type = "chrome",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}"
  }
}

dap.configurations.typescriptreact = dap.configurations.javascriptreact

-- Optional: DAP UI for a better debugging experience
require("dapui").setup()

-- Optional: Virtual text for inline debugging
require("nvim-dap-virtual-text").setup()
EOF

" ---- nvim-dap Keybindings ----
lua << EOF
-- Keybindings for DAP
vim.api.nvim_set_keymap('n', '<F5>', ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F11>', ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F12>', ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>B', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dr', ":lua require'dap'.repl.open()<CR>", { noremap = true, silent = true })
EOF

" ---- ToggleTerm Configuration ----
lua << EOF
require('toggleterm').setup{
  open_mapping = '<C-\\>',
  direction = 'float',
  float_opts = { 
    border = 'curved',
  },
}
EOF

" Function to search upward for docker-compose.yml 
lua << EOF
local function find_docker_compose_dir()
    local current_dir = vim.fn.expand('%:p:h')  -- Get the directory of the current file

    -- Loop upwards until we find docker-compose.yaml or reach the root directory
    while current_dir and current_dir ~= '/' do
        local docker_compose_path = current_dir .. '/docker-compose.yaml'

        if vim.fn.filereadable(docker_compose_path) == 1 then
            return current_dir  -- Return the directory where docker-compose.yaml is found
        end

        -- Move up to the parent directory
        local parent_dir = vim.fn.fnamemodify(current_dir, ':h')
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

" Open a terminal window on startup
augroup open_terminal
  autocmd!
  autocmd VimEnter * :terminal zsh
  autocmd TermOpen * startinsert
augroup END
