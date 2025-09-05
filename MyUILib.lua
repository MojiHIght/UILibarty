--====================================================
-- 🟣 Moji UI V.2 - Block 1 (Core / Window System Glass Effect)
--====================================================

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local MyUILib = {}
MyUILib.theme = {
    Background = Color3.fromRGB(25, 25, 35),
    Topbar     = Color3.fromRGB(90, 0, 140),
    Sidebar    = Color3.fromRGB(40, 40, 60),
    Section    = Color3.fromRGB(55, 55, 80),
    Accent     = Color3.fromRGB(170, 0, 255),
    Text       = Color3.fromRGB(255, 255, 255)
}

-- Utility: Rounded corner
local function addCorner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = obj
    return c
end

-- Utility: Stroke
local function addStroke(obj, color, th)
    local s = Instance.new("UIStroke")
    s.Color = color or MyUILib.theme.Accent
    s.Thickness = th or 1
    s.Transparency = 0.3
    s.Parent = obj
    return s
end

-- Utility: Gradient
local function addGradient(obj, colors)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(colors or {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 0, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
    })
    g.Rotation = 90
    g.Parent = obj
    return g
end

-- Utility: Blur (Glass Effect)
local function addGlass(obj, intensity)
    local blur = Instance.new("UIStroke")
    blur.Color = Color3.fromRGB(255, 255, 255)
    blur.Thickness = intensity or 2
    blur.Transparency = 0.9
    blur.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    blur.Parent = obj
    return blur
end

-- Utility: Make draggable
local function makeDraggable(frame, dragHandle)
    local dragging, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- 🟣 Create Window
function MyUILib:CreateWindow(title, configName)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MojiUI"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = game:GetService("CoreGui")

    -- MainFrame
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 680, 0, 440)
    MainFrame.Position = UDim2.new(0.5, -340, 0.5, -220)
    MainFrame.BackgroundTransparency = 0.25
    MainFrame.BackgroundColor3 = MyUILib.theme.Background
    addCorner(MainFrame, 14)
    addStroke(MainFrame, MyUILib.theme.Accent, 2)
    addGradient(MainFrame, {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 0, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 45))
    })
    addGlass(MainFrame, 2)

    -- Topbar
    local Topbar = Instance.new("Frame", MainFrame)
    Topbar.Size = UDim2.new(1, 0, 0, 42)
    Topbar.BackgroundColor3 = MyUILib.theme.Topbar
    Topbar.BackgroundTransparency = 0.15
    addCorner(Topbar, 12)

    local Title = Instance.new("TextLabel", Topbar)
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "✨ " .. title
    Title.TextColor3 = MyUILib.theme.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16

    makeDraggable(MainFrame, Topbar)

    -- Sidebar
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 170, 1, -42)
    Sidebar.Position = UDim2.new(0, 0, 0, 42)
    Sidebar.BackgroundTransparency = 0.25
    Sidebar.BackgroundColor3 = MyUILib.theme.Sidebar
    addCorner(Sidebar, 12)
    addGlass(Sidebar, 1)

    local UIList = Instance.new("UIListLayout", Sidebar)
    UIList.Padding = UDim.new(0, 6)

    -- Container
    local Container = Instance.new("Frame", MainFrame)
    Container.Size = UDim2.new(1, -170, 1, -42)
    Container.Position = UDim2.new(0, 170, 0, 42)
    Container.BackgroundTransparency = 1

    local window = {
        tabs = {},
        values = {},
        configFile = (configName or "MojiConfig") .. ".json",
        container = Container
    }

    -- Tab System
    function window:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, -12, 0, 34)
        TabBtn.Text = " " .. name
        TabBtn.BackgroundColor3 = MyUILib.theme.Section
        TabBtn.TextColor3 = MyUILib.theme.Text
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 13
        TabBtn.AutoButtonColor = false
        addCorner(TabBtn, 8)

        local TabFrame = Instance.new("ScrollingFrame", Container)
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Visible = false
        TabFrame.ScrollBarThickness = 4
        TabFrame.BackgroundTransparency = 1
        local Layout = Instance.new("UIListLayout", TabFrame)
        Layout.Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(window.tabs) do
                t.frame.Visible = false
            end
            TabFrame.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.25), {BackgroundColor3 = MyUILib.theme.Accent}):Play()
            task.delay(0.35, function()
                TweenService:Create(TabBtn, TweenInfo.new(0.25), {BackgroundColor3 = MyUILib.theme.Section}):Play()
            end)
        end)

        local tab = {frame = TabFrame}
        table.insert(window.tabs, tab)
        return tab
    end

    return window
