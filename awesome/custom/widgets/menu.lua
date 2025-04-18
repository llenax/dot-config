local awful = require "awful"
local my_awesome_menu = {
  -- { "restart", awesome.restart },
  -- {
  --   "quit",
  --   function()
  --     awesome.quit()
  --   end,
  -- },
}

local my_main_menu = awful.menu {
  items = {
    { "Terminal", "ghostty" },
    { "Files", "nautilus" },
    { "Browser", "brave-browser" },
  },
}

return my_main_menu
