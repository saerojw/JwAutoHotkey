#HotIf WinActive("ahk_exe PowerToys.Peek.UI.exe")
Space:: !Space


;;; vscode
#HotIf WinActive("ahk_exe Code.exe")
#]::^]
#[::^[
#p::^p


;;; windows terminal
#HotIf WinActive("ahk_exe WindowsTerminal.exe")
>^b:: Send "^b"

<^a:: Send "+^a"    ; select all
<^f:: Send "+^f"    ; find
<^d:: Send "+!="    ; split vertically
+<^d:: Send "+!-"   ; split horizontally
<^n:: Send "+^n"    ; new window
<^t:: Send "+^t"    ; new tab
<^w:: Send "+^w"    ; close splited plane
!<^w:: Send "^{F4}" ; close tab
+<^w:: Send "!{F4}" ; close window

<^Up:: Send "+^{Home}"
<^Down:: Send "+^{End}"
!<^Left:: Send "!{Left}"
!<^Right:: Send "!{Right}"
!<^Up:: Send "!{Up}"
!<^Down:: Send "!{Down}"

;;; explorer
#HotIf WinActive("ahk_exe Explorer.EXE") or WinActive("ahk_exe explorer.exe")
Enter:: {
    ClassNN := ControlGetClassNN(ControlGetFocus("A"))
    ; select file or folder in explorer or desktop
    if (InStr(ClassNN, "DirectUIHWND")>0 or ClassNN = "SysListView321") {
        Send "{F2}"     ; rename
    } else {
        Send "{Enter}"  ; done
    }
}
#o::
<^o:: Send "{Enter}"    ; open
#i::
<^i:: Send "!{Enter}"   ; information
<^d:: Send "^c^v"       ; duplicate
#BS::
<^BS:: Send "{Del}"     ; delete
Space:: {
    ClassNN := ControlGetClassNN(ControlGetFocus("A"))
    ; select file or folder in explorer or desktop
    if (InStr(ClassNN, "DirectUIHWND")>0 or ClassNN = "SysListView321") {
        Send "^{Space}"
    } else {
        Send "{Space}"
    }
}


;;; open current web page on the another browser (chrome <-> edge)
#HotIf WinActive("ahk_exe chrome.exe")
!<^n:: {
    Send "^l"           ; select address
    sleep 200
    Send "^c"           ; copy
    Run "msedge.exe --new-window " A_Clipboard
}

#HotIf WinActive("ahk_exe msedge.exe")
!<^n:: {
    Send "^l"           ; select address
    sleep 200
    Send "^c"           ; copy
    Run "chrome.exe --new-window " A_Clipboard
}

#HotIf not (WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe"))
+<^z::^y    ; redo


;;; microsoft office
#HotIf WinActive("ahk_exe EXCEL.EXE")
+<^s:: Send "{F12}"         ; save as
#0::
<^0:: Send "!wj"            ; view -> page width
#-::
<^-:: Send "^{WheelDown}"   ; zoom out
#=::
<^=:: Send "^{WheelUp}"     ; zoom in
!Enter:: Send "!{Enter}"    ; new line in cell

#HotIf WinActive("ahk_exe POWERPNT.EXE")
>^=:: Send "!nei"           ; insert equation
+<^s:: Send "{F12}"         ; save as
#0::
<^0:: Send "!wf"            ; view >> fit to window
#-::
<^-:: Send "^{WheelDown}"   ; zoom out
#=::
<^=:: Send "^{WheelUp}"     ; zoom in

#HotIf WinActive("ahk_exe WINWORD.EXE")
>^=:: Send "!nei"           ; insert equation
+<^s:: Send "{F12}"         ; save as
#0::
<^0:: Send "!wi"            ; view -> 100%
#-::
<^-:: Send "^{WheelDown}"   ; zoom out
#=::
<^=:: Send "^{WheelUp}"     ; zoom in

;;; 한컴오피스 한글
#HotIf WinActive("ahk_exe Hwp.exe")
#0::
<^0:: Send "^gw"            ; 폭 맞춤
#-::
<^-:: Send "^{WheelDown}"   ; zoom out
#=::
<^=:: Send "^{WheelUp}"     ; zoom in


#HotIf