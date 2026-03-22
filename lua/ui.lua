-------------------------------------------------------
--- Quick-select popup (press a number to instantly pick)
-------------------------------------------------------
vim.ui.select = function(items, opts, on_choice)
  local buf = vim.api.nvim_create_buf(false, true)

  local lines = {}
  for i, item in ipairs(items) do
    local label = opts.format_item and opts.format_item(item) or tostring(item)
    table.insert(lines, string.format(" %d  %s ", i, label))
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  local width = 0
  for _, line in ipairs(lines) do width = math.max(width, #line) end

  local win = vim.api.nvim_open_win(buf, true, {
    relative  = "cursor",
    row = 1, col = 0,
    width     = width,
    height    = #lines,
    style     = "minimal",
    border    = "rounded",
    title     = opts.prompt and (" " .. opts.prompt .. " ") or nil,
    title_pos = "center",
  })

  local function pick(idx)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if idx then on_choice(items[idx], idx) else on_choice(nil, nil) end
  end

  for i = 1, math.min(#items, 9) do
    vim.keymap.set("n", tostring(i), function() pick(i) end,
      { buffer = buf, nowait = true, silent = true })
  end
  vim.keymap.set("n", "<CR>", function()
    local row = vim.api.nvim_win_get_cursor(win)[1]
    pick(row)
  end, { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "<Esc>", function() pick(nil) end,
    { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "q",     function() pick(nil) end,
    { buffer = buf, nowait = true, silent = true })
end
