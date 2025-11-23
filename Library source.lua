--[[
    Meno Library (Remastered)
]]

-- Variables 
local uis = game:GetService("UserInputService") 
local players = game:GetService("Players") 
local ws = game:GetService("Workspace")
local rs = game:GetService("ReplicatedStorage")
local http_service = game:GetService("HttpService")
local gui_service = game:GetService("GuiService")
local lighting = game:GetService("Lighting")
local run = game:GetService("RunService")
local tween_service = game:GetService("TweenService")

local vec2 = Vector2.new
local dim2 = UDim2.new
local dim = UDim.new 
local rgb = Color3.fromRGB
local hex = Color3.fromHex
local hsv = Color3.fromHSV
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new

local camera = ws.CurrentCamera
local lp = players.LocalPlayer 
local mouse = lp:GetMouse() 

local floor = math.floor 
local clamp = math.clamp 
local insert = table.insert 
local find = table.find 
local remove = table.remove
local concat = table.concat

-- Library init
getgenv().library = {
    directory = "milenium",
    folders = {
        "/fonts",
        "/configs",
    },
    flags = {},
    config_flags = {},
    connections = {},   
    notifications = {notifs = {}},
    current_open = nil,
    open_button_label = nil,
    authorized = false, 
}

local themes = {
    preset = {
        accent = rgb(155, 150, 219),
    }, 

    utility = {
        accent = {
            BackgroundColor3 = {}, 	
            TextColor3 = {}, 
            ImageColor3 = {}, 
            ScrollBarImageColor3 = {},
            Color = {} -- Added for UIStroke
        },
    }
}

local theme_list = {
    {Name = "Purple", Color = rgb(155, 150, 219)},
    {Name = "Red",    Color = rgb(225, 60, 60)}, -- Added vivid colors
    {Name = "Blue",   Color = rgb(60, 100, 225)},
    {Name = "Green",  Color = rgb(60, 225, 100)},
    {Name = "White",  Color = rgb(255, 255, 255)},
}
local current_theme_idx = 1

local keys = { [Enum.KeyCode.LeftShift] = "LS", [Enum.KeyCode.RightShift] = "RS", [Enum.KeyCode.LeftControl] = "LC", [Enum.KeyCode.RightControl] = "RC", [Enum.KeyCode.Insert] = "INS", [Enum.KeyCode.Backspace] = "BS", [Enum.KeyCode.Return] = "Ent", [Enum.KeyCode.LeftAlt] = "LA", [Enum.KeyCode.RightAlt] = "RA", [Enum.KeyCode.CapsLock] = "CAPS", [Enum.KeyCode.One] = "1", [Enum.KeyCode.Two] = "2", [Enum.KeyCode.Three] = "3", [Enum.KeyCode.Four] = "4", [Enum.KeyCode.Five] = "5", [Enum.KeyCode.Six] = "6", [Enum.KeyCode.Seven] = "7", [Enum.KeyCode.Eight] = "8", [Enum.KeyCode.Nine] = "9", [Enum.KeyCode.Zero] = "0", [Enum.UserInputType.MouseButton1] = "MB1", [Enum.UserInputType.MouseButton2] = "MB2", [Enum.KeyCode.Escape] = "ESC", [Enum.KeyCode.Space] = "SPC" }

library.__index = library

for _, path in next, library.folders do 
    makefolder(library.directory .. path)
end

local flags = library.flags 
local config_flags = library.config_flags
local notifications = library.notifications 

