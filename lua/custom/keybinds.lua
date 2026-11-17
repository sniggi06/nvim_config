-- Open markdown/web links under cursor
-- Handles both: [text](url) markdown links AND bare web URLs
vim.keymap.set('n', 'gx', function()
  local line = vim.api.nvim_get_current_line()
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
  
  -- First try: match markdown link pattern [text](url) or ![alt](url)
  local raw_url = string.match(line, '%[.-%]%((.-)%)')
  
  if raw_url then
    -- Take only the first word (handles titles like (url "title") or (url title)
    local clean_url = raw_url:match('^%S+')
    if clean_url and clean_url:match('^%a+://') then
      vim.fn.jobstart({'xdg-open', clean_url})
      return
    end
  end
  
  -- Second try: match bare web URL in line (e.g., "Visit https://example.com")
  local bare_url = line:match('(%a+://[^%s]+)')
  if bare_url and bare_url:match('^%a+://') then
    vim.fn.jobstart({'xdg-open', bare_url})
    return
  end
  
  -- Third try: get word under cursor as fallback
  local word = vim.fn.expand('<cword>')
  if word:match('^%a+://') then
    vim.fn.jobstart({'xdg-open', word})
  end
end, { silent = true, desc = 'Open markdown/web link under cursor' })