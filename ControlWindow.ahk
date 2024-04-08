;------------------------------------------------------------------------------;
; Modified on 2022/02/16 by Juwon
; e-mail: saero94j@gmail.com
;
; Script for multi-tasking similar to magnet on macOS
; Written based on AutoHotkey v2.0.2
; Add shortcut to control window size
;
;;;; Symbols ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; !(Alt), ^(Ctrl), +(Shift), #(vk5B;LWin or vk5C;RWin), <*(Left*), >*(Right*)
; vk15(HanEng), vk19(Hanja), AppsKey(ContextMenu), BS(Backspace)
;------------------------------------------------------------------------------;
display := { Count: 0, list: [] }

min(A, B) {
    return A < B ? A : B
}

max(A, B) {
    return A > B ? A : B
}

clamp(X, A, B) {
    return min(max(X, A), B)
}

internal_division(A, B, ratio) {
    return (1 - ratio) * A + ratio * B
}


updateMonitorTarget(index) {
    global display

    MonitorGetWorkArea(index, &X_min, &Y_min, &X_max, &Y_max)
    X_1_2 := internal_division(X_min, X_max, 1 / 2)
    X_1_3 := internal_division(X_min, X_max, 1 / 3)
    X_2_3 := internal_division(X_min, X_max, 2 / 3)
    X_1_4 := internal_division(X_min, X_max, 1 / 4)
    X_3_4 := internal_division(X_min, X_max, 3 / 4)
    W_len := X_max - X_min
    W_1_2 := W_len / 2
    W_1_3 := W_len / 3
    W_2_3 := W_1_3 * 2
    W_1_4 := W_len / 4
    W_3_4 := W_1_4 * 3
    Y_1_2 := internal_division(Y_min, Y_max, 1 / 2)
    Y_1_3 := internal_division(Y_min, Y_max, 1 / 3)
    Y_2_3 := internal_division(Y_min, Y_max, 2 / 3)
    Y_1_4 := internal_division(Y_min, Y_max, 1 / 4)
    Y_3_4 := internal_division(Y_min, Y_max, 3 / 4)
    H_len := Y_max - Y_min
    H_1_2 := H_len / 2
    H_1_3 := H_len / 3
    H_2_3 := H_1_3 * 2
    H_1_4 := H_len / 4
    H_3_4 := H_1_4 * 3
    vertical := W_len < H_len
    display.list[index].id := X_min . Y_min . X_max . Y_max
    display.list[index].info := {
        xmin: X_min, xcom: X_1_2, xmax: X_max, wmax: W_len,
        ymin: Y_min, ycom: Y_1_2, ymax: Y_max, hmax: H_len
    }

    AlmostFullRatio := 0.9
    display.list[index].AlmostFullscreen := {
        X: X_min + (1 - AlmostFullRatio) / 2 * W_len,
        Y: Y_min + (1 - AlmostFullRatio) / 2 * H_len,
        W: AlmostFullRatio * W_len,
        H: AlmostFullRatio * H_len
    }

    display.list[index].LeftHalf := { X: X_min, Y: Y_min, W: W_1_2, H: H_len }
    display.list[index].RightHalf := { X: X_1_2, Y: Y_min, W: W_1_2, H: H_len }
    display.list[index].TopHalf := { X: X_min, Y: Y_min, W: W_len, H: H_1_2 }
    display.list[index].BottomHalf := { X: X_min, Y: Y_1_2, W: W_len, H: H_1_2 }

    display.list[index].TopLeft := { X: X_min, Y: Y_min, W: W_1_2, H: H_1_2 }
    display.list[index].TopRight := { X: X_1_2, Y: Y_min, W: W_1_2, H: H_1_2 }
    display.list[index].BottomLeft := { X: X_min, Y: Y_1_2, W: W_1_2, H: H_1_2 }
    display.list[index].BottomRight := { X: X_1_2, Y: Y_1_2, W: W_1_2, H: H_1_2 }

    if not vertical {
        display.list[index].info.wmin := W_1_4
        display.list[index].info.hmin := H_1_3

        display.list[index].LeftThird := { X: X_min, Y: Y_min, W: W_1_3, H: H_len }
        display.list[index].CenterThird := { X: X_1_3, Y: Y_min, W: W_1_3, H: H_len }
        display.list[index].RightThird := { X: X_2_3, Y: Y_min, W: W_1_3, H: H_len }

        display.list[index].LeftTwoThird := { X: X_min, Y: Y_min, W: W_2_3, H: H_len }
        display.list[index].RightTwoThird := { X: X_1_3, Y: Y_min, W: W_2_3, H: H_len }

        display.list[index].FirstQuarter := { X: X_min, Y: Y_min, W: W_1_4, H: H_len }
        display.list[index].SecondQuarter := { X: X_1_4, Y: Y_min, W: W_1_4, H: H_len }
        display.list[index].ThirdQuarter := { X: X_1_2, Y: Y_min, W: W_1_4, H: H_len }
        display.list[index].LastQuarter := { X: X_3_4, Y: Y_min, W: W_1_4, H: H_len }

        display.list[index].LeftThreeQuarter := { X: X_min, Y: Y_min, W: W_3_4, H: H_len }
        display.list[index].RightThreeQuarter := { X: X_1_4, Y: Y_min, W: W_3_4, H: H_len }

        display.list[index].FirstSixth := { X: X_min, Y: Y_min, W: W_1_3, H: H_1_2 }
        display.list[index].SecondSixth := { X: X_1_3, Y: Y_min, W: W_1_3, H: H_1_2 }
        display.list[index].ThirdSixth := { X: X_2_3, Y: Y_min, W: W_1_3, H: H_1_2 }
        display.list[index].FourthSixth := { X: X_min, Y: Y_1_2, W: W_1_3, H: H_1_2 }
        display.list[index].FifthSixth := { X: X_1_3, Y: Y_1_2, W: W_1_3, H: H_1_2 }
        display.list[index].LastSixth := { X: X_2_3, Y: Y_1_2, W: W_1_3, H: H_1_2 }
    } else {
        display.list[index].info.wmin := W_1_3
        display.list[index].info.hmin := H_1_4

        display.list[index].LeftThird := { X: X_min, Y: Y_min, W: W_len, H: H_1_3 }
        display.list[index].CenterThird := { X: X_min, Y: Y_1_3, W: W_len, H: H_1_3 }
        display.list[index].RightThird := { X: X_min, Y: Y_2_3, W: W_len, H: H_1_3 }

        display.list[index].LeftTwoThird := { X: X_min, Y: Y_min, W: W_len, H: H_2_3 }
        display.list[index].RightTwoThird := { X: X_min, Y: Y_1_3, W: W_len, H: H_2_3 }

        display.list[index].FirstQuarter := { X: X_min, Y: Y_min, W: W_len, H: H_1_4 }
        display.list[index].SecondQuarter := { X: X_min, Y: Y_1_4, W: W_len, H: H_1_4 }
        display.list[index].ThirdQuarter := { X: X_min, Y: Y_1_2, W: W_len, H: H_1_4 }
        display.list[index].LastQuarter := { X: X_min, Y: Y_3_4, W: W_len, H: H_1_4 }

        display.list[index].LeftThreeQuarter := { X: X_min, Y: Y_min, W: W_len, H: H_3_4 }
        display.list[index].RightThreeQuarter := { X: X_min, Y: Y_1_4, W: W_len, H: H_3_4 }

        display.list[index].FirstSixth := { X: X_min, Y: Y_min, W: W_1_2, H: H_1_3 }
        display.list[index].SecondSixth := { X: X_min, Y: Y_1_3, W: W_1_2, H: H_1_3 }
        display.list[index].ThirdSixth := { X: X_min, Y: Y_2_3, W: W_1_2, H: H_1_3 }
        display.list[index].FourthSixth := { X: X_1_2, Y: Y_min, W: W_1_2, H: H_1_3 }
        display.list[index].FifthSixth := { X: X_1_2, Y: Y_1_3, W: W_1_2, H: H_1_3 }
        display.list[index].LastSixth := { X: X_1_2, Y: Y_2_3, W: W_1_2, H: H_1_3 }
    }
    return
}


