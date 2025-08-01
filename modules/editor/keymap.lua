-- Locals
local border = "rounded"

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Helpers

--- Convenience wrapper around `vim.keymap.set`
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc string
local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
        noremap = true,
        silent = true,
        desc = desc,
    })
end

-- Modes
map("n", "<leader>z", [[:NvimTreeToggle<cr>]], "Distraction free")

require("which-key").add({ "<leader>d", group = "Diagnostics" })
map("n", "<leader>ds", function()
    vim.diagnostic.open_float({ border = border })
end, "Show")

require("which-key").add({ "<leader>f", group = "File" })
map("n", "<leader>fo", [[<cmd>Telescope find_files<cr>]], "Open")
map("n", "<leader>fO", [[<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>]], "Open (all)")
map("n", "<leader>fn", [[<cmd>echo 'not yet implemented'<cr>]], "New")
map("n", "<C-s>", [[:w<cr>]], "Save")
map("i", "<C-s>", [[<esc>:w<cr>gi]], "Save")
map("n", "<leader><leader>", [[:so %<CR>]], "Source")

require("which-key").add({ "<leader>b", group = "Buffer" })
map("n", "<leader>bf", vim.lsp.buf.format, "Format")
map("n", "<leader>bs", [[<cmd>Telescope buffers<cr>]], "Search")
map("n", "<leader>bd", [[:bd<cr>]], "Delete")

require("which-key").add({ "<leader>l", group = "LSP" })
map("n", "<leader>ld", [[<cmd>Telescope lsp_definitions<cr>]], "Definition(s)")
map("n", "<leader>lt", [[<cmd>Telescope lsp_type_definitions<cr>]], "Type Definition(s)")
map("n", "<leader>li", [[<cmd>Telescope lsp_implementations<cr>]], "Implementation")
map("n", "<leader>ln", vim.lsp.buf.rename, "Rename")
map("n", "<leader>lr", [[<cmd>Telescope lsp_references<cr>]], "References")
map("n", "K", function()
    local base_win_id = vim.api.nvim_get_current_win()
    local windows = vim.api.nvim_tabpage_list_wins(0)
    for _, win_id in ipairs(windows) do
        if win_id ~= base_win_id then
            local win_cfg = vim.api.nvim_win_get_config(win_id)
            if win_cfg.relative == "win" and win_cfg.win == base_win_id then
                vim.api.nvim_win_close(win_id, {})
                return
            end
        end
    end
    vim.lsp.buf.hover({ border = border })
end, "Toggle LSP Hover")
map("n", "<m-k>", vim.lsp.buf.signature_help, "LSP Hover Signature")

require("which-key").add({ "<leader>g", group = "Git" })
map("n", "<leader>gs", require("telescope.builtin").git_status, "Status")
map("n", "<leader>gb", require("telescope.builtin").git_branches, "Branch")
map("n", "<leader>gh", require("telescope.builtin").git_stash, "Stash")
map("n", "<leader>gl", require("telescope.builtin").git_commits, "Log")
map("n", "<leader>gp", [[:Git pull<cr>]], "Pull")
map("n", "<leader>gP", [[:Git push<cr>]], "Push")

require("which-key").add({ "<leader>h", group = "Hunk" })
map("n", "<leader>hs", require("gitsigns").stage_hunk, "Stage")
map("n", "<leader>hr", require("gitsigns").reset_hunk, "Reset")
map("v", "<leader>hs", function()
    require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, "Stage")
map("v", "<leader>hr", function()
    require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, "Reset")
map("n", "<leader>hS", require("gitsigns").stage_buffer, "Stage buffer")
map("n", "<leader>hR", require("gitsigns").reset_buffer, "Reset buffer")
map("n", "<leader>hp", require("gitsigns").preview_hunk, "Preview")
map("n", "<leader>hd", require("gitsigns").diffthis, "Diff")
map("n", "]c", function()
    if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
    else
        require("gitsigns").nav_hunk("next")
    end
end, "Next change")
map("n", "[c", function()
    if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
    else
        require("gitsigns").nav_hunk("prev")
    end
end, "Next change")

require("which-key").add({ "<leader>t", group = "Text" })
map("n", "<leader>ts", require("telescope.builtin").live_grep, "Search")
map("n", "<leader>tr", function()
    require("grug-far").open({
        transient = true,
        prefills = {
            search = vim.fn.expand("<cword>"),
        },
    })
end, "Replace")

-- Single-key mappings
map("n", "<leader>?", require("telescope.builtin").help_tags, "Help")
map("n", "<leader>q", [[:wqa<cr>]], "Help")

-- Window movement
map("n", "<c-h>", [[<c-w>h]], "Focus left")
map("n", "<c-j>", [[<c-w>j]], "Focus down")
map("n", "<c-k>", [[<c-w>k]], "Focus up")
map("n", "<c-l>", [[<c-w>l]], "Focus right")

-- Window resize
map("n", "<c-up>", [[<cmd>resize -2<cr>]], "")
map("n", "<c-down>", [[<cmd>resize +2<cr>]], "")
map("n", "<c-left>", [[<cmd>vertical resize -2<cr>]], "")
map("n", "<c-right>", [[<cmd>vertical resize +2<cr>]], "")

-- Buffer manipulation
map("n", "<tab>", [[:bn<cr>]], "Next buffer")
map("n", "<s-tab>", [[:bp<cr>]], "Previous buffer")

-- Text Manipulation
map("v", "J", [[:m '>+1<CR>gv=gv]], "Swap ↓")
map("v", "K", [[:m '<-2<CR>gv=gv]], "Swap ↑")
map("n", "J", [[mzJ`z]], "Join")
map("v", "<leader>d", [["_d]], "Delete")
map("x", "<leader>p", [["_dP]], "Paste")

-- Overwrite defaults
map("n", "<C-d>", [[<C-d>zz]], "Scroll down")
map("n", "<C-u>", [[<C-u>zz]], "Scroll up")
map("n", "n", [[nzzzv]], "Next")
map("n", "N", [[Nzzzv]], "Prev")
map("v", ">", [[>gv]], "Indent")
map("v", "<", [[<gv]], "Dedent")
vim.keymap.del("x", "Q")
