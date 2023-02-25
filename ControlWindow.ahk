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
display := [{Count: 0, Restore:{X: "", Y: "", W: "", H: "", standby: False}}]

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
    return (1-ratio)*A + ratio*B
}


updateMonitorTarget(index) {
    global display

    MonitorGetWorkArea(index, &X_min, &Y_min, &X_max, &Y_max)
    X_1_2 := internal_division(X_min, X_max, 1/2)
    X_1_3 := internal_division(X_min, X_max, 1/3)
    X_2_3 := internal_division(X_min, X_max, 2/3)
    X_1_4 := internal_division(X_min, X_max, 1/4)
    X_3_4 := internal_division(X_min, X_max, 3/4)
    W_len := X_max - X_min
    W_1_2 := W_len/2
    W_1_3 := W_len/3
    W_2_3 := W_1_3*2
    W_1_4 := W_len/4
    W_3_4 := W_1_4*3
    Y_1_2 := internal_division(Y_min, Y_max, 1/2)
    Y_1_3 := internal_division(Y_min, Y_max, 1/3)
    Y_2_3 := internal_division(Y_min, Y_max, 2/3)
    Y_1_4 := internal_division(Y_min, Y_max, 1/4)
    Y_3_4 := internal_division(Y_min, Y_max, 3/4)
    H_len := Y_max - Y_min
    H_1_2 := H_len/2
    H_1_3 := H_len/3
    H_2_3 := H_1_3*2
    H_1_4 := H_len/4
    H_3_4 := H_1_4*3
    vertical := W_len < H_len
    display[index].id := X_min . Y_min . X_max . Y_max
    display[index].info := {xmin: X_min, xcom: X_1_2, xmax: X_max, wmax: W_len,
                            ymin: Y_min, ycom: Y_1_2, ymax: Y_max, hmax: H_len}

    AlmostFullRatio := 0.9
    display[index].AlmostFullscreen := {X: X_min+(1-AlmostFullRatio)/2*W_len,
                                        Y: Y_min+(1-AlmostFullRatio)/2*H_len,
                                        W: AlmostFullRatio*W_len,
                                        H: AlmostFullRatio*H_len}

    display[index].LeftHalf     := {X: X_min, Y: Y_min, W: W_1_2, H: H_len}
    display[index].RightHalf    := {X: X_1_2, Y: Y_min, W: W_1_2, H: H_len}
    display[index].TopHalf      := {X: X_min, Y: Y_min, W: W_len, H: H_1_2}
    display[index].BottomHalf   := {X: X_min, Y: Y_1_2, W: W_len, H: H_1_2}

    display[index].TopLeft      := {X: X_min, Y: Y_min, W: W_1_2, H: H_1_2}
    display[index].TopRight     := {X: X_1_2, Y: Y_min, W: W_1_2, H: H_1_2}
    display[index].BottomLeft   := {X: X_min, Y: Y_1_2, W: W_1_2, H: H_1_2}
    display[index].BottomRight  := {X: X_1_2, Y: Y_1_2, W: W_1_2, H: H_1_2}

    if not vertical {
        display[index].info.wmin := W_1_4
        display[index].info.hmin := H_1_3

        display[index].LeftThird          := {X: X_min, Y: Y_min, W: W_1_3, H: H_len}
        display[index].CenterThird        := {X: X_1_3, Y: Y_min, W: W_1_3, H: H_len}
        display[index].RightThird         := {X: X_2_3, Y: Y_min, W: W_1_3, H: H_len}

        display[index].LeftTwoThird       := {X: X_min, Y: Y_min, W: W_2_3, H: H_len}
        display[index].RightTwoThird      := {X: X_1_3, Y: Y_min, W: W_2_3, H: H_len}

        display[index].FirstQuarter       := {X: X_min, Y: Y_min, W: W_1_4, H: H_len}
        display[index].SecondQuarter      := {X: X_1_4, Y: Y_min, W: W_1_4, H: H_len}
        display[index].ThirdQuarter       := {X: X_1_2, Y: Y_min, W: W_1_4, H: H_len}
        display[index].LastQuarter        := {X: X_3_4, Y: Y_min, W: W_1_4, H: H_len}

        display[index].LeftThreeQuarter   := {X: X_min, Y: Y_min, W: W_3_4, H: H_len}
        display[index].RightThreeQuarter  := {X: X_1_4, Y: Y_min, W: W_3_4, H: H_len}

        display[index].FirstSixth         := {X: X_min, Y: Y_min, W: W_1_3, H: H_1_2}
        display[index].SecondSixth        := {X: X_1_3, Y: Y_min, W: W_1_3, H: H_1_2}
        display[index].ThirdSixth         := {X: X_2_3, Y: Y_min, W: W_1_3, H: H_1_2}
        display[index].FourthSixth        := {X: X_min, Y: Y_1_2, W: W_1_3, H: H_1_2}
        display[index].FifthSixth         := {X: X_1_3, Y: Y_1_2, W: W_1_3, H: H_1_2}
        display[index].LastSixth          := {X: X_2_3, Y: Y_1_2, W: W_1_3, H: H_1_2}
    } else {
        display[index].info.wmin := W_1_3
        display[index].info.hmin := H_1_4

        display[index].LeftThird          := {X: X_min, Y: Y_min, W: W_len, H: H_1_3}
        display[index].CenterThird        := {X: X_min, Y: Y_1_3, W: W_len, H: H_1_3}
        display[index].RightThird         := {X: X_min, Y: Y_2_3, W: W_len, H: H_1_3}

        display[index].LeftTwoThird       := {X: X_min, Y: Y_min, W: W_len, H: H_2_3}
        display[index].RightTwoThird      := {X: X_min, Y: Y_1_3, W: W_len, H: H_2_3}

        display[index].FirstQuarter       := {X: X_min, Y: Y_min, W: W_len, H: H_1_4}
        display[index].SecondQuarter      := {X: X_min, Y: Y_1_4, W: W_len, H: H_1_4}
        display[index].ThirdQuarter       := {X: X_min, Y: Y_1_2, W: W_len, H: H_1_4}
        display[index].LastQuarter        := {X: X_min, Y: Y_3_4, W: W_len, H: H_1_4}

        display[index].LeftThreeQuarter   := {X: X_min, Y: Y_min, W: W_len, H: H_3_4}
        display[index].RightThreeQuarter  := {X: X_min, Y: Y_1_4, W: W_len, H: H_3_4}

        display[index].FirstSixth         := {X: X_min, Y: Y_min, W: W_1_2, H: H_1_3}
        display[index].SecondSixth        := {X: X_min, Y: Y_1_3, W: W_1_2, H: H_1_3}
        display[index].ThirdSixth         := {X: X_min, Y: Y_2_3, W: W_1_2, H: H_1_3}
        display[index].FourthSixth        := {X: X_1_2, Y: Y_min, W: W_1_2, H: H_1_3}
        display[index].FifthSixth         := {X: X_1_2, Y: Y_1_3, W: W_1_2, H: H_1_3}
        display[index].LastSixth          := {X: X_1_2, Y: Y_2_3, W: W_1_2, H: H_1_3}
    }
    return
}


