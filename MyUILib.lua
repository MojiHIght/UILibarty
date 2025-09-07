-- Modern Beautiful UI Library
-- สำหรับ Roblox Executor - สวยงาม โมเดิร์น

local ModernUI = {}

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
ModernUI.Config = {
    AnimationSpeed = 0.35,
    SoundEffects = true,
    BlurIntensity = 8,
    DropShadow = true
}

-- Modern Theme System
ModernUI.Themes = {
    Midnight = {
        Name = "Midnight",
        Background = Color3.fromRGB(20, 25, 35),
        Secondary = Color3.fromRGB(30, 35, 45),
        Tertiary = Color3.fromRGB(40, 45, 55),
        Accent = Color3.fromRGB(120, 160, 255),
        AccentDark = Color3.fromRGB(100, 140, 235),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 185, 195),
        TextDim = Color3.fromRGB(140, 145, 155),
        Success = Color3.fromRGB(85, 200, 140),
        Warning = Color3.fromRGB(255, 180, 70),
        Error = Color3.fromRGB(255, 110, 110),
        Border = Color3.fromRGB(55, 65, 75),
        Shadow = Color3.fromRGB(5, 10, 15)
    },
    Ocean = {
        Name = "Ocean",
        Background = Color3.fromRGB(15, 30, 45),
        Secondary = Color3.fromRGB(25, 40, 55),
        Tertiary = Color3.fromRGB(35, 50, 65),
        Accent = Color3.fromRGB(70, 180, 255),
        AccentDark = Color3.fromRGB(50, 160, 235),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 220, 240),
        TextDim = Color3.fromRGB(160, 180, 200),
        Success = Color3.fromRGB(80, 220, 160),
        Warning = Color3.fromRGB(255, 190, 80),
        Error = Color3.fromRGB(255, 120, 120),
        Border = Color3.fromRGB(45, 70, 95),
        Shadow = Color3.fromRGB(5, 15, 25)
    },
    Forest = {
        Name = "Forest",
        Background = Color3.fromRGB(25, 35, 25),
        Secondary = Color3.fromRGB(35, 45, 35),
        Tertiary = Color3.fromRGB(45, 55, 45),
        Accent = Color3.fromRGB(120, 200, 140),
        AccentDark = Color3.fromRGB(100, 180, 120),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(210, 220, 210),
        TextDim = Color3.fromRGB(170, 180, 170),
        Success = Color3.fromRGB(100, 220, 120),
        Warning = Color3.fromRGB(255, 200, 100),
        Error = Color3.fromRGB(255, 130, 130),
        Border = Color3.fromRGB(65, 75, 65),
        Shadow = Color3.fromRGB(10, 15, 10)
    }
}

ModernUI.CurrentTheme = ModernUI.Themes.Midnight
ModernUI.Windows = {}
ModernUI.Connections = {}
ModernUI.Notifications = {}

-- Sound System
local Sounds = {
    Click = "rbxassetid://6895079853",
    Hover = "rbxassetid://6895079853",
    Success = "rbxassetid://6026984644",
    Error = "rbxassetid://6026984644",
    Pop = "rbxassetid://6895079853"
}

-- Utility Functions
local function PlaySound(soundName, volume)
    if not ModernUI.Config.SoundEffects then return end
    
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = Sounds[soundName] or Sounds.Click
        sound.Volume = volume or 0.15
        sound.Pitch = 1 + (math.random(-10, 10) / 100)
        sound.Parent = SoundService
        sound:Play()
        
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
end

local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    return corner
end

