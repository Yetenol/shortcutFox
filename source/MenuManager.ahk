#Include TRAYMENU_LAYOUT.ahk
#Include core.ahk

global TRAYMENU_LAYOUT

class MenuManager {
    LAYOUT := []

    isEmpty := true

    static TYPES := {
        ACTION: 0,
        /*  - used as DEFAULT
            - type can be omitted
        */
        GROUP: 1,
        /*  - child items listed above each other
            - displays a line before and after the group
            - doesn't show title
        */
        SUBMENU: 2,
        /*  - display title as single item
            - hovering over it expands a new menu with child item
        */
        LINE: 3, 
        ;   - draws a seperator line
    }

    /** Constructor
    */
    __New(layout) {
        this.LAYOUT := layout
        this.parseLayout()
        this.update()
    }

    /** Read out layout definition and create necessary objects for all submenus or groups.
        - to display a submenu, items must be attached to an existing {Menu} object
        - objects are stored inside the definition object
        @param {Object[]} definition - array of items to recursively parse through
     */
    parseLayout(layer:=false)
    {
        if (!layer)
        { ; start recursion at top level of layout definition
            layer := this.LAYOUT
            layer.menu := A_trayMenu
        }
        else
        {
            layer.menu := Menu() ; create a new submenu object
            layer.menu.name := layer.id ; name the submenu object to differentiate then
        }

        ; debug("parseLayout", "layer:`t" layer.id)
        debug("parseLayout", "layer:`t" layer.id, "content:`t" layer.content.Length)

        i := 1
        while (i <= layer.content.Length)
        {
            item := layer.content[i]

            if (item is string)
            { ; item is a symbolic link to another submenu or group
                link := this.findItem(item)
                layer.content[i] := link
                debug("linked parent", "layer:`t" layer.id, "content:`t" layer.content.Length)
                i-- ; iterate through the newly pasted linked items as well

            }
            else if (item is object)
            { ; item is a proper item
                if (item.hasOwnProp("content"))
                {
                    this.parseLayout(item)
                }
            }
            i++
        }
    }

    /** Print the current traymenu layout into a file
        @param {string } filename - file to override
        other param are recursion internal
    */
    printAll(filename:="traymenu.txt", layer:=false, layerIndex:=0, first:=false, last:=false) {
        if (!layer)
        { ; start recursion at top level of layout definition
            if (fileExist(filename))
            { ; only delete if it exists
                fileDelete(filename)
            }
            layer := this.LAYOUT
        }

        indent := "" 
        loop layerIndex
        {
            indent  := indent  " "
        }


        if (first && last)
        {
            draw := "└"
        }
        else if (first)
        {
            draw := "├"
        }
        else if (last)
        {
            draw := "└"
        }
        else
        {
            draw := "├"
        }
        
        line := indent draw " " layer.id "`n"
                
        fileAppend(line, filename, "UTF-8")

        if (layer.hasOwnProp("content"))
        {
            max := layer.content.Length
            for i, item in layer.content
            {
                first := (i = 1)
                last := (i = max)
                this.printAll(filename, item, layerIndex + 1, first, last)
            }
        }
    }

    /** Get the type of an item.
        - returns a {MenuManager.TYPES} value
        @param {Object} item - item of interest
     */
    getType(item) {
        itemType := MenuManager.TYPES.ACTION ; default is action

        if (item.hasOwnProp("content"))
        { ; item is a group or submenu
            if (item.hasOwnProp("maxDisplay"))
            { ; a maximum number of displayed child items before using a submenu is set                
                if(item.maxDisplay = 0)
                { ; force to display a submenu
                    return MenuManager.TYPES.SUBMENU
                }

                if (item.maxDisplay != -1 && item.content.Length > item.maxDisplay)
                { ; too many children => display a submenu
                    return MenuManager.TYPES.SUBMENU
                }
                else 
                { ; not too many children => display a group
                    return MenuManager.TYPES.GROUP
                }
            }
            else
            { ; no maximun number of displayed child items before using a submenu is set => display group
                return MenuManager.TYPES.GROUP
            }
        }

    }

    /** Clear the entire traymenu.
        @param {Menu} menu - traymenu or submenu to clear from
        @param {Object[]} parent - array of items to recursively search through
    */
    clear(layer:=false) {
        if (!layer)
        { ; start recursion at top level of layout definition
            layer := this.LAYOUT
        }
        layer.menu.delete()
        layer.menu.isEmpty := true

        for item in layer.content
        {
            if (item is object)
            { ; item is a proper item
                if (item.hasOwnProp("content"))
                {
                    this.clear(item)
                }
            }
        }
    }


