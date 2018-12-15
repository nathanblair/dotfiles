#!/bin/sh
if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P0101010
  \e]P1e84f4f
  \e]P2b8d68c
  \e]P3e1aa5d
  \e]P47dc1cf
  \e]P59b64fb
  \e]P66d878d
  \e]P7dddddd
  \e]P8404040
  \e]P9d23d3d
  \e]PAa0cf5d
  \e]PBf39d21
  \e]PC4e9fb1
  \e]PD8542ff
  \e]PE42717b
  \e]PFdddddd
  "
  # get rid of artifacts
  clear
fi