local fonts = {}; do
    function Register_Font(Name, Weight, Style, Asset)
        if not isfile(Asset.Id) then writefile(Asset.Id, Asset.Font) end
        if isfile(Name .. ".font") then delfile(Name .. ".font") end
        
        local Data = { name = Name, faces = {{ name = "Normal", weight = Weight, style = Style, assetId = getcustomasset(Asset.Id) }} }
        writefile(Name .. ".font", http_service:JSONEncode(Data))
        return getcustomasset(Name .. ".font");
    end
    
    local Medium = Register_Font("Medium", 200, "Normal", { Id = "Medium.ttf", Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf") })
    local SemiBold = Register_Font("SemiBold", 200, "Normal", { Id = "SemiBold.ttf", Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf") })

    fonts = {
        small = Font.new(Medium, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        font = Font.new(SemiBold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    }
end

-- Library functions 
    function library:tween(obj, properties, easing_style, time) 
        local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), properties)
        tween:Play()
        return tween
    end

    function library:resizify(frame) 
        local Frame = Instance.new("TextButton")
        Frame.Position = dim2(1, -10, 1, -10)
        Frame.Size = dim2(0, 10, 0, 10)
        Frame.BackgroundTransparency = 1 
        Frame.Parent = frame
        Frame.Text = ""

        local resizing, start, start_size 
        local og_size = frame.Size  

        Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                start = input.Position
                start_size = frame.Size
            end
        end)

        Frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end
        end)

        library:connection(uis.InputChanged, function(input) 
            if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local current_size = dim2(start_size.X.Scale, clamp(start_size.X.Offset + (input.Position.X - start.X), og_size.X.Offset, camera.ViewportSize.X), start_size.Y.Scale, clamp(start_size.Y.Offset + (input.Position.Y - start.Y), og_size.Y.Offset, camera.ViewportSize.Y))
                library:tween(frame, {Size = current_size}, Enum.EasingStyle.Linear, 0.05)
            end
        end)
    end 

    function library:next_flag()
        local index = 0; for _ in library.flags do index = index + 1 end
        return string.format("flagnumber%s", index + 1)
    end 

    function library:draggify(frame)
        local dragging, start, start_pos 

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                start = input.Position
                start_pos = frame.Position
            end
        end)

        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)

        library:connection(uis.InputChanged, function(input) 
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local current_pos = dim2(start_pos.X.Scale, start_pos.X.Offset + (input.Position.X - start.X), start_pos.Y.Scale, start_pos.Y.Offset + (input.Position.Y - start.Y))
                library:tween(frame, {Position = current_pos}, Enum.EasingStyle.Linear, 0.05)
            end
        end)
    end 

    function library:round(number, float) 
        local multiplier = 1 / (float or 1)
        return floor(number * multiplier + 0.5) / multiplier
    end 

    function library:apply_theme(instance, theme, property) 
        insert(themes.utility[theme][property], instance)
        -- Apply immediately
        if instance[property] then instance[property] = themes.preset[theme] end
    end

    function library:update_theme(theme, color)
        for _, property in themes.utility[theme] do 
            for m, object in property do 
                object[_] = color 
            end 
        end 
        themes.preset[theme] = color 
    end 

    function library:connection(signal, callback)
        local connection = signal:Connect(callback)
        insert(library.connections, connection)
        return connection 
    end

    function library:close_element(new_path) 
        if library.current_open and new_path ~= library.current_open then
            library.current_open.set_visible(false)
            library.current_open.open = false;
        end 
        library.current_open = new_path
    end 

    function library:create(instance, options)
        local ins = Instance.new(instance) 
        for prop, value in options do ins[prop] = value end
        return ins 
    end

    function library:unload_menu() 
        if library["items"] then library["items"]:Destroy() end
        if library["other"] then library["other"]:Destroy() end 
        if library["open_gui"] then library["open_gui"]:Destroy() end
        if library["key_gui"] then library["key_gui"]:Destroy() end
        if lighting:FindFirstChild("MileniumBlur") then lighting.MileniumBlur:Destroy() end
        for _, conn in library.connections do conn:Disconnect() end
        library = nil 
    end 
--

