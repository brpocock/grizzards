;;; Grizzards Source/Banks/Bank00/Bank0Strings.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
SelectText:
          .MiniText "SELECT"
EraseText:
          .MiniText "ERASE "
BeginText:
          .MiniText "BEGIN "
VacantText:
          .MiniText "VACANT"
ResumeText:
          .MiniText "RESUME"
InUseText:
          .MiniText "IN USE"
SlotText:
          .MiniText " SLOT "
SlotOneText:
          .MiniText "SLOT 1"
CopyrightText:
          .SignText "COPYRIGHT   "
CopyrightYearText:
          .SignText format(" %04d       ", YEARNOW)
BruceRobertText:
          .SignText "BRUCE-ROBERT"
PocockText:
          .SignText " POCOCK     "

JatibuCode:
          .byte P0StickUp, P0StickUp, P0StickDown, P0StickDown
          .byte P0StickLeft, P0StickRight, P0StickLeft, P0StickRight
          .byte 0

WithLoveText:
          .SignText "WITH LOVE TO"
ZephyrText:
          .SignText "ZEPHYR SALZ "

DatestampText:
          .SignText format(" %04d-%02d-%02d ", YEARNOW, MONTHNOW, DATENOW)
