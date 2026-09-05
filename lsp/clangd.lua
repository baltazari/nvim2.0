-- C and C++. Binary: sudo dnf install clang-tools-extra
return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
  },

  init_options = {
    fallbackFlags = {
      "-std=c++20",
    },
  },
}
