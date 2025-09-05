--====================================================
-- 🟣 Moji UI V.4 - Fluent Style (Block 1: Core)
--====================================================

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local MyUILib = {}
MyUILib.theme = {
    Background = Color3.fromRGB(18, 18, 18),    -- Main BG
    Topbar     = Color3.fromRGB(18, 18, 18),    -- Topbar
    Sidebar    = Color3.fromRGB(14, 14, 14),    -- Sidebar
    Section    = Color3.fromRGB(30, 30, 30),    -- Card
    Accent     = Color3.fromRGB(0, 120, 212),   -- Fluent Blue
    Text       = Color3.fromRGB(255, 255, 255)  -- White
}

-- Utility: Rounded corner
local function addCorner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = obj
end

-- Utility: Stroke
local function addStroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or MyUILib.theme.Accent
    s.Thickness = thickness or 1
    s.Transparency = 0.4
    s.Parent = obj
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

-- 🟣 Window System
function MyUILib:CreateWindow(title, configName)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MojiUI"
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 760, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -380, 0.5, -250)
    MainFrame.BackgroundColor3 = self.theme.Background
    addCorner(MainFrame, 8)

    -- Topbar
    local Topbar = Instance.new("Frame", MainFrame)
    Topbar.Size = UDim2.new(1, 0, 0, 36)
    Topbar.BackgroundColor3 = self.theme.Topbar

    local Title = Instance.new("TextLabel", Topbar)
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = self.theme.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14

    makeDraggable(MainFrame, Topbar)

    -- Sidebar
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 200, 1, -36)
    Sidebar.Position = UDim2.new(0, 0, 0, 36)
    Sidebar.BackgroundColor3 = self.theme.Sidebar

    local UIList = Instance.new("UIListLayout", Sidebar)
    UIList.Padding = UDim.new(0, 4)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Container
    local Container = Instance.new("Frame", MainFrame)
    Container.Size = UDim2.new(1, -200, 1, -36)
    Container.Position = UDim2.new(0, 200, 0, 36)
    Container.BackgroundTransparency = 1

    local window = {
        tabs = {},
        values = {},
        configFile = configName .. ".json",
        container = Container
    }

    -- Tab System
    function window:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, -12, 0, 34)
        TabBtn.Text = name
        TabBtn.BackgroundColor3 = MyUILib.theme.Sidebar
        TabBtn.TextColor3 = MyUILib.theme.Text
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        addCorner(TabBtn, 6)

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
            -- ปุ่ม Tab highlight
            for _, b in pairs(Sidebar:GetChildren()) do
                if b:IsA("TextButton") then
                    TweenService:Create(b, TweenInfo.new(0.2), {
                        BackgroundColor3 = MyUILib.theme.Sidebar,
                        TextColor3 = MyUILib.theme.Text
                    }):Play()
                end
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = MyUILib.theme.Section,
                TextColor3 = MyUILib.theme.Accent
            }):Play()
        end)

        local tab = {frame = TabFrame}
        table.insert(window.tabs, tab)
        if #window.tabs == 1 then
            TabFrame.Visible = true
            TabBtn.BackgroundColor3 = MyUILib.theme.Section
            TabBtn.TextColor3 = MyUILib.theme.Accent
        end
        return tab
    end

    return window
end

--====================================================
-- 🟣 Moji UI V.4 - Block 2 (Elements Fluent Style)
--====================================================

-- 🟣 Card Utility (Wrapper)
local function createCard(tab, height)
    local Card = Instance.new("Frame", tab.frame)
    Card.Size = UDim2.new(1, -12, 0, height or 46)
    Card.BackgroundColor3 = MyUILib.theme.Section
    Card.BorderSizePixel = 0
    addCorner(Card, 6)
    addStroke(Card, Color3.fromRGB(255,255,255), 1)
    return Card
end

-- 🟣 Button (Fluent)
function MyUILib:AddButton(tab, text, callback)
    local Card = createCard(tab, 46)

    local Btn = Instance.new("TextButton", Card)
    Btn.Size = UDim2.new(1, -20, 1, -10)
    Btn.Position = UDim2.new(0, 10, 0, 5)
    Btn.Text = text
    Btn.BackgroundColor3 = MyUILib.theme.Section
    Btn.TextColor3 = MyUILib.theme.Text
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.AutoButtonColor = false

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = MyUILib.theme.Accent}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = MyUILib.theme.Text}):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

