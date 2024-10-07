-- ========================================
--               init.lua
--         Converted from init.vim
-- ========================================

-- ================================
--         General Settings
-- ================================

-- Enable true color support
vim.opt.termguicolors = true

-- Enable mouse support
vim.opt.mouse = 'a'

-- Enable line numbers (relative and absolute)
vim.opt.number = true
vim.opt.relativenumber = true

-- Set complete options for better completion experience
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }

-- Short message settings to avoid unnecessary messages
vim.opt.shortmess:append('cI')  -- 'c' and 'I'

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Enable smart indentation
vim.opt.smartindent = true

-- Set tab and indentation width
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Set command-line height to avoid pressing 'Enter' too often
vim.opt.cmdheight = 2

-- Reduce delay for triggering plugins like CursorHold
vim.opt.updatetime = 50

-- Always show the sign column, to prevent shifting text
vim.opt.signcolumn = 'yes'

-- Use the system clipboard
vim.opt.clipboard = 'unnamed,unnamedplus'

-- ================================
--        Disable Providers
-- ================================
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- ================================
--          Plugin Manager
-- ================================

-- Automatically install packer.nvim if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path
    })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand to reload Neovim and sync plugins when init.lua is saved
vim.api.nvim_create_augroup('packer_user_config', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = 'packer_user_config',
  pattern = 'init.lua',
  command = 'source <afile> | PackerSync'
})

-- Initialize packer and list plugins
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- ================================
  --             Plugins
  -- ================================

  -- Status Line
  use 'nvim-lualine/lualine.nvim'                -- Lualine status line

  -- Sensible defaults
  use 'tpope/vim-sensible'                       -- Sensible defaults

  -- Color Schemes
  use 'sainnhe/edge'                             -- Edge color scheme
  use 'janoamaral/tokyo-night-tmux'              -- Tokyo Night TMUX theme

  -- LSP Configuration
  use 'neovim/nvim-lspconfig'                    -- LSP

  -- Snippets
  use 'SirVer/ultisnips'                         -- Code snippets engine
  use 'honza/vim-snippets'                       -- Collection of snippets

  -- Fuzzy Finder Dependencies
  use 'nvim-lua/popup.nvim'                      -- Popup API
  use 'nvim-lua/plenary.nvim'                    -- Lua functions

  -- Fuzzy Finder
  use 'nvim-telescope/telescope.nvim'            -- Fuzzy finder
  use 'nvim-telescope/telescope-dap.nvim'        -- DAP integration for Telescope

  -- Syntax Highlighting
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'} -- Treesitter
  use 'nvim-treesitter/playground'               -- Treesitter playground

  -- File Explorer Icons and Explorer
  use 'kyazdani42/nvim-web-devicons'             -- File explorer icons
  use 'kyazdani42/nvim-tree.lua'                 -- File explorer

  -- Debugging
  use 'mfussenegger/nvim-dap'                    -- DAP
  use 'mfussenegger/nvim-dap-python'             -- Python DAP

  -- GitHub Integration
  use 'pwntester/octo.nvim'                      -- GitHub integration

  -- GitHub Copilot
  use 'zbirenbaum/copilot.lua'                   -- GitHub Copilot
  use 'zbirenbaum/copilot-cmp'                   -- Copilot completion source for nvim-cmp

  -- Autocompletion
  use 'hrsh7th/nvim-cmp'                         -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'                     -- LSP completions
  use 'hrsh7th/cmp-buffer'                       -- Buffer completions
  use 'hrsh7th/cmp-path'                         -- Path completions
  use 'hrsh7th/cmp-cmdline'                      -- Cmdline completions
  use 'saadparwaiz1/cmp_luasnip'                 -- LuaSnip completions

  -- Snippet Engine
  use 'L3MON4D3/LuaSnip'                         -- Snippet engine

  -- Terminal Integration
  use 'akinsho/toggleterm.nvim'                  -- Toggle Term

  -- DAP UI and Virtual Text
  use 'rcarriga/nvim-dap-ui'                     -- DAP UI
  use 'theHamsta/nvim-dap-virtual-text'           -- DAP virtual text

  -- Tmux Integration
  use 'tmux-plugins/tpm'                         -- Tmux Plugin Manager
  use 'tmux-plugins/tmux-sensible'               -- Tmux sensible defaults
  use 'tmux-plugins/tmux-resurrect'              -- Tmux resurrect
  use 'tmux-plugins/tmux-sessionist'             -- Tmux session management

  -- Fzf Integration
  use 'junegunn/fzf.vim'                         -- Fzf integration for Vim

  -- Automatically install missing plugins on startup
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- ================================
--          Plugin Configurations
-- ================================

