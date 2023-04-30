; https://soooprmx.com/autohotkey-%ED%95%9C%EC%98%81-%EC%83%81%ED%83%9C-%EA%B0%90%EC%A7%80%ED%95%98%EA%B8%B0/
imm32 := DllCall("LoadLibrary", "Str", "imm32.dll", "Ptr")

IMECheckHangul() { ; 0: 영어, 1: 한글
    hWnd := WinGetID("A")
    ; WinGet 명령은 제거되었고, 창의 핸들을 얻기위해서는 WinGet("A")를 사용한다.
    hIME := DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", hWnd, "UInt")
    temp := A_DetectHiddenWindows
    DetectHiddenWindows(True)
    IME_Hangul := SendMessage(0x0283, 0x0005, 0x0000, , "ahk_id " hIME)
    DetectHiddenWindows(temp)
    return IME_Hangul
}

+Space::CapsLock
*CapsLock up:: {
    if (A_PriorKey == "CapsLock" and IMECheckHangul()
        and not (GetKeyState("Shift") or GetKeyState("Ctrl") or GetKeyState("Alt")
            or GetKeyState("LWin") or GetKeyState("RWin"))) {
        Send "{VK15}"
    }
}
; LButton::

~LShift up:: {
    if (A_PriorKey == "LShift" and not IMECheckHangul()
        and not (GetKeyState("Ctrl") or GetKeyState("Alt")
            or GetKeyState("LWin") or GetKeyState("RWin"))) {
        Send "{VK15}"
    }
}
#HotIf GetKeyState("CapsLock", "P")
Tab::^Tab
Esc::^Esc
`::+^Tab
1::+1
2::+2
3::+3
+3:: Send "+#s"
4::+4
5::+5
6::+6
7::+7
8::+8
9::+9
0::+0
-::+-
=::+=
BS::Del
\::+\
Enter::^Enter
a::Home
b::^Left
c::^c
d::Del
e::End
f::^Right
g::Enter
h::BS
i::Up
j::Left
k::Down
l::Right
m::^m
n::PgDn
o:: Send "{Enter}{Left}"
p::PgUp
q::^q
r::^r
s::Space
t::^t
u::^u
v::^v
w::^w
x::^x
y::^y
z::^z
[::^[
]::^]
`;::+;
'::+'
,::^,
.::^.
/::^/
Space::^Space
Left:: Send "^#{Left}"   ; prev desktop
Right:: Send "^#{Right}" ; next desktop
Up:: Send "#{Tab}"       ; task view
Down:: Send "{LWin}"     ; start memu
#HotIf

; ExitFunc(ExitReason, ExitCode) {
;     DllCall("FreeLibary", "Ptr", imm32)
; }

; OnExit("ExitFunc")
