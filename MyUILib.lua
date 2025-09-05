-- MyUILib.lua - Rayfield Inspired UI Library
-- Author: YOU 🔥

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local MyUILib = {}
MyUILib.theme = {
    background = Color3.fromRGB(25, 25, 35),
    topbar = Color3.fromRGB(60, 0, 90),
    sidebar = Color3.fromRGB(35, 35, 50),
    section = Color3.fromRGB(45, 45, 65),
    accent = Color3.fromRGB(170, 0, 255),
    text = Color3.fromRGB(255, 255, 255)
}

-- 🟣 Create rounded corners
local function addCorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = obj
    return corner
end

-- 🟣 Add stroke
local function addStroke(obj, color)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(80, 0, 120)
    stroke.Thickness = 1
    stroke.Parent = obj
    return stroke
end

-- 🟣 Draggable
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

-- 🟣 Notification
function MyUILib:Notify(text, duration)
    duration = duration or 3
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("MyUILibNotify") or Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "MyUILibNotify"

    local Frame = Instance.new("TextLabel", ScreenGui)
    Frame.Size = UDim2.new(0, 250, 0, 40)
    Frame.Position = UDim2.new(1, -260, 1, -50)
    Frame.BackgroundColor3 = self.theme.topbar
    Frame.TextColor3 = self.theme.text
    Frame.Text = text
    Frame.TextScaled = true
    addCorner(Frame, 6)
    addStroke(Frame, self.theme.accent)

    local tweenIn = TweenService:Create(Frame, TweenInfo.new(0.3), {Position = UDim2.new(1, -260, 1, -100)})
    tweenIn:Play()
    task.delay(duration, function()
        local tweenOut = TweenService:Create(Frame, TweenInfo.new(0.3), {Position = UDim2.new(1, -260, 1, 0)})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        Frame:Destroy()
    end)
end

