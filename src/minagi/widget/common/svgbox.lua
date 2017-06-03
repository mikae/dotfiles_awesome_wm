-- some code base is taken from
-- "https://github.com/worron/redflat/blob/aa1a1a364014a21e38485c1072ed52e8a8fd2fb0/gauge/svgbox.lua"

do
   local setmetatable    = setmetatable
   local math            = math
   local type            = type

   local wibox           = require("wibox")
   local surface         = require("gears.surface")

   local cairo_color     = require("gears.color")

   local util = require("minagi.util")

   -- load pixbuf
   local pixbuf

   local function load_pixbuf()
      -- for some reason, svg is not displayed without this -_-
      local Gdk = require("lgi").Gdk
      pixbuf = require("lgi").GdkPixbuf
   end

   local is_pixbuf_loaded = pcall(load_pixbuf)

   -- utils
   local is_svg = function(path)
      return type(path) == "string" and string.match(path, "%.svg")
   end

   local pixbuf_from_svg = function(file, width, height)
      return pixbuf.Pixbuf.new_from_file_at_scale(file, width, height, true)
   end

   local get_current_pattern = function(cr)
      cr:push_group()
      cr:paint()
      return cr:pop_group()
   end

   -- draw
   -- todo: use x, and y while draw
   local draw_svg = function(cr, img, img_path, x, y, width, height, resize, color)
      if width == 0 or height == 0 or not img then return end
      local w, h = img.width, img.height
      local aspect = math.min(width / w, height / h)
      cr:save()

      if (img.width ~= width or img.height ~= height) and resize then
         if is_pixbuf_loaded then
            local pxbf = pixbuf_from_svg(img_path, math.floor(w * aspect), math.floor(h * aspect))
            cr:set_source_pixbuf(pxbf, 0, 0)
         else
            cr:scale(aspect, aspect)
            cr:set_source_surface(img, 0, 0)
            cr:scale(1 / aspect, 1 / aspect) -- fix this !!!
         end
      else
         cr:set_source_surface(img, 0, 0)
      end

      if color then
         local pattern = get_current_pattern(cr)

         cr:scale(aspect, aspect) -- fix this !!!
         cr:set_source(cairo_color(color))
         cr:scale(1 / aspect, 1 / aspect) -- fix this !!!
         cr:mask(pattern, 0, 0)
      else
         cr:paint()
      end

      cr:restore()
   end

   -- default style
   local default_style = function()
      return {
         w = nil,
         h = nil,
         resizable = true,
         p = {
            t = 0,
            r = 0,
            b = 0,
            l = 0
         },
         c = {
            bg = nil,
            fg = nil
         }
      }
   end

   -- svgbox widget
   local svgbox = {
      mt = {}
   }

   -- constructor
   local new = function(preferred_style)
      local style = util.table.merge(default_style(), preferred_style or {})

      local state = {
         image      = nil,
         image_path = nil,
         is_svg     = false
      }

      local widget = wibox.widget.base.make_widget()

      -- Properties
      function widget:image(image_path)
         local image

         if type(image_path) == "string" then
            image = surface.load(image_path)

            if not image then
               print(debug.traceback())
               return false
            end
         else
            image = surface.load(image_path)
         end

         if image and (image.width <= 0 or image.height <= 0) then
            return false
         end

         state.image      = image
         state.image_path = image_path
         state.is_svg     = is_svg(image_path)

         self:emit_signal("property::image")
         self:emit_signal("widget::redraw_needed")
         self:emit_signal("widget::layout_changed")

         return true
      end

      function widget:fg(color)
         if color then
            style.c.fg = color

            self:emit_signal("property::fg")
            self:emit_signal("widget::redraw_needed")
            self:emit_signal("widget::layout_changed")
         else
            return style.c.fg
         end
      end

      function widget:bg(color)
         if color then
            style.c.bg = color

            self:emit_signal("property::bg")
            self:emit_signal("widget::redraw_needed")
            self:emit_signal("widget::layout_changed")
         else
            return style.c.bg
         end
      end

      -- Fit
      function widget:fit(_, width, height)
         if not state.image then
            return 0, 0
         end

         local w = style.w or width
         local h = style.h or height

         return w, h
      end

      -- Draw
      function widget:draw(_, cr, width, height)
         if style.c.bg then
            cr:set_source(cairo_color(style.c.bg))
            cr:paint()
         end

         draw_svg(
            cr,
            state.image,
            state.image_path,
            style.p.l,
            style.p.r,
            width  - style.p.l - style.p.r,
            height - style.p.t - style.p.b,
            style.resizable,
            style.c.fg
         )
      end

      return {
         widget = widget,
         update_function = util.func.void,
         keys = {},
         timer_definitions = {},
      }
   end

   function svgbox.mt:__call(...)
      return new(...)
   end

   return setmetatable(svgbox, svgbox.mt)
end
