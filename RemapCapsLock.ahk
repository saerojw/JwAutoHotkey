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

Lclick := False
~+LButton:: global Lclick := True

ThisLShift := True, t_LShiftDown := 0
~LShift:: {
    global ThisLShift
    if ThisLShift {
        global t_LShiftDown := A_TickCount
    }
    ThisLShift := False
}
LShift up:: {
    global Lclick, t_LShiftDown, ThisLShift
    t_LShiftPressed := A_TickCount - t_LShiftDown
    if (A_PriorKey == "LShift" and not IMECheckHangul() and not Lclick and t_LShiftPressed < 200
        and not (GetKeyState("Ctrl") or GetKeyState("Alt") or GetKeyState("LWin") or GetKeyState("RWin"))) {
        Send "{VK15}"
    }
    Lclick := False
    ThisLShift := True
}

ThisRCtrl := True, t_RCtrlDown := 0
~RControl:: {
    global ThisRCtrl
    if ThisRCtrl {
        global t_RCtrlDown := A_TickCount
    }
    ThisRCtrl := False
}
RControl up:: {
    global Lclick, t_RCtrlDown, ThisRCtrl
    t_RCtrlPressed := A_TickCount - t_RCtrlDown
    if (A_PriorKey == "RControl" and IMECheckHangul() and not Lclick and t_RCtrlPressed < 200
        and not (GetKeyState("Shift") or GetKeyState("Alt") or GetKeyState("LWin") or GetKeyState("RWin"))) {
        Send "{VK15}"
    }
    Lclick := False
    ThisRCtrl := True
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
-::^-
=:: {
    if WinActive("ahk_exe WINWORD.EXE") or WinActive("ahk_exe POWERPNT.EXE") {
        Send "!nei"          ; insert equation
    } else {
        Send "="
    }
}
BS::Del
\::^\
Enter::^Enter
a::Home
b:: {
    if WinActive("ahk_exe WindowsTerminal.exe") {
        Send "^b"
    } else {
        Send "{Left}"
    }
}
<^b::^Left
c::^c
d::Del
e::End
f::Right
<^f::^Right
g::Enter
h::BS
i::Up
j::Left
k::Down
l::Right
m::^m
n::PgDn
o::^o
p::PgUp
q::^q
r::F9
+r::F5
s::^s
t::^t
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
Space::VK15