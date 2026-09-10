-- C and C++
-- Fedora package: sudo dnf install clang-tools-extra

return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--function-arg-placeholders",
    "--query-driver=/home/baltazar/.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-*",
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
