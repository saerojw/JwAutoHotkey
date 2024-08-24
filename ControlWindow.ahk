;------------------------------------------------------------------------------;
; Modified on 2024/08/25 by Juwon
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
DEBUGGING := 0

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
        xmin: X_min, xcom: X_1_2, xmax: X_max, wmax: W_len, xmargin: max(X_min/2, 4),
        ymin: Y_min, ycom: Y_1_2, ymax: Y_max, hmax: H_len, ymargin: max(Y_min/2, 4)
    }

    AlmostFullRatio := 0.9
    display.list[index].AlmostFullscreen := {
        X: X_min + (1 - AlmostFullRatio) / 2 * W_len,
        Y: Y_min + (1 - AlmostFullRatio) / 2 * H_len,
        W: AlmostFullRatio * W_len,
        H: AlmostFullRatio * H_len
    }

    Steps := 25
    display.list[index].ResizeStep := {
        X: W_len / (Steps * 2),
        Y: H_len / (Steps * 2),
        W: W_len / Steps,
        H: H_len / Steps
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


getMonitorIndex(x, y) {
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

        if (display.list[A_Index].info.xmin <= x
            and display.list[A_Index].info.ymin <= y
            and x < display.list[A_Index].info.xmax
            and y < display.list[A_Index].info.ymax) {
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
        WinGetClientPos &srcX, &srcY, &srcW, &srcH, "A"
        WinRestore "A"  ; maximized window cannot move
        cx := srcX + srcW / 2
        cy := srcY + srcH / 2
        index := getMonitorIndex(cx, cy)

        attachedL := srcX < display.list[index].info.xmin + display.list[index].info.xmargin
        attachedR := srcX + srcW > display.list[index].info.xmax - display.list[index].info.xmargin
        attachedT := srcY < display.list[index].info.ymin + display.list[index].info.ymargin * 3
        attachedB := srcY + srcH > display.list[index].info.ymax - display.list[index].info.ymargin
        fullscreen := attachedL and attachedR and attachedT and attachedB
        if (loc == "Center") {
            tgtX := display.list[index].info.xcom - srcW / 2
            tgtY := display.list[index].info.ycom - srcH / 2
            tgtW := srcW
            tgtH := srcH
        } else if (loc == "HalfCenter") {
            tgtX := display.list[index].LeftHalf.X + display.list[index].LeftHalf.W / 2
            tgtY := display.list[index].LeftHalf.Y
            tgtW := display.list[index].LeftHalf.W
            tgtH := display.list[index].LeftHalf.H
        } else if (loc == "MakeLarger" or loc == "MakeSmaller"
                or loc == "MakeLargerH" or loc == "MakeSmallerH" or loc == "MakeLargerW" or loc == "MakeSmallerW") {
            useMaxW := (attachedL and attachedR and not fullscreen)
            useMaxH := (attachedT and attachedB and not fullscreen)
            both := (loc == "MakeLarger" or loc == "MakeSmaller")
            resizeW := ((both or loc == "MakeLargerW" or loc == "MakeSmallerW") and not useMaxW)
            resizeH := ((both or loc == "MakeLargerH" or loc == "MakeSmallerH") and not useMaxH)

            sign := (loc == "MakeLarger" or loc == "MakeLargerH" or loc == "MakeLargerW") ? 1 : -1
            step := sign ;+ (sign > 0)
            if (resizeW) {
                posW := srcW / display.list[index].ResizeStep.W
                tgtW := (posW + step) * display.list[index].ResizeStep.W
            } else {
                tgtW := useMaxW ? display.list[index].info.wmax : srcW
            }
            if (resizeH) {
                posH := srcH / display.list[index].ResizeStep.H
                tgtH := (posH + step) * display.list[index].ResizeStep.H
            } else {
                tgtH := useMaxH ? display.list[index].info.hmax : srcH
            }
            if (resizeW) {
                if ((attachedL or attachedR) and not fullscreen) {
                    tgtX := attachedL ? display.list[index].info.xmin : display.list[index].info.xmax - tgtW
                } else {
                    posX := srcX / display.list[index].ResizeStep.X
                    tgtX := (posX - step) * display.list[index].ResizeStep.X
                }
            } else {
                tgtX := useMaxW ? display.list[index].info.xmin : srcX
            }
            if (resizeH) {
                if ((attachedT or attachedB) and not fullscreen) {
                    tgtY := attachedT ? display.list[index].info.ymin : display.list[index].info.ymax - tgtH
                } else {
                    posY := srcY / display.list[index].ResizeStep.Y
                    tgtY := (posY - step) * display.list[index].ResizeStep.Y
                }
            } else {
                tgtY := useMaxH ? display.list[index].info.ymin : srcY
            }
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
        err_lv := 2
        if (Abs(X - tgtX) > err_lv or Abs(Y - tgtY) > err_lv or Abs(W - tgtW) > err_lv or Abs(H - tgtH) > err_lv) {
            corX := tgtX + (tgtX - X)
            corY := tgtY
            corW := tgtW + (tgtW - W)
            corH := tgtH + ((tgtY + tgtH) - (Y + H))
            WinMove corX, corY, corW, corH, "A"
        }

        if (DEBUGGING) {
            WinGetClientPos &outX, &outY, &outW, &outH, "A"
            corX := tgtX + (tgtX - X)
            corY := tgtY
            corW := tgtW + (tgtW - W)
            corH := tgtH + ((tgtY + tgtH) - (Y + H))

            sposX := srcX / display.list[index].ResizeStep.X
            sposY := srcY / display.list[index].ResizeStep.Y
            sposW := srcW / display.list[index].ResizeStep.W
            sposH := srcH / display.list[index].ResizeStep.H
            tposX := tgtX / display.list[index].ResizeStep.X
            tposY := tgtY / display.list[index].ResizeStep.Y
            tposW := tgtW / display.list[index].ResizeStep.W
            tposH := tgtH / display.list[index].ResizeStep.H
            oposX := X / display.list[index].ResizeStep.X
            oposY := Y / display.list[index].ResizeStep.Y
            oposW := W / display.list[index].ResizeStep.W
            oposH := H / display.list[index].ResizeStep.H
            cposX := corX / display.list[index].ResizeStep.X
            cposY := corY / display.list[index].ResizeStep.Y
            cposW := corW / display.list[index].ResizeStep.W
            cposH := corH / display.list[index].ResizeStep.H
            fposX := outX / display.list[index].ResizeStep.X
            fposY := outY / display.list[index].ResizeStep.Y
            fposW := outW / display.list[index].ResizeStep.W
            fposH := outH / display.list[index].ResizeStep.H

            MsgBox ('src: ' srcX ' ' srcY ' ' srcX + srcW ' ' srcY + srcH ' | ' srcW ' ' srcH
                '`r`ntgt: ' tgtX ' ' tgtY ' ' tgtX + tgtW ' ' tgtY + tgtH ' | ' tgtW ' ' tgtH
                '`r`nout: ' X ' ' Y ' ' X + W ' ' Y + H ' | ' W ' ' H
                '`r`ncor: ' corX ' ' corY ' ' corX + corW ' ' corY + corH ' | ' corW ' ' corH
                '`r`nout: ' outX ' ' outY ' ' outX + outW ' ' outY + outH ' | ' outW ' ' outH
            '`r`n`r`nattached L: ' attachedL ' R: ' attachedR ' T: ' attachedT ' B: ' attachedB
            '`r`n`r`nsrc: ' Floor(sposX*10) ' ' Floor(sposY*10) ' ' Floor(sposW*10) ' ' Floor(sposH*10)
                '`r`ntgt: ' Floor(tposX*10) ' ' Floor(tposY*10) ' ' Floor(tposW*10) ' ' Floor(tposH*10)
                '`r`nout: ' Floor(oposX*10) ' ' Floor(oposY*10) ' ' Floor(oposW*10) ' ' Floor(oposH*10)
                '`r`ncor: ' Floor(cposX*10) ' ' Floor(cposY*10) ' ' Floor(cposW*10) ' ' Floor(cposH*10)
                '`r`nout: ' Floor(fposX*10) ' ' Floor(fposY*10) ' ' Floor(fposW*10) ' ' Floor(fposH*10)
            )
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
>^!+=:: controlWindow("MakeLargerH")
>^!+-:: controlWindow("MakeSmallerH")

>^!a::
>^!Left:: controlWindow("LeftHalf")
>^!d::
>^!Right:: controlWindow("RightHalf")
>^!w::
>^!Up:: controlWindow("TopHalf")
>^!s::
>^!Down:: controlWindow("BottomHalf")
>^!+s:: controlWindow("HalfCenter")

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

>^!1:: controlWindow("FirstSixth")
>^!2:: controlWindow("SecondSixth")
>^!3:: controlWindow("ThirdSixth")
>^!4:: controlWindow("FourthSixth")
>^!5:: controlWindow("FifthSixth")
>^!6:: controlWindow("LastSixth")

>^!+1:: controlWindow("FirstQuarter")
>^!+2:: controlWindow("SecondQuarter")
>^!+3:: controlWindow("ThirdQuarter")
>^!+4:: controlWindow("LastQuarter")

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
!+=:: controlWindow("MakeLargerH")
!+-:: controlWindow("MakeSmallerH")

!a::
!Left:: controlWindow("LeftHalf")
!d::
!Right:: controlWindow("RightHalf")
!w::
!Up:: controlWindow("TopHalf")
!s::
!Down:: controlWindow("BottomHalf")
!+s:: controlWindow("HalfCenter")

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

!1:: controlWindow("FirstSixth")
!2:: controlWindow("SecondSixth")
!3:: controlWindow("ThirdSixth")
!4:: controlWindow("FourthSixth")
!5:: controlWindow("FifthSixth")
!6:: controlWindow("LastSixth")

!+1:: controlWindow("FirstQuarter")
!+2:: controlWindow("SecondQuarter")
!+3:: controlWindow("ThirdQuarter")
!+4:: controlWindow("LastQuarter")
#HotIf