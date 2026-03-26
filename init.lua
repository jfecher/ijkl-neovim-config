-- These options (everything until the "Bootstrap lazy.nvim" line) must be set before plugins load
vim.opt.termguicolors = true
-- Use space for leader
vim.g.mapleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n",   "ErrorMsg" },
            { out,                              "WarningMsg" },
            { "\nPress any key to continue...", "" },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------------------------------------
---------------------------------------- Plugins ----------------------------------------
-----------------------------------------------------------------------------------------
require("lazy").setup({
    -- Color Schemes
    "jfecher/vim-sunset-theme",
    "gruvbox-community/gruvbox",

    -- UI
    {
        "vim-airline/vim-airline",
        init = function()
            vim.g["airline#extensions#tabline#enabled"] = 1
            vim.g.airline_powerline_fonts = 1
            vim.g.airline_theme = "sunset"
        end,
    },
    "vim-airline/vim-airline-themes",
    "folke/which-key.nvim",
    { "norcalli/nvim-colorizer.lua", config = function() require("colorizer").setup() end },
    { "ray-x/lsp_signature.nvim",    config = true },
    { "Bekaboo/dropbar.nvim",        config = true },
    {
        "lewis6991/hover.nvim",
        config = function()
            require("hover").setup({
                providers = { 'hover.providers.lsp' },
                preview_opts = { border = "rounded" },
                title = true,
            })
            vim.keymap.set("n", "K", function()
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if vim.api.nvim_win_get_config(win).relative ~= "" then
                        vim.api.nvim_win_close(win, false)
                    end
                end
                require("hover").hover()
            end, { desc = "Hover" })
        end,
    },

    -- Navigation
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    preview = {
                        treesitter = true,
                        highlight = true,
                        filetype_hook = function(filepath, bufnr, _)
                            local ft = vim.filetype.match({ filename = filepath })
                            if ft then vim.bo[bufnr].filetype = ft end
                            return true
                        end,

                    },
                },
            })
            require("telescope").load_extension("fzf")
        end,
    },

    -- LSP & Language-specific
    {
        "Saghen/blink.cmp",
        version = "1.*",
        opts = {
            keymap = { ["<CR>"] = { "accept", "fallback" } },
        }
    },
    "neovim/nvim-lspconfig",
    "noir-lang/noir-nvim",
    "jfecher/ante.vim",
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                keys = {
                    i = "prev",
                    k = "next",
                }
            })
        end
    },

    -- Git
    {
        "tpope/vim-fugitive",
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "fugitive", "git" },
                callback = function(ev)
                    vim.keymap.set("n", "i", "k", { buffer = ev.buf, silent = true })
                    vim.keymap.set("n", "k", "j", { buffer = ev.buf, silent = true })
                    vim.keymap.set("n", "j", "h", { buffer = ev.buf, silent = true })
                end,
            })
        end,
    },
    { "lewis6991/gitsigns.nvim",         config = true },

    -- Other
    "romainl/vim-cool", -- Auto unhighlight search text when finished
    { "windwp/nvim-autopairs",               config = true },
    { "lukas-reineke/indent-blankline.nvim", config = function() require("ibl").setup() end },
})

vim.cmd.colorscheme("sunset")

-- Treesitter setup runs after all plugins are loaded
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    once = true,
    callback = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "rust", "noir", "markdown", "markdown_inline" },
            highlight = { enable = true },
        })
    end,
})

-- Load LSP config
require("lsp")
require("ui")

-----------------------------------------------------------------------------------------
------------------------------------ Keymaps (Heresy) -----------------------------------
-----------------------------------------------------------------------------------------
-- Use ijkl for movement
vim.keymap.set("n", "i", "k")
vim.keymap.set("n", "k", "j")
vim.keymap.set("n", "j", "h")

vim.keymap.set("v", "i", "k")
vim.keymap.set("v", "k", "j")
vim.keymap.set("v", "j", "h")

vim.keymap.set("n", "<C-w>j", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-w>i", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-w>J", "<C-w>H", { silent = true })

