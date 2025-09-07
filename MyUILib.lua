-- ProMax UI Library สำหรับ Executor
-- ใช้สำหรับ Script Injection ใน Roblox

local ProMaxUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- สำหรับ Executor ใช้ CoreGui แทน PlayerGui เพื่อไม่โดนรีเซ็ต
local GuiParent = (syn and syn.protect_gui and CoreGui) or PlayerGui

-- Configuration
ProMaxUI.Config = {
    AnimationSpeed = 0.3,
    BlurIntensity = 10
}

-- Themes
ProMaxUI.Themes = {
    Executor = {
        Primary = Color3.fromRGB(18, 18, 25),
        Secondary = Color3.fromRGB(25, 25, 35),
        Tertiary = Color3.fromRGB(30, 30, 40),
        Accent = Color3.fromRGB(255, 64, 129),
        AccentDark = Color3.fromRGB(200, 50, 100),
        Success = Color3.fromRGB(76, 175, 80),
        Warning = Color3.fromRGB(255, 193, 7),
        Error = Color3.fromRGB(244, 67, 54),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(60, 60, 80)
    },
    Dark = {
        Primary = Color3.fromRGB(13, 17, 23),
        Secondary = Color3.fromRGB(22, 27, 34),
        Tertiary = Color3.fromRGB(33, 38, 45),
        Accent = Color3.fromRGB(88, 166, 255),
        AccentDark = Color3.fromRGB(70, 130, 200),
        Success = Color3.fromRGB(46, 160, 67),
        Warning = Color3.fromRGB(255, 212, 59),
        Error = Color3.fromRGB(248, 81, 73),
        Text = Color3.fromRGB(248, 248, 242),
        TextDim = Color3.fromRGB(139, 148, 158),
        Border = Color3.fromRGB(48, 54, 61)
    }
}

ProMaxUI.CurrentTheme = ProMaxUI.Themes.Executor

-- Utility Functions
local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    return corner
end

