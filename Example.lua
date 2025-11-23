local library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Black69Weeds/Meno-Library-/refs/heads/main/Library.lua"
))()

--[[
    This UI uses a column-based system for creating sections.

    - Each "column" is how many sections you can have side-by-side.
    - You can have 1, 2, 3, 4, etc. columns with this library.
    - There is a lot of customizability, which is why this library is popular.

    NOTE: This example is just to showcase how to use:
        window -> tab -> column -> section -> controls
]]

--// MAIN WINDOW
local window = library:window({
    name     = "GAY",
    suffix   = "MAX",
    gameInfo = "Milenium for Counter-Strike: Global Offensive",
})

window:seperator({ name = "General" })
library:home(SYZENHUB)
---------------------------------------------------------------------
--// TAB EXAMPLE 1 – WITH SUB TABS + COLUMNS
---------------------------------------------------------------------

local enemies, teammates, self_section = window:tab({
    name = "Example",
    tabs = { "Enemies", "Teammates", "Self" },
})

for _, tab in { enemies, teammates, self_section } do
    local column = tab:column({})

    local section = column:section({
        name    = "General",
        default = true,
        toggle  = false,
    })

    section:label({
        name = "This is a title!",
        info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig",
    })

    -- Sub-tab inside the same tab
    local page = tab:sub_tab({
        order = -10000, -- -1 sets it to the top (very high priority)
        size  = 2,
    })

    for i = 1, 2 do
        local column = page:column({})

        local section = column:section({
            name    = "General",
            default = true,
        })

        section:toggle({
            name      = "Enable ESP",
            seperator = true,
            callback  = function(bool)
                print(bool)
            end,
        })

        section:toggle({
            name      = "Through walls",
            seperator = true,
        })

        local toggle = section:toggle({
            name      = "Shared ESP",
            seperator = true,
        }):colorpicker({})

        --// Sub Section Example
        local nameToggle = section:toggle({
            name      = "Name",
            seperator = true,
        })

        nameToggle:colorpicker({})

        local sub_section = nameToggle:settings({})

        sub_section:toggle({
            name      = "Show Display Names",
            seperator = true,
        })

        sub_section:dropdown({
            name      = "Font Name",
            items     = { "ProggyTiny", "MonoSpace", "Tahoma" },
            default   = "MonoSpace",
            seperator = true,
        })

        sub_section:colorpicker({
            name      = "Another Colorpicker why not",
            seperator = true,
        })

        sub_section:keybind({
            name     = "Keybind",
            callback = function(bool)
                print(bool)
            end,
            info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig",
        })
        --// End Sub Section Example

        section:toggle({
            name      = "Weapon",
            seperator = true,
            info      = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig",
        }):colorpicker({})

        section:dropdown({
            name      = "Flags",
            items     = { "Scoped", "Flashed", "Knocked", "Touched" },
            default   = { "Scoped", "Flashed", "Knocked" },
            multi     = true,
            seperator = true,
        })

        section:toggle({
            name      = "Other Shit",
            seperator = false,
        }):colorpicker({})
    end
end

---------------------------------------------------------------------
--// TAB EXAMPLE 2 – SIMPLE REPEATED SECTIONS
---------------------------------------------------------------------

local enemies2, teammates2, self_section2 = window:tab({
    name = "Example",
    tabs = { "Enemies", "Teammates", "Self" },
})

for _, tab in { enemies2, teammates2, self_section2 } do
    for i = 1, 2 do
        local column = tab:column({})

        local section = column:section({
            name    = "General",
            default = true,
        })

        section:toggle({
            name      = "Enable ESP",
            seperator = true,
            callback  = function(bool)
                print(bool)
            end,
        })

        section:toggle({
            name      = "Through walls",
            seperator = true,
        })

        local toggle = section:toggle({
            name      = "Shared ESP",
            seperator = true,
        }):colorpicker({})

        --// Sub Section Example
        local nameToggle = section:toggle({
            name      = "Name",
            seperator = true,
        })

        nameToggle:colorpicker({})

        local sub_section = nameToggle:settings({})

        sub_section:toggle({
            name      = "Show Display Names",
            seperator = true,
        })

        sub_section:dropdown({
            name      = "Font Name",
            items     = { "ProggyTiny", "MonoSpace", "Tahoma" },
            default   = "MonoSpace",
            seperator = true,
        })

        sub_section:colorpicker({
            name      = "Another Colorpicker why not",
            seperator = true,
        })

        sub_section:keybind({
            name     = "Keybind",
            callback = function(bool)
                print(bool)
            end,
            info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig",
        })
        --// End Sub Section Example

        section:toggle({
            name      = "Weapon",
            seperator = true,
            info      = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig",
        }):colorpicker({})

        section:dropdown({
            name      = "Flags",
            items     = { "Scoped", "Flashed", "Knocked", "Touched" },
            default   = { "Scoped", "Flashed", "Knocked" },
            multi     = true,
            seperator = true,
        })

        section:toggle({
            name      = "Other Shit",
            seperator = false,
        }):colorpicker({})
    end
