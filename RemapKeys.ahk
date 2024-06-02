;------------------------------------------------------------------------------;
; Modified on 2023/05/31 by Juwon
; e-mail: saero94j@gmail.com
;
; Script for using macOS layout keyboard on Windows.
; Written based on AutoHotkey v2.0.2
;
; Windows layout:
;     CapsLock
;     LShift                                         RShift
;     (fn) - LCtrl - LWin - LAlt  ---- RAlt  - RWin - RCtrl
;
; MacOS layout:
;     CapsLock
;     LShift                                         RShift
;     (fn) - LCtrl - LOpt - LCmd  ---- RCmd  - ROpt - RCtrl
;
; CapsLock is not only used as Ctrl but also an fn-key for navigation keys.
; Win-key is used as Cmd in MacOS
;
; custom layout:
;     CapsLock (or RCtrl)
;     LShift                                         RShift
;     (fn) - RCtrl - LAlt - LCtrl ---- RWin - RWin - RCtrl
;
;;; Remap via Registry Editor ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; #REMARK: I choose this for using mouse gesture button
; Windows keyboard scancode in registry
; cf. https://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html
; LCtrl(1D 00), LAlt(38 00), LWin(5B E0), RCtrl(1D E0), RAlt(38 E0), RWin(5C E0)
; CapsLock(3A 00), Hangul(72 00), ContextMenu(5D E0), MacNumPadEq(59 00)
;
; REGEDIT>>HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/
;          Keyboard Layout/Scancode Map
;
; Scancode Map(A2 A1 <- B2 B1)
; 00 00 00 00 00 00 00 00  ;; allways 0
; 0X 00 00 00 A2 A1 B2 B1  ;; remap X-1 keys  ; AFTER<-BEFORE
; A2 A1 B2 B1 A2 A1 B2 B1  ;; AFTER<-BEFORE   ; AFTER<-BEFORE
;           ...
; 00 00 00 00              ;; Null terminator
;
;;; Symbols ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; !(Alt), ^(Ctrl), +(Shift), #(VK5B;LWin or VK5C;RWin), <*(Left*), >*(Right*),
; VK15(Hangul), VK17(Junja), VK19(Hanja), AppsKey(ContextMenu), BS(Backspace),
; NumpadClear(=)
;
;;; Documents ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; https://www.autohotkey.com/docs/v2/
;
;------------------------------------------------------------------------------;
SetStoreCapsLockMode False

;;; Space
+Space::CapsLock
>^Space::VK15   ; Hangul
#Space::VK19    ; Hanja
; ^!t::WinSetAlwaysOnTop -1, "A" ; toggle AlwaysOnTop -> powertoys
!Space::#s      ; search
<^Space::#Space ; search -> powertoys run
; >^<^Space::#.   ; Emoji
; >^<^q:: DllCall("LockWorkStation")    ; Lock Screen


;;; BS/Del
>^BS:: Send "{Del}"          ; delete
!BS:: Send "^{BS}"           ; delete a prev word
>^!BS:: Send "+^{Right}{BS}" ; delete a next word <- prevent ^!Del
!Del:: Send "^{Del}"         ; delete a next word
#BS::
<^BS:: Send "+{Home}{Del}"   ; delete line till cursor
>^<^BS::
#Del::
<^Del:: Send "+{End}{Del}"   ; delete line from cursor


;;; Windows key
<^Tab::AltTab       ; alt tap
<^`::ShiftAltTab    ; shift alt tap
>^`::+^Tab

#+::^+
#-::^-
#/::^/
#-::^-
#Enter::^Enter
#o::^o
#[::
^[:: {
    if WinActive("ahk_exe Code.exe") {
        Send "^["
    } else {
        Send "!{Left}"  ; go back
    }
}
#]::
^]::{
    if WinActive("ahk_exe Code.exe") {
        Send "^]"
    } else {
        Send "!{Right}"  ; go next
    }
}
#p::{
    if WinActive("ahk_exe Code.exe") {
        Send "^p"
    } else {
        Send "{RWinDown}p{RWinUp}"
    }
}
#\::^\
#'::^'
<^c:: {     ; copy
    if WinActive("ahk_exe KakaoTalk.exe") {
        Send "^c"
    } else {
        Send "^{Ins}"
    }
}
<^v:: Send "+{Ins}"     ; paste
+<^v:: Send "#v"        ; clipboard
<^m:: WinMinimize "A"   ; minimize window
<^q:: Send "!{F4}"      ; close window


;;; navigation keys
^Left:: Send "{Home}"
^Right:: Send "{End}"
!Left:: Send "^{Left}"
!Right:: Send "^{Right}"
<^Up:: Send "^{Home}"
<^Down:: Send "^{End}"
>^Up:: Send "{PgUp}"
>^Down:: Send "{PgDn}"
+^Left:: Send "+{Home}"
+^Right:: Send "+{End}"
+!Left:: Send "+^{Left}"
+!Right:: Send "+^{Right}"
+<^Up:: Send "+^{Home}"
+<^Down:: Send "+^{End}"
+>^Up:: Send "+{PgUp}"
+>^Down:: Send "+{PgDn}"

;;;; GetKeyState("RCtrl", "P")
>^a::Home
>^b:: {
    if WinActive("ahk_exe WindowsTerminal.exe") {
        Send "^b"
    } else {
        Send "{Left}"
    }
}
>^<^b::^Left
>^d::Del
>^e::End
>^f::Right
>^<^f::^Right
>^g::Enter
>^h::BS
>^i::Up
>^j::Left
>^k::Down
>^l::Right
>^n::PgDn
>^p::PgUp
>^r::F9
>^+r::F5
>^=:: {
    if WinActive("ahk_exe WINWORD.EXE") or WinActive("ahk_exe POWERPNT.EXE") {
        Send "!nei"          ; insert equation
    } else {
        Send "="
    }
}


;;; shourcut
+<^3:: Send "+#s"   ; screenshot
+!^m:: {
    if WinExist("Parsify Desktop") {
        if WinActive("Parsify Desktop") {
            WinMinimize("Parsify Desktop")
        } else {
            WinActivate
            WinSetAlwaysOnTop 1, "A"
        }
    } else {
        Run "C:\Users\User\AppData\Local\Programs\parsify-desktop\Parsify Desktop.exe"
        WinSetAlwaysOnTop 1, "A"
    }
}
+!^t:: {
    if WinExist("ahk_exe WindowsTerminal.exe") {
        WinActivate
    } else {
        Run "explorer.exe shell:appsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App"
    }
}
; +!^n:: {
;     if WinExist("ahk_exe Notion.exe") {
;         WinActivate
;     } else {
;         Run "C:\Users\User\AppData\Local\Programs\parsify-desktop\Parsify Notion.exe"
;     }
; }