-- KEY SYSTEM
function library:key_system(settings, on_success)
    library.authorized = false 
    local Timer = settings.Timer or 0

    -- Link Support Check
    if tostring(settings.Key):find("http") or tostring(settings.Key):find("www") then
        local success, result = pcall(function()
            return game:HttpGet(settings.Key):gsub("[\n\r]", ""):gsub(" ", "")
        end)
        if success then
            settings.Key = result
        else
            warn("Failed to fetch key from URL")
        end
    end

    local blur = library:create("BlurEffect", { Parent = lighting, Size = 0, Name = "MileniumBlur" })
    tween_service:Create(blur, TweenInfo.new(1), {Size = 18}):Play()

    local key_gui = library:create("ScreenGui", { Parent = game.CoreGui, Name = "MileniumKeySystem", ZIndexBehavior = Enum.ZIndexBehavior.Global, IgnoreGuiInset = true })
    library["key_gui"] = key_gui
    
    local main_frame = library:create("Frame", { Parent = key_gui, Size = dim2(0, 450, 0, 260), Position = dim2(0.5, -225, 0.5, -130), BackgroundColor3 = rgb(18, 18, 22), BorderSizePixel = 0 })
    library:create("UICorner", {Parent = main_frame, CornerRadius = dim(0, 12)})
    library:create("UIStroke", {Parent = main_frame, Color = rgb(35, 35, 40), ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Thickness = 1})
    
    library:create("TextLabel", { Parent = main_frame, Text = settings.Title or "Authentication", FontFace = fonts.font, TextColor3 = themes.preset.accent, TextSize = 24, Size = dim2(1, 0, 0, 40), BackgroundTransparency = 1, Position = dim2(0, 0, 0, 15) })
    library:create("TextLabel", { Parent = main_frame, Text = settings.Subtitle or "Enter Key", FontFace = fonts.small, TextColor3 = rgb(140, 140, 140), TextSize = 15, Size = dim2(1, 0, 0, 20), BackgroundTransparency = 1, Position = dim2(0, 0, 0, 48) })

    -- Timer Label
    local timer_label = library:create("TextLabel", { Parent = main_frame, Text = "", FontFace = fonts.small, TextColor3 = rgb(200, 50, 50), TextSize = 14, Size = dim2(1, 0, 0, 20), BackgroundTransparency = 1, Position = dim2(0, 0, 1, -25) })

    local input_bg = library:create("Frame", { Parent = main_frame, Size = dim2(0, 320, 0, 45), Position = dim2(0.5, -160, 0.40, 0), BackgroundColor3 = rgb(12, 12, 14) })
    library:create("UICorner", {Parent = input_bg, CornerRadius = dim(0, 8)})
    library:create("UIStroke", {Parent = input_bg, Color = rgb(40, 40, 45), Thickness = 1})
    local input_box = library:create("TextBox", { Parent = input_bg, Size = dim2(1, -20, 1, 0), Position = dim2(0, 10, 0, 0), BackgroundTransparency = 1, TextColor3 = rgb(255, 255, 255), PlaceholderText = "Paste Key...", FontFace = fonts.small, TextSize = 16, BorderSizePixel = 0 })

    local check_btn = library:create("TextButton", { Parent = main_frame, Size = dim2(0, 150, 0, 40), Position = dim2(0.5, -165, 0.70, 0), BackgroundColor3 = themes.preset.accent, Text = "Submit", TextColor3 = rgb(255, 255, 255), FontFace = fonts.font, TextSize = 15, AutoButtonColor = false })
    library:create("UICorner", {Parent = check_btn, CornerRadius = dim(0, 8)})

    local link_btn = library:create("TextButton", { Parent = main_frame, Size = dim2(0, 150, 0, 40), Position = dim2(0.5, 15, 0.70, 0), BackgroundColor3 = rgb(35, 35, 40), Text = "Get Key", TextColor3 = rgb(200, 200, 200), FontFace = fonts.font, TextSize = 15, AutoButtonColor = false })
    library:create("UICorner", {Parent = link_btn, CornerRadius = dim(0, 8)})

    -- Logic
    local function finish()
        library.authorized = true
        tween_service:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play()
        key_gui:Destroy()
        blur:Destroy()
        on_success()
    end

    -- Timer Logic
    if Timer > 0 then
        task.spawn(function()
            local remaining = Timer
            while remaining > 0 and key_gui.Parent do
                timer_label.Text = "Time Left: " .. remaining .. "s"
                task.wait(1)
                remaining = remaining - 1
            end
            if not library.authorized then
                check_btn.Text = "Timed Out"
                check_btn.Active = false
            end
        end)
    end

    check_btn.MouseButton1Click:Connect(function()
        if input_box.Text == settings.Key or input_box.Text == tostring(settings.Key) then
            check_btn.BackgroundColor3 = rgb(50, 200, 100); check_btn.Text = "Success"
            task.wait(0.5)
            finish()
        else
            check_btn.BackgroundColor3 = rgb(200, 50, 50); check_btn.Text = "Invalid"
            task.wait(1)
            check_btn.BackgroundColor3 = themes.preset.accent; check_btn.Text = "Submit"
        end
    end)
    
    link_btn.MouseButton1Click:Connect(function()
        if settings.SecondAction.Type == "Link" then setclipboard(settings.SecondAction.Parameter) end
    end)
end