end
--====================================================
-- 🟣 Moji UI V.2 - Block 2 (Button / Toggle / Slider)
--====================================================

-- 🟣 Button
function MyUILib:AddButton(tab, text, callback)
    local Btn = Instance.new("TextButton", tab.frame)
    Btn.Size = UDim2.new(1, -12, 0, 34)
    Btn.Text = text
    Btn.BackgroundColor3 = MyUILib.theme.Accent
    Btn.TextColor3 = MyUILib.theme.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.AutoButtonColor = false
    addCorner(Btn, 8)
    addStroke(Btn, Color3.fromRGB(200, 100, 255), 1)

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 0, 255)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = MyUILib.theme.Accent}):Play()
    end)
    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -16, 0, 32)}):Play()
        task.wait(0.12)
        TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -12, 0, 34)}):Play()
        pcall(callback)
    end)
end

-- 🟣 Toggle (iOS style)
function MyUILib:AddToggle(tab, text, default, callback)
    local Frame = Instance.new("Frame", tab.frame)
    Frame.Size = UDim2.new(1, -12, 0, 34)
    Frame.BackgroundColor3 = MyUILib.theme.Section
    addCorner(Frame, 8)
    addStroke(Frame, MyUILib.theme.Accent, 1)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextColor3 = MyUILib.theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBtn = Instance.new("Frame", Frame)
    ToggleBtn.Size = UDim2.new(0, 48, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -60, 0.5, -11)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    addCorner(ToggleBtn, 12)
    addStroke(ToggleBtn, Color3.fromRGB(120,120,120), 1)

    local Knob = Instance.new("Frame", ToggleBtn)
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = default and UDim2.new(1, -21, 0, 1) or UDim2.new(0, 1, 0, 1)
    Knob.BackgroundColor3 = default and MyUILib.theme.Accent or Color3.fromRGB(130,130,130)
    addCorner(Knob, 10)

    local state = default
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            TweenService:Create(Knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = state and UDim2.new(1, -21, 0, 1) or UDim2.new(0, 1, 0, 1),
                BackgroundColor3 = state and MyUILib.theme.Accent or Color3.fromRGB(130,130,130)
            }):Play()
            TweenService:Create(ToggleBtn, TweenInfo.new(0.25), {
                BackgroundColor3 = state and Color3.fromRGB(80, 40, 120) or Color3.fromRGB(60, 60, 80)
            }):Play()
            pcall(callback, state)
        end
    end)
end

-- 🟣 Slider (glow fill)
function MyUILib:AddSlider(tab, text, min, max, default, callback)
    local Frame = Instance.new("Frame", tab.frame)
    Frame.Size = UDim2.new(1, -12, 0, 56)
    Frame.BackgroundColor3 = MyUILib.theme.Section
    addCorner(Frame, 8)
    addStroke(Frame, MyUILib.theme.Accent, 1)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = text .. " : " .. default
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextColor3 = MyUILib.theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, -20, 0, 12)
    Bar.Position = UDim2.new(0, 10, 0, 34)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    addCorner(Bar, 8)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = MyUILib.theme.Accent
    addCorner(Fill, 8)

    addGradient(Fill, {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 200))
    })

    local value = default
    local dragging = false

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * rel)
            Fill.Size = UDim2.new(rel, 0, 1, 0)
            Label.Text = text .. " : " .. value
            pcall(callback, value)
        end
    end)
end
--====================================================
-- 🟣 Moji UI V.2 - Block 3 (Dropdown / Input / Label / Keybind / ColorPicker)
--====================================================