    /** Rerender the entire traymenu.
    */
    update() {
        this.clear()
        this.attachItem(A_trayMenu, this.LAYOUT)
    }

    /** Attach an item to the traymenu or a submenu.
        @param {Menu} menu - traymenu or submenu to which is attached
        @param {item} item - group, submenu or action to attach
        @param {string} [icon=false] - icon to inherit from parent group of submenu
    */
    attachItem(menu, item, icon:=false) {
        if (!icon && item.hasOwnProp("icon"))
        { ; no icon to inherit but this item has it's own icon
            icon := item.icon
        }
        
        ; MsgBox("attachItem`nitem:`t" item.id "`nmenu:`t" menu.name)

        switch this.getType(item)
        {
        case MenuManager.TYPES.GROUP:           
            menu.doLine := true ; remember to add a seperator line before the next item on this submenu level
            for child in item.content
            {
                this.attachItem(menu, child, icon)
            }
            menu.doLine := true ; remember to add a seperator line before the next item on this submenu level

        case MenuManager.TYPES.SUBMENU:
            for child in item.content
            {
                this.attachItem(item.menu, child, icon)
            }

            ; attach and display the submenu to the traymenu or another submenu
            this.drawLine(menu)
            menu.add(item.text, item.menu)
            this.drawIcon(menu, item, icon)
            menu.isEmpty := false ; flag non-empty menus

        case MenuManager.TYPES.LINE:
            menu.doLine := true ; remember to add a seperator line before the next item on this submenu level

        default: ; item in a proper action
            ; attach and display the action to the traymenu or a submenu
            this.drawLine(menu)
            menu.add(item.text, handler)
            this.drawIcon(menu, item, icon)
            menu.isEmpty := false ; flag non-empty menus

        }
    }


    /** return an item by id
        @param {string} id - id of the item of interest
        @param {Object[]} [parent=this.LAYOUT] - array of items to recursively search through
    */
    findItem(id, layer:=false) {
        if (!layer)
        { ; recursion starts at the root of the definition
            layer := this.LAYOUT
        }

        for item in layer.content
        {
            if (item is object)
            { ; item is a proper item
                if (item.id = id)
                {
                    return item
                }
                else if (item.hasOwnProp("content"))
                {
                    item := this.findItem(id, item)
                    if (item)
                    { ; found a valid item
                        return item
                    }
                }
            } 
        }
        return false ; couldn't find item
    }

;    /** Resolve the content information into an array of children
;        @param {object[]/string} content - array of items OR the id of a linked parent
;    */
;    getChildren(content) {
;        if (content is array)
;        { ; content isn't linked => recursively attach all child items
;            return content
;        }
;        else if (content is string)
;        { ; content is linked => recursively attach linked content' child items
;            linkedParent := this.findItem(content)
;            if (linkedParent)
;            { ; linked content was found
;                if (linkedParent.hasOwnProp("content"))
;                {
;                    ; MsgBox("Found parent`ntarget:`t" content "`nfound:`t" linkedParent.id)
;                    return this.getChildren(linkedParent.content)
;                }
;                else
;                {
;                    throw "Linked parent doesn't contain children:`n" content
;                }
;            }
;            else
;            {
;                throw "Cannot find linked parent:`n" content
;            }
;        }
;    }

    /** Draw a seperator line if requested previously.
        @param {Menu} menu - traymenu or submenu to which is drawn
    */
    drawLine(menu) {
        if (menu.hasOwnProp("isEmpty") && !menu.isEmpty)
        { ; menu is not empty
            if (menu.hasOwnProp("doLine") && menu.doLine) {
                menu.add() ; add a seperator line
                menu.doLine := false
            }
        }
        else
        { ; menu is empty
            menu.doLine := false
        }
    }

    /** Display the correct icon for a submenu or action
        @param {Menu} menu - traymenu or submenu to which is drawn
        @param {Object} item - action or submenu to apply the icon to
        @param {string[]/string} icon - icon to be applied
    */
    drawIcon(menu, item, icon) {
        if (icon is array)
        { ; icon contains a path and index
            menu.setIcon(item.text, icon[1], icon[2]) 
        }
        else if(icon is string)
        { ; icon only contains a path
            menu.setIcon(item.text, icon)
        }
        else
        { ; no icon is set
        }
    }

}

handler(*) {
    MsgBox("Clicked on tray")
}