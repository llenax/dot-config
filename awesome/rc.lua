local _ = require "custom.setup" -- Error handling

local terminal = "ghostty"

local mods = require("custom.theme.constants").mods

local awful = require "awful"
local beautiful = require "beautiful"
local naughty = require "naughty"
local gears = require "gears"
local hotkeys_popup = require "awful.hotkeys_popup"
local wibox = require "wibox"

--startup
awful.spawn.once "blueman-applet"
awful.spawn.once "nm-applet"

awful.util.spawn_with_shell "xrandr --output eDP-1 --right-of HDMI-1 --primary"

beautiful.init(string.format("%s/.config/awesome/custom/theme.lua", os.getenv "HOME"))
require "awful.autofocus"

awful.layout.layouts = {
  awful.layout.suit.tile,
}

-- Setup Theme
awful.screen.connect_for_each_screen(require("custom.theme").at_screen_connect)

root.buttons(gears.table.join(awful.button({}, 3, function()
  require("custom.widgets.menu"):toggle()
end)))

local global_keys = gears.table.join(
  awful.key({}, "Print", function()
    local cmd = string.format("MAIM_PKG=%s %s/.local/scripts/maim-clipboard-ss", "/usr/bin/maim", os.getenv "HOME")
    awful.spawn.easy_async_with_shell(cmd, function(_, stderr, _, exitcode)
      if exitcode == 0 then
        naughty.notify {
          preset = naughty.config.presets.normal,
          title = "Screenshot successfull",
          text = "Screenshot saved to clipboard",
        }
      else
        naughty.notify {
          preset = naughty.config.presets.critical,
          title = "Screenshot failed",
          text = "Screenshot failed with " .. exitcode .. "\n Error: " .. stderr,
        }
      end
    end)
  end, { description = "take fullscreen screenshot", group = "client" }),
  awful.key({ mods.shift }, "Print", function()
    local cmd = string.format("%s --select | xclip -selection clipboard -t image/png", "/usr/bin/maim")
    awful.spawn.easy_async_with_shell(cmd, function(_, stderr, _, exitcode)
      if exitcode == 0 then
        naughty.notify {
          preset = naughty.config.presets.normal,
          title = "Screenshot successfull",
          text = "Screenshot saved to clipboard",
        }
      else
        naughty.notify {
          preset = naughty.config.presets.critical,
          title = "Screenshot failed",
          text = "Screenshot failed with " .. exitcode .. "\n Error: " .. stderr,
        }
      end
    end)
  end, { description = "take area screenshot", group = "client" }),
  awful.key({ mods.super }, "s", hotkeys_popup.show_help, {
    description = "show help",
    group = "awesome",
  }),
  awful.key({ mods.super }, "Escape", awful.tag.history.restore, {
    description = "go back",
    group = "tag",
  }),
  awful.key({ mods.super }, "j", function()
    awful.client.focus.byidx(1)
  end, {
    description = "focus next by index",
    group = "client",
  }),
  awful.key({ mods.super }, "k", function()
    awful.client.focus.byidx(-1)
  end, {
    description = "focus previous by index",
    group = "client",
  }),
  awful.key({ mods.super }, "w", function()
    require("custom.widgets.menu"):show()
  end, {
    description = "show main menu",
    group = "awesome",
  }), -- Layout manipulation
  awful.key({ mods.super, mods.shift }, "j", function()
    awful.client.swap.byidx(1)
  end, {
    description = "swap with next client by index",
    group = "client",
  }),
  awful.key({ mods.super, mods.shift }, "k", function()
    awful.client.swap.byidx(-1)
  end, {
    description = "swap with previous client by index",
    group = "client",
  }),
  awful.key({ mods.super, mods.control }, "j", function()
    awful.screen.focus_relative(1)
  end, {
    description = "focus the next screen",
    group = "screen",
  }),
  awful.key({ mods.super, mods.control }, "k", function()
    awful.screen.focus_relative(-1)
  end, {
    description = "focus the previous screen",
    group = "screen",
  }),
  awful.key({ mods.super }, "u", awful.client.urgent.jumpto, {
    description = "jump to urgent client",
    group = "client",
  }),
  awful.key({ mods.super }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, {
    description = "go back",
    group = "client",
  }), -- Standard program
  awful.key({ mods.super }, "Return", function()
    awful.spawn(terminal)
  end, {
    description = "open a terminal",
    group = "launcher",
  }),
  awful.key({ mods.super, mods.control }, "r", awesome.restart, {
    description = "reload awesome",
    group = "awesome",
  }),
  -- awful.key({ mods.super, mods.shift }, "q", awesome.quit, {
  --   description = "quit awesome",
  --   group = "awesome",
  -- }),
  awful.key({ mods.super }, "l", function()
    awful.tag.incmwfact(0.05)
  end, {
    description = "increase master width factor",
    group = "layout",
  }),
  awful.key({ mods.super }, "h", function()
    awful.tag.incmwfact(-0.05)
  end, {
    description = "decrease master width factor",
    group = "layout",
  }),
  awful.key({ mods.super, mods.shift }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, {
    description = "increase the number of master clients",
    group = "layout",
  }),
  awful.key({ mods.super, mods.shift }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, {
    description = "decrease the number of master clients",
    group = "layout",
  }),
  awful.key({ mods.super, mods.control }, "h", function()
    awful.tag.incncol(1, nil, true)
  end, {
    description = "increase the number of columns",
    group = "layout",
  }),
  awful.key({ mods.super, mods.control }, "l", function()
    awful.tag.incncol(-1, nil, true)
  end, {
    description = "decrease the number of columns",
    group = "layout",
  }),
  awful.key({ mods.super }, "space", function()
    awful.layout.inc(1)
  end, {
    description = "select next",
    group = "layout",
  }),
  awful.key({ mods.super, mods.shift }, "space", function()
    awful.layout.inc(-1)
  end, {
    description = "select previous",
    group = "layout",
  }),

  awful.key({ mods.super, mods.control }, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      c:emit_signal("request::activate", "key.unminimize", { raise = true })
    end
  end, {
    description = "restore minimized",
    group = "client",
  }), -- Prompt

  awful.key({ mods.super }, "a", function()
    -- TODO: I have stuff like ghostty installed without Desktop stuff...
    -- I guess I could add that and it would show up in drun, but ... idk
    awful.spawn "rofi -show run"
  end, {
    description = "run prompt",
    group = "launcher",
  }),

  awful.key({ mods.super }, "x", function()
    awful.prompt.run {
      prompt = "Run Lua code: ",
      textbox = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval",
    }
  end, {
    description = "lua execute prompt",
    group = "awesome",
  }),

  -- Volume control
  awful.key({}, "#123", require("custom.volume").inc),
  awful.key({}, "#122", require("custom.volume").dec),

  -- Titlebar
  awful.key({ mods.super, mods.shift }, "t", function()
    awful.titlebar.toggle(client.focus)
  end)
)

