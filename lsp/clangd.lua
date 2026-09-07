-- C and C++. Binary: sudo dnf install clang-tools-extra
return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--function-arg-placeholders",
  },

  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
  },

  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}
