--[[ 
    MyUILib - Custom Roblox Executor UI
    Author: YOU 🔥
    Features: Window, Tabs, Button, Toggle, Slider, Dropdown, Input, Notification, Keybind, SaveConfig
]]

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local MyUILib = {}
MyUILib.theme = {
    bg = Color3.fromRGB(25, 25, 35),
    topbar = Color3.fromRGB(60, 0, 90),
    section = Color3.fromRGB(40, 40, 60),
    text = Color3.fromRGB(255, 255, 255),
    accent = Color3.fromRGB(170, 0, 255)
}

-- 🟣 Utility: Make draggable
local function makeDraggable(frame, parent)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- 🟣 Notification System
function MyUILib:Notify(text, duration)
    duration = duration or 3
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("MyUILibNotify") or Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "MyUILibNotify"

    local Frame = Instance.new("TextLabel")
    Frame.Size = UDim2.new(0, 250, 0, 40)
    Frame.Position = UDim2.new(1, -260, 1, -100)
    Frame.BackgroundColor3 = self.theme.topbar
    Frame.TextColor3 = self.theme.text
    Frame.Text = text
    Frame.TextScaled = true
    Frame.Parent = ScreenGui

    game:GetService("TweenService"):Create(Frame, TweenInfo.new(0.5), {Position = UDim2.new(1, -260, 1, -150)}):Play()
    task.delay(duration, function()
        game:GetService("TweenService"):Create(Frame, TweenInfo.new(0.5), {Position = UDim2.new(1, -260, 1, 0)}):Play()
        task.wait(0.5)
        Frame:Destroy()
    end)
end

-- 🟣 Core: Create Window
function MyUILib:CreateWindow(title, configName)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = self.theme.bg
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local Topbar = Instance.new("TextLabel")
    Topbar.Size = UDim2.new(1, 0, 0, 35)
    Topbar.BackgroundColor3 = self.theme.topbar
    Topbar.Text = "  " .. title
    Topbar.TextColor3 = self.theme.text
    Topbar.TextXAlignment = Enum.TextXAlignment.Left
    Topbar.Parent = MainFrame

    makeDraggable(Topbar, MainFrame)

    local TabHolder = Instance.new("Frame")
    TabHolder.Size = UDim2.new(0, 120, 1, -35)
    TabHolder.Position = UDim2.new(0, 0, 0, 35)
    TabHolder.BackgroundColor3 = self.theme.section
    TabHolder.Parent = MainFrame

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -120, 1, -35)
    Container.Position = UDim2.new(0, 120, 0, 35)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    local UIList = Instance.new("UIListLayout")
    UIList.Parent = TabHolder

    local window = {
        tabs = {},
        container = Container,
        configFile = configName .. ".json",
        values = {}
    }

    -- 🟣 Tab System
    function window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.Text = name
        TabButton.BackgroundColor3 = MyUILib.theme.section
        TabButton.TextColor3 = MyUILib.theme.text
        TabButton.Parent = TabHolder

        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.ScrollBarThickness = 6
        TabFrame.Visible = false
        TabFrame.Parent = Container

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 6)
        Layout.Parent = TabFrame

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.tabs) do
                t.frame.Visible = false
            end
            TabFrame.Visible = true
        end)

        local tab = {
            frame = TabFrame
        }
        table.insert(window.tabs, tab)

        -- 🟣 Elements
        function tab:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 30)
            Btn.Text = text
            Btn.BackgroundColor3 = MyUILib.theme.accent
            Btn.TextColor3 = MyUILib.theme.text
            Btn.Parent = TabFrame
            Btn.MouseButton1Click:Connect(callback)
        end

        function tab:AddToggle(text, default, callback)
            local Toggle = Instance.new("TextButton")
            Toggle.Size = UDim2.new(1, -10, 0, 30)
            Toggle.Text = text .. " : " .. (default and "ON" or "OFF")
            Toggle.BackgroundColor3 = MyUILib.theme.section
            Toggle.TextColor3 = MyUILib.theme.text
            Toggle.Parent = TabFrame
            local state = default
            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Toggle.Text = text .. " : " .. (state and "ON" or "OFF")
                callback(state)
                window.values[text] = state
            end)
        end

        function tab:AddSlider(text, min, max, default, callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 40)
            Frame.BackgroundColor3 = MyUILib.theme.section
            Frame.Parent = TabFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0.5, 0)
            Label.Text = text .. " : " .. default
            Label.TextColor3 = MyUILib.theme.text
            Label.BackgroundTransparency = 1
            Label.Parent = Frame

            local Slider = Instance.new("TextButton")
            Slider.Size = UDim2.new(1, -20, 0.5, -5)
            Slider.Position = UDim2.new(0, 10, 0.5, 5)
            Slider.BackgroundColor3 = MyUILib.theme.accent
            Slider.Text = ""
            Slider.Parent = Frame

            local value = default
            Slider.MouseButton1Down:Connect(function(x)
                local moveCon
                moveCon = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                        value = math.floor(min + (max - min) * rel)
                        Label.Text = text .. " : " .. value
                        callback(value)
                        window.values[text] = value
                    end
                end)
                UserInputService.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                        moveCon:Disconnect()
                    end
                end)
            end)
        end

        function tab:AddDropdown(text, list, callback)
            local Drop = Instance.new("TextButton")
            Drop.Size = UDim2.new(1, -10, 0, 30)
            Drop.Text = text .. " ▼"
            Drop.BackgroundColor3 = MyUILib.theme.section
            Drop.TextColor3 = MyUILib.theme.text
            Drop.Parent = TabFrame

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, #list * 25)
            Frame.Visible = false
            Frame.BackgroundColor3 = MyUILib.theme.section
            Frame.Parent = TabFrame

            local Layout = Instance.new("UIListLayout")
            Layout.Parent = Frame

            for _, v in pairs(list) do
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 25)
                Btn.Text = v
                Btn.BackgroundColor3 = MyUILib.theme.section
                Btn.TextColor3 = MyUILib.theme.text
                Btn.Parent = Frame
                Btn.MouseButton1Click:Connect(function()
                    Drop.Text = text .. " : " .. v
                    callback(v)
                    window.values[text] = v
                    Frame.Visible = false
                end)
            end

            Drop.MouseButton1Click:Connect(function()
                Frame.Visible = not Frame.Visible
            end)
        end

        function tab:AddInput(text, placeholder, callback)
            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(1, -10, 0, 30)
            Box.PlaceholderText = placeholder
            Box.Text = ""
            Box.BackgroundColor3 = MyUILib.theme.section
            Box.TextColor3 = MyUILib.theme.text
            Box.Parent = TabFrame
            Box.FocusLost:Connect(function()
                callback(Box.Text)
                window.values[text] = Box.Text
            end)
        end

        function tab:AddKeybind(text, defaultKey, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 30)
            Btn.Text = text .. " : " .. defaultKey.Name
            Btn.BackgroundColor3 = MyUILib.theme.section
            Btn.TextColor3 = MyUILib.theme.text
            Btn.Parent = TabFrame

            local key = defaultKey
            UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and input.KeyCode == key then
                    callback()
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

        return tab
    end

    -- 🟣 Config
    function window:SaveConfig()
        writefile(self.configFile, HttpService:JSONEncode(self.values))
    end
    function window:LoadConfig()
        if isfile(self.configFile) then
            self.values = HttpService:JSONDecode(readfile(self.configFile))
        end
    end

    return window
end

return MyUILib