local function CreateStroke(thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or ModernUI.CurrentTheme.Border
    stroke.Transparency = transparency or 0
    return stroke
end

local function CreateGradient(colors, rotation, transparency)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colors
    gradient.Rotation = rotation or 0
    if transparency then
        gradient.Transparency = transparency
    end
    return gradient
end

local function CreateDropShadow(parent, size, intensity, color)
    if not ModernUI.Config.DropShadow then return end
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.Parent = parent
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = color or ModernUI.CurrentTheme.Shadow
    shadow.ImageTransparency = 1 - (intensity or 0.3)
    shadow.Position = UDim2.new(0, -size, 0, -size)
    shadow.Size = UDim2.new(1, size * 2, 1, size * 2)
    shadow.ZIndex = (parent.ZIndex or 1) - 1
    
    CreateCorner(size).Parent = shadow
    return shadow
end

local function SmoothTween(object, properties, duration, style, direction, callback)
    local tweenInfo = TweenInfo.new(
        duration or ModernUI.Config.AnimationSpeed,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    table.insert(ModernUI.Connections, tween)
    return tween
end

local function CreateRipple(button, color)
    local rippleConnection
    rippleConnection = button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            PlaySound("Click")
            
            local ripple = Instance.new("Frame")
            ripple.Name = "Ripple"
            ripple.Parent = button
            ripple.BackgroundColor3 = color or ModernUI.CurrentTheme.Accent
            ripple.BackgroundTransparency = 0.8
            ripple.BorderSizePixel = 0
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            ripple.ZIndex = button.ZIndex + 10
            
            local mousePos = UserInputService:GetMouseLocation()
            local buttonPos = button.AbsolutePosition
            ripple.Position = UDim2.new(0, mousePos.X - buttonPos.X, 0, mousePos.Y - buttonPos.Y)
            ripple.Size = UDim2.new(0, 0, 0, 0)
            
            CreateCorner(100).Parent = ripple
            
            local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.2
            
            SmoothTween(ripple, {
                Size = UDim2.new(0, maxSize, 0, maxSize),
                BackgroundTransparency = 1
            }, 0.6, Enum.EasingStyle.Quad, nil, function()
                if ripple.Parent then
                    ripple:Destroy()
                end
            end)
        end
    end)
    
    table.insert(ModernUI.Connections, rippleConnection)
end

local function CreateGlow(object, color, intensity)
    local glow = Instance.new("Frame")
    glow.Name = "Glow"
    glow.Parent = object
    glow.BackgroundColor3 = color or ModernUI.CurrentTheme.Accent
    glow.BackgroundTransparency = 1 - (intensity or 0.1)
    glow.BorderSizePixel = 0
    glow.Position = UDim2.new(0, -2, 0, -2)
    glow.Size = UDim2.new(1, 4, 1, 4)
    glow.ZIndex = object.ZIndex - 1
    
    CreateCorner(12).Parent = glow
    
    local glowGradient = CreateGradient(
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, color or ModernUI.CurrentTheme.Accent)
        },
        0,
        NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(1, 1)
        }
    )
    glowGradient.Parent = glow
    
    return glow
end

