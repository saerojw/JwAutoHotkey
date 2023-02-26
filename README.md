Written by Juwon\
e-mail: saero94j@gmail.com

Script for using macOS layout keyboard on Windows.\
Written based on AutoHotkey v2.0.2

Windows layout:
```
    CapsLock
    LShift                                         RShift
    (fn) - LCtrl - LWin - LAlt  ---- RAlt  - RWin - RCtrl
```
MacOS layout:
```
    CapsLock
    LShift                                         RShift
    (fn) - LCtrl - LOpt - LCmd  ---- RCmd  - ROpt - RCtrl
```
custom layout:
```
    CapsLock
    LShift                                         RShift
    (fn) - LCtrl - LAlt - RCtrl ---- RCtrl - RAlt - RWin
```

---

Remap via Registry Editor:\
cf. https://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html\
LCtrl(1D 00), LAlt(38 00), LWin(5B E0), RCtrl(1D E0), RAlt(38 E0), RWin(5C E0),\
CapsLock(3A 00), Hangul(72 00), ContextMenu(5D E0), MacNumPadEq(59 00)

REGEDIT>>HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/
         Keyboard Layout/Scancode Map

Scancode Map(A2 A1 <- B2 B1)
```
00 00 00 00 00 00 00 00  ;; allways 0
0X 00 00 00 A2 A1 B2 B1  ;; remap X-1 keys  ; AFTER<-BEFORE
A2 A1 B2 B1 A2 A1 B2 B1  ;; AFTER<-BEFORE   ; AFTER<-BEFORE
          ...
00 00 00 00              ;; Null terminator
```
Specifically, see "*CustomLayout.reg*"

---
\
`Win`(remapped as `RCtrl`) is used as `Cmd` in MacOS.
## RemapKeys.ahk
- use modifiers like macOS.
- toggle Hangul/English by tapping `CapsLock`
- `CapsLock` is not only used as Ctrl but also an fn-key for navigation keys.
- some shortcut for WindowsTerminal, Chrome/Edge, MS Office and 한컴오피스

## ControlWindow.ahk
- provides screen control shortcuts such as Rectangle on macOS
- basic command with `LCtrl` and `Alt`
