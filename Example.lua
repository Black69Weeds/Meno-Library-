--//========================================================
--// LOAD LIBRARY
--//========================================================

local library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Black69Weeds/Meno-Library-/refs/heads/main/Library%20source.lua"
))()



--//========================================================
--// MAIN WINDOW + KEY SYSTEM
--//========================================================

local window = library:window({
    name     = "Meno",
    suffix   = "library",
    gameInfo = "Universal",
    size     = UDim2.new(0, 700, 0, 565),

    --// KEY SYSTEM SETTINGS (COMBINED & CLEANED)
    KeySystem = true, -- Enable the key system
    KeySettings = {
        Title      = "Meno Key System",
        Subtitle   = "Universal Script", -- You can change this to anything
        Note       = "To get the key, please join our Discord",
        SaveInRoot = false,             -- Save key in a root folder (if your lib uses it)
        SaveKey    = true,              -- Remember key between executions

        -- List of valid keys (example values)
        Key = { "Syze", "FreeKy", "SyzenHub" },

        -- Second action: Discord / Link for key system or support
        SecondAction = {
            Enabled   = true,
            Type      = "Discord", -- "Discord" or "Link"
            Parameter = "W8qeVXK8" -- Discord invite code (NO "discord.gg/"), or full URL for Type = "Link"
        }
    }
})

-- Small button text at the top center when UI is minimized/closed
library:home("open Meno")

-- Top separator title inside the main window
window:seperator({ name = "General" })



--//========================================================
--// TAB GROUP 1 – MAIN (COMBAT / VISUALS / MISC)
--//========================================================

local main_tab, visual_tab, misc_tab = window:tab({
    name = "Main",
    tabs = { "Combat", "Visuals", "Misc" },
})

------------------------------------------------------------
-- COMBAT TAB
------------------------------------------------------------

local combat_column = main_tab:column({})

local aimbot_section = combat_column:section({
    name    = "Aimbot",
    default = true
})

aimbot_section:toggle({
    name     = "Enable Aimbot",
    default  = false,
    callback = function(enabled)
        print("Aimbot:", enabled)
    end
})

aimbot_section:slider({
    name    = "FOV Radius",
    min     = 0,
    max     = 500,
    default = 100,
    suffix  = " px"
})

aimbot_section:dropdown({
    name    = "Hitbox",
    items   = { "Head", "Torso", "HumanoidRootPart" },
    default = "Head"
})

------------------------------------------------------------
-- VISUALS TAB
------------------------------------------------------------

local visuals_column = visual_tab:column({})

local esp_section = visuals_column:section({
    name    = "ESP Settings",
    default = true
})

esp_section:toggle({
    name    = "Box ESP",
    default = true
}):colorpicker({
    color = Color3.fromRGB(255, 0, 0)
})

esp_section:toggle({
    name    = "Name ESP",
    default = true
})

esp_section:toggle({
    name    = "Tracers",
    default = false
})

------------------------------------------------------------
-- MISC TAB
------------------------------------------------------------

local misc_column = misc_tab:column({})

local character_section = misc_column:section({
    name    = "Character",
    default = true
})

