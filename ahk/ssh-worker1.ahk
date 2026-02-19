#Requires AutoHotkey v2.0

pw := EnvGet("INTRA_PW")

^+!j:: {
    SendText(pw)
}
