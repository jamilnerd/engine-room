vim.cmd.colorscheme("habamax")
vim.g.terminal_ansi_colors = {
    '#000000',
    '#cc0403',
    '#19cb00',
    '#cecb00',
    '#0d73cc',
    '#cb1ed1',
    '#0dcdcd',
    '#dddddd',
    '#767676',
    '#f2201f',
    '#23fd00',
    '#fffd00',
    '#1a8fff',
    '#fd28ff',
    '#14ffff',
    '#ffffff'
}
for i = 0, #vim.g.terminal_ansi_colors - 1 do
    vim.g['terminal_color_' .. i] = vim.g.terminal_ansi_colors[i + 1]
end
vim.cmd("filetype plugin indent on")

require("init.global")

require("init.lazy")
require("init.autocmd")
require("init.function")
require("init.highlight")
require("init.keymap")
require("init.lsp")
require("init.option")
require("init.diagnostic")
require("init.usercommand")

vim.cmd.set("foldtext=g:fold_text()")

local target_path = vim.fn.fnamemodify("playbook-run/state.yaml", ":p")
local timers = {}

local function is_target_buffer(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr)
    and vim.api.nvim_buf_get_name(bufnr) == target_path
end

local function stop_checktime(bufnr)
  local timer = timers[bufnr]

  if not timer then
    return false
  end

  timers[bufnr] = nil
  timer:stop()
  timer:close()
  return true
end

local function find_target_buffer()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and is_target_buffer(bufnr) then
      return bufnr
    end
  end
end

local function resolve_buffer(args)
  if args.args ~= "" then
    local bufnr = tonumber(args.args)

    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
      error("invalid buffer number: " .. args.args)
    end

    if not is_target_buffer(bufnr) then
      error("buffer is not " .. target_path)
    end

    return bufnr
  end

  local current = vim.api.nvim_get_current_buf()

  if is_target_buffer(current) then
    return current
  end

  return find_target_buffer()
end

vim.api.nvim_create_user_command("StartStateChecktime", function(args)
  local bufnr = resolve_buffer(args)

  if not bufnr then
    error("target buffer is not loaded: " .. target_path)
  end

  if timers[bufnr] then
    vim.notify("checktime already running for buffer " .. bufnr)
    return
  end

  local timer = (vim.uv or vim.loop).new_timer()
  timers[bufnr] = timer

  timer:start(500, 500, vim.schedule_wrap(function()
    if not timers[bufnr]
        or not vim.api.nvim_buf_is_valid(bufnr)
        or not vim.api.nvim_buf_is_loaded(bufnr) then
      stop_checktime(bufnr)
      return
    end

    -- :checktime operates on the current buffer.
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd.checktime()
    end)
  end))

  vim.notify("started checktime for buffer " .. bufnr)
end, {
  nargs = "?",
  desc = "Start 500 ms checktime polling for state.yaml",
})

vim.api.nvim_create_user_command("StopStateChecktime", function(args)
  local bufnr = resolve_buffer(args)

  if not bufnr then
    error("target buffer is not loaded: " .. target_path)
  end

  if stop_checktime(bufnr) then
    vim.notify("stopped checktime for buffer " .. bufnr)
  else
    vim.notify("no checktime timer for buffer " .. bufnr)
  end
end, {
  nargs = "?",
  desc = "Stop checktime polling for state.yaml",
})

vim.api.nvim_create_autocmd({ "BufUnload", "BufDelete" }, {
  callback = function(args)
    stop_checktime(args.buf)
  end,
})

-- require('vim._core.ui2').enable({
--     enable = true, -- Whether to enable or disable the UI.
--     -- msg = {        -- Options related to the message module.
--     --     ---@type 'cmd'|'msg' Default message target, either in the
--     --     ---cmdline or in a separate ephemeral message window.
--     --     ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
--     --     ---or table mapping |ui-messages| kinds and triggers to a target.
--     --     targets = 'cmd',
--     --     cmd = {             -- Options related to messages in the cmdline window.
--     --         height = 0.5    -- Maximum height while expanded for messages beyond 'cmdheight'.
--     --     },
--     --     dialog = {          -- Options related to dialog window.
--     --         height = 0.5,   -- Maximum height.
--     --     },
--     --     msg = {             -- Options related to msg window.
--     --         height = 0.5,   -- Maximum height.
--     --         timeout = 4000, -- Time a message is visible in the message window.
--     --     },
--     --     pager = {           -- Options related to message window.
--     --         height = 1,     -- Maximum height.
--     --     },
--     -- },
-- })