-- 🟣 Dropdown (animated slide)
function MyUILib:AddDropdown(tab, text, list, callback)
    local DropBtn = Instance.new("TextButton", tab.frame)
    DropBtn.Size = UDim2.new(1, -12, 0, 34)
    DropBtn.Text = text .. " ▼"
    DropBtn.BackgroundColor3 = MyUILib.theme.Section
    DropBtn.TextColor3 = MyUILib.theme.Text
    DropBtn.Font = Enum.Font.Gotham
    DropBtn.TextSize = 13
    DropBtn.AutoButtonColor = false
    addCorner(DropBtn, 8)
    addStroke(DropBtn, MyUILib.theme.Accent, 1)

    local DropFrame = Instance.new("Frame", tab.frame)
    DropFrame.Size = UDim2.new(1, -12, 0, 0)
    DropFrame.ClipsDescendants = true
    DropFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    DropFrame.Visible = false
    addCorner(DropFrame, 8)
    addStroke(DropFrame, Color3.fromRGB(120,120,160), 1)

    local Layout = Instance.new("UIListLayout", DropFrame)
    Layout.Padding = UDim.new(0, 3)

    local optionButtons = {}
    for _, v in pairs(list) do
        local Opt = Instance.new("TextButton", DropFrame)
        Opt.Size = UDim2.new(1, -8, 0, 28)
        Opt.Text = v
        Opt.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
        Opt.TextColor3 = MyUILib.theme.Text
        Opt.Font = Enum.Font.Gotham
        Opt.TextSize = 12
        Opt.AutoButtonColor = false
        addCorner(Opt, 6)

        Opt.MouseEnter:Connect(function()
            TweenService:Create(Opt, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,80,120)}):Play()
        end)
        Opt.MouseLeave:Connect(function()
            TweenService:Create(Opt, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55,55,75)}):Play()
        end)

        Opt.MouseButton1Click:Connect(function()
            DropBtn.Text = text .. " : " .. v
            TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -12, 0, 0)}):Play()
            task.delay(0.3, function() DropFrame.Visible = false end)
            pcall(callback, v)
        end)

        table.insert(optionButtons, Opt)
    end

    local isOpen = false
    DropBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            DropFrame.Visible = true
            TweenService:Create(DropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(1, -12, 0, #optionButtons * 32 + 8)
            }):Play()
        else
            TweenService:Create(DropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(1, -12, 0, 0)
            }):Play()
            task.delay(0.3, function() DropFrame.Visible = false end)
        end
    end)
end

-- 🟣 Input Box
function MyUILib:AddInput(tab, placeholder, callback)
    local Box = Instance.new("TextBox", tab.frame)
    Box.Size = UDim2.new(1, -12, 0, 34)
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.BackgroundColor3 = MyUILib.theme.Section
    Box.TextColor3 = MyUILib.theme.Text
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 13
    addCorner(Box, 8)
    addStroke(Box, MyUILib.theme.Accent, 1)

    Box.FocusLost:Connect(function()
        if Box.Text ~= "" then
            pcall(callback, Box.Text)
        end
    end)
end

-- 🟣 Label / Section
function MyUILib:AddLabel(tab, text)
    local Label = Instance.new("TextLabel", tab.frame)
    Label.Size = UDim2.new(1, -12, 0, 24)
    Label.Text = text
    Label.TextColor3 = MyUILib.theme.Accent
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    return Label
end

-- 🟣 Keybind
function MyUILib:AddKeybind(tab, text, defaultKey, callback)
    local Btn = Instance.new("TextButton", tab.frame)
    Btn.Size = UDim2.new(1, -12, 0, 34)
    Btn.Text = text .. " : " .. defaultKey.Name
    Btn.BackgroundColor3 = MyUILib.theme.Section
    Btn.TextColor3 = MyUILib.theme.Text
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    addCorner(Btn, 8)
    addStroke(Btn, MyUILib.theme.Accent, 1)

    local key = defaultKey
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == key then
            pcall(callback)
        end
    end)

    Btn.MouseButton1Click:Connect(function()
        Btn.Text = text .. " : ..."
        local con
        con = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                key = input.KeyCode
                Btn.Text = text .. " : " .. key.Name
                con:Disconnect()
            end
        end)
    end)
end

