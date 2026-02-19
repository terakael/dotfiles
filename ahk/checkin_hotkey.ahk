#Requires AutoHotkey v2.0

; Ctrl+Alt+I: Type "checking in", press Ctrl+Enter, and log timestamp
^!i::
{
    ; Type the message
    SendText "checking in"
    
    ; Press Ctrl+Enter to submit
    Send "^{Enter}"
    
    ; Get current timestamp in ISO 8601 format
    timestamp := FormatTime(, "yyyy-MM-ddTHH:mm:ss")
    
    ; Append timestamp to the log file
    FileAppend timestamp . "`n", "C:/Users/daniel.knezevic/Documents/checkins.txt"
    
    return
}