initializeMonitorTarget(Count) {
    global display

    display := []
    Loop Count {
        display.Push({})
        updateMonitorTarget(A_Index)
    }
    display.Push({Count: Count, Restore:{X: "", Y: "", W: "", H: "", standby: False}})
    return
}


getMonitorIndex(xcow, ycow) {
    global display

    Count := MonitorGetCount()
    if not (display[-1].Count==Count) {
        display[-1].Count := Count
        initializeMonitorTarget(Count)
    }

    Loop Count {
        MonitorGetWorkArea A_Index, &X_min, &Y_min, &X_max, &Y_max
        MonitorID := X_min . Y_min . X_max . Y_max
        if not (display[A_Index].id==MonitorID) {
            updateMonitorTarget(A_Index)
        }

        if (display[A_Index].info.xmin<xcow and xcow<display[A_Index].info.xmax
            and display[A_Index].info.ymin<ycow and ycow<display[A_Index].info.ymax) {
            return A_Index
        }
    }

    Primary_Index := MonitorGetPrimary()
    return Primary_Index
}


mvWin(index, tgtX, tgtY, tgtW, tgtH) {
    global display
    WinMove tgtX, tgtY, tgtW, tgtH, "A"
    ; correction
    WinGetClientPos &X, &Y, &W, &H, "A"
    if not (X==tgtX and Y==tgtY and W==tgtW and H==tgtH) {
        tgtXcow := tgtX+tgtW/2
        tgtYcow := tgtY+tgtH/2
        Xcow := X+W/2
        Ycow := Y+H/2
        dW := tgtW-W
        dH := tgtH-H
        dX := (tgtXcow-Xcow-dW)/2 + (dW<0 ? dW : 0)
        dY := (tgtYcow-Ycow-dH/2)/2
        corX := Round(clamp(tgtX+dX, display[index].info.xmin+dX, display[index].info.xmax-W))
        corY := Round(clamp(tgtY+dY, display[index].info.ymin+dY, display[index].info.ymax-H))
        corW := tgtW + Abs(dW)
        corH := tgtH + Abs(dH)
        WinMove corX, corY, corW, corH, "A"
    }
    return
}