-- 🟣 Toggle (Fluent Switch)
function MyUILib:AddToggle(tab, text, default, callback)
    local Card = createCard(tab, 46)

    local Label = Instance.new("TextLabel", Card)
    Label.Size = UDim2.new(0.75, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextColor3 = MyUILib.theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left

    -- Switch
    local Switch = Instance.new("Frame", Card)
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(1, -50, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    addCorner(Switch, 10)

    local Knob = Instance.new("Frame", Switch)
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = default and UDim2.new(1, -19, 0, 1) or UDim2.new(0, 1, 0, 1)
    Knob.BackgroundColor3 = default and MyUILib.theme.Accent or Color3.fromRGB(200,200,200)
    addCorner(Knob, 10)

    local state = default
    Switch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            TweenService:Create(Knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                Position = state and UDim2.new(1, -19, 0, 1) or UDim2.new(0, 1, 0, 1),
                BackgroundColor3 = state and MyUILib.theme.Accent or Color3.fromRGB(200,200,200)
            }):Play()
            pcall(callback, state)
        end
    end)
end

-- 🟣 Slider (Fluent Bar)
function MyUILib:AddSlider(tab, text, min, max, default, callback)
    local Card = createCard(tab, 66)

    local Label = Instance.new("TextLabel", Card)
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = text .. " : " .. default
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextColor3 = MyUILib.theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("Frame", Card)
    Bar.Size = UDim2.new(1, -20, 0, 8)
    Bar.Position = UDim2.new(0, 10, 0, 40)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    addCorner(Bar, 4)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = MyUILib.theme.Accent
    addCorner(Fill, 4)

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
-- 🟣 Moji UI V.4 - Block 3 (More Fluent Elements)
--====================================================

-- 🟣 Dropdown (Fluent Expandable List)
function MyUILib:AddDropdown(tab, text, list, callback)
    local Card = createCard(tab, 46)

    local DropBtn = Instance.new("TextButton", Card)
    DropBtn.Size = UDim2.new(1, -20, 1, -10)
    DropBtn.Position = UDim2.new(0, 10, 0, 5)
    DropBtn.Text = text .. " ▼"
    DropBtn.BackgroundTransparency = 1
    DropBtn.TextColor3 = MyUILib.theme.Text
    DropBtn.Font = Enum.Font.Gotham
    DropBtn.TextSize = 13
    DropBtn.TextXAlignment = Enum.TextXAlignment.Left

    -- Options container
    local DropFrame = Instance.new("Frame", tab.frame)
    DropFrame.Size = UDim2.new(1, -12, 0, 0)
    DropFrame.BackgroundColor3 = MyUILib.theme.Section
    DropFrame.ClipsDescendants = true
    DropFrame.Visible = false
    addCorner(DropFrame, 6)
    addStroke(DropFrame, Color3.fromRGB(255,255,255), 1)

    local Layout = Instance.new("UIListLayout", DropFrame)
    Layout.Padding = UDim.new(0, 4)

    local isOpen = false
    for _, v in pairs(list) do
        local Opt = Instance.new("TextButton", DropFrame)
        Opt.Size = UDim2.new(1, -12, 0, 28)
        Opt.Position = UDim2.new(0, 6, 0, 0)
        Opt.Text = v
        Opt.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Opt.TextColor3 = MyUILib.theme.Text
        Opt.Font = Enum.Font.Gotham
        Opt.TextSize = 12
        addCorner(Opt, 4)

        Opt.MouseEnter:Connect(function()
            TweenService:Create(Opt, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(65,65,65)}):Play()
        end)
        Opt.MouseLeave:Connect(function()
            TweenService:Create(Opt, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45,45,45)}):Play()
        end)

        Opt.MouseButton1Click:Connect(function()
            DropBtn.Text = text .. " : " .. v
            isOpen = false
            TweenService:Create(DropFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, -12, 0, 0)}):Play()
            task.delay(0.25, function() DropFrame.Visible = false end)
            pcall(callback, v)
        end)
    end

    DropBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            DropFrame.Visible = true
            TweenService:Create(DropFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, -12, 0, #list * 32)}):Play()
        else
            TweenService:Create(DropFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, -12, 0, 0)}):Play()
            task.delay(0.25, function() DropFrame.Visible = false end)
        end
    end)
end

