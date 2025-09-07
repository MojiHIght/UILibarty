-- LibraryUI - Premium Clean Version
-- Optimized for performance and functionality

local LibraryUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")

-- Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Safe GUI Parent
local GuiParent = (syn and syn.protect_gui and gethui and gethui()) or CoreGui or PlayerGui

-- Configuration
LibraryUI.Config = {
    AnimationSpeed = 0.3,
    SoundEffects = true,
    SaveConfig = true,
    DefaultTheme = "Dark"
}

-- Clean Theme System
LibraryUI.Themes = {
    Dark = {
        Name = "Dark",
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(100, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Success = Color3.fromRGB(75, 200, 130),
        Warning = Color3.fromRGB(255, 180, 60),
        Error = Color3.fromRGB(255, 100, 100),
        Border = Color3.fromRGB(60, 60, 70)
    },
    Light = {
        Name = "Light",
        Background = Color3.fromRGB(245, 245, 250),
        Secondary = Color3.fromRGB(235, 235, 240),
        Accent = Color3.fromRGB(70, 120, 255),
        Text = Color3.fromRGB(20, 20, 30),
        TextSecondary = Color3.fromRGB(80, 80, 90),
        Success = Color3.fromRGB(60, 180, 110),
        Warning = Color3.fromRGB(255, 160, 40),
        Error = Color3.fromRGB(255, 80, 80),
        Border = Color3.fromRGB(200, 200, 210)
    },
    Blue = {
        Name = "Blue",
        Background = Color3.fromRGB(15, 25, 40),
        Secondary = Color3.fromRGB(25, 35, 50),
        Accent = Color3.fromRGB(60, 140, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(170, 180, 200),
        Success = Color3.fromRGB(80, 200, 140),
        Warning = Color3.fromRGB(255, 180, 60),
        Error = Color3.fromRGB(255, 100, 100),
        Border = Color3.fromRGB(40, 60, 80)
    }
}

LibraryUI.CurrentTheme = LibraryUI.Themes.Dark
LibraryUI.Windows = {}
LibraryUI.Connections = {}

-- Sound System
local Sounds = {
    Click = "rbxassetid://6895079853",
    Hover = "rbxassetid://6895079853",
    Success = "rbxassetid://6026984644",
    Error = "rbxassetid://6026984644"
}

-- Utility Functions
local function PlaySound(soundName, volume)
    if not LibraryUI.Config.SoundEffects then return end
    
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = Sounds[soundName] or Sounds.Click
        sound.Volume = volume or 0.2
        sound.Parent = SoundService
        sound:Play()
        
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
end

local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    return corner
end

local function CreateStroke(thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or LibraryUI.CurrentTheme.Border
    stroke.Transparency = transparency or 0
    return stroke
end

local function CreateGradient(colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colors
    gradient.Rotation = rotation or 0
    return gradient
end

local function SmoothTween(object, properties, duration, style, direction, callback)
    local tweenInfo = TweenInfo.new(
        duration or LibraryUI.Config.AnimationSpeed,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    -- Store connection for cleanup
    table.insert(LibraryUI.Connections, tween)
    
    return tween
end

local function CreateRipple(button)
    local rippleConnection
    rippleConnection = button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            PlaySound("Click")
            
            local ripple = Instance.new("Frame")
            ripple.Name = "Ripple"
            ripple.Parent = button
            ripple.BackgroundColor3 = LibraryUI.CurrentTheme.Accent
            ripple.BackgroundTransparency = 0.7
            ripple.BorderSizePixel = 0
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            ripple.ZIndex = button.ZIndex + 5
            
            local mousePos = UserInputService:GetMouseLocation()
            local buttonPos = button.AbsolutePosition
            ripple.Position = UDim2.new(0, mousePos.X - buttonPos.X, 0, mousePos.Y - buttonPos.Y)
            ripple.Size = UDim2.new(0, 0, 0, 0)
            
            CreateCorner(100).Parent = ripple
            
            local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5
            
            SmoothTween(ripple, {
                Size = UDim2.new(0, maxSize, 0, maxSize),
                BackgroundTransparency = 1
            }, 0.5, nil, nil, function()
                ripple:Destroy()
            end)
        end
    end)
    
    table.insert(LibraryUI.Connections, rippleConnection)
end

-- Window Creation
function LibraryUI:CreateWindow(config)
    config = config or {}
    
    local windowConfig = {
        Title = config.Title or "Library UI",
        Size = config.Size or UDim2.new(0, 550, 0, 400),
        Theme = config.Theme or "Dark",
        KeyBind = config.KeyBind or Enum.KeyCode.Insert
    }
    
    -- Set theme
    if LibraryUI.Themes[windowConfig.Theme] then
        LibraryUI.CurrentTheme = LibraryUI.Themes[windowConfig.Theme]
    end
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LibraryUI_" .. HttpService:GenerateGUID(false):sub(1, 8)
    ScreenGui.Parent = GuiParent
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = LibraryUI.CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -windowConfig.Size.X.Offset/2, 0.5, -windowConfig.Size.Y.Offset/2)
    MainFrame.Size = windowConfig.Size
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    CreateCorner(8).Parent = MainFrame
    CreateStroke(1, LibraryUI.CurrentTheme.Border).Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = LibraryUI.CurrentTheme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    
    CreateCorner(8).Parent = TitleBar
    CreateStroke(1, LibraryUI.CurrentTheme.Border, 0.5).Parent = TitleBar
    
    -- Title Text
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = windowConfig.Title
    TitleLabel.TextColor3 = LibraryUI.CurrentTheme.Text
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundColor3 = LibraryUI.CurrentTheme.Error
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16
    
    CreateCorner(4).Parent = CloseButton
    CreateRipple(CloseButton)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = LibraryUI.CurrentTheme.Secondary
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.Size = UDim2.new(0, 140, 1, -35)
    
    CreateStroke(1, LibraryUI.CurrentTheme.Border, 0.5).Parent = Sidebar
    
    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = LibraryUI.CurrentTheme.Accent
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 140, 0, 35)
    ContentFrame.Size = UDim2.new(1, -140, 1, -35)
    
    -- Window Object
    local WindowObject = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        TitleBar = TitleBar,
        Sidebar = Sidebar,
        TabContainer = TabContainer,
        ContentFrame = ContentFrame,
        Config = windowConfig,
        Tabs = {},
        CurrentTab = nil,
        Visible = true,
        TabCount = 0
    }
    
    -- Window Methods
    function WindowObject:Toggle()
        self.Visible = not self.Visible
        self.ScreenGui.Enabled = self.Visible
    end
    
    function WindowObject:Destroy()
        -- Clean up all connections
        for _, connection in pairs(LibraryUI.Connections) do
            if typeof(connection) == "RBXScriptConnection" then
                connection:Disconnect()
            elseif typeof(connection) == "Tween" then
                connection:Cancel()
            end
        end
        
        self.ScreenGui:Destroy()
        
        -- Remove from windows list
        for i, window in pairs(LibraryUI.Windows) do
            if window == self then
                table.remove(LibraryUI.Windows, i)
                break
            end
        end
    end
    
    function WindowObject:CreateTab(config)
        config = config or {}
        
        local tabConfig = {
            Name = config.Name or "Tab",
            Icon = config.Icon or "📄"
        }
        
        self.TabCount = self.TabCount + 1
        local tabIndex = self.TabCount
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "Tab_" .. tabConfig.Name
        TabButton.Parent = self.TabContainer
        TabButton.BackgroundColor3 = LibraryUI.CurrentTheme.Background
        TabButton.BorderSizePixel = 0
        TabButton.Position = UDim2.new(0, 0, 0, (tabIndex - 1) * 35)
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = tabConfig.Icon .. " " .. tabConfig.Name
        TabButton.TextColor3 = LibraryUI.CurrentTheme.TextSecondary
        TabButton.TextSize = 12
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        
        CreateCorner(6).Parent = TabButton
        CreateRipple(TabButton)
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. tabConfig.Name
        TabContent.Parent = self.ContentFrame
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = LibraryUI.CurrentTheme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        
        -- Tab Object
        local TabObject = {
            Button = TabButton,
            Content = TabContent,
            Config = tabConfig,
            Active = false,
            ElementCount = 0
        }
        
        function TabObject:Activate()
            if self.Active then return end
            
            -- Deactivate other tabs
            for _, tab in pairs(WindowObject.Tabs) do
                if tab.Active then
                    tab:Deactivate()
                end
            end
            
            self.Active = true
            WindowObject.CurrentTab = self
            
            SmoothTween(self.Button, {
                BackgroundColor3 = LibraryUI.CurrentTheme.Accent,
                TextColor3 = LibraryUI.CurrentTheme.Text
            })
            
            self.Content.Visible = true
        end
        
        function TabObject:Deactivate()
            self.Active = false
            
            SmoothTween(self.Button, {
                BackgroundColor3 = LibraryUI.CurrentTheme.Background,
                TextColor3 = LibraryUI.CurrentTheme.TextSecondary
            })
            
            self.Content.Visible = false
        end
        
        function TabObject:CreateButton(config)
            config = config or {}
            
            local buttonConfig = {
                Name = config.Name or "Button",
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 50
            self.ElementCount = self.ElementCount + 1
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button_" .. buttonConfig.Name
            Button.Parent = self.Content
            Button.BackgroundColor3 = LibraryUI.CurrentTheme.Accent
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(0, 0, 0, yPos)
            Button.Size = UDim2.new(1, -5, 0, 35)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = buttonConfig.Name
            Button.TextColor3 = LibraryUI.CurrentTheme.Text
            Button.TextSize = 14
            
            CreateCorner(6).Parent = Button
            CreateRipple(Button)
            
            -- Hover effects
            local connections = {}
            
            connections[1] = Button.MouseEnter:Connect(function()
                PlaySound("Hover", 0.1)
                SmoothTween(Button, {
                    BackgroundColor3 = Color3.fromRGB(
                        math.min(255, LibraryUI.CurrentTheme.Accent.R * 255 + 20),
                        math.min(255, LibraryUI.CurrentTheme.Accent.G * 255 + 20),
                        math.min(255, LibraryUI.CurrentTheme.Accent.B * 255 + 20)
                    )
                })
            end)
            
            connections[2] = Button.MouseLeave:Connect(function()
                SmoothTween(Button, {BackgroundColor3 = LibraryUI.CurrentTheme.Accent})
            end)
            
            connections[3] = Button.MouseButton1Click:Connect(function()
                local success, err = pcall(buttonConfig.Callback)
                if not success then
                    warn("Button callback error:", err)
                end
            end)
            
            -- Store connections for cleanup
            for _, conn in pairs(connections) do
                table.insert(LibraryUI.Connections, conn)
            end
            
            self:UpdateCanvasSize()
            return Button
        end
        
        function TabObject:CreateToggle(config)
            config = config or {}
            
            local toggleConfig = {
                Name = config.Name or "Toggle",
                Default = config.Default or false,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 50
            self.ElementCount = self.ElementCount + 1
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle_" .. toggleConfig.Name
            ToggleFrame.Parent = self.Content
            ToggleFrame.BackgroundColor3 = LibraryUI.CurrentTheme.Secondary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Position = UDim2.new(0, 0, 0, yPos)
            ToggleFrame.Size = UDim2.new(1, -5, 0, 35)
            
            CreateCorner(6).Parent = ToggleFrame
            CreateStroke(1, LibraryUI.CurrentTheme.Border, 0.5).Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.Text = toggleConfig.Name
            ToggleLabel.TextColor3 = LibraryUI.CurrentTheme.Text
            ToggleLabel.TextSize = 13
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = toggleConfig.Default and LibraryUI.CurrentTheme.Success or LibraryUI.CurrentTheme.Border
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(1, -50, 0, 7.5)
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Text = toggleConfig.Default and "ON" or "OFF"
            ToggleButton.Font = Enum.Font.GothamBold
            ToggleButton.TextColor3 = LibraryUI.CurrentTheme.Text
            ToggleButton.TextSize = 10
            
            CreateCorner(10).Parent = ToggleButton
            
            local isToggled = toggleConfig.Default
            
            local toggleConnection = ToggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                PlaySound("Click")
                
                SmoothTween(ToggleButton, {
                    BackgroundColor3 = isToggled and LibraryUI.CurrentTheme.Success or LibraryUI.CurrentTheme.Border
                })
                
                ToggleButton.Text = isToggled and "ON" or "OFF"
                
                local success, err = pcall(toggleConfig.Callback, isToggled)
                if not success then
                    warn("Toggle callback error:", err)
                end
            end)
            
            table.insert(LibraryUI.Connections, toggleConnection)
            
            self:UpdateCanvasSize()
            return ToggleFrame
        end
        
        function TabObject:CreateSlider(config)
            config = config or {}
            
            local sliderConfig = {
                Name = config.Name or "Slider",
                Min = config.Min or 0,
                Max = config.Max or 100,
                Default = config.Default or 50,
                Increment = config.Increment or 1,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 60
            self.ElementCount = self.ElementCount + 1
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider_" .. sliderConfig.Name
            SliderFrame.Parent = self.Content
            SliderFrame.BackgroundColor3 = LibraryUI.CurrentTheme.Secondary
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Position = UDim2.new(0, 0, 0, yPos)
            SliderFrame.Size = UDim2.new(1, -5, 0, 50)
            
            CreateCorner(6).Parent = SliderFrame
            CreateStroke(1, LibraryUI.CurrentTheme.Border, 0.5).Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Parent = SliderFrame
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.Size = UDim2.new(0.6, 0, 0, 20)
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.Text = sliderConfig.Name
            SliderLabel.TextColor3 = LibraryUI.CurrentTheme.Text
            SliderLabel.TextSize = 13
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(0.6, 0, 0, 5)
            ValueLabel.Size = UDim2.new(0.4, -10, 0, 20)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(sliderConfig.Default)
            ValueLabel.TextColor3 = LibraryUI.CurrentTheme.Accent
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Parent = SliderFrame
            SliderBar.BackgroundColor3 = LibraryUI.CurrentTheme.Border
            SliderBar.BorderSizePixel = 0
            SliderBar.Position = UDim2.new(0, 10, 0, 30)
            SliderBar.Size = UDim2.new(1, -20, 0, 6)
            
            CreateCorner(3).Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderBar
            SliderFill.BackgroundColor3 = LibraryUI.CurrentTheme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
            
            CreateCorner(3).Parent = SliderFill
            
            local currentValue = sliderConfig.Default
            local isDragging = false
            
            local function UpdateSlider(input)
                local barPos = SliderBar.AbsolutePosition.X
                local barSize = SliderBar.AbsoluteSize.X
                local mousePos = input.Position.X
                
                local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
                local rawValue = sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percent
                currentValue = math.floor(rawValue / sliderConfig.Increment + 0.5) * sliderConfig.Increment
                currentValue = math.clamp(currentValue, sliderConfig.Min, sliderConfig.Max)
                
                local finalPercent = (currentValue - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                
                SmoothTween(SliderFill, {Size = UDim2.new(finalPercent, 0, 1, 0)}, 0.1)
                ValueLabel.Text = tostring(currentValue)
                
                local success, err = pcall(sliderConfig.Callback, currentValue)
                if not success then
                    warn("Slider callback error:", err)
                end
            end
            
            local connections = {}
            
            connections[1] = SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    PlaySound("Click", 0.1)
                    UpdateSlider(input)
                end
            end)
            
            connections[2] = UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            
            connections[3] = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)
            
            for _, conn in pairs(connections) do
                table.insert(LibraryUI.Connections, conn)
            end
            
            self:UpdateCanvasSize()
            return SliderFrame
        end
        
        function TabObject:CreateDropdown(config)
            config = config or {}
            
            local dropdownConfig = {
                Name = config.Name or "Dropdown",
                Options = config.Options or {"Option 1", "Option 2", "Option 3"},
                Default = config.Default or config.Options[1],
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 50
            self.ElementCount = self.ElementCount + 1
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "Dropdown_" .. dropdownConfig.Name
            DropdownFrame.Parent = self.Content
            DropdownFrame.BackgroundColor3 = LibraryUI.CurrentTheme.Secondary
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Position = UDim2.new(0, 0, 0, yPos)
            DropdownFrame.Size = UDim2.new(1, -5, 0, 35)
            DropdownFrame.ClipsDescendants = false
            
            CreateCorner(6).Parent = DropdownFrame
            CreateStroke(1, LibraryUI.CurrentTheme.Border, 0.5).Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Parent = DropdownFrame
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.Size = UDim2.new(0.4, 0, 1, 0)
            DropdownLabel.Font = Enum.Font.GothamSemibold
            DropdownLabel.Text = dropdownConfig.Name
            DropdownLabel.TextColor3 = LibraryUI.CurrentTheme.Text
            DropdownLabel.TextSize = 13
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundColor3 = LibraryUI.CurrentTheme.Background
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Position = UDim2.new(0.5, 0, 0, 5)
            DropdownButton.Size = UDim2.new(0.5, -10, 0, 25)
            DropdownButton.Font = Enum.Font.GothamSemibold
            DropdownButton.Text = dropdownConfig.Default .. " ▼"
            DropdownButton.TextColor3 = LibraryUI.CurrentTheme.Text
            DropdownButton.TextSize = 11
            
            CreateCorner(4).Parent = DropdownButton
            CreateStroke(1, LibraryUI.CurrentTheme.Border, 0.5).Parent = DropdownButton
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Parent = DropdownFrame
            DropdownList.BackgroundColor3 = LibraryUI.CurrentTheme.Background
            DropdownList.BorderSizePixel = 0
            DropdownList.Position = UDim2.new(0.5, 0, 0, 35)
            DropdownList.Size = UDim2.new(0.5, -10, 0, 0)
            DropdownList.Visible = false
            DropdownList.ClipsDescendants = true
            DropdownList.ZIndex = 10
            
            CreateCorner(4).Parent = DropdownList
            CreateStroke(1, LibraryUI.CurrentTheme.Accent).Parent = DropdownList
            
            local isOpen = false
            local selectedOption = dropdownConfig.Default
            
            -- Create option buttons
            for i, option in ipairs(dropdownConfig.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Parent = DropdownList
                OptionButton.BackgroundColor3 = option == selectedOption and LibraryUI.CurrentTheme.Accent or Color3.fromRGB(0, 0, 0, 0)
                OptionButton.BackgroundTransparency = option == selectedOption and 0 or 1
                OptionButton.BorderSizePixel = 0
                OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 25)
                OptionButton.Size = UDim2.new(1, 0, 0, 25)
                OptionButton.Font = Enum.Font.GothamSemibold
                OptionButton.Text = option
                OptionButton.TextColor3 = LibraryUI.CurrentTheme.Text
                OptionButton.TextSize = 11
                OptionButton.ZIndex = 11
                
                local optionConnection = OptionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    DropdownButton.Text = option .. " ▼"
                    PlaySound("Click")
                    
                    -- Update option visuals
                    for _, btn in pairs(DropdownList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            SmoothTween(btn, {
                                BackgroundTransparency = btn.Text == option and 0 or 1
                            })
                        end
                    end
                    
                    -- Close dropdown
                    isOpen = false
                    SmoothTween(DropdownList, {Size = UDim2.new(0.5, -10, 0, 0)}, 0.2, nil, nil, function()
                        DropdownList.Visible = false
                    end)
                    
                    local success, err = pcall(dropdownConfig.Callback, option)
                    if not success then
                        warn("Dropdown callback error:", err)
                    end
                end)
                
                table.insert(LibraryUI.Connections, optionConnection)
            end
            
            local dropdownConnection = DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                PlaySound("Click")
                
                if isOpen then
                    DropdownButton.Text = selectedOption .. " ▲"
                    DropdownList.Visible = true
                    SmoothTween(DropdownList, {Size = UDim2.new(0.5, -10, 0, #dropdownConfig.Options * 25)})
                else
                    DropdownButton.Text = selectedOption .. " ▼"
                    SmoothTween(DropdownList, {Size = UDim2.new(0.5, -10, 0, 0)}, 0.2, nil, nil, function()
                        DropdownList.Visible = false
                    end)
                end
            end)
            
            table.insert(LibraryUI.Connections, dropdownConnection)
            
            self:UpdateCanvasSize()
            return DropdownFrame
        end
        
        function TabObject:UpdateCanvasSize()
            local contentSize = self.ElementCount * 55 + 10
            SmoothTween(self.Content, {CanvasSize = UDim2.new(0, 0, 0, contentSize)})
        end
        
        -- Tab activation
        local tabConnection = TabButton.MouseButton1Click:Connect(function()
            TabObject:Activate()
        end)
        
        table.insert(LibraryUI.Connections, tabConnection)
        
        -- Add to tabs
        self.Tabs[tabConfig.Name] = TabObject
        
        -- Auto-activate first tab
        if self.TabCount == 1 then
            TabObject:Activate()
        end
        
        -- Update tab container
        self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, self.TabCount * 35 + 5)
        
        return TabObject
    end
    
    -- Close button functionality
    local closeConnection = CloseButton.MouseButton1Click:Connect(function()
        WindowObject:Destroy()
    end)
    
    table.insert(LibraryUI.Connections, closeConnection)
    
    -- KeyBind toggle
    local keybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == windowConfig.KeyBind then
            WindowObject:Toggle()
        end
    end)
    
    table.insert(LibraryUI.Connections, keybindConnection)
    
    -- Add to windows
    table.insert(LibraryUI.Windows, WindowObject)
    
    return WindowObject
end

-- Notification System
function LibraryUI:Notify(config)
    config = config or {}
    
    local notifConfig = {
        Title = config.Title or "Notification",
        Description = config.Description or "",
        Duration = config.Duration or 3,
        Type = config.Type or "Info"
    }
    
    local colors = {
        Info = LibraryUI.CurrentTheme.Accent,
        Success = LibraryUI.CurrentTheme.Success,
        Warning = LibraryUI.CurrentTheme.Warning,
        Error = LibraryUI.CurrentTheme.Error
    }
    
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "LibraryNotification"
    NotifGui.Parent = GuiParent
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Parent = NotifGui
    NotifFrame.BackgroundColor3 = LibraryUI.CurrentTheme.Background
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(1, 10, 0, 10)
    NotifFrame.Size = UDim2.new(0, 300, 0, 80)
    
    CreateCorner(8).Parent = NotifFrame
    CreateStroke(2, colors[notifConfig.Type] or colors.Info).Parent = NotifFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = NotifFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 10)
    TitleLabel.Size = UDim2.new(1, -20, 0, 25)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = notifConfig.Title
    TitleLabel.TextColor3 = LibraryUI.CurrentTheme.Text
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Parent = NotifFrame
    DescLabel.BackgroundTransparency = 1
    DescLabel.Position = UDim2.new(0, 10, 0, 35)
    DescLabel.Size = UDim2.new(1, -20, 0, 35)
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = notifConfig.Description
    DescLabel.TextColor3 = LibraryUI.CurrentTheme.TextSecondary
    DescLabel.TextSize = 12
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true
    
    -- Slide in
    SmoothTween(NotifFrame, {Position = UDim2.new(1, -310, 0, 10)})
    
    PlaySound(notifConfig.Type == "Error" and "Error" or "Success")
    
    -- Auto remove
    spawn(function()
        wait(notifConfig.Duration)
        if NotifGui.Parent then
            SmoothTween(NotifFrame, {Position = UDim2.new(1, 10, 0, 10)}, 0.3, nil, nil, function()
                NotifGui:Destroy()
            end)
        end
    end)
end

-- Theme Management
function LibraryUI:SetTheme(themeName)
    if LibraryUI.Themes[themeName] then
        LibraryUI.CurrentTheme = LibraryUI.Themes[themeName]
        
        self:Notify({
            Title = "Theme Changed",
            Description = "Successfully changed to " .. themeName .. " theme",
            Type = "Success"
        })
    end
end

-- Cleanup function
function LibraryUI:Cleanup()
    for _, connection in pairs(LibraryUI.Connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif typeof(connection) == "Tween" then
            connection:Cancel()
        end
    end
    
    LibraryUI.Connections = {}
    
    for _, window in pairs(LibraryUI.Windows) do
        window:Destroy()
    end
end

return LibraryUI