-- 🟣 ColorPicker (Pop-up Circle)
function MyUILib:AddColorPicker(tab, text, default, callback)
    local Frame = Instance.new("Frame", tab.frame)
    Frame.Size = UDim2.new(1, -12, 0, 40)
    Frame.BackgroundColor3 = MyUILib.theme.Section
    addCorner(Frame, 8)
    addStroke(Frame, MyUILib.theme.Accent, 1)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = MyUILib.theme.Text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ColorBtn = Instance.new("TextButton", Frame)
    ColorBtn.Size = UDim2.new(0.3, 0, 0.8, 0)
    ColorBtn.Position = UDim2.new(0.65, 0, 0.1, 0)
    ColorBtn.BackgroundColor3 = default or Color3.fromRGB(255, 0, 0)
    ColorBtn.Text = ""
    addCorner(ColorBtn, 6)

    -- Pop-up Picker
    ColorBtn.MouseButton1Click:Connect(function()
        local Popup = Instance.new("Frame", game:GetService("CoreGui").MojiUI)
        Popup.Size = UDim2.new(0, 200, 0, 200)
        Popup.Position = UDim2.new(0.5, -100, 0.5, -100)
        Popup.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        Popup.BackgroundTransparency = 0.1
        addCorner(Popup, 10)
        addStroke(Popup, MyUILib.theme.Accent, 2)

        local Wheel = Instance.new("ImageButton", Popup)
        Wheel.Size = UDim2.new(1, -20, 1, -50)
        Wheel.Position = UDim2.new(0, 10, 0, 10)
        Wheel.BackgroundTransparency = 1
        Wheel.Image = "rbxassetid://6020299385" -- วงล้อสี
        Wheel.ImageColor3 = Color3.fromRGB(255,255,255)

        local Close = Instance.new("TextButton", Popup)
        Close.Size = UDim2.new(1, -20, 0, 30)
        Close.Position = UDim2.new(0, 10, 1, -40)
        Close.BackgroundColor3 = MyUILib.theme.Accent
        Close.Text = "OK"
        Close.Font = Enum.Font.GothamBold
        Close.TextColor3 = Color3.fromRGB(255,255,255)
        addCorner(Close, 6)

        Wheel.MouseButton1Click:Connect(function(x, y)
            local relX = (x.Position.X - Wheel.AbsolutePosition.X) / Wheel.AbsoluteSize.X
            local newColor = Color3.fromHSV(relX, 1, 1)
            TweenService:Create(ColorBtn, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
            pcall(callback, newColor)
        end)

        Close.MouseButton1Click:Connect(function()
            Popup:Destroy()
        end)
    end)
end
--====================================================
-- 🟣 Moji UI V.2 - Block 4 (Utils / Notify / Config / Hotkey)
--====================================================

-- 🟣 Notification (Toast แบบเล็ก)
function MyUILib:Notify(text, duration)
    duration = duration or 2
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("MojiNotify") 
        or Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "MojiNotify"

    local Frame = Instance.new("TextLabel", ScreenGui)
    Frame.Size = UDim2.new(0, 200, 0, 36)
    Frame.Position = UDim2.new(1, -220, 1, -60)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
    Frame.BackgroundTransparency = 0.15
    Frame.TextColor3 = MyUILib.theme.Text
    Frame.Text = text
    Frame.TextScaled = true
    Frame.Font = Enum.Font.GothamBold
    Frame.TextSize = 13
    addCorner(Frame, 8)
    addStroke(Frame, MyUILib.theme.Accent, 1)

    -- Slide in
    local tweenIn = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -220, 1, -110)
    })
    tweenIn:Play()

    -- Auto remove
    task.delay(duration, function()
        local tweenOut = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Position = UDim2.new(1, -220, 1, -40),
            BackgroundTransparency = 1,
            TextTransparency = 1
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()
        Frame:Destroy()
    end)
end

-- 🟣 Save Config
function MyUILib:SaveConfig(window)
    if not window or not window.values then return end
    writefile(window.configFile, HttpService:JSONEncode(window.values))
    self:Notify("✅ Config saved!", 2)
end

-- 🟣 Load Config
function MyUILib:LoadConfig(window)
    if not window or not window.values then return end
    if isfile(window.configFile) then
        local data = HttpService:JSONDecode(readfile(window.configFile))
        window.values = data
        self:Notify("📂 Config loaded!", 2)
    end
end

-- 🟣 Hotkey toggle UI on/off
function MyUILib:BindToggleKey(window, key)
    local visible = true
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == key then
            visible = not visible
            window.container.Parent.Visible = visible
            self:Notify(visible and "📑 UI Shown" or "🙈 UI Hidden", 1.5)
        end
    end)
end

return MyUILib
