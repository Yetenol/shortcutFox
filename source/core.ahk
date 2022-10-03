#Include config.ahk

log(lines*)
{
    text := ""

    for line in lines
    {
        text := text line "`n"
    }

    MsgBox(text)
}