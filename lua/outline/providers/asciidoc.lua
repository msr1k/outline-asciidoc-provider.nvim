local M = {
  name = 'asciidoc',
}


---@return boolean ft_is_asciidoc
function M.supports_buffer(bufnr)
  return vim.api.nvim_buf_get_option(bufnr, 'ft') == 'asciidoc'
end

-- Parses asciidoc files and returns a table of SymbolInformation[] which is
-- used by the plugin to show the outline.
---@return table
function M.handle_asciidoc()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local level_symbols = { { children = {} } }
  local max_level = 1
  local is_inside_code_block = false

  for line, value in ipairs(lines) do
    if string.find(value, '^```') then
      is_inside_code_block = not is_inside_code_block
    end
    if is_inside_code_block then
      goto nextline
    end

    local header, title = string.match(value, '^(=+)%s+(.+)$')
    if not header or not title then
      goto nextline
    end

    local depth = #header + 1

    local parent
    for i = depth - 1, 1, -1 do
      if level_symbols[i] ~= nil then
        parent = level_symbols[i].children
        break
      end
    end

    for i = depth, max_level do
      if level_symbols[i] ~= nil then
        level_symbols[i].selectionRange['end'].line = line - 1
        level_symbols[i].range['end'].line = line - 1
        level_symbols[i] = nil
      end
    end
    max_level = depth

    local entry = {
      kind = 15,
      name = title,
      selectionRange = {
        start = { character = 1, line = line - 1 },
        ['end'] = { character = 1, line = line - 1 },
      },
      range = {
        start = { character = 1, line = line - 1 },
        ['end'] = { character = 1, line = line - 1 },
      },
      children = {},
    }

    parent[#parent + 1] = entry
    level_symbols[depth] = entry
    ::nextline::
  end

  for i = 2, max_level do
    if level_symbols[i] ~= nil then
      level_symbols[i].selectionRange['end'].line = #lines
      level_symbols[i].range['end'].line = #lines
    end
  end

  return level_symbols[1].children
end

---@param on_symbols function
---@param opts table
function M.request_symbols(on_symbols, opts)
  on_symbols(M.handle_asciidoc(), opts)
end

return M