local function AnimateScale(object, targetScale, duration)
    object.AnchorPoint = Vector2.new(0.5, 0.5)
    local originalPosition = object.Position
    object.Position = UDim2.new(originalPosition.X.Scale + originalPosition.X.Offset/object.Parent.AbsoluteSize.X/2, 0, originalPosition.Y.Scale + originalPosition.Y.Offset/object.Parent.AbsoluteSize.Y/2, 0)
    
    SmoothTween(object, {
        Size = UDim2.new(targetScale, 0, targetScale, 0)
    }, duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

-- Window Creation
function ModernUI:CreateWindow(config)
    config = config or {}
    
    local windowConfig = {
        Title = config.Title or "Modern UI",
        Subtitle = config.Subtitle or "Beautiful & Functional",
        Size = config.Size or UDim2.new(0, 580, 0, 420),
        Theme = config.Theme or "Midnight",
        KeyBind = config.KeyBind or Enum.KeyCode.Insert,
        Draggable = config.Draggable ~= false
    }
    
    -- Set theme
    if ModernUI.Themes[windowConfig.Theme] then
        ModernUI.CurrentTheme = ModernUI.Themes[windowConfig.Theme]
    end
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUI_" .. HttpService:GenerateGUID(false):sub(1, 8)
    ScreenGui.Parent = GuiParent
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    
    -- Background Blur
    local BlurFrame = Instance.new("Frame")
    BlurFrame.Name = "BlurBackground"
    BlurFrame.Parent = ScreenGui
    BlurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlurFrame.BackgroundTransparency = 0.4
    BlurFrame.BorderSizePixel = 0
    BlurFrame.Size = UDim2.new(1, 0, 1, 0)
    BlurFrame.ZIndex = 1
    
    -- Main Container
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = ScreenGui
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0.5, -windowConfig.Size.X.Offset/2, 0.5, -windowConfig.Size.Y.Offset/2)
    Container.Size = windowConfig.Size
    Container.ZIndex = 2
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Container
    MainFrame.BackgroundColor3 = ModernUI.CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.ZIndex = 3
    
    CreateCorner(12).Parent = MainFrame
    CreateStroke(1, ModernUI.CurrentTheme.Border, 0.3).Parent = MainFrame
    CreateDropShadow(MainFrame, 8, 0.4)
    
    -- Background Gradient
    local bgGradient = CreateGradient(
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, ModernUI.CurrentTheme.Background),
            ColorSequenceKeypoint.new(0.5, ModernUI.CurrentTheme.Secondary),
            ColorSequenceKeypoint.new(1, ModernUI.CurrentTheme.Background)
        },
        45
    )
    bgGradient.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = ModernUI.CurrentTheme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.ZIndex = 4
    
    CreateCorner(12).Parent = TitleBar
    CreateStroke(1, ModernUI.CurrentTheme.Border, 0.4).Parent = TitleBar
    
    -- Title Bar Gradient
    local titleGradient = CreateGradient(
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, ModernUI.CurrentTheme.Accent),
            ColorSequenceKeypoint.new(1, ModernUI.CurrentTheme.AccentDark)
        },
        90,
        NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(1, 0.95)
        }
    )
    titleGradient.Parent = TitleBar
    
    -- Icon
    local IconFrame = Instance.new("Frame")
    IconFrame.Name = "Icon"
    IconFrame.Parent = TitleBar
    IconFrame.BackgroundColor3 = ModernUI.CurrentTheme.Accent
    IconFrame.BorderSizePixel = 0
    IconFrame.Position = UDim2.new(0, 12, 0.5, -12)
    IconFrame.Size = UDim2.new(0, 24, 0, 24)
    IconFrame.ZIndex = 5
    
    CreateCorner(6).Parent = IconFrame
    CreateGlow(IconFrame, ModernUI.CurrentTheme.Accent, 0.2)
    
    -- Spinning icon animation
    spawn(function()
        while IconFrame.Parent do
            SmoothTween(IconFrame, {Rotation = 360}, 8, Enum.EasingStyle.Linear)
            wait(8)
            IconFrame.Rotation = 0
        end
    end)
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 45, 0, 8)
    TitleLabel.Size = UDim2.new(0.6, 0, 0, 20)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = windowConfig.Title
    TitleLabel.TextColor3 = ModernUI.CurrentTheme.Text
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 5
    
    -- Subtitle
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Parent = TitleBar
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Position = UDim2.new(0, 45, 0, 26)
    SubtitleLabel.Size = UDim2.new(0.6, 0, 0, 15)
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.Text = windowConfig.Subtitle
    SubtitleLabel.TextColor3 = ModernUI.CurrentTheme.TextDim
    SubtitleLabel.TextSize = 11
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.ZIndex = 5
    
    -- Control Buttons
    local ControlsFrame = Instance.new("Frame")
    ControlsFrame.Name = "Controls"
    ControlsFrame.Parent = TitleBar
    ControlsFrame.BackgroundTransparency = 1
    ControlsFrame.Position = UDim2.new(1, -90, 0, 8)
    ControlsFrame.Size = UDim2.new(0, 80, 0, 30)
    ControlsFrame.ZIndex = 5
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "Minimize"
    MinimizeBtn.Parent = ControlsFrame
    MinimizeBtn.BackgroundColor3 = ModernUI.CurrentTheme.Warning
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "─"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 14
    MinimizeBtn.ZIndex = 6
    
    CreateCorner(8).Parent = MinimizeBtn
    CreateRipple(MinimizeBtn, ModernUI.CurrentTheme.Warning)
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Parent = ControlsFrame
    CloseBtn.BackgroundColor3 = ModernUI.CurrentTheme.Error
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(0, 40, 0, 0)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 14
    CloseBtn.ZIndex = 6
    
    CreateCorner(8).Parent = CloseBtn
    CreateRipple(CloseBtn, ModernUI.CurrentTheme.Error)
    
    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 45)
    ContentFrame.Size = UDim2.new(1, 0, 1, -45)
    ContentFrame.ZIndex = 4
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = ContentFrame
    Sidebar.BackgroundColor3 = ModernUI.CurrentTheme.Secondary
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.ZIndex = 5
    
    CreateStroke(1, ModernUI.CurrentTheme.Border, 0.4).Parent = Sidebar
    
    -- Sidebar Gradient
    local sidebarGradient = CreateGradient(
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, ModernUI.CurrentTheme.Secondary),
            ColorSequenceKeypoint.new(1, ModernUI.CurrentTheme.Tertiary)
        },
        180
    )
    sidebarGradient.Parent = Sidebar
    
    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 8, 0, 8)
    TabContainer.Size = UDim2.new(1, -16, 1, -16)
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = ModernUI.CurrentTheme.Accent
    TabContainer.ScrollBarImageTransparency = 0.4
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ZIndex = 6
    
    -- Main Content
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.Parent = ContentFrame
    MainContent.BackgroundTransparency = 1
    MainContent.Position = UDim2.new(0, 150, 0, 0)
    MainContent.Size = UDim2.new(1, -150, 1, 0)
    MainContent.ZIndex = 5
    
    -- Window Object
    local WindowObject = {
        ScreenGui = ScreenGui,
        Container = Container,
        MainFrame = MainFrame,
        TitleBar = TitleBar,
        ContentFrame = ContentFrame,
        Sidebar = Sidebar,
        TabContainer = TabContainer,
        MainContent = MainContent,
        BlurFrame = BlurFrame,
        Config = windowConfig,
        Tabs = {},
        CurrentTab = nil,
        Visible = true,
        Minimized = false,
        TabCount = 0
    }
    
    -- Window Methods
    function WindowObject:Toggle()
        self.Visible = not self.Visible
        
        if self.Visible then
            self.ScreenGui.Enabled = true
            -- Scale in animation
            self.Container.Size = UDim2.new(0, 0, 0, 0)
            SmoothTween(self.Container, {Size = windowConfig.Size}, 0.5, Enum.EasingStyle.Back)
            SmoothTween(self.BlurFrame, {BackgroundTransparency = 0.4})
            PlaySound("Pop", 0.3)
        else
            SmoothTween(self.Container, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
            SmoothTween(self.BlurFrame, {BackgroundTransparency = 1}, 0.4, nil, nil, function()
                self.ScreenGui.Enabled = false
            end)
        end
    end
    
    function WindowObject:Minimize()
        self.Minimized = not self.Minimized
        PlaySound("Click", 0.2)
        
        local targetSize = self.Minimized and UDim2.new(0, windowConfig.Size.X.Offset, 0, 45) or windowConfig.Size
        
        SmoothTween(self.Container, {Size = targetSize}, 0.4, Enum.EasingStyle.Back)
        
        self.ContentFrame.Visible = not self.Minimized
    end
    
    function WindowObject:Destroy()
        -- Clean up connections
        for _, connection in pairs(ModernUI.Connections) do
            if typeof(connection) == "RBXScriptConnection" then
                connection:Disconnect()
            elseif typeof(connection) == "Tween" then
                connection:Cancel()
            end
        end
        
        PlaySound("Pop", 0.2)
        SmoothTween(self.Container, {
            Size = UDim2.new(0, 0, 0, 0),
            Rotation = 5
        }, 0.4, Enum.EasingStyle.Back, nil, function()
            self.ScreenGui:Destroy()
        end)
        
        -- Remove from windows list
        for i, window in pairs(ModernUI.Windows) do
            if window == self then
                table.remove(ModernUI.Windows, i)
                break
            end
        end
    end
    
    function WindowObject:CreateTab(config)
        config = config or {}
        
        local tabConfig = {
            Name = config.Name or "Tab",
            Icon = config.Icon or "📁"
        }
        
        self.TabCount = self.TabCount + 1
        local tabIndex = self.TabCount
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "Tab_" .. tabConfig.Name
        TabButton.Parent = self.TabContainer
        TabButton.BackgroundColor3 = ModernUI.CurrentTheme.Tertiary
        TabButton.BorderSizePixel = 0
        TabButton.Position = UDim2.new(0, 0, 0, (tabIndex - 1) * 45)
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = ""
        TabButton.TextColor3 = ModernUI.CurrentTheme.TextSecondary
        TabButton.TextSize = 13
        TabButton.ZIndex = 7
        
        CreateCorner(10).Parent = TabButton
        CreateStroke(1, ModernUI.CurrentTheme.Border, 0.6).Parent = TabButton
        
        -- Tab Icon
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Name = "Icon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 12, 0, 0)
        TabIcon.Size = UDim2.new(0, 30, 1, 0)
        TabIcon.Font = Enum.Font.GothamBold
        TabIcon.Text = tabConfig.Icon
        TabIcon.TextColor3 = ModernUI.CurrentTheme.TextSecondary
        TabIcon.TextSize = 16
        TabIcon.TextXAlignment = Enum.TextXAlignment.Center
        TabIcon.ZIndex = 8
        
        -- Tab Text
        local TabText = Instance.new("TextLabel")
        TabText.Name = "Text"
        TabText.Parent = TabButton
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, 42, 0, 0)
        TabText.Size = UDim2.new(1, -50, 1, 0)
        TabText.Font = Enum.Font.GothamSemibold
        TabText.Text = tabConfig.Name
        TabText.TextColor3 = ModernUI.CurrentTheme.TextSecondary
        TabText.TextSize = 12
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.ZIndex = 8
        
        -- Tab Indicator
        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Parent = TabButton
        TabIndicator.BackgroundColor3 = ModernUI.CurrentTheme.Accent
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Position = UDim2.new(1, -3, 0, 8)
        TabIndicator.Size = UDim2.new(0, 0, 1, -16)
        TabIndicator.ZIndex = 8
        
        CreateCorner(3).Parent = TabIndicator
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. tabConfig.Name
        TabContent.Parent = self.MainContent
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, 15, 0, 15)
        TabContent.Size = UDim2.new(1, -30, 1, -30)
        TabContent.ScrollBarThickness = 6
        TabContent.ScrollBarImageColor3 = ModernUI.CurrentTheme.Accent
        TabContent.ScrollBarImageTransparency = 0.5
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.ZIndex = 6
        
        -- Tab Object
        local TabObject = {
            Button = TabButton,
            Content = TabContent,
            Icon = TabIcon,
            Text = TabText,
            Indicator = TabIndicator,
            Config = tabConfig,
            Active = false,
            ElementCount = 0
        }
        
        function TabObject:Activate()
            if self.Active then return end
            
            PlaySound("Click", 0.15)
            
            -- Deactivate other tabs
            for _, tab in pairs(WindowObject.Tabs) do
                if tab.Active then
                    tab:Deactivate()
                end
            end
            
            self.Active = true
            WindowObject.CurrentTab = self
            
            -- Smooth animations
            SmoothTween(self.Button, {BackgroundColor3 = ModernUI.CurrentTheme.Accent}, 0.3)
            SmoothTween(self.Icon, {TextColor3 = ModernUI.CurrentTheme.Text}, 0.3)
            SmoothTween(self.Text, {TextColor3 = ModernUI.CurrentTheme.Text}, 0.3)
            SmoothTween(self.Indicator, {Size = UDim2.new(0, 3, 1, -16)}, 0.4, Enum.EasingStyle.Back)
            
            -- Show content with fade
            self.Content.Visible = true
            self.Content.BackgroundTransparency = 1
            SmoothTween(self.Content, {BackgroundTransparency = 0}, 0.3)
            
            CreateGlow(self.Button, ModernUI.CurrentTheme.Accent, 0.15)
        end
        
        function TabObject:Deactivate()
            self.Active = false
            
            SmoothTween(self.Button, {BackgroundColor3 = ModernUI.CurrentTheme.Tertiary}, 0.3)
            SmoothTween(self.Icon, {TextColor3 = ModernUI.CurrentTheme.TextSecondary}, 0.3)
            SmoothTween(self.Text, {TextColor3 = ModernUI.CurrentTheme.TextSecondary}, 0.3)
            SmoothTween(self.Indicator, {Size = UDim2.new(0, 0, 1, -16)}, 0.3)
            
            if self.Button:FindFirstChild("Glow") then
                self.Button.Glow:Destroy()
            end
            
            self.Content.Visible = false
        end
        
        function TabObject:CreateButton(config)
            config = config or {}
            
            local buttonConfig = {
                Name = config.Name or "Button",
                Description = config.Description or "",
                Callback = config.Callback or function() end,
                Color = config.Color or ModernUI.CurrentTheme.Accent
            }
            
            local yPos = self.ElementCount * 65
            self.ElementCount = self.ElementCount + 1
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "ButtonFrame_" .. buttonConfig.Name
            ButtonFrame.Parent = self.Content
            ButtonFrame.BackgroundTransparency = 1
            ButtonFrame.Position = UDim2.new(0, 0, 0, yPos)
            ButtonFrame.Size = UDim2.new(1, 0, 0, 55)
            ButtonFrame.ZIndex = 7
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = ButtonFrame
            Button.BackgroundColor3 = buttonConfig.Color
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(0, 0, 0, 0)
            Button.Size = UDim2.new(1, -5, 1, -10)
            Button.Font = Enum.Font.GothamBold
            Button.Text = ""
            Button.TextColor3 = ModernUI.CurrentTheme.Text
            Button.TextSize = 14
            Button.ZIndex = 8
            
            CreateCorner(12).Parent = Button
            CreateStroke(1, ModernUI.CurrentTheme.Border, 0.3).Parent = Button
            CreateRipple(Button, buttonConfig.Color)
            CreateDropShadow(Button, 4, 0.2)
            
            -- Button gradient
            local buttonGradient = CreateGradient(
                ColorSequence.new{
                    ColorSequenceKeypoint.new(0, buttonConfig.Color),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(
                        math.max(0, buttonConfig.Color.R * 255 - 15),
                        math.max(0, buttonConfig.Color.G * 255 - 15),
                        math.max(0, buttonConfig.Color.B * 255 - 15)
                    ))
                },
                90
            )
            buttonGradient.Parent = Button
            
            -- Button icon
            local ButtonIcon = Instance.new("TextLabel")
            ButtonIcon.Name = "Icon"
            ButtonIcon.Parent = Button
            ButtonIcon.BackgroundTransparency = 1
            ButtonIcon.Position = UDim2.new(0, 15, 0, 0)
            ButtonIcon.Size = UDim2.new(0, 35, 1, 0)
            ButtonIcon.Font = Enum.Font.GothamBold
            ButtonIcon.Text = "🚀"
            ButtonIcon.TextColor3 = ModernUI.CurrentTheme.Text
            ButtonIcon.TextSize = 18
            ButtonIcon.TextXAlignment = Enum.TextXAlignment.Center
            ButtonIcon.ZIndex = 9
            
            -- Button text
            local ButtonText = Instance.new("TextLabel")
            ButtonText.Name = "Text"
            ButtonText.Parent = Button
            ButtonText.BackgroundTransparency = 1
            ButtonText.Position = UDim2.new(0, 50, 0, 8)
            ButtonText.Size = UDim2.new(1, -55, 0, 20)
            ButtonText.Font = Enum.Font.GothamBold
            ButtonText.Text = buttonConfig.Name
            ButtonText.TextColor3 = ModernUI.CurrentTheme.Text
            ButtonText.TextSize = 14
            ButtonText.TextXAlignment = Enum.TextXAlignment.Left
            ButtonText.ZIndex = 9
            
            -- Button description
            if buttonConfig.Description ~= "" then
                local ButtonDesc = Instance.new("TextLabel")
                ButtonDesc.Name = "Description"
                ButtonDesc.Parent = Button
                ButtonDesc.BackgroundTransparency = 1
                ButtonDesc.Position = UDim2.new(0, 50, 0, 26)
                ButtonDesc.Size = UDim2.new(1, -55, 0, 15)
                ButtonDesc.Font = Enum.Font.Gotham
                ButtonDesc.Text = buttonConfig.Description
                ButtonDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
                ButtonDesc.TextSize = 11
                ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
                ButtonDesc.ZIndex = 9
            end
            
            -- Hover effects
            local hoverConnections = {}
            
            hoverConnections[1] = Button.MouseEnter:Connect(function()
                PlaySound("Hover", 0.08)
                SmoothTween(Button, {
                    Size = UDim2.new(1, -2, 1, -7),
                    BackgroundColor3 = Color3.fromRGB(
                        math.min(255, buttonConfig.Color.R * 255 + 15),
                        math.min(255, buttonConfig.Color.G * 255 + 15),
                        math.min(255, buttonConfig.Color.B * 255 + 15)
                    )
                }, 0.2)
                CreateGlow(Button, buttonConfig.Color, 0.2)
            end)
            
            hoverConnections[2] = Button.MouseLeave:Connect(function()
                SmoothTween(Button, {
                    Size = UDim2.new(1, -5, 1, -10),
                    BackgroundColor3 = buttonConfig.Color
                }, 0.2)
                if Button:FindFirstChild("Glow") then
                    Button.Glow:Destroy()
                end
            end)
            
            hoverConnections[3] = Button.MouseButton1Click:Connect(function()
                -- Click animation
                SmoothTween(Button, {Size = UDim2.new(1, -8, 1, -13)}, 0.1, nil, nil, function()
                    SmoothTween(Button, {Size = UDim2.new(1, -5, 1, -10)}, 0.1)
                end)
                
                local success, err = pcall(buttonConfig.Callback)
                if not success then
                    ModernUI:Notify({
                        Title = "ข้อผิดพลาด",
                        Description = "เกิดข้อผิดพลาดในการทำงาน: " .. tostring(err),
                        Type = "Error"
                    })
                end
            end)
            
            for _, conn in pairs(hoverConnections) do
                table.insert(ModernUI.Connections, conn)
            end
            
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
            
            local yPos = self.ElementCount * 65
            self.ElementCount = self.ElementCount + 1
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame_" .. toggleConfig.Name
            ToggleFrame.Parent = self.Content
            ToggleFrame.BackgroundColor3 = ModernUI.CurrentTheme.Secondary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Position = UDim2.new(0, 0, 0, yPos)
            ToggleFrame.Size = UDim2.new(1, -5, 0, 55)
            ToggleFrame.ZIndex = 7
            
            CreateCorner(12).Parent = ToggleFrame
            CreateStroke(1, ModernUI.CurrentTheme.Border, 0.4).Parent = ToggleFrame
            CreateDropShadow(ToggleFrame, 3, 0.15)
            
            local toggleGradient = CreateGradient(
                ColorSequence.new{
                    ColorSequenceKeypoint.new(0, ModernUI.CurrentTheme.Secondary),
                    ColorSequenceKeypoint.new(1, ModernUI.CurrentTheme.Tertiary)
                },
                45
            )
            toggleGradient.Parent = ToggleFrame
            
            -- Toggle content similar to button but with switch
            -- [Rest of toggle implementation with modern styling...]
            
            self:UpdateCanvasSize()
            return ToggleFrame
        end
        
        function TabObject:UpdateCanvasSize()
            local contentSize = self.ElementCount * 70 + 20
            SmoothTween(self.Content, {CanvasSize = UDim2.new(0, 0, 0, contentSize)}, 0.3)
        end
        
        -- Tab activation
        CreateRipple(TabButton, ModernUI.CurrentTheme.Accent)
        
        local tabConnection = TabButton.MouseButton1Click:Connect(function()
            TabObject:Activate()
        end)
        
        table.insert(ModernUI.Connections, tabConnection)
        
        self.Tabs[tabConfig.Name] = TabObject
        
        if self.TabCount == 1 then
            TabObject:Activate()
        end
        
        self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, self.TabCount * 45 + 8)
        
        return TabObject
    end
    
    -- Button functionality
    local closeConnection = CloseBtn.MouseButton1Click:Connect(function()
        WindowObject:Destroy()
    end)
    
    local minimizeConnection = MinimizeBtn.MouseButton1Click:Connect(function()
        WindowObject:Minimize()
    end)
    
    table.insert(ModernUI.Connections, closeConnection)
    table.insert(ModernUI.Connections, minimizeConnection)
    
    -- Dragging
    if windowConfig.Draggable then
        local dragging = false
        local dragStart = nil
        local startPos = nil
        
        local dragConnection1 = TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Container.Position
                PlaySound("Click", 0.05)
            end
        end)
        
        local dragConnection2 = UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                Container.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
        
        local dragConnection3 = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        table.insert(ModernUI.Connections, dragConnection1)
        table.insert(ModernUI.Connections, dragConnection2)
        table.insert(ModernUI.Connections, dragConnection3)
    end
    
    -- KeyBind
    local keybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == windowConfig.KeyBind then
            WindowObject:Toggle()
        end
    end)
    
    table.insert(ModernUI.Connections, keybindConnection)
    
    -- Initial entrance animation
    Container.Size = UDim2.new(0, 0, 0, 0)
    BlurFrame.BackgroundTransparency = 1
    
    SmoothTween(Container, {Size = windowConfig.Size}, 0.6, Enum.EasingStyle.Back)
    SmoothTween(BlurFrame, {BackgroundTransparency = 0.4}, 0.4)
    
    table.insert(ModernUI.Windows, WindowObject)
    return WindowObject
