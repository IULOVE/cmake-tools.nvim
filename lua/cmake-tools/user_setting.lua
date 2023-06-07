local user = {}

user.config = {
  kit = nil,
  build_type = nil,
  target = nil,
}

local setting_file_name = "CMakeUserSetting.json"

---@param config = require "cmake-tools.config"
function user.load(config)
  user.config = config
  if not user.config.enable_user_setting then
    return
  end

  local find_setting = function()
    local files = vim.fn.readdir(".")
    local file = nil
    for _, f in ipairs(files) do
      if f == setting_file_name then
        file = vim.fn.resolve("./" .. f)
        return file
      end
    end
    return file
  end

  local file = find_setting()
  if file then
    if file:match(".*%.json") then -- .. and is a json file
      local setting = vim.fn.json_decode(vim.fn.readfile(file))
      if setting and setting.configurations then
        config.build_type = setting.configurations.build_type
        config.build_target = setting.configurations.target
        config.kit = setting.configurations.kit

        if config.build_type == "" then
          config.build_type = nil
        end
        if config.build_target == "" then
          config.build_target = nil
        end
        if config.kit == "" then
          config.kit = nil
        end
        config.launch_target = config.build_target
        return true
      end
    end
  end
  return false
end

-- write bookmarks into disk file for next load
function user.persistent()
  if not user.config.enable_user_setting then
    return
  end
  local config = {
    configurations = {
      kit = user.config.kit,
      build_type = user.config.build_type,
      target = user.config.build_target,
    },
  }

  -- configurations Writes to a file if it is not empty
  for _, _ in pairs(config.configurations) do
    local c = vim.fn.json_encode(config)
    local file_name = vim.fn.resolve("./" .. setting_file_name)

    vim.fn.writefile({ c }, file_name)
    break
  end
end

return user
