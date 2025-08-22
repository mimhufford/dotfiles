-------------------------
-- Bootstrap lazy.nvim --
-------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)


-------------------------
--  Configure options  --
-------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.cmd.colorscheme "unokai"

vim.opt.number = true         -- show line numbers
vim.opt.cursorline = true     -- highlight the current line
vim.opt.ignorecase = true     -- ignore case while searching
vim.opt.smartcase = true      -- except if caps are used
vim.opt.tabstop = 4           -- 4 spaces per tab
vim.opt.shiftwidth = 4        -- 4 spaces per indentation level
vim.opt.expandtab = true      -- use spaces instead of tabs
vim.opt.softtabstop = 4       -- 4 spaces per tab

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>")  -- hide search highlights when pressing esc
vim.keymap.set("n", "n",     "nzz")                       -- center the results when cycling through
vim.keymap.set("n", "N",     "Nzz")                       -- center the results when cycling through
vim.keymap.set("n", "gd",    "gdzz")                      -- center when jumping to definition

vim.keymap.set("n", "<A-j>", ":m +1<CR>==")               -- move the current line down and auto indent
vim.keymap.set("n", "<A-k>", ":m -2<CR>==")               -- move the current line up and auto indent
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")          -- move the current block down and auto indent
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")          -- move the current block up and auto indent

vim.keymap.set("i", "<C-H>",   "<C-w>")                   -- ctrl-basckspace to delete by word in insert mode
vim.keymap.set("i", "<C-Del>", "<C-o>dw")                 -- ctrl-delete to delete by word in insert mode

vim.api.nvim_create_autocmd("FocusLost", { pattern = "*", command = "wa" })  -- save all buffers when focus is lost


------------------------------------------
--  Compile and run for current project --
------------------------------------------
vim.opt.makeprg = "~/jai/bin/jai-linux game.jai +Autorun"
vim.opt.errorformat = "%f:%l\\,%c: Error: %m"
vim.keymap.set("n", "<leader><leader>", "<cmd>wa<CR><cmd>make<CR>")


-------------------------------------------
--  Quick crappy custom comment toggler  --
-------------------------------------------
local function toggle_comment()
  local line = vim.api.nvim_get_current_line()
  local indent, content = line:match("^(%s*)(.*)$")

  if content:find("^//") then
    content = content:gsub("^//%s?", "", 1)
  else
    content = "// " .. content
  end

  vim.api.nvim_set_current_line(indent .. content)
end

vim.keymap.set("n", "<C-_>", toggle_comment, { noremap = true, silent = true })


-------------------------
--   Setup lazy.nvim   --
-------------------------
require("lazy").setup({
    spec = {
        { "rluba/jai.vim" },
        {
            "NeogitOrg/neogit", requires = { "nvim-lua/plenary.nvim" },
            config = function()
                vim.keymap.set("n", "<leader>g", "<cmd>wa<CR><cmd>Neogit<CR>")
            end
        },
        { "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false, build = ":TSUpdate" },
        {
            "nvim-telescope/telescope.nvim", tag = "0.1.8", requires = { "nvim-lua/plenary.nvim" },
            config = function()
                local telescope = require("telescope.builtin")
                vim.keymap.set("n", "<leader>f", telescope.find_files)
                vim.keymap.set("n", "<leader>s", telescope.live_grep)
            end
        },
    },
    install = { colorscheme = { "unokai" } },    -- colorscheme when installing plugins
    checker = { enabled = true },                -- automatically check for plugin updates
})
