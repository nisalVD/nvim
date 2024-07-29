local M = {}
M.formatter_data = {}

function M.add_fidget_ignore(filetype, task_name)
  M.formatter_data = vim.tbl_deep_extend("force", M.formatter_data, {
    [filetype] = {
      [task_name] = 1,
    },
  })
  -- M.formatter_data = {
  -- 	[filetype] = {
  -- 		[task_name] = 1,
  -- 	},
  -- }
end

function M.is_format_ignore(task_name)
  local filetype = vim.bo.filetype
  local all_ignores = M.formatter_data["*"]

  for k, _ in pairs(all_ignores) do
    if k == task_name then
      return true
    end
  end

  if M.formatter_data[filetype] then
    if M.formatter_data[filetype][task_name] == 1 then
      return true
    end
  end
  return false
end

return M