-- Main Window
function library:window(properties)
    local cfg = { 
        suffix = properties.suffix or "tech",
        name = properties.name or "nebula",
        size = properties.size or dim2(0, 700, 0, 565),
        key_system = properties.KeySystem or false,
        key_settings = properties.KeySettings or {},
        items = {},
    }
    
    local parent = game.CoreGui
    if cfg.key_system then parent = nil else library.authorized = true end

    library["items"] = library:create("ScreenGui", { Parent = parent, Name = "MileniumMain", Enabled = not cfg.key_system, IgnoreGuiInset = true })
    library["open_gui"] = library:create("ScreenGui", { Parent = parent, Name = "MileniumOpen", Enabled = false, IgnoreGuiInset = true })
    library["other"] = library:create("ScreenGui", { Parent = parent, Name = "\0", ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true })

    local items = cfg.items; do
        -- Main Frame
        items["main"] = library:create("Frame", {
            Parent = library["items"], Size = cfg.size, Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2),
            BackgroundColor3 = rgb(14, 14, 16), BorderSizePixel = 0
        }); library:draggify(items["main"]); library:resizify(items["main"])
        
        library:create("UICorner", {Parent = items["main"], CornerRadius = dim(0, 10)})
        
        -- FIXED: UIStroke now follows Theme
        items["main_stroke"] = library:create("UIStroke", { Color = themes.preset.accent, Parent = items["main"], ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
        library:apply_theme(items["main_stroke"], "accent", "Color")

        items["side_frame"] = library:create("Frame", {
            Parent = items["main"], BackgroundTransparency = 1, Size = dim2(0, 196, 1, -25), BackgroundColor3 = rgb(14, 14, 16)
        })

        -- OPEN BUTTON (Fix 3: Draggable & Reset)
        local open_btn = library:create("TextButton", {
            Parent = library["open_gui"], Text = "", AutoButtonColor = false, BackgroundColor3 = rgb(20, 20, 20),
            Position = dim2(0.5, 0, 0, 10), AnchorPoint = vec2(0.5, 0), Size = dim2(0, 120, 0, 35), BorderSizePixel = 0
        })
        library:create("UICorner", {Parent = open_btn, CornerRadius = dim(0, 6)})
        local open_stroke = library:create("UIStroke", {Parent = open_btn, Color = themes.preset.accent, Thickness = 1.5})
        library:apply_theme(open_stroke, "accent", "Color") -- Theme applied
        
        library:create("TextLabel", { Parent = open_btn, Size = dim2(1,0,1,0), BackgroundTransparency = 1, Text = "Open Menu", TextColor3 = rgb(255,255,255), FontFace = fonts.font, TextSize = 16 })
        
        -- Make Open Button Draggable
        library:draggify(open_btn)

        local close_button = library:create("TextButton", {
            Parent = items["main"], Text = "X", FontFace = fonts.font, TextColor3 = rgb(150, 150, 150),
            BackgroundTransparency = 1, Size = dim2(0, 30, 0, 30), Position = dim2(1, -5, 0, 5), AnchorPoint = vec2(1, 0), TextSize = 18
        })

        -- Open/Close Logic
        close_button.MouseButton1Click:Connect(function()
            library:tween(items["main"], {Size = dim2(0,0,0,0), Position = dim2(0.5,0,0.5,0), BackgroundTransparency = 1}, Enum.EasingStyle.Back, 0.4)
            task.wait(0.4)
            library["items"].Enabled = false
            library["open_gui"].Enabled = true
            -- RESET OPEN BUTTON POSITION
            open_btn.Position = dim2(0.5, 0, 0, 10)
        end)

        open_btn.MouseButton1Click:Connect(function()
            library["open_gui"].Enabled = false
            library["items"].Enabled = true
            items["main"].Size = dim2(0,0,0,0)
            items["main"].Position = dim2(0.5,0,0.5,0)
            items["main"].BackgroundTransparency = 0
            library:tween(items["main"], {Size = cfg.size, Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2)}, Enum.EasingStyle.Elastic, 0.8)
        end)

        -- Content
        items["button_holder"] = library:create("Frame", { Parent = items["side_frame"], BackgroundTransparency = 1, Position = dim2(0, 0, 0, 60), Size = dim2(1, 0, 1, -60) })
        library:create("UIListLayout", { Parent = items["button_holder"], Padding = dim(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })
        library:create("UIPadding", { PaddingTop = dim(0, 16), Parent = items["button_holder"], PaddingLeft = dim(0, 10), PaddingRight = dim(0, 10) })

        local title_btn = library:create("TextButton", { Parent = items["side_frame"], BackgroundTransparency = 1, Size = dim2(1,0,0,70), Text = "", ZIndex = 2 })
        items["title"] = library:create("TextLabel", {
            FontFace = fonts.font, Text = string.format('<u>%s</u><font color="rgb(255,255,255)">%s</font>', cfg.name, cfg.suffix),
            Parent = title_btn, BackgroundTransparency = 1, Size = dim2(1, 0, 1, 0), TextColor3 = themes.preset.accent, RichText = true, TextSize = 30
        }); library:apply_theme(items["title"], "accent", "TextColor3")

        title_btn.MouseButton1Click:Connect(function()
            current_theme_idx = current_theme_idx + 1
            if current_theme_idx > #theme_list then current_theme_idx = 1 end
            library:update_theme("accent", theme_list[current_theme_idx].Color)
            notifications:create_notification({name = "Theme", info = "Switched to " .. theme_list[current_theme_idx].Name})
        end)

        items["multi_holder"] = library:create("Frame", { Parent = items["main"], BackgroundTransparency = 1, Position = dim2(0, 196, 0, 0), Size = dim2(1, -196, 0, 56) })
        
        -- Separator Line
        items["header_sep"] = library:create("Frame", { AnchorPoint = vec2(0, 1), Parent = items["multi_holder"], Position = dim2(0, 0, 1, 0), Size = dim2(1, 0, 0, 1), BackgroundColor3 = themes.preset.accent })
        library:apply_theme(items["header_sep"], "accent", "BackgroundColor3")

        items["global_fade"] = library:create("Frame", { Parent = items["main"], BackgroundTransparency = 1, Position = dim2(0, 196, 0, 56), Size = dim2(1, -196, 1, -81), BackgroundColor3 = rgb(14, 14, 16), ZIndex = 2 })
        
        -- Footer
        items["info"] = library:create("Frame", { AnchorPoint = vec2(0, 1), Parent = items["main"], Position = dim2(0, 0, 1, 0), Size = dim2(1, 0, 0, 25), BackgroundColor3 = rgb(23, 23, 25) })
        library:create("UICorner", { Parent = items["info"], CornerRadius = dim(0, 10) })
        items["footer_fill"] = library:create("Frame", { Parent = items["info"], Size = dim2(1, 0, 0, 6), BackgroundColor3 = rgb(23, 23, 25), BorderSizePixel = 0 })
        
        items["other_info"] = library:create("TextLabel", { Parent = items["info"], RichText = true, TextColor3 = themes.preset.accent, Text = "Meno Library Remastered", Size = dim2(1, 0, 0, 0), Position = dim2(0, -10, 0.5, -1), AnchorPoint = vec2(0, 0.5), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Right, FontFace = fonts.font, TextSize = 14 })
        library:apply_theme(items["other_info"], "accent", "TextColor3")
    end

    -- Logo Function (Fix 2)
    function cfg:logo(assetId)
        if items["logo_img"] then items["logo_img"]:Destroy() end
        
        -- Adjust title text to make room
        items["title"].Size = dim2(1, -40, 1, 0)
        items["title"].Position = dim2(0, 40, 0, 0)
        items["title"].TextXAlignment = Enum.TextXAlignment.Left
        
        items["logo_img"] = library:create("ImageLabel", {
            Parent = items["side_frame"],
            Image = assetId,
            Size = dim2(0, 40, 0, 40),
            Position = dim2(0, 10, 0, 15),
            BackgroundTransparency = 1,
            ScaleType = Enum.ScaleType.Fit
        })
    end

    function cfg.toggle_menu(bool)
        if not library.authorized then return end
        library["items"].Enabled = bool
        library["open_gui"].Enabled = not bool
    end 

    if cfg.key_system then
        library:key_system(cfg.key_settings, function()
            library["items"].Parent = game.CoreGui; library["items"].Enabled = true
            library["other"].Parent = game.CoreGui; library["open_gui"].Parent = game.CoreGui
        end)
    end

    return setmetatable(cfg, library)
end 

-- Tab Function
function library:tab(properties)
    local cfg = { name = properties.name or "Tab", icon = properties.icon or "", tabs = properties.tabs or {}, pages = {}, items = {} }
    local items = cfg.items; do 
        items["tab_holder"] = library:create("Frame", { Parent = library.cache, Visible = false, BackgroundTransparency = 1, Position = dim2(0, 196, 0, 56), Size = dim2(1, -216, 1, -101) })
        
        items["button"] = library:create("TextButton", { FontFace = fonts.font, TextColor3 = rgb(255, 255, 255), Text = "", Parent = self.items["button_holder"], AutoButtonColor = false, BackgroundTransparency = 1, Size = dim2(1, 0, 0, 35), TextSize = 16 })
        
        items["icon"] = library:create("ImageLabel", { ImageColor3 = rgb(72, 72, 73), Parent = items["button"], AnchorPoint = vec2(0, 0.5), Image = cfg.icon, BackgroundTransparency = 1, Position = dim2(0, 10, 0.5, 0), Size = dim2(0, 22, 0, 22) })
        library:apply_theme(items["icon"], "accent", "ImageColor3")
        
        items["name"] = library:create("TextLabel", { FontFace = fonts.font, TextColor3 = rgb(72, 72, 73), Text = cfg.name, Parent = items["button"], Size = dim2(0, 0, 1, 0), Position = dim2(0, 40, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, TextSize = 16 })
        
        items["multi_section_button_holder"] = library:create("Frame", { Parent = library.cache, BackgroundTransparency = 1, Visible = false, Size = dim2(1, 0, 1, 0) })
        library:create("UIListLayout", { Parent = items["multi_section_button_holder"], Padding = dim(0, 7), SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Horizontal })
        library:create("UIPadding", { PaddingTop = dim(0, 8), PaddingBottom = dim(0, 7), Parent = items["multi_section_button_holder"], PaddingRight = dim(0, 7), PaddingLeft = dim(0, 7) })

        for _, section in cfg.tabs do
            local data = {items = {}} 
            local multi_items = data.items; do 
                multi_items["button"] = library:create("TextButton", { FontFace = fonts.font, TextColor3 = rgb(255, 255, 255), AutoButtonColor = false, Text = "", Parent = items["multi_section_button_holder"], Size = dim2(0, 0, 0, 39), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X })
                multi_items["name"] = library:create("TextLabel", { FontFace = fonts.font, TextColor3 = rgb(62, 62, 63), Text = section, Parent = multi_items["button"], Size = dim2(0, 0, 1, 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY, TextSize = 16 })
                library:create("UIPadding", { Parent = multi_items["name"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5) })
                
                multi_items["accent"] = library:create("Frame", { AnchorPoint = vec2(0, 1), Parent = multi_items["button"], Position = dim2(0, 10, 1, 4), Size = dim2(1, -20, 0, 6), BackgroundColor3 = themes.preset.accent })
                library:apply_theme(multi_items["accent"], "accent", "BackgroundColor3")
                library:create("UICorner", { Parent = multi_items["accent"], CornerRadius = dim(0, 999) })
                library:create("UIPadding", { Parent = multi_items["button"], PaddingRight = dim(0, 10), PaddingLeft = dim(0, 10) })
                
                multi_items["tab"] = library:create("Frame", { Parent = library.cache, BackgroundTransparency = 1, Size = dim2(1, -20, 1, -20), Visible = false })
                library:create("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, HorizontalFlex = Enum.UIFlexAlignment.Fill, Parent = multi_items["tab"], Padding = dim(0, 7), VerticalFlex = Enum.UIFlexAlignment.Fill })
            end

            data.text = multi_items["name"]; data.accent = multi_items["accent"]; data.button = multi_items["button"]; data.page = multi_items["tab"]
            data.parent = setmetatable(data, library):sub_tab({}).items["tab_parent"]

            function data.open_page()
                local page = cfg.current_multi; 
                if page and page.text ~= data.text then 
                    self.items["global_fade"].BackgroundTransparency = 0
                    library:tween(self.items["global_fade"], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                    page.page.Visible = false; page.page.Parent = library["cache"] 
                    library:tween(page.text, {TextColor3 = rgb(62, 62, 63)}); library:tween(page.accent, {BackgroundTransparency = 1})
                end
                library:tween(data.text, {TextColor3 = rgb(255, 255, 255)})
                library:tween(data.accent, {BackgroundTransparency = 0})
                data.page.Visible = true; data.page.Parent = items["tab_holder"]
                cfg.current_multi = data
            end
            multi_items["button"].MouseButton1Down:Connect(function() data.open_page() end)
            cfg.pages[#cfg.pages + 1] = setmetatable(data, library)
        end 
        cfg.pages[1].open_page()
    end 

    function cfg.open_tab() 
        local selected_tab = self.selected_tab
        if selected_tab then 
            library:tween(selected_tab[1], {BackgroundTransparency = 1})
            library:tween(selected_tab[2], {ImageColor3 = rgb(72, 72, 73)})
            library:tween(selected_tab[3], {TextColor3 = rgb(72, 72, 73)})
            selected_tab[4].Visible = false; selected_tab[4].Parent = library["cache"]
            selected_tab[5].Visible = false; selected_tab[5].Parent = library["cache"]
        end
        library:tween(items["button"], {BackgroundTransparency = 0})
        library:tween(items["icon"], {ImageColor3 = themes.preset.accent})
        library:tween(items["name"], {TextColor3 = rgb(255, 255, 255)})
        items["tab_holder"].Visible = true; items["tab_holder"].Parent = self.items["main"]
        items["multi_section_button_holder"].Visible = true; items["multi_section_button_holder"].Parent = self.items["multi_holder"]
        self.selected_tab = { items["button"], items["icon"], items["name"], items["tab_holder"], items["multi_section_button_holder"] }
    end
    items["button"].MouseButton1Down:Connect(function() cfg.open_tab() end)
    if not self.selected_tab then cfg.open_tab() end
    return unpack(cfg.pages)
end

function library:seperator(properties)
    local cfg = {items = {}, name = properties.Name or "General"}
    local items = cfg.items; do 
        items["name"] = library:create("TextLabel", { FontFace = fonts.font, TextColor3 = rgb(72, 72, 73), Text = cfg.name, Parent = self.items["button_holder"], Size = dim2(1, 0, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, AutomaticSize = Enum.AutomaticSize.XY, TextSize = 16 })
        library:create("UIPadding", { Parent = items["name"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5) })                
    end; return setmetatable(cfg, library)
end 

function library:column(properties) 
    local cfg = {items = {}, size = properties.size or 1}
    local items = cfg.items; do     
        items["column"] = library:create("Frame", { Parent = self["parent"] or self.items["tab_parent"], BackgroundTransparency = 1, Size = dim2(0, 0, cfg.size, 0) })
        library:create("UIPadding", { PaddingBottom = dim(0, 10), Parent = items["column"] })
        library:create("UIListLayout", { Parent = items["column"], HorizontalFlex = Enum.UIFlexAlignment.Fill, Padding = dim(0, 10), FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder })
    end; return setmetatable(cfg, library)
end 

function library:sub_tab(properties) 
    local cfg = {items = {}, size = properties.size or 1}
    local items = cfg.items; do 
        items["tab_parent"] = library:create("Frame", { Parent = self.items["tab"], BackgroundTransparency = 1, Size = dim2(0,0,cfg.size,0) })
        library:create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalFlex = Enum.UIFlexAlignment.Fill, VerticalFlex = Enum.UIFlexAlignment.Fill, Parent = items["tab_parent"], Padding = dim(0, 7) })
    end; return setmetatable(cfg, library)
end 

function library:section(properties)
    local cfg = { name = properties.name or "section", items = {} };
    local items = cfg.items; do 
        items["outline"] = library:create("Frame", { Parent = self.items["column"], Size = dim2(0, 0, 0.5, -3), BackgroundColor3 = rgb(25, 25, 29) })
        library:create("UICorner", { Parent = items["outline"], CornerRadius = dim(0, 7) })
        items["inline"] = library:create("Frame", { Parent = items["outline"], Position = dim2(0, 1, 0, 1), Size = dim2(1, -2, 1, -2), BackgroundColor3 = rgb(22, 22, 24) })
        library:create("UICorner", { Parent = items["inline"], CornerRadius = dim(0, 7) })
        items["scrolling"] = library:create("ScrollingFrame", { ScrollBarImageColor3 = rgb(44, 44, 46), Active = true, AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, Parent = items["inline"], Size = dim2(1, 0, 1, -40), BackgroundTransparency = 1, Position = dim2(0, 0, 0, 35), CanvasSize = dim2(0, 0, 0, 0), BorderSizePixel = 0 })
        items["elements"] = library:create("Frame", { Parent = items["scrolling"], BackgroundTransparency = 1, Position = dim2(0, 10, 0, 10), Size = dim2(1, -20, 0, 0), AutomaticSize = Enum.AutomaticSize.Y })
        library:create("UIListLayout", { Parent = items["elements"], Padding = dim(0, 10), SortOrder = Enum.SortOrder.LayoutOrder })
        library:create("UIPadding", { PaddingBottom = dim(0, 15), Parent = items["elements"] })
        
        items["button"] = library:create("TextButton", { FontFace = fonts.font, TextColor3 = rgb(255, 255, 255), Text = "", AutoButtonColor = false, Parent = items["outline"], Position = dim2(0, 1, 0, 1), Size = dim2(1, -2, 0, 35), BackgroundColor3 = rgb(19, 19, 21) })
        library:create("UICorner", { Parent = items["button"], CornerRadius = dim(0, 7) })
        items["section_title"] = library:create("TextLabel", { FontFace = fonts.font, TextColor3 = rgb(255, 255, 255), Text = cfg.name, Parent = items["button"], Size = dim2(0, 0, 1, 0), Position = dim2(0, 10, 0, -1), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, AutomaticSize = Enum.AutomaticSize.X, TextSize = 16 })
        library:create("Frame", { AnchorPoint = vec2(0, 1), Parent = items["button"], Position = dim2(0, 0, 1, 0), Size = dim2(1, 0, 0, 1), BackgroundColor3 = rgb(36, 36, 37), BorderSizePixel = 0 })
    end; return setmetatable(cfg, library)
end  

function library:toggle(options) 
    local cfg = { enabled = options.enabled, name = options.name or "Toggle", info = options.info, flag = options.flag or library:next_flag(), callback = options.callback or function() end, items = {} }
    flags[cfg.flag] = options.default or false
    local items = cfg.items; do
        items["toggle"] = library:create("TextButton", { FontFace = fonts.small, Text = "", Parent = self.items["elements"], BackgroundTransparency = 1, Size = dim2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y })
        items["name"] = library:create("TextLabel", { FontFace = fonts.small, TextColor3 = rgb(245, 245, 245), Text = cfg.name, Parent = items["toggle"], Size = dim2(1, 0, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, AutomaticSize = Enum.AutomaticSize.XY, TextSize = 16 })
        if cfg.info then library:create("TextLabel", { FontFace = fonts.small, TextColor3 = rgb(130, 130, 130), TextWrapped = true, Text = cfg.info, Parent = items["toggle"], Position = dim2(0, 5, 0, 17), Size = dim2(1, -10, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, AutomaticSize = Enum.AutomaticSize.XY, TextSize = 16 }) end 
        library:create("UIPadding", { Parent = items["name"], PaddingRight = dim(0, 5), PaddingLeft = dim(0, 5) })
        
        items["right_components"] = library:create("Frame", { Parent = items["toggle"], Position = dim2(1, 0, 0, 0), Size = dim2(0, 0, 1, 0), BackgroundTransparency = 1 })
        library:create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = items["right_components"], Padding = dim(0, 9) })
        
        items["toggle_button"] = library:create("TextButton", { AnchorPoint = vec2(1, 0.5), Parent = items["right_components"], Position = dim2(1, -9, 0.5, 0), Size = dim2(0, 36, 0, 18), BackgroundColor3 = themes.preset.accent, Text = "" }); library:apply_theme(items["toggle_button"], "accent", "BackgroundColor3")
        library:create("UICorner", { Parent = items["toggle_button"], CornerRadius = dim(0, 999) })
        items["inline"] = library:create("Frame", { Parent = items["toggle_button"], Size = dim2(1, -2, 1, -2), BorderMode = Enum.BorderMode.Inset, Position = dim2(0, 1, 0, 1), BackgroundColor3 = themes.preset.accent }); library:apply_theme(items["inline"], "accent", "BackgroundColor3")
        library:create("UICorner", { Parent = items["inline"], CornerRadius = dim(0, 999) })
        items["circle"] = library:create("Frame", { Parent = items["inline"], Position = dim2(1, -14, 0, 2), Size = dim2(0, 12, 0, 12), BackgroundColor3 = rgb(255, 255, 255) })
        library:create("UICorner", { Parent = items["circle"], CornerRadius = dim(0, 999) })                        
    end
    
    function cfg.set(bool)
        library:tween(items["toggle_button"], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)})
        library:tween(items["inline"], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)})
        library:tween(items["circle"], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)})
        cfg.callback(bool); flags[cfg.flag] = bool
    end 
    items["toggle"].MouseButton1Click:Connect(function() cfg.enabled = not cfg.enabled; cfg.set(cfg.enabled) end)
    items["toggle_button"].MouseButton1Click:Connect(function() cfg.enabled = not cfg.enabled; cfg.set(cfg.enabled) end)
    cfg.set(options.default or false); config_flags[cfg.flag] = cfg.set
    return setmetatable(cfg, library)