-- 🟣 Input (TextBox Fluent)
function MyUILib:AddInput(tab, placeholder, callback)
    local Card = createCard(tab, 46)

    local Box = Instance.new("TextBox", Card)
    Box.Size = UDim2.new(1, -20, 1, -10)
    Box.Position = UDim2.new(0, 10, 0, 5)
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Box.TextColor3 = MyUILib.theme.Text
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 13
    addCorner(Box, 4)

    Box.FocusLost:Connect(function()
        if Box.Text ~= "" then
            pcall(callback, Box.Text)
        end
    end)
end

-- 🟣 Label (Section Title)
function MyUILib:AddLabel(tab, text)
    local Card = createCard(tab, 34)

    local Label = Instance.new("TextLabel", Card)
    Label.Size = UDim2.new(1, -20, 1, -6)
    Label.Position = UDim2.new(0, 10, 0, 3)
    Label.Text = text
    Label.TextColor3 = MyUILib.theme.Accent
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    return Label
end

-- 🟣 Keybind (Fluent Style)
function MyUILib:AddKeybind(tab, text, defaultKey, callback)
    local Card = createCard(tab, 46)

    local Btn = Instance.new("TextButton", Card)
    Btn.Size = UDim2.new(1, -20, 1, -10)
    Btn.Position = UDim2.new(0, 10, 0, 5)
    Btn.Text = text .. " : " .. defaultKey.Name
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Btn.TextColor3 = MyUILib.theme.Text
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    addCorner(Btn, 4)

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

-- 🟣 ColorPicker (Fluent Simple)
function MyUILib:AddColorPicker(tab, text, default, callback)
    local Card = createCard(tab, 50)

    local Label = Instance.new("TextLabel", Card)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = MyUILib.theme.Text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ColorBtn = Instance.new("TextButton", Card)
    ColorBtn.Size = UDim2.new(0, 40, 0, 28)
    ColorBtn.Position = UDim2.new(1, -50, 0.5, -14)
    ColorBtn.BackgroundColor3 = default or Color3.fromRGB(0, 120, 212)
    ColorBtn.Text = ""
    addCorner(ColorBtn, 6)

    ColorBtn.MouseButton1Click:Connect(function()
        local newColor = Color3.fromHSV(math.random(), 1, 1)
        TweenService:Create(ColorBtn, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
        pcall(callback, newColor)
    end)
end
--====================================================
-- 🟣 Moji UI V.4 - Block 4 (Utils & Extras)
--====================================================

-- 🟣 Notification (Fluent Toast)
function MyUILib:Notify(text, duration)
    duration = duration or 2.5
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("MojiNotify") or Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "MojiNotify"

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 220, 0, 38)
    Frame.Position = UDim2.new(1, -240, 1, -50)
    Frame.BackgroundColor3 = MyUILib.theme.Section
    Frame.BackgroundTransparency = 0.1
    addCorner(Frame, 6)
    addStroke(Frame, Color3.fromRGB(255,255,255), 1)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -12, 1, 0)
    Label.Position = UDim2.new(0, 6, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = MyUILib.theme.Text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    -- Animate In
    Frame.Position = UDim2.new(1, 240, 1, -50)
    TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -240, 1, -50)
    }):Play()

    task.delay(duration, function()
        local tweenOut = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Position = UDim2.new(1, 240, 1, -50)
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()
        Frame:Destroy()
    end)
end

-- 🟣 Save Config
function MyUILib:SaveConfig(window)
    if not window or not window.values then return end
    local success, result = pcall(function()
        writefile(window.configFile, HttpService:JSONEncode(window.values))
    end)
    if success then
        self:Notify("✅ Config Saved", 2)
    else
        warn("SaveConfig Error:", result)
        self:Notify("❌ Save Failed", 2)
    end
end

-- 🟣 Load Config
function MyUILib:LoadConfig(window)
    if not window or not window.values then return end
    if isfile(window.configFile) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(window.configFile))
        end)
        if success and data then
            window.values = data
            self:Notify("📂 Config Loaded", 2)
        else
            self:Notify("❌ Load Failed", 2)
        end
    end
end

-- 🟣 Hotkey toggle UI
function MyUILib:BindToggleKey(window, key)
    local visible = true
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == key then
            visible = not visible
            window.container.Parent.Visible = visible
            self:Notify(visible and "UI Shown" or "UI Hidden", 1.5)
        end
    end)
end

return MyUILib
