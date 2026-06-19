-- C and C++. Binary: sudo dnf install clang-tools-extra
return {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
}