-- Nvim Web DevIcons
require'nvim-web-devicons'.setup()


-- Lualine Configuration
require('lualine').setup {
  options = {
    theme = 'tokyo-night',  -- Use Tokyo Night theme for Lualine
    section_separators = {'', ''},  -- These are powerline separators
    component_separators = {'', ''},  -- Alternative powerline separators
    icons_enabled = true,  -- Ensure icons are enabled
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

-- Treesitter Configuration
require('nvim-treesitter.configs').setup {
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
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
  }),
  sources = cmp.config.sources({
    { name = 'copilot' },    -- Copilot as a completion source
    { name = 'nvim_lsp' },
    { name = 'luasnip' },    -- Snippets source
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Fzf Integration Key Mappings
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', ':Telescope help_tags<CR>', { noremap = true, silent = true })

-- Nvim-tree Configuration
require('nvim-tree').setup {
  disable_netrw = true,
  hijack_netrw = true,
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
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
    enable = true,
    update_cwd = true,
    ignore_list = {}
  },
  system_open = {
    cmd = nil,
    args = {}
  },
  view = {
    width = 30,
    side = 'left',
  }
}

-- ================================
--          LSP Configuration
-- ================================

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

local servers = { 'pyright', 'gopls', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- ================================
--          DAP Configuration
-- ================================

local dap = require('dap')

-- Configure Python DAP
dap.adapters.python = {
  type = 'executable',
  command = '/usr/bin/python', -- Adjust this path if your Python is located elsewhere
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python', -- The type here established the link to the adapter definition
    request = 'launch',
    name = "Launch file",
    program = "${file}", -- This configuration will launch the current file if used.
    pythonPath = function()
      -- Use activated virtualenv
      local venv_path = os.getenv("VIRTUAL_ENV")
      if venv_path then
        return venv_path .. "/bin/python"
      else
        return '/usr/bin/python' -- Default Python path
      end
    end,
  },
}

-- Configure DAP UI
require("dapui").setup()

-- Configure DAP Virtual Text
require("nvim-dap-virtual-text").setup()

-- ================================
--          Key Mappings
-- ================================

-- General key mappings
local opts = { noremap=true, silent=true }

-- Map <Space>v to edit init.lua
vim.api.nvim_set_keymap('n', '<Space>v', ':e ~/.config/nvim/init.lua<CR>', opts)

-- Toggle NvimTree
vim.api.nvim_set_keymap('n', '<leader>tt', ':NvimTreeToggle<CR>', opts)

-- Toggle Terminal
vim.api.nvim_set_keymap('n', '<leader>t', ':ToggleTerm<CR>', opts)

-- Telescope Keybindings
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', ':Telescope help_tags<CR>', opts)

-- Git Keybindings using Fugitive
vim.api.nvim_set_keymap('n', '<leader>gs', ':Git status<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gd', ':Git diff<CR>', opts)

-- Diagnostic Keybindings
vim.api.nvim_set_keymap('n', '<leader>e', ':lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>f', ':lua vim.lsp.buf.format({ async = true })<CR>', opts)

-- DAP Keybindings
vim.api.nvim_set_keymap('n', '<leader>dd', ":lua require('dap').continue()<CR>", opts)
vim.api.nvim_set_keymap('n', '<F10>', ":lua require'dap'.step_over()<CR>", opts)
vim.api.nvim_set_keymap('n', '<F11>', ":lua require'dap'.step_into()<CR>", opts)
vim.api.nvim_set_keymap('n', '<F12>', ":lua require'dap'.step_out()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>B', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>lp', ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>dr', ":lua require'dap'.repl.open()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>dl', ":lua require'dap'.repl.run_last()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>dn', ":lua require('dap-python').test_method()<CR>", opts)
vim.api.nvim_set_keymap('v', '<leader>ds', '<ESC>:lua require(\'dap-python\').debug_selection()<CR>', opts)

-- ================================
--          Custom Functions
-- ================================

-- Function to find the nearest directory containing docker-compose.yaml
local function find_docker_compose_dir()
  local current_dir = vim.fn.expand('%:p:h')  -- Get the directory of the current file
  while true do
    local compose_file = vim.fn.glob(current_dir .. '/docker-compose.yaml')
    if compose_file ~= '' then
      return current_dir
    end

    local parent_dir = vim.fn.fnamemodify(current_dir, ':h')
    if parent_dir == current_dir then
      -- Reached root directory
      break
    end
    current_dir = parent_dir
  end
  return nil
end

-- Custom command to run Docker Compose up in the nearest directory with docker-compose.yaml
vim.api.nvim_create_user_command('DockerComposeUp', function()
  local docker_compose_dir = find_docker_compose_dir()

  if docker_compose_dir then
    vim.fn.jobstart('docker-compose up -d', {
      cwd = docker_compose_dir,
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

-- Alias the function to fmfl for quick access
vim.api.nvim_set_keymap('n', '<leader>du', ':DockerComposeUp<CR>', { noremap = true, silent = true })

-- ================================
--          Highlight Yank
-- ================================

local highlight_yank = vim.api.nvim_create_augroup('highlight_yank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_yank,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- ================================
--          PATH Modification
-- ================================

-- Append /usr/bin to PATH
vim.env.PATH = vim.env.PATH .. ':/usr/bin'

-- ================================
--          Clean Startup
-- ================================

local clean_startup = vim.api.nvim_create_augroup('clean_startup', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = clean_startup,
  command = 'silent! redraw!'
})

-- ================================
--          Aliases
-- ================================

-- Alias 'vim', 'vi', 'v' to 'nvim'
vim.cmd [[
  command! -nargs=* Vim execute 'nvim' <args>
  command! -nargs=* Vi execute 'nvim' <args>
  command! -nargs=* V execute 'nvim' <args>
]]

-- ================================
--          ShellFish Integration
-- ================================

if vim.env.LC_TERMINAL == 'ShellFish' then
  vim.opt.clipboard = 'unnamed,unnamedplus'  -- Use iOS clipboard

  if vim.env.TMUX then
    -- Set term codes for 24-bit colors
    vim.opt.t_8f = "\027[38;2;%lu;%lu;%lum"
    vim.opt.t_8b = "\027[48;2;%lu;%lu;%lum"
    -- Enable mouse mode in tmux
    vim.opt.mouse = 'a'
  end
end

-- ================================
--          Font Configuration
-- ================================

-- Source font scripts (if necessary)
vim.cmd('source ~/.fonts/*.sh')

-- ================================
--          Terminal Integration
-- ================================

-- Open a terminal window on startup
local open_terminal = vim.api.nvim_create_augroup('open_terminal', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = open_terminal,
  command = ':terminal zsh',
})
vim.api.nvim_create_autocmd('TermOpen', {
  group = open_terminal,
  command = 'startinsert',
})

-- ================================
--          ToggleTerm Setup
-- ================================

require("toggleterm").setup{
  size = 20,
  open_mapping = [[<c-\>]],
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = '1',
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = true,
}

-- ================================
--          DAP UI Setup
-- ================================

require("dapui").setup()

-- ================================
--          Additional Commands
-- ================================

-- Example: Git Fugitive command alias
vim.cmd [[
  command! Git execute 'Git'
]]

-- ================================
--          Custom Functions
-- ================================

-- Function to fetch multiple failed GitHub Actions logs
-- (Assuming this was part of your original configuration)
-- You can integrate similar functionality using Lua or keep it as a shell alias
-- Below is an example Lua function to execute shell commands and display output

function FetchMultipleFailedLogs(limit, log_lines)
  limit = limit or 3
  log_lines = log_lines or 20
  local cmd = string.format("fetch_multiple_failed_logs %d %d", limit, log_lines)
  vim.cmd("split | terminal " .. cmd)
end

-- Create a keybinding for the function
vim.api.nvim_set_keymap('n', '<leader>fl', ':lua FetchMultipleFailedLogs()<CR>', { noremap = true, silent = true })

-- ================================
--          Final Notes
-- ================================

-- After saving this `init.lua`, ensure you remove or rename your `init.vim` to prevent conflicts.
-- For example:
-- mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.backup

-- Restart Neovim to apply all changes.

