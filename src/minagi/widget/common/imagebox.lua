do
   local setmetatable    = setmetatable
   local math            = math
   local type            = type

   local wibox           = require("wibox")
   local surface         = require("gears.surface")

   local cairo_color     = require("gears.color")

   local util = require("minagi.util")

   -- draw imagebox
   local draw_image = function(cr, img, x, y, width, height, resize)
      local img_w = img:get_width()
      local img_h = img:get_height()

      local result_x = x
      local result_y = y
      local result_width = width
      local result_height = height

      if resize then
         local aspect = math.min(width / img_w, height / img_h)
         cr:scale(aspect, aspect)

         result_x = math.floor(result_x / aspect)
         result_y = math.floor(result_y / aspect)
         result_width = math.floor(result_width / aspect)
         result_height = math.floor(result_height / aspect)
      end

      cr:set_source_surface(img, result_x, result_y)
      cr:rectangle(result_x, result_y, result_width, result_height)
      cr:fill()
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
            bg = "#000000"
         }
      }
   end

   -- imagebox widget
   local imagebox = {
      mt = {}
   }

   -- constructor
   local new = function(preferred_style)
      local style = util.table.merge(default_style(), preferred_style or {})

      local state = {
         image = nil
      }

      local widget_definition = {
         widget = nil,
         update_function = nil,
         keys = {},
         timer_definitions = {},
      }

      widget_definition.widget = wibox.widget.base.make_widget()
      widget_definition.update_function = function()
         widget_definition.widget:emit_signal("widget::updated")
      end

      -- Properties
      function widget_definition.widget:image(image_path)
         if image_path then
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
               return nil
            end

            -- is it need???
            -- if state.image == image then
            --    self:emit_signal("widget::redraw_needed")
            --    return true
            -- end

            state.image = image

            self:emit_signal("property::image")
            self:emit_signal("widget::redraw_needed")
            self:emit_signal("widget::layout_changed")
         else
            return state.image
         end
      end

      -- Fit
      function widget_definition.widget:fit(_, width, height)
         if not state.image then
            return 0, 0
         end

         local w = style.w or width
         local h = style.h or height

         return w, h
      end

      -- Draw
      function widget_definition.widget:draw(_, cr, width, height)
         if not state.image or width == 0 or height == 0 then
            return
         end

         cr:set_source(cairo_color(style.c.bg))
         cr:paint()

         draw_image(
            cr,
            state.image,
            style.p.l,
            style.p.t,
            width  - style.p.l - style.p.r,
            height - style.p.t - style.p.b,
            style.resizable
         )
      end

      return widget_definition
   end

   function imagebox.mt:__call(...)
      return new(...)
   end

   return setmetatable(imagebox, imagebox.mt)
end
