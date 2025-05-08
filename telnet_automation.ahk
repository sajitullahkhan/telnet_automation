#IfWinActive ahk_class ConsoleWindowClass

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
} else {
    MsgBox, Invalid input format.`nPlease use: IP.TYPE.PORT.ONT`nExample: 58.g.0/1.3
}
return


RunTelnetAndShowONT(ipPart, type, port, ontID) {
    Send, {Backspace 30}
    ip := "10.10.10." . ipPart

    Send, telnet %ip%{Enter}
    Sleep, 500
    Send, support{Enter}
    Sleep, 300
    Send, Support@321{#}{Enter}
    Sleep, 300
    Send, enable{Enter}
    Sleep, 300
    Send, config{Enter}
    Sleep, 300
    Send, interface %type% %port%{Enter}
    Sleep, 300
    Send, display ont info %ontID% all{Enter}
    Sleep, 300
    Send, {Enter}
    Sleep, 200
    Loop, 10
        Send, {Space}
}

DisableKeyboard() {
    keys = a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,Enter,Tab,Esc,Backspace,Space,Up,Down,Left,Right,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12
    Loop, Parse, keys, `,
    {
        Hotkey, *%A_LoopField%, BlockKey, On
    }
}

EnableKeyboard() {
    keys = a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,Enter,Tab,Esc,Backspace,Space,Up,Down,Left,Right,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12
    Loop, Parse, keys, `,
    {
        Hotkey, *%A_LoopField%, BlockKey, Off
    }
}

BlockKey:
return

^!q::  ; Ctrl + Alt + Q
EnableKeyboard()
MsgBox, Keyboard input has been re-enabled (fail-safe hotkey pressed).
return
