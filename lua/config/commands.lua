vim.api.nvim_create_user_command("PutMessages", function()
  vim.cmd("put = execute('messages')")
end, {})
