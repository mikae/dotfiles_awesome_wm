do
   local setmetatable    = setmetatable
   local math            = math

   local wibox           = require("wibox")

   local lgi = require("lgi")
   local Pango = lgi.Pango
   local PangoCairo = lgi.PangoCairo

   local cairo_color = require("gears.color")

   local util = require("minagi.util")

   local update_layout = function(layout, width, height)
      layout.width = Pango.units_from_double(width)
      layout.height = Pango.units_from_double(height)
   end

   local update_dpi = function(state, dpi)
      if state.dpi ~= dpi then
         state.dpi = dpi
         state.ctx:set_resolution(dpi)
         state.layout:context_changed()
      end
   end

   local do_fit = function(layout)
      local _, logical = layout:get_pixel_extents()

      if logical.width == 0 or logical.height == 0 then
         return 0, 0
      end

      return logical.width, logical.height
   end

   -- align
   local allowed = {left = "LEFT", center = "CENTER", right = "RIGHT"}

   -- todo: make it vertical too
   local align = function(layout, alignment)
      if allowed[alignment] and (layout:get_alignment() ~= allowed[alignment]) then
         layout:set_alignment(allowed[alignment])
      end
   end

   -- default style
   local default_style = function()
      return {
         w = nil,
         h = nil,
         align = "left",
         expand = true,
         c = {
            fg    = "#FF0000",
            bg    = "#000000"
         },
         font     = {
            name  = "DejaVu Sans Mono Oblique",
            size  = 20,
            face  = 0,
            slant = 0
         }
      }
   end

   -- textbox widget
   local textbox = {
      mt = {}
   }

   -- constructor
   local new = function(preferred_style)
      local style = util.table.merge(default_style(), preferred_style or {})

      local state = {}

      state.w = nil
      state.h = nil
      state.last_w = nil
      state.last_h = nil

      state.dpi = -1
      state.ctx = PangoCairo.font_map_get_default():create_context()
      state.layout = Pango.Layout.new(state.ctx)

      local widget = wibox.widget.base.make_widget()

      -- Setters
      function widget:text(text)
         if text then
            if state.layout.text == text and state.layout.attributes == nil then
               return
            end

            state.layout.text = text
            state.layout.attributes = nil

            self:emit_signal("widget::updated")
            self:emit_signal("changed::text", text)
         end
      end

      function widget:fg(color)
         if color then
            style.c.fg = color
            self:emit_signal("widget::updated")
            self:emit_signal("property::fg", color)
         else
            return style.c.fg
         end
      end

      function widget:bg(color)
         if color then
            style.c.bg = color
            self:emit_signal("widget::updated")
            self:emit_signal("property::bg", color)
         else
            return style.c.bg
         end
      end

      function widget:w()
         return state.w
      end

      function widget:h()
         return state.h
      end

      -- Fit
      function widget:fit(context, width, height)
         update_layout(state.layout, width, height)
         update_dpi(state, context.dpi)

         local w, h = do_fit(state.layout)

         state.w = w
         state.h = h

         if style.expand then
            w = math.max(style.w or 0, state.w or 0)
            h = math.max(style.h or 0, state.h or 0)
         else
            w = style.w or state.w
            h = style.h or state.h
         end

         if w ~= state.last_w then
            self:emit_signal("property::w", w)
            state.last_w = w
         end

         if h ~= state.last_h then
            self:emit_signal("property::h", h)
            state.last_h = h
         end

         return w, h
      end

      -- Draw
      function widget:draw(context, cr, width, height)
         cr:set_source(cairo_color(style.c.bg))
         cr:paint()

         update_layout(state.layout, width, height)
         update_dpi(state, context.dpi)

         cr:update_layout(state.layout)

         cr:set_font_size(style.font.size)
         cr:select_font_face(style.font.name, style.font.slant, style.font.face)

         cr:set_source(cairo_color(style.c.fg))
         align(state.layout, style.align)
         cr:move_to(0, 0)
         cr:show_layout(state.layout)
      end

      return {
         widget = widget,
         update_function = util.func.void,
         keys = {},
         timer_definitions = {},
      }
   end

   function textbox.mt:__call(...)
      return new(...)
   end

   return setmetatable(textbox, textbox.mt)
end
