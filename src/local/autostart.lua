return {
   {

      command = "redshift-gtk",
      command_filter = "redshift-gtk",
      args = "",
      once = true,
      kill_on_exit = false
   },
   {
      command = "pulseaudio",
      command_filter = "pulseaudio",
      args = "--start",
      once = true,
      kill_on_exit = false
   },
   {
      command = "nm-applet",
      command_filter = "nm-applet",
      args = "",
      once = true,
      kill_on_exit = false
   },
   {
      command = "mpd",
      command_filter = "mpd",
      args = "",
      once = true,
      kill_on_exit = false
   },
   {
      command = "xkbcomp -I$HOME/.xkb ~/.xkb/keymap/mykbd $DISPLAY",
      command_filter = nil,
      args = "",
      once = false,
      kill_on_exit = false
   }
}
