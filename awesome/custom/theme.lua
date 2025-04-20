local beautiful = require "beautiful"
local gears = require "gears"
local awful = require "awful"
local wibox = require "wibox"
local dpi = require("beautiful.xresources").apply_dpi
local mouse = require("custom.theme.constants").mouse
local mods = require("custom.theme.constants").mods

local theme = {}
theme.dir = os.getenv "HOME" .. "/.config/awesome/custom/theme"
theme.wallpaper = theme.dir .. "/wall.png"
theme.font = "monospace 10"
theme.useless_gap = 0

local gray = {
  "#111111",
  "#282a2e",
  "#373b41",
  "#969896",
  "#b4b7b4",
  "#c5c8c6",
  "#e0e0e0",
  "#ffffff",
}

-- theme.bg_normal = "#111111"
-- theme.fg_normal = "#FEFEFE"
-- theme.bg_normal = "#222222"
-- theme.bg_focus = "#535d6c"
theme.bg_normal = "#222222"
theme.bg_focus = "#535d6c"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_normal

theme.bg_urgent = "#FF0000"
theme.fg_urgent = "#000000"

theme.bg_focus = "#FFFFFF"
theme.fg_focus = "#111111"

theme.taglist_fg_focus = gray[7]
-- theme.taglist_bg_focus = "#00CCFF"

theme.bg_normal = "#222222"
theme.bg_focus = "#535d6c"
-- theme.tasklist_bg_normal = "#103000"
theme.tasklist_fg_normal = gray[4]
theme.tasklist_bg_focus = "#555555"
theme.tasklist_fg_focus = gray[7]
-- theme.tasklist_bg_urgent = "#282a2e"
theme.tasklist_fg_urgent = "#00CCFF"

theme.titlebar_bg_focus = gray[7]
theme.titlebar_bg_normal = gray[7]
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_focus = theme.fg_focus

theme.border_width = dpi(2)
theme.border_normal = "#3F3F3F"
theme.border_focus = "#6F6F6F"
theme.border_marked = "#CC9393"

theme.menu_height = dpi(16)
theme.menu_width = dpi(140)
theme.menu_submenu_icon = theme.dir .. "/icons/submenu.png"

theme.awesome_icon = theme.dir .. "/icons/awesome.png"
theme.taglist_squares_sel = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile = theme.dir .. "/icons/tile.png"
theme.layout_tileleft = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv = theme.dir .. "/icons/fairv.png"
theme.layout_fairh = theme.dir .. "/icons/fairh.png"
theme.layout_spiral = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle = theme.dir .. "/icons/dwindle.png"
theme.layout_max = theme.dir .. "/icons/max.png"
theme.layout_fullscreen = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier = theme.dir .. "/icons/magnifier.png"
theme.layout_floating = theme.dir .. "/icons/floating.png"
theme.widget_ac = theme.dir .. "/icons/ac.png"
theme.widget_battery = theme.dir .. "/icons/battery.png"
theme.widget_battery_low = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty = theme.dir .. "/icons/battery_empty.png"
theme.widget_brightness = theme.dir .. "/icons/brightness.png"
theme.widget_mem = theme.dir .. "/icons/mem.png"
theme.widget_cpu = theme.dir .. "/icons/cpu.png"
theme.widget_temp = theme.dir .. "/icons/temp.png"
theme.widget_net = theme.dir .. "/icons/net.png"
theme.widget_hdd = theme.dir .. "/icons/hdd.png"
theme.widget_music = theme.dir .. "/icons/note.png"
theme.widget_music_on = theme.dir .. "/icons/note_on.png"
theme.widget_music_pause = theme.dir .. "/icons/pause.png"
theme.widget_music_stop = theme.dir .. "/icons/stop.png"
theme.widget_vol = theme.dir .. "/icons/vol.png"
theme.widget_vol_low = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail = theme.dir .. "/icons/mail.png"
theme.widget_mail_on = theme.dir .. "/icons/mail_on.png"
theme.widget_task = theme.dir .. "/icons/task.png"
theme.widget_scissors = theme.dir .. "/icons/scissors.png"
theme.tasklist_plain_task_name = false
theme.tasklist_disable_icon = false
theme.titlebar_close_button_focus = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

-- local mylauncher = awful.widget.launcher { image = beautiful.awesome_icon, menu = my_main_menu }
local text_clock = wibox.widget.textclock " %I:%M %p "
text_clock:set_font "monospace 10"

local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

local batterywidget = wibox.widget.textbox()
local batteryicon = wibox.widget.imagebox()

local month_calendar = awful.widget.calendar_popup.month {
  bg = "#222222",
  style_focus = {
    bg_color = "#4444ff",
  },
}
month_calendar:attach(text_clock, "tr")

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

function theme.at_screen_connect(s)
  set_wallpaper(s)

  ---@diagnostic disable-next-line
  local batterywidgettimer = timer { timeout = 5 }
  batterywidgettimer:connect_signal("timeout", function()
    local fh = assert(io.popen("acpi | cut -d, -f 2,3 | cut -d% -f 1 -", "r"))
    local per = fh:read "*number"
    batterywidget:set_text(per .. "%")
    if per > 80 then
      batteryicon:set_image(theme.widget_battery)
    elseif per > 40 then
      batteryicon:set_image(theme.widget_battery_low)
    else
      batteryicon:set_image(theme.widget_battery_empty)
    end
    fh:close()
  end)
  batterywidgettimer:start()

  -- Each screen has its own tag table.
  local screen_layout = awful.layout.layouts[1]
  if s.index == 1 then
    screen_layout = awful.layout.suit.tile.left
  end

  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, screen_layout)

  -- Create a taglist widget
  local taglist_buttons = gears.table.join(
    awful.button({}, mouse.left, function(t)
      t:view_only()
    end),
    awful.button({ mods.super }, mouse.left, function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end),
    awful.button({}, mouse.right, awful.tag.viewtoggle),
    awful.button({ mods.super }, mouse.right, function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end)
  )

  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

  -- Create a tasklist widget
  local tasklist_buttons = gears.table.join(awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal("request::activate", "tasklist", { raise = true })
    end
  end))

  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  s.mypromptbox = awful.widget.prompt()

  -- Create the wibox
  s.mywibox = awful.wibar { position = "top", screen = s, height = dpi(20), bg = theme.bg_normal, fg = theme.fg_normal }

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      --spr,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.widget.systray(),
      text_clock,
      wibox.container.margin(
        wibox.widget {
          batteryicon,
          batterywidget,
          layout = wibox.layout.align.horizontal,
        },
        dpi(3),
        dpi(3)
      ),
      -- s.mylayoutbox,
    },
  }
end

return theme