initializeMonitorTarget(Count) {
    global display

    display := { Count: Count, list: [] }
    Loop Count {
        display.list.Push({})
        updateMonitorTarget(A_Index)
    }
    return
}


getMonitorIndex(xcow, ycow) {
    global display

    Count := MonitorGetCount()
    if not (display.Count == Count) {
        display.Count := Count
        initializeMonitorTarget(Count)
    }

    Loop Count {
        MonitorGetWorkArea A_Index, &X_min, &Y_min, &X_max, &Y_max
        MonitorID := X_min . Y_min . X_max . Y_max
        if not (display.list[A_Index].id == MonitorID) {
            updateMonitorTarget(A_Index)
        }

        if (display.list[A_Index].info.xmin < xcow
            and display.list[A_Index].info.ymin < ycow
            and xcow < display.list[A_Index].info.xmax
            and ycow < display.list[A_Index].info.ymax) {
            return A_Index
        }
    }

    Primary_Index := MonitorGetPrimary()
    return Primary_Index
}


;;; controlWindow
controlWindow(loc) {
    global display

    if (loc == "NextDisplay") {
        SendInput "{RWinDown}{ShiftDown}{Right}{ShiftUp}{RWinUp}"
    } else if (loc == "PreviousDisplay") {
        SendInput "{RWinDown}{ShiftDown}{Left}{ShiftUp}{RWinUp}"
    } else if (loc == "Fullscreen") {
        WinMaximize "A"
    } else {
        Title := WinGetTitle("A")
        if (Title == "" or Title == "Program Manager") {
            return
        }
        WinRestore "A"  ; maximized window cannot move
        WinGetClientPos &srcX, &srcY, &srcW, &srcH, "A"
        xcow := srcX + srcW / 2
        ycow := srcY + srcH / 2
        index := getMonitorIndex(xcow, ycow)

        EdgeL := srcX < display.list[index].info.xmin + 4
        EdgeR := srcX + srcW > display.list[index].info.xmax - 4
        EdgeT := srcY < display.list[index].info.ymin + 4
        EdgeB := srcY + srcH > display.list[index].info.ymax - 4
        fullscreen := EdgeL and EdgeR and EdgeT and EdgeB
        if (loc == "Center") {
            tgtX := display.list[index].info.xcom - srcW / 2
            tgtY := display.list[index].info.ycom - srcH / 2
            tgtW := srcW
            tgtH := srcH
        } else if (loc == "MakeLarger" or loc == "MakeSmaller") {
            steps := 24
            dW := (EdgeL and EdgeR and not fullscreen) ? 0 : display.list[index].info.wmax / steps
            dH := (EdgeT and EdgeB and not fullscreen) ? 0 : display.list[index].info.hmax / steps
            dX := (EdgeR and not fullscreen) ? -dW : -dW / 2
            dY := (EdgeB and not fullscreen) ? -dH : -dH / 2
            sign := loc == "MakeLarger" ? 1 : -1
            tgtW := srcW + sign * dW
            tgtH := srcH + sign * dH
            tgtX := srcX + (1 - ((EdgeL + fullscreen) = 1)) * sign * dX
            tgtY := srcY + (1 - ((EdgeT + fullscreen) = 1)) * sign * dY
        } else {
            tgtX := display.list[index].%loc%.X
            tgtY := display.list[index].%loc%.Y
            tgtW := display.list[index].%loc%.W
            tgtH := display.list[index].%loc%.H
        }
        tgtW := Round(clamp(tgtW, display.list[index].info.wmin, display.list[index].info.wmax))
        tgtH := Round(clamp(tgtH, display.list[index].info.hmin, display.list[index].info.hmax))
        tgtX := Round(clamp(tgtX, display.list[index].info.xmin, display.list[index].info.xmax - tgtW))
        tgtY := Round(clamp(tgtY, display.list[index].info.ymin, display.list[index].info.ymax - tgtH))
        WinMove tgtX, tgtY, tgtW, tgtH, "A"

        ; correction
        WinGetClientPos &X, &Y, &W, &H, "A"
        if not (X == tgtX and Y == tgtY and W == tgtW and H == tgtH) {
            tgtXcow := tgtX + tgtW / 2
            tgtYcow := tgtY + tgtH / 2
            Xcow := X + W / 2
            Ycow := Y + H / 2
            dW := tgtW - W
            dH := tgtH - H
            dX := (tgtXcow - Xcow - dW) / 2 + (dW < 0 ? dW : 0)
            dY := (tgtYcow - Ycow - dH / 2) / 2
            corX := Round(clamp(tgtX + dX, display.list[index].info.xmin + dX, display.list[index].info.xmax - W))
            corY := Round(clamp(tgtY + dY, display.list[index].info.ymin + dY, display.list[index].info.ymax - H))
            corW := tgtW + Abs(dW)
            corH := tgtH + Abs(dH)
            WinMove corX, corY, corW, corH, "A"
        }
    }
    return
}