character_section:slider({
    name     = "WalkSpeed",
    min      = 16,
    max      = 200,
    default  = 16,
    callback = function(value)
        local player   = game.Players.LocalPlayer
        local character = player and player.Character
        local humanoid  = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

character_section:slider({
    name     = "JumpPower",
    min      = 50,
    max      = 300,
    default  = 50,
    callback = function(value)
        local player   = game.Players.LocalPlayer
        local character = player and player.Character
        local humanoid  = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.JumpPower = value
        end
    end
})

character_section:button({
    name     = "Reset Character",
    callback = function()
        local player    = game.Players.LocalPlayer
        local character = player and player.Character

        if character then
            character:BreakJoints()
        end
    end
})



--//========================================================
--// TAB GROUP 2 – ESP EXAMPLE 1 (SUB TABS + COLUMNS + SETTINGS)
--//========================================================

local enemies, teammates, self_section = window:tab({
    name = "ESP Example 1",
    tabs = { "Enemies", "Teammates", "Self" },
})

for _, tab in ipairs({ enemies, teammates, self_section }) do
    -- Main column for this tab
    local column = tab:column({})

    local section = column:section({
        name    = "General",
        default = true,
        toggle  = false,
    })

    section:label({
        name = "This is a title!",
        info = "This is an example description/paragraph for the ESP section.\nYou can use this to explain what each setting does."
    })

    -- Sub-tab page inside this tab (like "pages" under ESP)
    local page = tab:sub_tab({
        order = -10000, -- very high priority, appears on top
        size  = 2,      -- number of columns in this page
    })

    for i = 1, 2 do
        local sub_column = page:column({})

        local sub_section = sub_column:section({
            name    = "General",
            default = true,
        })

        sub_section:toggle({
            name      = "Enable ESP",
            seperator = true,
            callback  = function(enabled)
                print("Enable ESP:", enabled)
            end,
        })

        sub_section:toggle({
            name      = "Through walls",
            seperator = true,
        })

        local shared_toggle = sub_section:toggle({
            name      = "Shared ESP",
            seperator = true,
        }):colorpicker({})

        -- Sub Section Example under "Name"
        local nameToggle = sub_section:toggle({
            name      = "Name",
            seperator = true,
        })

        nameToggle:colorpicker({})

        local name_settings = nameToggle:settings({})

        name_settings:toggle({
            name      = "Show Display Names",
            seperator = true,
        })

        name_settings:dropdown({
            name      = "Font Name",
            items     = { "ProggyTiny", "MonoSpace", "Tahoma" },
            default   = "MonoSpace",
            seperator = true,
        })

        name_settings:colorpicker({
            name      = "Another Colorpicker",
            seperator = true,
        })

        name_settings:keybind({
            name     = "Keybind",
            callback = function(active)
                print("Name keybind active:", active)
            end,
            info = "Example info text for this keybind.",
        })
        -- End Sub Section Example

        sub_section:toggle({
            name      = "Weapon",
            seperator = true,
            info      = "Extra info about weapon ESP here.",
        }):colorpicker({})

        sub_section:dropdown({
            name      = "Flags",
            items     = { "Scoped", "Flashed", "Knocked", "Touched" },
            default   = { "Scoped", "Flashed", "Knocked" },
            multi     = true,
            seperator = true,
        })

        sub_section:toggle({
            name      = "Other Stuff",
            seperator = false,
        }):colorpicker({})
    end
end



--//========================================================
--// TAB GROUP 3 – ESP EXAMPLE 2 (SIMPLE REPEATED SECTIONS)
--//========================================================

local enemies2, teammates2, self_section2 = window:tab({
    name = "ESP Example 2",
    tabs = { "Enemies", "Teammates", "Self" },
})

for _, tab in ipairs({ enemies2, teammates2, self_section2 }) do
    for i = 1, 2 do
        local column = tab:column({})

        local section = column:section({
            name    = "General",
            default = true,
        })

        section:toggle({
            name      = "Enable ESP",
            seperator = true,
            callback  = function(enabled)
                print("Enable ESP 2:", enabled)
            end,
        })

        section:toggle({
            name      = "Through walls",
            seperator = true,
        })

        local shared_toggle = section:toggle({
            name      = "Shared ESP",
            seperator = true,
        }):colorpicker({})

        -- Sub Section Example
        local nameToggle = section:toggle({
            name      = "Name",
            seperator = true,
        })

        nameToggle:colorpicker({})

        local name_settings = nameToggle:settings({})

        name_settings:toggle({
            name      = "Show Display Names",
            seperator = true,
        })

        name_settings:dropdown({
            name      = "Font Name",
            items     = { "ProggyTiny", "MonoSpace", "Tahoma" },
            default   = "MonoSpace",
            seperator = true,
        })

        name_settings:colorpicker({
            name      = "Another Colorpicker",
            seperator = true,
        })

        name_settings:keybind({
            name     = "Keybind",
            callback = function(active)
                print("Keybind pressed (Example 2):", active)
            end,
            info = "Example info text for this keybind.",
        })
        -- End Sub Section Example

        section:toggle({
            name      = "Weapon",
            seperator = true,
            info      = "Extra info about weapon ESP here.",
        }):colorpicker({})

        section:dropdown({
            name      = "Flags",
            items     = { "Scoped", "Flashed", "Knocked", "Touched" },
            default   = { "Scoped", "Flashed", "Knocked" },
            multi     = true,
            seperator = true,
        })

        section:toggle({
            name      = "Other Stuff",
            seperator = false,
        }):colorpicker({})
    end
end



--//========================================================
--// TAB GROUP 4 – ESP EXAMPLE 3 (SINGLE COLUMN)
--//========================================================

local enemies3, teammates3, self_section3 = window:tab({
    name = "ESP Example 3",
    tabs = { "Enemies", "Teammates", "Self" },
})

for _, tab in ipairs({ enemies3, teammates3, self_section3 }) do
    local column = tab:column({})

    local section = column:section({
        name    = "General",
        default = true,
    })

    section:toggle({
        name      = "Enable ESP",
        seperator = true,
        callback  = function(enabled)
            print("Enable ESP 3:", enabled)
        end,
    })

    section:toggle({
        name      = "Through walls",
        seperator = true,
    })

    local shared_toggle = section:toggle({
        name      = "Shared ESP",
        seperator = true,
    }):colorpicker({})

    -- Sub Section Example
    local nameToggle = section:toggle({
        name      = "Name",
        seperator = true,
    })

    nameToggle:colorpicker({})

    local name_settings = nameToggle:settings({})

    name_settings:toggle({
        name      = "Show Display Names",
        seperator = true,
    })

    name_settings:dropdown({
        name      = "Font Name",
        items     = { "ProggyTiny", "MonoSpace", "Tahoma" },
        default   = "MonoSpace",
        seperator = true,
    })

    name_settings:colorpicker({
        name      = "Another Colorpicker",
        seperator = true,
    })

    name_settings:keybind({
        name     = "Keybind",
        callback = function(active)
            print("Keybind pressed (Example 3):", active)
        end,
        info = "Example info text for this keybind.",
    })
    -- End Sub Section Example

    section:toggle({
        name      = "Weapon",
        seperator = true,
        info      = "Extra info about weapon ESP here.",
    }):colorpicker({})

    section:dropdown({
        name      = "Flags",
        items     = { "Scoped", "Flashed", "Knocked", "Touched" },
        default   = { "Scoped", "Flashed", "Knocked" },
        multi     = true,
        seperator = true,
    })

    section:toggle({
        name      = "Other Stuff",
        seperator = false,
    }):colorpicker({})
end



--//========================================================
--// TAB GROUP 5 – ESP EXAMPLE 4 (TWO STACKED SECTIONS)
--//========================================================

local enemies4, teammates4, self_section4 = window:tab({
    name = "ESP Example 4",
    tabs = { "Enemies", "Teammates", "Self" },
})

for _, tab in ipairs({ enemies4, teammates4, self_section4 }) do
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
            callback  = function(enabled)
                print("Enable ESP 4:", enabled)
            end,
        })

        section:toggle({
            name      = "Through walls",
            seperator = true,
        })

        local shared_toggle = section:toggle({
            name      = "Shared ESP",
            seperator = true,
        }):colorpicker({})

        -- Sub Section Example
        local nameToggle = section:toggle({
            name      = "Name",
            seperator = true,
        })

        nameToggle:colorpicker({})

        local name_settings = nameToggle:settings({})

        name_settings:toggle({
            name      = "Show Display Names",
            seperator = true,
        })

        name_settings:dropdown({
            name      = "Font Name",
            items     = { "ProggyTiny", "MonoSpace", "Tahoma" },
            default   = "MonoSpace",
            seperator = true,
        })

        name_settings:colorpicker({
            name      = "Another Colorpicker",
            seperator = true,
        })

        name_settings:keybind({
            name     = "Keybind",
            callback = function(active)
                print("Keybind pressed (Example 4):", active)
            end,
            info = "Example info text for this keybind.",
        })
        -- End Sub Section Example

        section:toggle({
            name      = "Weapon",
            seperator = true,
            info      = "Extra info about weapon ESP here.",
        }):colorpicker({})

        section:dropdown({
            name      = "Flags",
            items     = { "Scoped", "Flashed", "Knocked", "Touched" },
            default   = { "Scoped", "Flashed", "Knocked" },
            multi     = true,
            seperator = true,
        })

        section:toggle({
            name      = "Other Stuff",
            seperator = false,
        }):colorpicker({})
    end
end



--//========================================================
--// CONFIG SYSTEM INIT
--//========================================================

library:init_config(window)
