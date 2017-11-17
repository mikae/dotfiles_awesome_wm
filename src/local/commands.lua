return {
   terminal = {
      cmd  = "urxvt",
      args = "",
      wait = false
   },
   shutdown = {
      cmd  = "systemctl poweroff",
      args = "",
      wait = false

   },
   reboot = {
      cmd  = "systemctl reboot",
      args = "",
      wait = false
   },
   screenshoot_window = {
      cmd  = "xfce4-screenshooter",
      args = "-w",
      wait = false
   },
   screenshoot_screen = {
      cmd  = "xfce4-screenshooter",
      args = "-f",
      wait = false
   },
   screenlocker = {
      cmd  = "slock",
      args = "",
      wait = false
   },
}