-- 🟣 Create Window
function MyUILib:CreateWindow(title, configName)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = self.theme.background
    addCorner(MainFrame, 8)
    addStroke(MainFrame, self.theme.accent)

    local Topbar = Instance.new("Frame", MainFrame)
    Topbar.Size = UDim2.new(1, 0, 0, 35)
    Topbar.BackgroundColor3 = self.theme.topbar
    addCorner(Topbar, 8)

    local Title = Instance.new("TextLabel", Topbar)
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = self.theme.text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14

    makeDraggable(MainFrame, Topbar)

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 150, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = self.theme.sidebar

    local Container = Instance.new("Frame", MainFrame)
    Container.Size = UDim2.new(1, -150, 1, -35)
    Container.Position = UDim2.new(0, 150, 0, 35)
    Container.BackgroundTransparency = 1

    local UIList = Instance.new("UIListLayout", Sidebar)
    UIList.Padding = UDim.new(0, 5)

    local window = {
        tabs = {},
        values = {},
        configFile = configName .. ".json"
    }

    -- Tab System
    function window:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, -10, 0, 30)
        TabBtn.Text = name
        TabBtn.BackgroundColor3 = self.theme.section
        TabBtn.TextColor3 = self.theme.text
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

        -- Elements
        function tab:AddButton(text, callback)
            local Btn = Instance.new("TextButton", TabFrame)
            Btn.Size = UDim2.new(1, -10, 0, 30)
            Btn.Text = text
            Btn.BackgroundColor3 = MyUILib.theme.accent
            Btn.TextColor3 = MyUILib.theme.text
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 12
            addCorner(Btn, 6)
            Btn.MouseButton1Click:Connect(callback)
        end

        function tab:AddToggle(text, default, callback)
            local Toggle = Instance.new("TextButton", TabFrame)
            Toggle.Size = UDim2.new(1, -10, 0, 30)
            Toggle.BackgroundColor3 = MyUILib.theme.section
            Toggle.TextColor3 = MyUILib.theme.text
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextSize = 12
            addCorner(Toggle, 6)

            local state = default
            Toggle.Text = text .. " : " .. (state and "ON" or "OFF")
            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Toggle.Text = text .. " : " .. (state and "ON" or "OFF")
                callback(state)
                window.values[text] = state
            end)
        end

        function tab:AddSlider(text, min, max, default, callback)
            local Frame = Instance.new("Frame", TabFrame)
            Frame.Size = UDim2.new(1, -10, 0, 40)
            Frame.BackgroundColor3 = MyUILib.theme.section
            addCorner(Frame, 6)

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(1, 0, 0.5, 0)
            Label.Text = text .. " : " .. default
            Label.TextColor3 = MyUILib.theme.text
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12

            local Bar = Instance.new("Frame", Frame)
            Bar.Size = UDim2.new(1, -20, 0, 10)
            Bar.Position = UDim2.new(0, 10, 0.6, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            addCorner(Bar, 6)

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = MyUILib.theme.accent
            addCorner(Fill, 6)

            local value = default
            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local conn
                    conn = UserInputService.InputChanged:Connect(function(move)
                        if move.UserInputType == Enum.UserInputType.MouseMovement then
                            local rel = math.clamp((move.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                            value = math.floor(min + (max - min) * rel)
                            Fill.Size = UDim2.new(rel, 0, 1, 0)
                            Label.Text = text .. " : " .. value
                            callback(value)
                            window.values[text] = value
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(endInput)
                        if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                            conn:Disconnect()
                        end
                    end)
                end
            end)
        end

        function tab:AddDropdown(text, list, callback)
            local DropBtn = Instance.new("TextButton", TabFrame)
            DropBtn.Size = UDim2.new(1, -10, 0, 30)
            DropBtn.Text = text .. " ▼"
            DropBtn.BackgroundColor3 = MyUILib.theme.section
            DropBtn.TextColor3 = MyUILib.theme.text
            addCorner(DropBtn, 6)

            local DropFrame = Instance.new("Frame", TabFrame)
            DropFrame.Size = UDim2.new(1, -10, 0, #list * 25)
            DropFrame.BackgroundColor3 = MyUILib.theme.section
            DropFrame.Visible = false
            addCorner(DropFrame, 6)

            local Layout = Instance.new("UIListLayout", DropFrame)

            for _, v in pairs(list) do
                local Opt = Instance.new("TextButton", DropFrame)
                Opt.Size = UDim2.new(1, 0, 0, 25)
                Opt.Text = v
                Opt.BackgroundColor3 = MyUILib.theme.section
                Opt.TextColor3 = MyUILib.theme.text
                Opt.MouseButton1Click:Connect(function()
                    DropBtn.Text = text .. " : " .. v
                    callback(v)
                    window.values[text] = v
                    DropFrame.Visible = false
                end)
            end

            DropBtn.MouseButton1Click:Connect(function()
                DropFrame.Visible = not DropFrame.Visible
            end)
        end

        function tab:AddInput(text, placeholder, callback)
            local Box = Instance.new("TextBox", TabFrame)
            Box.Size = UDim2.new(1, -10, 0, 30)
            Box.PlaceholderText = placeholder
            Box.Text = ""
            Box.BackgroundColor3 = MyUILib.theme.section
            Box.TextColor3 = MyUILib.theme.text
            addCorner(Box, 6)
            Box.FocusLost:Connect(function()
                callback(Box.Text)
                window.values[text] = Box.Text
            end)
        end

        function tab:AddKeybind(text, defaultKey, callback)
            local Btn = Instance.new("TextButton", TabFrame)
            Btn.Size = UDim2.new(1, -10, 0, 30)
            Btn.Text = text .. " : " .. defaultKey.Name
            Btn.BackgroundColor3 = MyUILib.theme.section
            Btn.TextColor3 = MyUILib.theme.text
            addCorner(Btn, 6)

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

        table.insert(window.tabs, tab)
        return tab
    end

    -- Config
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
