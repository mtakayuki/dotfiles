return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Install parsers (idempotent — already installed parsers are skipped)
    local ensure = {
      "bash", "lua", "python", "json", "yaml", "toml",
      "markdown", "markdown_inline", "vim", "vimdoc",
    }
    for _, lang in ipairs(ensure) do
      pcall(function() vim.treesitter.language.add(lang) end)
    end

    -- Enable treesitter-based highlighting and indentation
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
