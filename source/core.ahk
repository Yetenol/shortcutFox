#Include config.ahk

debug(lines*)
{
    if (DO_DEBUG)
    {
        log(lines*)
    }
}

log(lines*)
{
    text := ""

    for line in lines
    {
        text := text line "`n"
    }

    MsgBox(text)
}