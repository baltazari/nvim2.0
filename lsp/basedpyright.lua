-- Python. Binary: pipx install basedpyright
return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
        autoImportCompletions = true,
      },
    },
  },
}
