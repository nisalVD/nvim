local M = {}

function M.open_markdown_window(markdown_file_path)
  -- Open the Markdown file in a buffer
  local markdown_buf = vim.fn.bufadd(markdown_file_path)

  -- Open a floating window with the Markdown buffer
  local win_config = {
    relative = "editor",
    width = 80,
    height = 40,
    row = 5,
    col = 5,
    style = "minimal",
    border = "single",
  }

  local markdown_win = vim.api.nvim_open_win(markdown_buf, true, win_config)

  -- Set the filetype of the buffer to 'markdown'
  vim.api.nvim_buf_set_option(markdown_buf, "filetype", "markdown")
end

function M.convert_jira_link()
  -- Get the current word under the cursor
  local issue_key = vim.fn.expand("<cWORD>")

  -- Check if the word is a Jira issue key
  if string.match(issue_key, "^%u+%-%d+$") then
    -- Construct the Jira link
    local jira_link = "https://convertdigital.atlassian.net/browse/" .. issue_key

    -- Replace the current word with the Jira link in Markdown format
    vim.fn.setline(
      ".",
      vim.fn.substitute(vim.fn.getline("."), issue_key, "[" .. issue_key .. "](" .. jira_link .. ")", "")
    )

    -- Move the cursor to the end of the link text
    vim.fn.search("]\\=")
    vim.fn.normal("l")
  else
    print("Not a valid Jira issue key")
  end
end

-- Map a key (e.g., <Leader>jl) to trigger the conversion

return M
