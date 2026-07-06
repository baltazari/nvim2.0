-- Go. Binary installed by Mason (gopls).
return {
  settings = {
    gopls = {
      gofumpt = true,                    -- stricter formatting
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
}