end 

function library:init_config(window) 
    window:seperator({name = "Settings"})
    local main = window:tab({name = "Configs", tabs = {"Main"}})
    
    local column = main:column({})
    local section = column:section({name = "Configs", size = 1})
    
    local column2 = main:column({})
    local section2 = column2:section({name = "Settings", side = "right", size = 1})
    section2:colorpicker({name = "Menu Accent", callback = function(color) library:update_theme("accent", color) end, color = themes.preset.accent})
    section2:keybind({name = "Menu Bind", callback = function(bool) window.toggle_menu(bool) end, default = true})
end

-- Notification
function notifications:create_notification(options)
    local cfg = { name = options.name or "Title", info = options.info or "Info", lifetime = options.lifetime or 3, items = {} }
    local items = cfg.items; do 
        items["notification"] = library:create("Frame", { Parent = library["items"], Size = dim2(0, 210, 0, 53), BackgroundColor3 = rgb(14, 14, 16), AnchorPoint = vec2(1, 0) })
        library:create("UIStroke", { Color = rgb(23, 23, 29), Parent = items["notification"], ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
        library:create("TextLabel", { FontFace = fonts.font, TextColor3 = rgb(255, 255, 255), Text = cfg.name, Parent = items["notification"], Position = dim2(0, 7, 0, 6), TextSize = 14, BackgroundTransparency = 1 })
        library:create("TextLabel", { FontFace = fonts.font, TextColor3 = rgb(145, 145, 145), Text = cfg.info, Parent = items["notification"], Position = dim2(0, 9, 0, 22), TextSize = 14, BackgroundTransparency = 1 })
        items["bar"] = library:create("Frame", { AnchorPoint = vec2(0, 1), Parent = items["notification"], Position = dim2(0, 8, 1, -6), Size = dim2(0, 0, 0, 5), BackgroundColor3 = themes.preset.accent })
        library:create("UICorner", { Parent = items["notification"], CornerRadius = dim(0, 3) })
    end
    
    local offset = 50; for i, v in notifications.notifs do offset += (v.AbsoluteSize.Y + 10) end
    insert(notifications.notifs, items["notification"])
    items["notification"].Position = dim2(1, -20, 0, offset)
    library:tween(items["bar"], {Size = dim2(1, -16, 0, 5)}, Enum.EasingStyle.Quad, cfg.lifetime)

    task.delay(cfg.lifetime, function()
        library:tween(items["notification"], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.5)
        items["notification"]:Destroy(); remove(notifications.notifs, find(notifications.notifs, items["notification"]))
    end)
end

return library
