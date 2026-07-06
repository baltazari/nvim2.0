-- Treesitter (nvim-treesitter "main" branch).
-- Requires the tree-sitter CLI + a C compiler on your system.
local ts = require("nvim-treesitter")
ts.setup()

-- Parser names. Note: C++ = "cpp", C# = "c_sharp".
local parsers = {
 "rust", "cpp", "c", "python", "c_sharp", "zig",
  "go", "gomod", "gosum",
  "lua", "vim", "vimdoc", "query", "markdown",
  }

-- Installs any missing parsers (runs in the background on first launch).
ts.install(parsers)

-- Start Treesitter highlighting for any buffer that has a parser.
-- pcall guards filetypes without an installed parser.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
