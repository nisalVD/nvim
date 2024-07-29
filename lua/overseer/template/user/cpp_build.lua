return {
  name = "cmake_build",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    return {
      cmd = { "cmake" },
      args = { "--build", "out\\build" },
      {
        "on_output_parse",
        parser = {
          -- Put the parser results into the 'diagnostics' field on the task result
          diagnostics = {
            -- Extract fields using lua patterns
            -- To integrate with other components, items in the "diagnostics" result should match
            -- vim's quickfix item format (:help setqflist)
            { "extract", "%f(%l,%c): %t%\\s%r", "file", "line", "column", "message" },
          },
        },
      },
      components = {

        { "on_output_quickfix", open = true },
      },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
