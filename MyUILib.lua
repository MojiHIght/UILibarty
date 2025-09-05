--Moji Ui V.1

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local MyUILib = {}
MyUILib.theme = {
    Background = Color3.fromRGB(25, 25, 35),
    Topbar = Color3.fromRGB(60, 0, 90),
    Sidebar = Color3.fromRGB(35, 35, 50),
    Section = Color3.fromRGB(45, 45, 65),
    Accent = Color3.fromRGB(170, 0, 255),
    Text = Color3.fromRGB(255, 255, 255)
}

-- 🟣 Utility: Rounded corner
local function addCorner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = obj
    return c
end

-- 🟣 Utility: Stroke
local function addStroke(obj, color)
    local s = Instance.new("UIStroke")
    s.Color = color or MyUILib.theme.Accent
    s.Thickness = 1
    s.Parent = obj
    return s
end

-- 🟣 Utility: Make draggable
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

-- 🟣 Window System
function MyUILib:CreateWindow(title, configName)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = self.theme.Background
    addCorner(MainFrame, 8)
    addStroke(MainFrame, self.theme.Accent)

    local Topbar = Instance.new("Frame", MainFrame)
    Topbar.Size = UDim2.new(1, 0, 0, 35)
    Topbar.BackgroundColor3 = self.theme.Topbar
    addCorner(Topbar, 8)

    local Title = Instance.new("TextLabel", Topbar)
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = self.theme.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14

    makeDraggable(MainFrame, Topbar)

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 150, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = self.theme.Sidebar

    local Container = Instance.new("Frame", MainFrame)
    Container.Size = UDim2.new(1, -150, 1, -35)
    Container.Position = UDim2.new(0, 150, 0, 35)
    Container.BackgroundTransparency = 1

    local UIList = Instance.new("UIListLayout", Sidebar)
    UIList.Padding = UDim.new(0, 5)

    local window = {
        tabs = {},
        values = {},
        configFile = configName .. ".json",
        container = Container
    }

    -- Tab System
    function window:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, -10, 0, 30)
        TabBtn.Text = name
        TabBtn.BackgroundColor3 = MyUILib.theme.Section
        TabBtn.TextColor3 = MyUILib.theme.Text
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 12
        addCorner(TabBtn, 6)

        local TabFrame = Instance.new("ScrollingFrame", Container)
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Visible = false
        TabFrame.ScrollBarThickness = 4
        TabFrame.BackgroundTransparency = 1
        local Layout = Instance.new("UIListLayout", TabFrame)
        Layout.Padding = UDim.new(0, 6)

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(window.tabs) do
                t.frame.Visible = false
            end
            TabFrame.Visible = true
        end)

        local tab = {frame = TabFrame}
        table.insert(window.tabs, tab)
        return tab
    end

    return window
end

----------------------------------------------------------------
-- 🟣 Elements (Block 2)
----------------------------------------------------------------

-- 🟣 Button
function MyUILib:AddButton(tab, text, callback)
    local Btn = Instance.new("TextButton", tab.frame)
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.Text = text
    Btn.BackgroundColor3 = MyUILib.theme.Accent
    Btn.TextColor3 = MyUILib.theme.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    addCorner(Btn, 6)

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 0, 255)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = MyUILib.theme.Accent}):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

-- 🟣 Toggle
function MyUILib:AddToggle(tab, text, default, callback)
    local Frame = Instance.new("Frame", tab.frame)
    Frame.Size = UDim2.new(1, -10, 0, 30)
    Frame.BackgroundColor3 = MyUILib.theme.Section
    addCorner(Frame, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = MyUILib.theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBtn = Instance.new("Frame", Frame)
    ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    addCorner(ToggleBtn, 10)

    local Knob = Instance.new("Frame", ToggleBtn)
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = default and UDim2.new(1, -19, 0, 1) or UDim2.new(0, 1, 0, 1)
    Knob.BackgroundColor3 = default and MyUILib.theme.Accent or Color3.fromRGB(120,120,120)
    addCorner(Knob, 10)

    local state = default
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            TweenService:Create(Knob, TweenInfo.new(0.2), {
                Position = state and UDim2.new(1, -19, 0, 1) or UDim2.new(0, 1, 0, 1),
                BackgroundColor3 = state and MyUILib.theme.Accent or Color3.fromRGB(120,120,120)
            }):Play()
            pcall(callback, state)
        end
    end)