local function CreateStroke(thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or ProMaxUI.CurrentTheme.Border
    stroke.Transparency = transparency or 0.5
    return stroke
end

local function CreateGradient(colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colors
    gradient.Rotation = rotation or 0
    return gradient
end

local function CreateShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = parent
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.ZIndex = parent.ZIndex - 1
    CreateCorner(8).Parent = shadow
    return shadow
end

local function Tween(object, properties, duration, style, direction)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or ProMaxUI.Config.AnimationSpeed,
            style or Enum.EasingStyle.Quad,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    tween:Play()
    return tween
end

local function CreateRipple(button)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local ripple = Instance.new("Frame")
            ripple.Name = "Ripple"
            ripple.Parent = button
            ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ripple.BackgroundTransparency = 0.8
            ripple.BorderSizePixel = 0
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            
            local pos = UserInputService:GetMouseLocation()
            local btnPos = button.AbsolutePosition
            ripple.Position = UDim2.new(0, pos.X - btnPos.X, 0, pos.Y - btnPos.Y)
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.ZIndex = button.ZIndex + 1
            
            CreateCorner(100).Parent = ripple
            
            Tween(ripple, {
                Size = UDim2.new(0, 200, 0, 200),
                BackgroundTransparency = 1
            }, 0.6):Completed:Connect(function()
                ripple:Destroy()
            end)
        end
    end)
end

-- Main Window Function
function ProMaxUI:CreateWindow(config)
    config = config or {}
    
    local windowConfig = {
        Title = config.Title or "ProMax Executor",
        Subtitle = config.Subtitle or "v1.0.0",
        Size = config.Size or UDim2.new(0, 600, 0, 450),
        Theme = config.Theme or "Executor",
        SaveConfig = config.SaveConfig ~= false,
        ConfigFolder = config.ConfigFolder or "ProMaxExecutor",
        KeyBind = config.KeyBind or Enum.KeyCode.Insert
    }
    
    -- Set Theme
    if ProMaxUI.Themes[windowConfig.Theme] then
        ProMaxUI.CurrentTheme = ProMaxUI.Themes[windowConfig.Theme]
    end
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ProMaxExecutorUI"
    ScreenGui.Parent = GuiParent
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- ป้องกันการ Detect สำหรับ Executor
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
    
    -- Main Container
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = ScreenGui
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0.5, -windowConfig.Size.X.Offset/2, 0.5, -windowConfig.Size.Y.Offset/2)
    Container.Size = windowConfig.Size
    Container.Active = true
    Container.Draggable = true
    
    -- Background Frame
    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.Parent = Container
    Background.BackgroundColor3 = ProMaxUI.CurrentTheme.Primary
    Background.BorderSizePixel = 0
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.ClipsDescendants = true
    
    CreateCorner(10).Parent = Background
    CreateStroke(1, ProMaxUI.CurrentTheme.Border).Parent = Background
    CreateShadow(Background)
    
    -- Background Gradient
    local bgGradient = CreateGradient(
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, ProMaxUI.CurrentTheme.Primary),
            ColorSequenceKeypoint.new(1, ProMaxUI.CurrentTheme.Secondary)
        },
        45
    )
    bgGradient.Parent = Background
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = Background
    TitleBar.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    
    CreateCorner(10).Parent = TitleBar
    CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.3).Parent = TitleBar
    
    -- Title Text
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0, 300, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = windowConfig.Title .. " • " .. windowConfig.Subtitle
    TitleLabel.TextColor3 = ProMaxUI.CurrentTheme.Text
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Control Buttons
    local ControlsFrame = Instance.new("Frame")
    ControlsFrame.Name = "Controls"
    ControlsFrame.Parent = TitleBar
    ControlsFrame.BackgroundTransparency = 1
    ControlsFrame.Position = UDim2.new(1, -90, 0, 5)
    ControlsFrame.Size = UDim2.new(0, 85, 0, 30)
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "Minimize"
    MinimizeBtn.Parent = ControlsFrame
    MinimizeBtn.BackgroundColor3 = ProMaxUI.CurrentTheme.Warning
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "─"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 12
    
    CreateCorner(4).Parent = MinimizeBtn
    CreateRipple(MinimizeBtn)
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Parent = ControlsFrame
    CloseBtn.BackgroundColor3 = ProMaxUI.CurrentTheme.Error
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(0, 30, 0, 0)
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 12
    
    CreateCorner(4).Parent = CloseBtn
    CreateRipple(CloseBtn)
    
    -- Settings Button
    local SettingsBtn = Instance.new("TextButton")
    SettingsBtn.Name = "Settings"
    SettingsBtn.Parent = ControlsFrame
    SettingsBtn.BackgroundColor3 = ProMaxUI.CurrentTheme.Accent
    SettingsBtn.BorderSizePixel = 0
    SettingsBtn.Position = UDim2.new(0, 60, 0, 0)
    SettingsBtn.Size = UDim2.new(0, 25, 0, 25)
    SettingsBtn.Font = Enum.Font.GothamBold
    SettingsBtn.Text = "⚙"
    SettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SettingsBtn.TextSize = 12
    
    CreateCorner(4).Parent = SettingsBtn
    CreateRipple(SettingsBtn)
    
    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Parent = Background
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = ContentFrame
    Sidebar.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    
    CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.3).Parent = Sidebar
    
    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.ScrollBarThickness = 3
    TabContainer.ScrollBarImageColor3 = ProMaxUI.CurrentTheme.Accent
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    -- Main Content
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.Parent = ContentFrame
    MainContent.BackgroundTransparency = 1
    MainContent.Position = UDim2.new(0, 140, 0, 0)
    MainContent.Size = UDim2.new(1, -140, 1, 0)
    
    -- Window Object
    local WindowObject = {
        ScreenGui = ScreenGui,
        Container = Container,
        Background = Background,
        TitleBar = TitleBar,
        ContentFrame = ContentFrame,
        Sidebar = Sidebar,
        TabContainer = TabContainer,
        MainContent = MainContent,
        Config = windowConfig,
        Tabs = {},
        CurrentTab = nil,
        Visible = true,
        Minimized = false
    }
    
    -- Window Methods
    function WindowObject:Toggle()
        self.Visible = not self.Visible
        Tween(self.Container, {
            Size = self.Visible and windowConfig.Size or UDim2.new(0, 0, 0, 0)
        })
    end
    
    function WindowObject:Minimize()
        self.Minimized = not self.Minimized
        local targetSize = self.Minimized and UDim2.new(0, windowConfig.Size.X.Offset, 0, 40) or windowConfig.Size
        Tween(self.Container, {Size = targetSize})
        self.ContentFrame.Visible = not self.Minimized
    end
    
    function WindowObject:Destroy()
        self.ScreenGui:Destroy()
    end
    
    function WindowObject:CreateTab(config)
        config = config or {}
        local tabConfig = {
            Name = config.Name or "Tab",
            Icon = config.Icon or "📁",
            Color = config.Color or ProMaxUI.CurrentTheme.Accent
        }
        
        local tabIndex = #self.Tabs + 1
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "Tab_" .. tabConfig.Name
        TabButton.Parent = self.TabContainer
        TabButton.BackgroundColor3 = ProMaxUI.CurrentTheme.Tertiary
        TabButton.BorderSizePixel = 0
        TabButton.Position = UDim2.new(0, 0, 0, (tabIndex - 1) * 45)
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tabConfig.Icon .. " " .. tabConfig.Name
        TabButton.TextColor3 = ProMaxUI.CurrentTheme.TextDim
        TabButton.TextSize = 12
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        
        CreateCorner(6).Parent = TabButton
        CreateRipple(TabButton)
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. tabConfig.Name
        TabContent.Parent = self.MainContent
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = ProMaxUI.CurrentTheme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        
        -- Tab Object
        local TabObject = {
            Button = TabButton,
            Content = TabContent,
            Config = tabConfig,
            Active = false,
            Elements = {},
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
            
            -- Visual Update
            Tween(self.Button, {
                BackgroundColor3 = tabConfig.Color,
                TextColor3 = ProMaxUI.CurrentTheme.Text
            })
            
            self.Content.Visible = true
        end
        
        function TabObject:Deactivate()
            self.Active = false
            
            Tween(self.Button, {
                BackgroundColor3 = ProMaxUI.CurrentTheme.Tertiary,
                TextColor3 = ProMaxUI.CurrentTheme.TextDim
            })
            
            self.Content.Visible = false
        end
        
        function TabObject:CreateButton(config)
            config = config or {}
            local buttonConfig = {
                Name = config.Name or "Button",
                Description = config.Description or "",
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 70
            self.ElementCount = self.ElementCount + 1
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "Button_" .. buttonConfig.Name
            ButtonFrame.Parent = self.Content
            ButtonFrame.BackgroundTransparency = 1
            ButtonFrame.Position = UDim2.new(0, 0, 0, yPos)
            ButtonFrame.Size = UDim2.new(1, 0, 0, 60)
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = ButtonFrame
            Button.BackgroundColor3 = ProMaxUI.CurrentTheme.Accent
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(0, 0, 0, 0)
            Button.Size = UDim2.new(1, 0, 1, -10)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = buttonConfig.Name
            Button.TextColor3 = ProMaxUI.CurrentTheme.Text
            Button.TextSize = 14
            
            CreateCorner(6).Parent = Button
            CreateRipple(Button)
            
            -- Hover Effects
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = ProMaxUI.CurrentTheme.AccentDark})
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = ProMaxUI.CurrentTheme.Accent})
            end)
            
            Button.MouseButton1Click:Connect(function()
                buttonConfig.Callback()
            end)
            
            self:UpdateCanvasSize()
            return Button
        end
        
        function TabObject:CreateToggle(config)
            config = config or {}
            local toggleConfig = {
                Name = config.Name or "Toggle",
                Description = config.Description or "",
                Default = config.Default or false,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 70
            self.ElementCount = self.ElementCount + 1
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle_" .. toggleConfig.Name
            ToggleFrame.Parent = self.Content
            ToggleFrame.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Position = UDim2.new(0, 0, 0, yPos)
            ToggleFrame.Size = UDim2.new(1, 0, 0, 60)
            
            CreateCorner(6).Parent = ToggleFrame
            CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.3).Parent = ToggleFrame
            
            local NameLabel = Instance.new("TextLabel")
            NameLabel.Parent = ToggleFrame
            NameLabel.BackgroundTransparency = 1
            NameLabel.Position = UDim2.new(0, 15, 0, 10)
            NameLabel.Size = UDim2.new(0.7, 0, 0, 20)
            NameLabel.Font = Enum.Font.GothamSemibold
            NameLabel.Text = toggleConfig.Name
            NameLabel.TextColor3 = ProMaxUI.CurrentTheme.Text
            NameLabel.TextSize = 14
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local DescLabel = Instance.new("TextLabel")
            DescLabel.Parent = ToggleFrame
            DescLabel.BackgroundTransparency = 1
            DescLabel.Position = UDim2.new(0, 15, 0, 30)
            DescLabel.Size = UDim2.new(0.7, 0, 0, 20)
            DescLabel.Font = Enum.Font.Gotham
            DescLabel.Text = toggleConfig.Description
            DescLabel.TextColor3 = ProMaxUI.CurrentTheme.TextDim
            DescLabel.TextSize = 12
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Toggle Switch
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = toggleConfig.Default and ProMaxUI.CurrentTheme.Success or ProMaxUI.CurrentTheme.Tertiary
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(1, -60, 0.5, -12)
            ToggleButton.Size = UDim2.new(0, 50, 0, 24)
            ToggleButton.Text = ""
            
            CreateCorner(12).Parent = ToggleButton
            
            local ToggleKnob = Instance.new("Frame")
            ToggleKnob.Parent = ToggleButton
            ToggleKnob.BackgroundColor3 = ProMaxUI.CurrentTheme.Text
            ToggleKnob.BorderSizePixel = 0
            ToggleKnob.Position = UDim2.new(0, toggleConfig.Default and 28 or 2, 0, 2)
            ToggleKnob.Size = UDim2.new(0, 20, 0, 20)
            
            CreateCorner(10).Parent = ToggleKnob
            
            local isToggled = toggleConfig.Default
            
            ToggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                
                Tween(ToggleButton, {
                    BackgroundColor3 = isToggled and ProMaxUI.CurrentTheme.Success or ProMaxUI.CurrentTheme.Tertiary
                })
                
                Tween(ToggleKnob, {
                    Position = UDim2.new(0, isToggled and 28 or 2, 0, 2)
                }, 0.2, Enum.EasingStyle.Back)
                
                toggleConfig.Callback(isToggled)
            end)
            
            self:UpdateCanvasSize()
            return ToggleFrame
        end
        
        function TabObject:CreateSlider(config)
            config = config or {}
            local sliderConfig = {
                Name = config.Name or "Slider",
                Description = config.Description or "",
                Min = config.Min or 0,
                Max = config.Max or 100,
                Default = config.Default or 50,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 80
            self.ElementCount = self.ElementCount + 1
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider_" .. sliderConfig.Name
            SliderFrame.Parent = self.Content
            SliderFrame.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Position = UDim2.new(0, 0, 0, yPos)
            SliderFrame.Size = UDim2.new(1, 0, 0, 70)
            
            CreateCorner(6).Parent = SliderFrame
            CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.3).Parent = SliderFrame
            
            local NameLabel = Instance.new("TextLabel")
            NameLabel.Parent = SliderFrame
            NameLabel.BackgroundTransparency = 1
            NameLabel.Position = UDim2.new(0, 15, 0, 5)
            NameLabel.Size = UDim2.new(0.6, 0, 0, 20)
            NameLabel.Font = Enum.Font.GothamSemibold
            NameLabel.Text = sliderConfig.Name
            NameLabel.TextColor3 = ProMaxUI.CurrentTheme.Text
            NameLabel.TextSize = 14
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(0.7, 0, 0, 5)
            ValueLabel.Size = UDim2.new(0.25, 0, 0, 20)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(sliderConfig.Default)
            ValueLabel.TextColor3 = ProMaxUI.CurrentTheme.Accent
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            -- Slider Track
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Parent = SliderFrame
            SliderTrack.BackgroundColor3 = ProMaxUI.CurrentTheme.Tertiary
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Position = UDim2.new(0, 15, 0, 35)
            SliderTrack.Size = UDim2.new(1, -30, 0, 6)
            
            CreateCorner(3).Parent = SliderTrack
            
            -- Slider Fill
            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderTrack
            SliderFill.BackgroundColor3 = ProMaxUI.CurrentTheme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
            
            CreateCorner(3).Parent = SliderFill
            
            -- Slider Knob
            local SliderKnob = Instance.new("Frame")
            SliderKnob.Parent = SliderTrack
            SliderKnob.BackgroundColor3 = ProMaxUI.CurrentTheme.Text
            SliderKnob.BorderSizePixel = 0
            SliderKnob.Position = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), -6, 0.5, -6)
            SliderKnob.Size = UDim2.new(0, 12, 0, 12)
            SliderKnob.ZIndex = SliderTrack.ZIndex + 1
            
            CreateCorner(6).Parent = SliderKnob
            
            local isDragging = false
            local currentValue = sliderConfig.Default
            
            local function updateSlider(input)
                local trackPos = SliderTrack.AbsolutePosition.X
                local trackSize = SliderTrack.AbsoluteSize.X
                local mousePos = input.Position.X
                
                local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                currentValue = math.floor(sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percent)
                
                Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                Tween(SliderKnob, {Position = UDim2.new(percent, -6, 0.5, -6)}, 0.1)
                
                ValueLabel.Text = tostring(currentValue)
                sliderConfig.Callback(currentValue)
            end
            
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)
            
            self:UpdateCanvasSize()
            return SliderFrame
        end
        
        function TabObject:UpdateCanvasSize()
            local contentSize = self.ElementCount * 80
            self.Content.CanvasSize = UDim2.new(0, 0, 0, contentSize)
        end
        
        -- Connect tab activation
        TabButton.MouseButton1Click:Connect(function()
            TabObject:Activate()
        end)
        
        self.Tabs[tabConfig.Name] = TabObject
        
        -- Auto-activate first tab
        if #self.Tabs == 1 then
            TabObject:Activate()
        end
        
        -- Update sidebar canvas
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, tabIndex * 45)
        
        return TabObject
    end
    
    -- Event Connections
    CloseBtn.MouseButton1Click:Connect(function()
        WindowObject:Destroy()
    end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        WindowObject:Minimize()
    end)
    
    -- KeyBind Toggle
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == windowConfig.KeyBind then
            WindowObject:Toggle()
        end
    end)
    
    return WindowObject