local client_keys = gears.table.join(
  awful.key({ mods.super }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, {
    description = "toggle fullscreen",
    group = "client",
  }),
  awful.key({ mods.super, mods.shift }, "q", function(c)
    c:kill()
  end, {
    description = "close",
    group = "client",
  }),
  awful.key({ mods.super, mods.control }, "space", awful.client.floating.toggle, {
    description = "toggle floating",
    group = "client",
  }),
  awful.key({ mods.super, mods.control }, "Return", function(c)
    c:swap(awful.client.getmaster())
  end, {
    description = "move to master",
    group = "client",
  }),
  awful.key({ mods.super }, "o", function(c)
    c:move_to_screen()
  end, {
    description = "move to screen",
    group = "client",
  }),
  awful.key({ mods.super }, "t", function(c)
    c.ontop = not c.ontop
  end, {
    description = "toggle keep on top",
    group = "client",
  }),
  awful.key({ mods.super }, "n", function(c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
  end, {
    description = "minimize",
    group = "client",
  }),
  awful.key({ mods.super }, "m", function(c)
    c.maximized = not c.maximized
    c:raise()
  end, {
    description = "(un)maximize",
    group = "client",
  }),
  awful.key({ mods.super, mods.control }, "m", function(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end, {
    description = "(un)maximize vertically",
    group = "client",
  }),
  awful.key({ mods.super, mods.shift }, "m", function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
  end, {
    description = "(un)maximize horizontally",
    group = "client",
  }),
  -- TODO: Gotta figure out why this just opens 8 things?
  awful.key({ mods.super, mods.control }, "Return", function()
    awful.spawn("kitty", { floating = true })
  end, { description = "spawn floating terminal", group = "launcher" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  global_keys = gears.table.join(
    global_keys, -- View tag only.
    awful.key({ mods.super }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        tag:view_only()
      end
    end, {
      description = "view tag #" .. i,
      group = "tag",
    }),
    -- Move client to tag.
    awful.key({ mods.super, mods.shift }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, {
      description = "move focused client to tag #" .. i,
      group = "tag",
    }), -- Toggle tag on focused client.
    awful.key({ mods.super, mods.control, mods.shift }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end, {
      description = "toggle focused client on tag #" .. i,
      group = "tag",
    })
  )
end

local client_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ mods.super }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ mods.super }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

root.keys(global_keys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  },
  {
    rule_any = {
      instance = { "pinentry" },
      class = {},

      name = {},
      role = {
        "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
      },
    },
    properties = { floating = true },
  },
  {
    rule_any = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = true },
  },
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  awful.titlebar.hide(c)

  -- Prevent clients from being unreachable after screen count changes.
  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c):setup {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Middle
      { -- Title
        align = "center",
        widget = awful.titlebar.widget.titlewidget(c),
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal,
    },
    { -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal(),
    },
    layout = wibox.layout.align.horizontal,
  }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus or ""
end)

client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal or ""
end)
