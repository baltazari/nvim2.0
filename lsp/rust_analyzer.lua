-- Rust. Binary: rustup component add rust-analyzer
return {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
    },
  },
}