end

-- Notification System
function ProMaxUI:Notify(config)
    config = config or {}
    local notifConfig = {
        Title = config.Title or "Notification",
        Description = config.Description or "",
        Duration = config.Duration or 3,
        Type = config.Type or "Info" -- Info, Success, Warning, Error
    }
    
    local colors = {
        Info = ProMaxUI.CurrentTheme.Accent,
        Success = ProMaxUI.CurrentTheme.Success,
        Warning = ProMaxUI.CurrentTheme.Warning,
        Error = ProMaxUI.CurrentTheme.Error
    }
    
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "ProMaxNotification"
    NotifGui.Parent = GuiParent
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Parent = NotifGui
    NotifFrame.BackgroundColor3 = ProMaxUI.CurrentTheme.Primary
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(1, 10, 0, 50)
    NotifFrame.Size = UDim2.new(0, 300, 0, 80)
    
    CreateCorner(8).Parent = NotifFrame
    CreateStroke(2, colors[notifConfig.Type]).Parent = NotifFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = NotifFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    TitleLabel.Size = UDim2.new(1, -30, 0, 25)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = notifConfig.Title
    TitleLabel.TextColor3 = ProMaxUI.CurrentTheme.Text
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Parent = NotifFrame
    DescLabel.BackgroundTransparency = 1
    DescLabel.Position = UDim2.new(0, 15, 0, 35)
    DescLabel.Size = UDim2.new(1, -30, 0, 35)
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = notifConfig.Description
    DescLabel.TextColor3 = ProMaxUI.CurrentTheme.TextDim
    DescLabel.TextSize = 12
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true
    
    -- Animations
    Tween(NotifFrame, {Position = UDim2.new(1, -310, 0, 50)}, 0.5, Enum.EasingStyle.Back)
    
    -- Auto close
    game:GetService("Debris"):AddItem(NotifGui, notifConfig.Duration)
    wait(notifConfig.Duration - 0.5)
    if NotifGui.Parent then
        Tween(NotifFrame, {Position = UDim2.new(1, 10, 0, 50)}, 0.3)
    end
end

return ProMaxUI
