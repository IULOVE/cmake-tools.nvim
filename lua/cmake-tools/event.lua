local user = require("cmake-tools.user_setting")
local const = require("cmake-tools.const")
local M = {}
local api = vim.api

function M.setup()
  M.autocmd()
end

function M.autocmd()
  api.nvim_create_autocmd({ "VimLeave" }, {
    callback = function()
      user.persistent()
    end,
  })
end

return M
