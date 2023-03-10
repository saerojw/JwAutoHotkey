;------------------------------------------------------------------------------;
; Modified on 2022/02/26 by Juwon
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
;     CapsLock
;     LShift                                         RShift
;     (fn) - LCtrl - LAlt - RCtrl ---- RCtrl - RAlt - RWin
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
+Space::Enter
<^Space::VK15   ; Hangul
!Enter::VK19    ; Hanja
; !Space::WinSetAlwaysOnTop -1, "A" ; toggle AlwaysOnTop
!Space::^#t     ; WinSetAlwaysOnTop with powertoys
>^Space::#s     ; search
<^>^Space::#.   ; Emoji


;;; BS/Del
<^BS::Send "{Del}"          ; delete
!BS::Send "^{BS}"           ; delete a prev word
<^!BS::Send "+^{Right}{BS}" ; delete a next word <- prevent ^!Del
!Del::Send "^{Del}"         ; delete a next word
>^BS::Send "+{Home}{Del}"   ; delete line till cursor
<^>^BS::
>^Del::Send "+{End}{Del}"   ; delete line from cursor


;;; Windows key
>^Tab::AltTab       ; alt tap
>^`::ShiftAltTab    ; shift alt tap

>^[::!Left  ; go back
>^]::!Right ; go next
>^c::^Ins   ; copy
>^v::+Ins   ; paste
>^m::WinMinimize "A"    ; minimize window
>^q::!F4    ; close window
+>^z::^y    ; redo


;;; navigation keys
^Left::Home
^Right::End
!Left::^Left
!Right::^Right
>^Up::^Home
>^Down::^End
<^Up::PgUp
<^Down::PgDn


;;; CapsLock
+Space::CapsLock
*CapsLock up::{
    if (A_PriorKey=="CapsLock"
        and not (GetKeyState("Shift") or GetKeyState("Ctrl") or GetKeyState("Alt")
                 or GetKeyState("LWin") or GetKeyState("RWin"))) {
        Send "{VK15}"
    }
}
#HotIf GetKeyState("CapsLock", "P")
Tab::^Tab
Esc::^Esc
`::+^Tab
1::^1
2::^2
3::^3
4::^4
5::^5
6::^6
7::^7
8::^8
9::^9
0::^0
BS::Del
\::^\
Enter::^Enter
a::Home
b::^Left
c::^c
d::^Del
e::End
f::^Right
g::^g
h::BS
i::Up
j::Left
k::Down
l::Right
m::^m
n::PgDn
o::Enter
p::PgUp
q::^q
r::^r
s::^s
t::^t
+t::{   ; quick translate as you read with DeepL
    if WinActive("ahk_exe chrome.exe") {
        Send "+^y"
    } else {
        Send "^#!t"
    }
}
+>^t::+^!#t ; translate text within the DeepL app
u::^u
v::^v
w::^w
x::^x
y::^y
z::^z
[::^[
]::^]
`;::^;
'::^'
,::^,
.::^.
/::^/
Space::Send "{VK15}"    ; Hangul
Left::Send "^#{Left}"   ; prev desktop
Right::Send "^#{Right}" ; next desktop
Up::Send "#{Tab}"       ; task view
Down::Send "{LWin}"     ; start memu


;;; windows terminal
#HotIf WinActive("ahk_exe WindowsTerminal.exe")
>^a::Send "+^a"     ; select all
>^f::Send "+^f"     ; find
>^d::Send "+!="     ; split vertically
+>^d::Send "+!-"    ; split horizontally
>^t::Send "+^t"     ; new tab
>^w::Send "+^w"     ; close splited plane
!>^w::Send "^{F4}"  ; close tab
+>^w::Send "!{F4}"  ; close window

>^Up::Send "+^{Home}"
>^Down::Send "+^{End}"
!>^Left::Send "!{Left}"
!>^Right::Send "!{Right}"
!>^Up::Send "!{Up}"
!>^Down::Send "!{Down}"


;;; explorer
#HotIf WinActive("ahk_exe Explorer.EXE")
Enter::{
    ClassNN := ControlGetClassNN(ControlGetFocus("A"))
    ; select file or folder in explorer or desktop
    if (ClassNN="DirectUIHWND2" or ClassNN="SysListView321") {
        Send "{F2}"     ; rename
    } else {
        Send "{Enter}"  ; done
    }
}
>^o::Send "{Enter}"     ; open
>^i::Send "!{Enter}"    ; information
>^d::Send "^c^v"        ; duplicate
>^BS::Send "{Del}"      ; delete


;;; open current web page on the another browser (chrome <-> edge)
#HotIf WinActive("ahk_exe chrome.exe")
!>^n::{
    Send "^l"           ; copy address
    sleep 10
    Send "^c"
    Run "msedge.exe --new-window " A_Clipboard
}

#HotIf WinActive("ahk_exe msedge.exe")
!>^n::{
    Send "^l"           ; copy address
    sleep 10
    Send "^c"
    Run "chrome.exe --new-window " A_Clipboard
}


;;; microsoft office
#HotIf WinActive("ahk_exe EXCEL.EXE")
+>^s::Send "{F12}"          ; save as
>^0::Send "!wj"             ; view -> page width
>^-::Send "^{WheelDown}"    ; zoom out
>^=::Send "^{WheelUp}"      ; zoom in

#HotIf WinActive("ahk_exe POWERPNT.EXE")
+>^4::Send "!nei"           ; insert equation
+>^s::Send "{F12}"          ; save as
>^0::Send "!wf"             ; view >> fit to window
>^-::Send "^{WheelDown}"    ; zoom out
>^=::Send "^{WheelUp}"      ; zoom in

#HotIf WinActive("ahk_exe WINWORD.EXE")
+>^4::Send "!nei"           ; insert equation
+>^s::Send "{F12}"          ; save as
>^0::Send "!wi"             ; view -> 100%
>^-::Send "^{WheelDown}"    ; zoom out
>^=::Send "^{WheelUp}"      ; zoom in


;;; ??????????????? ??????
#HotIf WinActive("ahk_exe Hwp.exe")
>^0::Send "^gw"             ; ??? ??????
>^-::Send "^{WheelDown}"    ; zoom out
>^=::Send "^{WheelUp}"      ; zoom in
#HotIf