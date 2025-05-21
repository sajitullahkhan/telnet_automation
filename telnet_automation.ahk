#IfWinActive ahk_class ConsoleWindowClass

::45.:: ; I'm Sajit ullah Khan. My github : https://github.com/sajitullahkhan .  "WinWaitActive, Telnet*"
    RunTelnet("45")
return

::58.::
    RunTelnet("58")
return

::18.::
    RunTelnet("18")
return

::37.::
    RunTelnet("37")
return

RunTelnet(ipPart) {
    DisableKeyboard()
    ip := "10.10.10." . ipPart

    WinTitle := "ahk_class ConsoleWindowClass"
    
    ; Send telnet commands directly to the background CMD window
    ControlSend,, {Backspace 30}, %WinTitle%
    ControlSend,, telnet %ip%{Enter}, %WinTitle%
    Sleep, 500
    ControlSend,, Support{Enter}, %WinTitle%
    Sleep, 500
    send, Support@321{#}{Enter}
    Sleep, 500
    ControlSend,, enable{Enter}, %WinTitle%
    Sleep, 200
    ControlSend,, config{Enter}, %WinTitle%
    Sleep, 200
    EnableKeyboard()
}


::suk::
Input, UserInput, V L30, {Enter}

if (RegExMatch(UserInput, "^(?P<ip>\d+)\.(?P<type>[ge])\.(?P<port>\d+/\d+)\.(?P<ont>\d+)$", match)) {
    ipPart := matchip
    ontID := matchont
    port := matchport
    interfaceType := (matchtype = "g") ? "gpon" : "epon"

    ; Only allow specific IPs
    if (ipPart = "45" || ipPart = "58" || ipPart = "18" || ipPart = "37") {
        DisableKeyboard()
        RunTelnetAndShowONT(ipPart, interfaceType, port, ontID)
        EnableKeyboard()
    } else {
        MsgBox, Invalid IP address.`nOnly 45, 58, 18, or 37 are allowed.
    }
}  else if (RegExMatch(UserInput, "^(?P<ip>\d+)\.$", match)) {
    ; Only IP given
    ipPart := matchip

    ; Only allow specific IPs
    if (ipPart = "45" || ipPart = "58" || ipPart = "18" || ipPart = "37") {
        
    } else {
        MsgBox, Invalid IP address.`nOnly 45, 58, 18, or 37 are allowed.
    }
} else {
    MsgBox, Invalid input format.`nPlease use: IP.TYPE.PORT.ONT`nExample: 58.g.0/1.3
}
return


RunTelnetAndShowONT(ipPart, type, port, ontID) {
    ip := "10.10.10." . ipPart
    WinTitle := "ahk_class ConsoleWindowClass"

    ControlSend,, {Backspace 30}, %WinTitle%
    ControlSend,, telnet %ip%{Enter}, %WinTitle%
    Sleep, 500
    ControlSend,, support{Enter}, %WinTitle%
    Sleep, 500
    send, Support@321{#}{Enter}
    Sleep, 500
    ControlSend,, enable{Enter}, %WinTitle%
    Sleep, 200
    ControlSend,, config{Enter}, %WinTitle%
    Sleep, 200
    ControlSend,, interface %type% %port%{Enter}, %WinTitle%
    Sleep, 300
    ControlSend,, display ont info %ontID% all{Enter}, %WinTitle%
    Sleep, 300
    ControlSend,, {Enter}, %WinTitle%
    Sleep, 200
    Loop, 12 {
        ControlSend,, {Space}, %WinTitle%
        Sleep, 100
    }
}



DisableKeyboard() {
    allKeys = a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,Enter,Tab,Esc,Backspace,Space,Up,Down,Left,Right,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12
    Loop, Parse, allKeys, `,
    {
        Hotkey, *%A_LoopField%, BlockKey, On
    }
    SetTimer, AutoEnableKeyboard, -10000 ; auto-enable after 10 seconds
}

EnableKeyboard() {
    allKeys = a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,Enter,Tab,Esc,Backspace,Space,Up,Down,Left,Right,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12
    Loop, Parse, allKeys, `,
    {
        Hotkey, *%A_LoopField%, BlockKey, Off
    }
}

AutoEnableKeyboard:
EnableKeyboard()
return

BlockKey:
return