;;; controlWindow
controlWindow(loc) {
    global tgt

    if (loc=="NextDisplay") {
        SendInput "{RWinDown}{ShiftDown}{Right}{ShiftUp}{RWinUp}"
    } else if (loc=="PreviousDisplay") {
        SendInput "{RWinDown}{ShiftDown}{Left}{ShiftUp}{RWinUp}"
    } else if (loc=="Fullscreen") {
        display[-1].Restore.standby := False
        WinMaximize "A"
    } else {
        Title := WinGetTitle("A")
        if (Title=="" or Title=="Program Manager") {
            return
        }
        WinRestore "A"  ; maximized window cannot move
        WinGetClientPos &srcX, &srcY, &srcW, &srcH, "A"
        xcow := srcX + srcW/2
        ycow := srcY + srcH/2
        index := getMonitorIndex(xcow, ycow)
        if (loc=="Restore") {
            if display[-1].Restore.standby {
                mvWin(index, display[-1].Restore.X, display[-1].Restore.Y, display[-1].Restore.W, display[-1].Restore.H)
                display[-1].Restore.standby := False
            }
            return
        }
        EdgeL := srcX      < display[index].info.xmin+4
        EdgeR := srcX+srcW > display[index].info.xmax-4
        EdgeT := srcY      < display[index].info.ymin+4
        EdgeB := srcY+srcH > display[index].info.ymax-4
        fullscreen := EdgeL and EdgeR and EdgeT and EdgeB
        if (loc=="Center") {
            tgtX := display[index].info.xcom - srcW/2
            tgtY := display[index].info.ycom - srcH/2
            tgtW := srcW
            tgtH := srcH
        } else if (loc=="MakeLarger" or loc=="MakeSmaller") {
            steps := 24
            dW := (EdgeL and EdgeR and not fullscreen) ? 0 : display[index].info.wmax/steps
            dH := (EdgeT and EdgeB and not fullscreen) ? 0 : display[index].info.hmax/steps
            dX := (EdgeR and not fullscreen) ? -dW : -dW/2
            dY := (EdgeB and not fullscreen) ? -dH : -dH/2
            sign := loc=="MakeLarger" ? 1 : -1
            tgtW := srcW+sign*dW
            tgtH := srcH+sign*dH
            tgtX := srcX+(1-((EdgeL+fullscreen)=1))*sign*dX
            tgtY := srcY+(1-((EdgeT+fullscreen)=1))*sign*dY
        } else {
            tgtX := display[index].%loc%.X
            tgtY := display[index].%loc%.Y
            tgtW := display[index].%loc%.W
            tgtH := display[index].%loc%.H
        }
        tgtW := Round(clamp(tgtW, display[index].info.wmin, display[index].info.wmax))
        tgtH := Round(clamp(tgtH, display[index].info.hmin, display[index].info.hmax))
        tgtX := Round(clamp(tgtX, display[index].info.xmin, display[index].info.xmax-tgtW))
        tgtY := Round(clamp(tgtY, display[index].info.ymin, display[index].info.ymax-tgtH))
        mvWin(index, tgtX, tgtY, tgtW, tgtH)

        ; Restore info
        display[-1].Restore.X := srcX
        display[-1].Restore.Y := srcY
        display[-1].Restore.W := srcW
        display[-1].Restore.H := srcH
        display[-1].Restore.standby := True
    }
    return
}

  ;#### shortcuts
  <^!f::controlWindow("Fullscreen")
  <^!Enter::controlWindow("AlmostFullscreen")
  <^!c::controlWindow("Center")
  <^!z::controlWindow("Restore")
  <^!=::controlWindow("MakeLarger")
  <^!-::controlWindow("MakeSmaller")

  <^!>^Right::controlWindow("NextDisplay")
  <^!>^Left::controlWindow("PreviousDisplay")

  <^!Left::controlWindow("LeftHalf")
  <^!Right::controlWindow("RightHalf")
  <^!Up::controlWindow("TopHalf")
  <^!Down::controlWindow("BottomHalf")

  <^![::controlWindow("TopLeft")
  <^!]::controlWindow("TopRight")
  <^!;::controlWindow("BottomLeft")
  <^!'::controlWindow("BottomRight")

  <^!b::controlWindow("LeftThird")
  <^!n::controlWindow("CenterThird")
  <^!m::controlWindow("RightThird")

  <^!x::controlWindow("LeftTwoThird")
  <^!v::controlWindow("RightTwoThird")

  <^!h::controlWindow("FirstQuarter")
  <^!j::controlWindow("SecondQuarter")
  <^!k::controlWindow("ThirdQuarter")
  <^!l::controlWindow("LastQuarter")

  <^!d::controlWindow("LeftThreeQuarter")
  <^!g::controlWindow("RightThreeQuarter")

  <^!i::controlWindow("FirstSixth")
  <^!o::controlWindow("SecondSixth")
  <^!p::controlWindow("ThirdSixth")
  <^!,::controlWindow("FourthSixth")
  <^!.::controlWindow("FifthSixth")
  <^!/::controlWindow("LastSixth")