end

-- 🟣 Slider
function MyUILib:AddSlider(tab, text, min, max, default, callback)
    local Frame = Instance.new("Frame", tab.frame)
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.BackgroundColor3 = MyUILib.theme.Section
    addCorner(Frame, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = text .. " : " .. default
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = MyUILib.theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, -20, 0, 10)
    Bar.Position = UDim2.new(0, 10, 0, 30)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    addCorner(Bar, 6)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = MyUILib.theme.Accent
    addCorner(Fill, 6)

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
----------------------------------------------------------------
-- 🟣 Elements (Block 3)
----------------------------------------------------------------

-- 🟣 Dropdown (Rayfield-style)
function MyUILib:AddDropdown(tab, text, list, callback)
    local DropBtn = Instance.new("TextButton", tab.frame)
    DropBtn.Size = UDim2.new(1, -10, 0, 30)
    DropBtn.Text = text .. " ▼"
    DropBtn.BackgroundColor3 = MyUILib.theme.Section
    DropBtn.TextColor3 = MyUILib.theme.Text
    DropBtn.Font = Enum.Font.Gotham
    DropBtn.TextSize = 12
    addCorner(DropBtn, 6)
    addStroke(DropBtn, Color3.fromRGB(80,80,120))

    -- Container ของ Options
    local DropFrame = Instance.new("Frame", tab.frame)
    DropFrame.Size = UDim2.new(1, -10, 0, 0) -- เริ่มต้นสูง 0
    DropFrame.ClipsDescendants = true
    DropFrame.BackgroundColor3 = MyUILib.theme.Section
    addCorner(DropFrame, 6)
    addStroke(DropFrame, Color3.fromRGB(80,80,120))

    local Layout = Instance.new("UIListLayout", DropFrame)
    Layout.Padding = UDim.new(0, 3)

    -- สร้าง Options
    local optionButtons = {}
    for _, v in pairs(list) do
        local Opt = Instance.new("TextButton", DropFrame)
        Opt.Size = UDim2.new(1, -6, 0, 25)
        Opt.Text = v
        Opt.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
        Opt.TextColor3 = MyUILib.theme.Text
        Opt.Font = Enum.Font.Gotham
        Opt.TextSize = 12
        Opt.AutoButtonColor = false
        addCorner(Opt, 4)

        -- Hover effect
        Opt.MouseEnter:Connect(function()
            TweenService:Create(Opt, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(70,70,100)}):Play()
        end)
        Opt.MouseLeave:Connect(function()
            TweenService:Create(Opt, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55,55,75)}):Play()
        end)

        Opt.MouseButton1Click:Connect(function()
            DropBtn.Text = text .. " : " .. v
            -- ปิด Dropdown
            TweenService:Create(DropFrame, TweenInfo.new(0.25), {
                Size = UDim2.new(1, -10, 0, 0)
            }):Play()
            pcall(callback, v)
        end)

        table.insert(optionButtons, Opt)
    end

    -- กดปุ่ม Dropdown → เปิด/ปิด
    local isOpen = false
    DropBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local targetSize = isOpen and (#optionButtons * 30 + 6) or 0
        TweenService:Create(DropFrame, TweenInfo.new(0.25), {
            Size = UDim2.new(1, -10, 0, targetSize)
        }):Play()
    end)
end