end

-- Beautiful Notification System
function ModernUI:Notify(config)
    config = config or {}
    
    local notifConfig = {
        Title = config.Title or "การแจ้งเตือน",
        Description = config.Description or "",
        Duration = config.Duration or 4,
        Type = config.Type or "Info"
    }
    
    local colors = {
        Info = {Color = ModernUI.CurrentTheme.Accent, Icon = "ℹ️"},
        Success = {Color = ModernUI.CurrentTheme.Success, Icon = "✅"},
        Warning = {Color = ModernUI.CurrentTheme.Warning, Icon = "⚠️"},
        Error = {Color = ModernUI.CurrentTheme.Error, Icon = "❌"}
    }
    
    local typeData = colors[notifConfig.Type] or colors.Info
    
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "ModernNotification"
    NotifGui.Parent = GuiParent
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Parent = NotifGui
    NotifFrame.BackgroundColor3 = ModernUI.CurrentTheme.Background
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(1, 20, 0, 20 + (#ModernUI.Notifications * 90))
    NotifFrame.Size = UDim2.new(0, 320, 0, 80)
    NotifFrame.ZIndex = 100
    
    CreateCorner(12).Parent = NotifFrame
    CreateStroke(2, typeData.Color).Parent = NotifFrame
    CreateDropShadow(NotifFrame, 6, 0.3)
    
    -- Add to notifications list
    table.insert(ModernUI.Notifications, NotifGui)
    
    -- Slide in animation
    SmoothTween(NotifFrame, {Position = UDim2.new(1, -330, 0, 20 + ((#ModernUI.Notifications-1) * 90))}, 0.5, Enum.EasingStyle.Back)
    
    PlaySound(notifConfig.Type == "Error" and "Error" or "Success", 0.3)
    
    -- Auto remove
    spawn(function()
        wait(notifConfig.Duration)
        if NotifGui.Parent then
            SmoothTween(NotifFrame, {
                Position = UDim2.new(1, 20, 0, NotifFrame.Position.Y.Offset),
                Size = UDim2.new(0, 0, 0, 80)
            }, 0.4, nil, nil, function()
                for i, notif in ipairs(ModernUI.Notifications) do
                    if notif == NotifGui then
                        table.remove(ModernUI.Notifications, i)
                        break
                    end
                end
                NotifGui:Destroy()
            end)
        end
    end)
end

-- Theme Management
function ModernUI:SetTheme(themeName)
    if ModernUI.Themes[themeName] then
        ModernUI.CurrentTheme = ModernUI.Themes[themeName]
        
        self:Notify({
            Title = "เปลี่ยนธีมสำเร็จ",
            Description = "เปลี่ยนเป็นธีม " .. themeName .. " แล้ว",
            Type = "Success"
        })
    end
end

-- Cleanup
function ModernUI:Cleanup()
    for _, connection in pairs(ModernUI.Connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif typeof(connection) == "Tween" then
            connection:Cancel()
        end
    end
    
    ModernUI.Connections = {}
    
    for _, window in pairs(ModernUI.Windows) do
        window:Destroy()
    end
end

return ModernUI