; shortcuts
>^!+z::
>^!+Down::
>^!+Left:: controlWindow("PreviousDisplay")
>^!z::
>^!+Up::
>^!+Right:: controlWindow("NextDisplay")
>^!m:: #Down
;Send "#{Tab}"     ; task view

>^!Enter:: controlWindow("AlmostFullscreen")
>^!=:: controlWindow("MakeLarger")
>^!-:: controlWindow("MakeSmaller")

>^!a::
>^!Left:: controlWindow("LeftHalf")
>^!d::
>^!Right:: controlWindow("RightHalf")
>^!w::
>^!Up:: controlWindow("TopHalf")
>^!s::
>^!Down:: controlWindow("BottomHalf")
>^!+s::{
    controlWindow("LeftHalf")
    controlWindow("Center")
}

>^!+q:: controlWindow("TopLeft")
>^!+e:: controlWindow("TopRight")
>^!+a:: controlWindow("BottomLeft")
>^!+d:: controlWindow("BottomRight")

>^!+x:: controlWindow("LeftThird")
>^!+c:: controlWindow("CenterThird")
>^!+v:: controlWindow("RightThird")

>^!x:: controlWindow("LeftTwoThird")
>^!c:: controlWindow("Center")
>^!v:: controlWindow("RightTwoThird")