end

---------------------------------------------------------------------
--// TAB EXAMPLE 3 – SINGLE COLUMN
---------------------------------------------------------------------

local enemies3, teammates3, self_section3 = window:tab({
    name = "Example",
    tabs = { "Enemies", "Teammates", "Self" },
})

for _, tab in { enemies3, teammates3, self_section3 } do
    local column = tab:column({})

    local section = column:section({
        name    = "General",
        default = true,
    })

    section:toggle({
        name      = "Enable ESP",
        seperator = true,
        callback  = function(bool)
            print(bool)
        end,
    })

    section:toggle({
        name      = "Through walls",
        seperator = true,
    })

    local toggle = section:toggle({
        name      = "Shared ESP",
        seperator = true,
    }):colorpicker({})

    --// Sub Section Example
    local nameToggle = section:toggle({
        name      = "Name",
        seperator = true,
    })

    nameToggle:colorpicker({})

    local sub_section = nameToggle:settings({})

    sub_section:toggle({
        name      = "Show Display Names",
        seperator = true,
    })

    sub_section:dropdown({
        name      = "Font Name",
        items     = { "ProggyTiny", "MonoSpace", "Tahoma" },
        default   = "MonoSpace",
        seperator = true,
    })

    sub_section:colorpicker({
        name      = "Another Colorpicker why not",
        seperator = true,
    })

    sub_section:keybind({
        name     = "Keybind",
        callback = function(bool)
            print(bool)
        end,
        info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig",
    })
    --// End Sub Section Example

    section:toggle({
        name      = "Weapon",
        seperator = true,
        info      = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig",
    }):colorpicker({})

    section:dropdown({
        name      = "Flags",
        items     = { "Scoped", "Flashed", "Knocked", "Touched" },
        default   = { "Scoped", "Flashed", "Knocked" },
        multi     = true,
        seperator = true,
    })

    section:toggle({
        name      = "Other Shit",
        seperator = false,
    }):colorpicker({})
end

---------------------------------------------------------------------
--// TAB EXAMPLE 4 – TWO SECTIONS STACKED IN ONE COLUMN
---------------------------------------------------------------------

local enemies4, teammates4, self_section4 = window:tab({
    name = "Example",
    tabs = { "Enemies", "Teammates", "Self" },
})

for _, tab in { enemies4, teammates4, self_section4 } do
    local column = tab:column({})

    for i = 1, 2 do
        local section = column:section({
            name    = "General",
            default = true,
            size    = 0.5, -- half-height sections stacked vertically
        })

        section:toggle({
            name      = "Enable ESP",
            seperator = true,
            callback  = function(bool)
                print(bool)
            end,
        })

        section:toggle({
            name      = "Through walls",
            seperator = true,
        })

        local toggle = section:toggle({
            name      = "Shared ESP",
            seperator = true,
        }):colorpicker({})

        --// Sub Section Example
        local nameToggle = section:toggle({
            name      = "Name",
            seperator = true,
        })

        nameToggle:colorpicker({})

        local sub_section = nameToggle:settings({})

        sub_section:toggle({
            name      = "Show Display Names",
            seperator = true,
        })

        sub_section:dropdown({
            name      = "Font Name",
            items     = { "ProggyTiny", "MonoSpace", "Tahoma" },
            default   = "MonoSpace",
            seperator = true,
        })

        sub_section:colorpicker({
            name      = "Another Colorpicker why not",
            seperator = true,
        })

        sub_section:keybind({
            name     = "Keybind",
            callback = function(bool)
                print(bool)
            end,
            info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig",
        })
        --// End Sub Section Example

        section:toggle({
            name      = "Weapon",
            seperator = true,
            info      = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig",
        }):colorpicker({})

        section:dropdown({
            name      = "Flags",
            items     = { "Scoped", "Flashed", "Knocked", "Touched" },
            default   = { "Scoped", "Flashed", "Knocked" },
            multi     = true,
            seperator = true,
        })

        section:toggle({
            name      = "Other Shit",
            seperator = false,
        }):colorpicker({})
    end
end

---------------------------------------------------------------------
--// OLD DOCUMENTATION (COMMENTED OUT)
---------------------------------------------------------------------
--[[

-- for i = 1, 5 do 
--     window:seperator({name = "General"})
--     local enemies, teammates, self_section = window:tab({name = "Players", tabs = {"Enemies", "Teammates", "Self"}})
--     ...
-- end

]]

---------------------------------------------------------------------
--// INIT CONFIG (SAVE / LOAD SUPPORT)
---------------------------------------------------------------------

library:init_config(window)
