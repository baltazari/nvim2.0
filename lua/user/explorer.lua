-- ~/.config/nvim/lua/user/explorer.lua
-- VSCode-style file explorer sidebar (neo-tree).
--   Ctrl-e        open the explorer and jump into it (from anywhere)
--   Shift-e (E)   close the explorer
--   Up/Down       move between entries
--   Right         expand a folder (or open a file)
--   Left          collapse a folder / step out to the parent folder
--   Enter         open the file / toggle the folder under the cursor

require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  filesystem = {
    follow_current_file = { enabled = true }, -- highlight the file you're editing
    use_libuv_file_watcher = true,            -- auto-refresh on disk changes
    hijack_netrw_behavior = "open_default",
    filtered_items = {
      visible = true,        -- still show hidden files, just dimmed
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
  default_component_configs = {
    indent = { with_markers = true, with_expanders = true },
  },
  window = {
    position = "left",
    width = 32,
    mappings = {
      -- Built-in commands: reliable, no Enter needed first.
      ["<Right>"] = "open",        -- expand folder / open file
      ["<Left>"] = "close_node",   -- collapse folder / go to parent
      ["<CR>"] = "open",
      ["E"] = "noop",              -- avoid clash with the Shift-e close key
    },
  },
})

-- Ctrl-e: open the explorer and move the cursor into it (works from the editor).
vim.keymap.set("n", "<C-e>", "<cmd>Neotree focus filesystem left<cr>",
  { desc = "Focus file explorer" })

-- Shift-e: close the explorer.
vim.keymap.set("n", "E", "<cmd>Neotree close<cr>",
  { desc = "Close file explorer" })