>^!q:: controlWindow("LeftThreeQuarter")
>^!f:: controlWindow("Fullscreen")
>^!e:: controlWindow("RightThreeQuarter")

>^!1:: controlWindow("FirstQuarter")
>^!2:: controlWindow("SecondQuarter")
>^!3:: controlWindow("ThirdQuarter")
>^!4:: controlWindow("LastQuarter")

>^!5:: controlWindow("FirstSixth")
>^!6:: controlWindow("SecondSixth")
>^!7:: controlWindow("ThirdSixth")
>^!8:: controlWindow("FourthSixth")
>^!9:: controlWindow("FifthSixth")
>^!0:: controlWindow("LastSixth")

#HotIf GetKeyState("CapsLock", "P")
; shortcuts
!+z::
!+Down::
!+Left:: controlWindow("PreviousDisplay")
!z::
!+Up::
!+Right:: controlWindow("NextDisplay")
!m:: #Down
;Send "#{Tab}"     ; task view

!Enter:: controlWindow("AlmostFullscreen")
!=:: controlWindow("MakeLarger")
!-:: controlWindow("MakeSmaller")

!a::
!Left:: controlWindow("LeftHalf")
!d::
!Right:: controlWindow("RightHalf")
!w::
!Up:: controlWindow("TopHalf")
!s::
!Down:: controlWindow("BottomHalf")
!+s::{
    controlWindow("LeftHalf")
    controlWindow("Center")
}

!+q:: controlWindow("TopLeft")
!+e:: controlWindow("TopRight")
!+a:: controlWindow("BottomLeft")
!+d:: controlWindow("BottomRight")

!+x:: controlWindow("LeftThird")
!+c:: controlWindow("CenterThird")
!+v:: controlWindow("RightThird")

!x:: controlWindow("LeftTwoThird")
!c:: controlWindow("Center")
!v:: controlWindow("RightTwoThird")

!q:: controlWindow("LeftThreeQuarter")
!f:: controlWindow("Fullscreen")
!e:: controlWindow("RightThreeQuarter")

!1:: controlWindow("FirstQuarter")
!2:: controlWindow("SecondQuarter")
!3:: controlWindow("ThirdQuarter")
!4:: controlWindow("LastQuarter")

!5:: controlWindow("FirstSixth")
!6:: controlWindow("SecondSixth")
!7:: controlWindow("ThirdSixth")
!8:: controlWindow("FourthSixth")
!9:: controlWindow("FifthSixth")
!0:: controlWindow("LastSixth")
#HotIf