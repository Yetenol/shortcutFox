#Include config.ahk

debug(lines*)
{
    if (DO_DEBUG)
    {
        text := ""

        for line in lines
        {
            text := text line "`n"
        }

        MsgBox(text)
    }
}