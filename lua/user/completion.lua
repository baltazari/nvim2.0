-- ~/.config/nvim/lua/user/completion.lua
-- VSCode-style autocompletion via blink.cmp (works on top of native LSP).
-- IMPORTANT: this file must be required BEFORE user.lsp in init.lua, because
-- it registers the completion capabilities the LSP servers advertise.

require("blink.cmp").setup({
  -- "super-tab": Tab accepts the highlighted item / jumps in snippets,
  -- arrows move up/down the menu. Closest feel to VSCode.
  keymap = { preset = "super-tab" },

  appearance = {
    -- Set to "mono" if your Nerd Font is the "Mono" variant, else "normal".
    nerd_font_variant = "mono",
  },

  completion = {
    -- Show the menu automatically as you type.
    menu = {
      auto_show = true,
      draw = { treesitter = { "lsp" } }, -- syntax-colored menu items
    },
    -- Documentation popup next to the menu.
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    -- Greyed-out inline preview of the top suggestion.
    ghost_text = { enabled = true },
  },

  -- Where suggestions come from, in priority order.
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  -- Completion in the ":" command line (and "/" search), same popup menu.
  cmdline = {
    enabled = true,
    keymap = { preset = "cmdline" }, -- Tab to show/select, Enter to run
    completion = {
      menu = { auto_show = true },   -- pop up automatically as you type ":"
      ghost_text = { enabled = true },
    },
  },

  -- Function signature hints while typing arguments.
  signature = { enabled = true },

  -- Pure-Lua matcher: no Rust build step needed. Switch to "prefer_rust"
  -- later if you want it faster (requires the Rust binary to build).
  fuzzy = { implementation = "lua" },
})

-- Advertise blink's extra capabilities to every LSP server.
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})