-- 🟣 Input Box
function MyUILib:AddInput(tab, placeholder, callback)
    local Box = Instance.new("TextBox", tab.frame)
    Box.Size = UDim2.new(1, -10, 0, 30)
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.BackgroundColor3 = MyUILib.theme.Section
    Box.TextColor3 = MyUILib.theme.Text
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 12
    addCorner(Box, 6)

    Box.FocusLost:Connect(function()
        if Box.Text ~= "" then
            pcall(callback, Box.Text)
        end
    end)
end

-- 🟣 Label / Section
function MyUILib:AddLabel(tab, text)
    local Label = Instance.new("TextLabel", tab.frame)
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Text = text
    Label.TextColor3 = MyUILib.theme.Accent
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    return Label
end

-- 🟣 Keybind
function MyUILib:AddKeybind(tab, text, defaultKey, callback)
    local Btn = Instance.new("TextButton", tab.frame)
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.Text = text .. " : " .. defaultKey.Name
    Btn.BackgroundColor3 = MyUILib.theme.Section
    Btn.TextColor3 = MyUILib.theme.Text
    addCorner(Btn, 6)

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

-- 🟣 ColorPicker (เวอร์ชันง่าย)
function MyUILib:AddColorPicker(tab, text, default, callback)
    local Frame = Instance.new("Frame", tab.frame)
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundColor3 = MyUILib.theme.Section
    addCorner(Frame, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = MyUILib.theme.Text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ColorBtn = Instance.new("TextButton", Frame)
    ColorBtn.Size = UDim2.new(0.3, 0, 0.8, 0)
    ColorBtn.Position = UDim2.new(0.65, 0, 0.1, 0)
    ColorBtn.BackgroundColor3 = default or Color3.fromRGB(255, 0, 0)
    ColorBtn.Text = ""
    addCorner(ColorBtn, 6)

    ColorBtn.MouseButton1Click:Connect(function()
        -- Simple ColorPicker (สุ่มสีทุกครั้งที่กด)
        local newColor = Color3.fromHSV(math.random(), 1, 1)
        TweenService:Create(ColorBtn, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
        pcall(callback, newColor)
    end)
end
----------------------------------------------------------------
-- 🟣 Utils & Extras (Block 4)
----------------------------------------------------------------

-- 🟣 Notification System
function MyUILib:Notify(text, duration)
    duration = duration or 3
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("MyUILibNotify") or Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "MyUILibNotify"

    local Frame = Instance.new("TextLabel", ScreenGui)
    Frame.Size = UDim2.new(0, 250, 0, 40)
    Frame.Position = UDim2.new(1, -260, 1, -50)
    Frame.BackgroundColor3 = self.theme.Topbar
    Frame.TextColor3 = self.theme.Text
    Frame.Text = text
    Frame.TextScaled = true
    addCorner(Frame, 6)
    addStroke(Frame, self.theme.Accent)

    local tweenIn = TweenService:Create(Frame, TweenInfo.new(0.3), {Position = UDim2.new(1, -260, 1, -100)})
    tweenIn:Play()
    task.delay(duration, function()
        local tweenOut = TweenService:Create(Frame, TweenInfo.new(0.3), {Position = UDim2.new(1, -260, 1, 0)})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        Frame:Destroy()
    end)
end

-- 🟣 Save Config
function MyUILib:SaveConfig(window)
    if not window or not window.values then return end
    writefile(window.configFile, HttpService:JSONEncode(window.values))
    self:Notify("Config saved!", 2)
end

-- 🟣 Load Config
function MyUILib:LoadConfig(window)
    if not window or not window.values then return end
    if isfile(window.configFile) then
        local data = HttpService:JSONDecode(readfile(window.configFile))
        window.values = data
        self:Notify("Config loaded!", 2)
    end
end

-- 🟣 Hotkey toggle UI on/off
function MyUILib:BindToggleKey(window, key)
    local visible = true
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == key then
            visible = not visible
            window.container.Parent.Visible = visible
        end
    end)
end

return MyUILib
