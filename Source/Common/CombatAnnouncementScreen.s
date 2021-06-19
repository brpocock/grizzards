CombatAnnouncementScreen:     .block

          jsr VSync
          jsr VBlank

          ldx # KernelLines
FillScreen:
          stx WSYNC
          dex
          bne FillScreen

          .bend