vim.keymap.set("n", "<C-w>I", "<C-w>J", { silent = true })
vim.keymap.set("n", "<C-w>j", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-w>i", "<C-w>j", { silent = true })

-- Bind C-movement keys to switch splits
vim.keymap.set("n", "<C-j>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-i>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

vim.keymap.set("i", "<C-j>", "<Esc><C-w>h", { silent = true })
vim.keymap.set("i", "<C-i>", "<Esc><C-w>k", { silent = true })
vim.keymap.set("i", "<C-k>", "<Esc><C-w>j", { silent = true })
vim.keymap.set("i", "<C-l>", "<Esc><C-w>l", { silent = true })

-- Use h for insertion
vim.keymap.set("n", "h", "i")

-- Use `;` for commands
vim.keymap.set("n", ";", ":")

-- Use `jj` to get out of insert mode
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("t", "jj", "<C-\\><C-n>")

-- Use `t` for :terminal (opens and enters insert mode)
vim.keymap.set("n", "t", ":terminal<CR>i", { silent = true })

-- Smart close
vim.keymap.set("n", "Q", function()
    local bt = vim.bo.buftype
    if bt == "nofile" or bt == "help" or bt == "quickfix" or bt == "prompt" then
        vim.cmd("close")
    elseif #vim.api.nvim_tabpage_list_wins(0) > 1 then
        vim.cmd("close")
    elseif #vim.api.nvim_list_tabpages() > 1 then
        vim.cmd("tabclose")
    else
        vim.cmd("bdelete")
    end
end, { desc = "Smart close", silent = true })

vim.keymap.set("n", "<Leader>a", ':echo "hey there"<CR>')

---------- Options ----------
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- No extra files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Ignore common paths & binary files
vim.opt.wildignore:append({ "*/.git/*", "*/.hg/*", "*/.svn/*", "*.so", "*.cbp", "*/target/*" })
vim.opt.wildignore:append({ "*.o", "*.ao", "*.d", "*.gch", "*.class", "*.obj", "*/build/*" })

-----------------------------------------------------------------------------------------
------------------------------------ Which-key config -----------------------------------
-----------------------------------------------------------------------------------------
local wk = require("which-key")
local telescope = require('telescope.builtin')

wk.setup({
    win = { height = { max = 20 } },
    layout = { width = { min = 20, max = 40 } },
})
wk.add({
    -- Telescope / Search
    { "<leader>f",  telescope.find_files,      desc = "Find files" },
    { "<C-p>",      telescope.find_files,      desc = "Find files" },
    { "<leader>/",  telescope.live_grep,       desc = "Live grep" },
    { "<leader>?",  telescope.keymaps,         desc = "Find keymaps" },

    -- Git (fugitive)
    { "<leader>g",  group = "git" },
    { "<leader>gs", "<cmd>Git<CR>",            desc = "Status" },
    { "<leader>gb", "<cmd>Git blame<CR>",      desc = "Blame" },
    { "<leader>gd", "<cmd>Gdiffsplit<CR>",     desc = "Diff split" },
    { "<leader>gl", "<cmd>Git log<CR>",        desc = "Log" },
    { "<leader>gc", "<cmd>Git commit<CR>",     desc = "Commit" },
    { "<leader>gp", "<cmd>Git push<CR>",       desc = "Push" },
    { "<leader>gP", "<cmd>Git pull<CR>",       desc = "Pull" },
    { "<leader>gw", "<cmd>Gwrite<CR>",         desc = "Stage file" },
    { "<leader>gr", "<cmd>Gread<CR>",          desc = "Restore file" },

    -- LSP
    { "gf",         vim.lsp.buf.format,           desc = "Format file" },
    { "ga",         vim.lsp.buf.code_action,      desc = "Code actions" },
    {
        "<C-a>",
        function()
            vim.cmd("stopinsert")
            vim.lsp.buf.code_action()
        end,
        mode = "i",
        desc = "Code actions"
    },
    { "[g",          function() vim.diagnostic.jump({ count = -1 }) end, desc = "Previous diagnostic" },
    { "]g",          function() vim.diagnostic.jump({ count = 1 }) end,  desc = "Next diagnostic" },
    { "gd",          vim.lsp.buf.definition,      desc = "Go to definition" },
    { "gr",          vim.lsp.buf.references,      desc = "References" },
    { "gn",          vim.lsp.buf.rename,          desc = "Rename symbol" },
    { "gi",          vim.lsp.buf.implementation,  desc = "Implementations" },
    { "gt",          vim.lsp.buf.type_definition, desc = "Type definition" },
    { "gs",          vim.lsp.buf.declaration,     desc = "Declaration" },

    -- Diagnostics (trouble.nvim)
    { "<leader>d",   group = "diagnostics" },
    { "<leader>dd",  "<cmd>Trouble diagnostics toggle<CR>",              desc = "Workspace diagnostics" },
    { "<leader>db",  "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
    { "<leader>ds",  "<cmd>Trouble symbols toggle<CR>",                  desc = "Document symbols" },
    { "<leader>dl",  "<cmd>Trouble lsp toggle win.position=right<CR>",   desc = "References" },
    { "<leader>dq",  "<cmd>Trouble qflist toggle<CR>",                   desc = "Quickfix list" },

    -- Git hunks (gitsigns)
    { "<leader>gh",  group = "hunks" },
    { "<leader>ghp", "<cmd>Gitsigns preview_hunk<CR>",                   desc = "Preview hunk" },
    { "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>",                     desc = "Stage hunk" },
    { "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>",                     desc = "Reset hunk" },
    { "<leader>ghb", "<cmd>Gitsigns blame_line<CR>",                     desc = "Blame line" },

    -- Buffers
    { "<Tab>",       "<cmd>bnext<CR>",   desc = "Next buffer" },
    { "<S-Tab>",     "<cmd>bprev<CR>",   desc = "Previous buffer" },

    -- Misc
    { "t",           desc = "Open terminal" },
    { "Q",           desc = "Smart close" },
})
