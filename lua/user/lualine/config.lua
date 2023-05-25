local M = {}

local default = {
  float = true,
  separator = "triangle",
  colorful = true,
  separator_icon = { left = "", right = " " },
  thin_separator_icon = { left = "", right = " " },
}

M.options = {}

local function make_separator(type)
  if type == "bubble" then
    M.options.separator_icon = { left = "█", right = "█" }
    M.options.thin_separator_icon = { left = " ", right = " " }
  elseif type == "triangle" then
    M.options.separator_icon = { left = "█", right = "█" }
    M.options.thin_separator_icon = { left = " ", right = " " }
  else
    return
  end
end

M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", {}, default, opts or {})
  if M.options.float then
    make_separator(M.options.separator)
  end
end

M.setup()

return M
