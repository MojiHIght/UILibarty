-- Ultimate ProMax UI Library 💎
-- สำหรับ UNCs 99% Executor - จัดเต็มทุกลูกเล่น!
-- Created by: ProMax Team

local ProMaxUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

-- Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Mouse = Player:GetMouse()

-- High-End Executor Support
local GuiParent = gethui and gethui() or PlayerGui

-- Configuration
ProMaxUI.Config = {
    AnimationSpeed = 0.4,
    ParticleEffects = true,
    SoundEffects = true,
    BlurIntensity = 15,
    GlowIntensity = 20,
    RainbowSpeed = 2,
    SaveConfig = true
}

-- Advanced Themes with Gradients & Effects
ProMaxUI.Themes = {
    UltraNeon = {
        Name = "Ultra Neon",
        Primary = Color3.fromRGB(10, 10, 15),
        Secondary = Color3.fromRGB(15, 15, 25),
        Tertiary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(147, 51, 234),
        AccentHover = Color3.fromRGB(168, 85, 247),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(156, 163, 175),
        Border = Color3.fromRGB(75, 85, 99),
        Glow = Color3.fromRGB(147, 51, 234),
        Gradient1 = Color3.fromRGB(147, 51, 234),
        Gradient2 = Color3.fromRGB(79, 70, 229)
    },
    CyberPunk = {
        Name = "Cyber Punk",
        Primary = Color3.fromRGB(5, 8, 15),
        Secondary = Color3.fromRGB(10, 15, 25),
        Tertiary = Color3.fromRGB(15, 25, 35),
        Accent = Color3.fromRGB(0, 255, 157),
        AccentHover = Color3.fromRGB(34, 255, 178),
        Success = Color3.fromRGB(16, 185, 129),
        Warning = Color3.fromRGB(245, 158, 11),
        Error = Color3.fromRGB(220, 38, 127),
        Text = Color3.fromRGB(236, 254, 255),
        TextDim = Color3.fromRGB(94, 234, 212),
        Border = Color3.fromRGB(6, 182, 212),
        Glow = Color3.fromRGB(0, 255, 157),
        Gradient1 = Color3.fromRGB(0, 255, 157),
        Gradient2 = Color3.fromRGB(6, 182, 212)
    },
    DarkFuture = {
        Name = "Dark Future",
        Primary = Color3.fromRGB(7, 10, 15),
        Secondary = Color3.fromRGB(12, 15, 25),
        Tertiary = Color3.fromRGB(17, 25, 35),
        Accent = Color3.fromRGB(236, 72, 153),
        AccentHover = Color3.fromRGB(244, 114, 182),
        Success = Color3.fromRGB(52, 211, 153),
        Warning = Color3.fromRGB(251, 146, 60),
        Error = Color3.fromRGB(248, 113, 113),
        Text = Color3.fromRGB(248, 250, 252),
        TextDim = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(51, 65, 85),
        Glow = Color3.fromRGB(236, 72, 153),
        Gradient1 = Color3.fromRGB(236, 72, 153),
        Gradient2 = Color3.fromRGB(124, 58, 237)
    },
    GoldLux = {
        Name = "Gold Luxury",
        Primary = Color3.fromRGB(15, 12, 8),
        Secondary = Color3.fromRGB(25, 20, 15),
        Tertiary = Color3.fromRGB(35, 30, 22),
        Accent = Color3.fromRGB(251, 191, 36),
        AccentHover = Color3.fromRGB(252, 211, 77),
        Success = Color3.fromRGB(132, 204, 22),
        Warning = Color3.fromRGB(249, 115, 22),
        Error = Color3.fromRGB(239, 68, 68),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(212, 212, 212),
        Border = Color3.fromRGB(120, 113, 108),
        Glow = Color3.fromRGB(251, 191, 36),
        Gradient1 = Color3.fromRGB(251, 191, 36),
        Gradient2 = Color3.fromRGB(245, 158, 11)
    },
    Rainbow = {
        Name = "Rainbow Flow",
        Primary = Color3.fromRGB(8, 8, 12),
        Secondary = Color3.fromRGB(15, 15, 20),
        Tertiary = Color3.fromRGB(22, 22, 28),
        Accent = Color3.fromRGB(255, 0, 128), -- Will be animated
        AccentHover = Color3.fromRGB(255, 64, 150),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(170, 170, 170),
        Border = Color3.fromRGB(80, 80, 90),
        Glow = Color3.fromRGB(255, 0, 128),
        Gradient1 = Color3.fromRGB(255, 0, 128),
        Gradient2 = Color3.fromRGB(128, 0, 255),
        IsRainbow = true
    }
}

ProMaxUI.CurrentTheme = ProMaxUI.Themes.UltraNeon
ProMaxUI.Windows = {}
ProMaxUI.Notifications = {}

-- Advanced Sound System
local Sounds = {
    Click = "rbxassetid://421058925",
    Hover = "rbxassetid://421058925",
    Success = "rbxassetid://131961136",
    Error = "rbxassetid://131961136", 
    Notification = "rbxassetid://131961136",
    Whoosh = "rbxassetid://131961136"
}

-- Utility Functions
local function PlaySound(soundName, volume)
    if not ProMaxUI.Config.SoundEffects then return end
    
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = Sounds[soundName]
        sound.Volume = volume or 0.3
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
    stroke.Color = color or ProMaxUI.CurrentTheme.Border
    stroke.Transparency = transparency or 0.3
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

local function CreateGlow(parent, color, size, intensity)
    if not ProMaxUI.Config.ParticleEffects then return end
    
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Parent = parent
    glow.BackgroundTransparency = 1
    glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    glow.ImageColor3 = color or ProMaxUI.CurrentTheme.Glow
    glow.ImageTransparency = 0.7 - (intensity or 0.3)
    glow.Size = UDim2.new(1, size or 20, 1, size or 20)
    glow.Position = UDim2.new(0, -(size or 20)/2, 0, -(size or 20)/2)
    glow.ZIndex = (parent.ZIndex or 1) - 1
    
    CreateCorner(size or 20).Parent = glow
    
    -- Pulsing animation
    local pulse = TweenService:Create(glow,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {ImageTransparency = 0.9}
    )
    pulse:Play()
    
    return glow
end

local function CreateParticles(parent, color)
    if not ProMaxUI.Config.ParticleEffects then return end
    
    for i = 1, 3 do
        local particle = Instance.new("Frame")
        particle.Name = "Particle" .. i
        particle.Parent = parent
        particle.BackgroundColor3 = color or ProMaxUI.CurrentTheme.Accent
        particle.BorderSizePixel = 0
        particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
        particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        particle.BackgroundTransparency = 0.5
        particle.ZIndex = parent.ZIndex + 5
        
        CreateCorner(2).Parent = particle
        
        -- Floating animation
        local float = TweenService:Create(particle,
            TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {
                Position = UDim2.new(math.random(), 0, math.random(), 0),
                BackgroundTransparency = math.random(3, 8) / 10
            }
        )
        float:Play()
    end
end

local function CreateRipple(button, color)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            PlaySound("Click", 0.2)
            
            local ripple = Instance.new("Frame")
            ripple.Name = "Ripple"
            ripple.Parent = button
            ripple.BackgroundColor3 = color or ProMaxUI.CurrentTheme.Accent
            ripple.BackgroundTransparency = 0.7
            ripple.BorderSizePixel = 0
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            
            local mousePos = UserInputService:GetMouseLocation()
            local buttonPos = button.AbsolutePosition
            ripple.Position = UDim2.new(0, mousePos.X - buttonPos.X, 0, mousePos.Y - buttonPos.Y)
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.ZIndex = button.ZIndex + 10
            
            CreateCorner(200).Parent = ripple
            
            local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
            
            local expandTween = TweenService:Create(ripple,
                TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Size = UDim2.new(0, maxSize, 0, maxSize),
                    BackgroundTransparency = 1
                }
            )
            
            expandTween:Play()
            expandTween.Completed:Connect(function()
                ripple:Destroy()
            end)
        end
    end)
end

local function SmootTween(object, properties, duration, style, direction, callback)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or ProMaxUI.Config.AnimationSpeed,
            style or Enum.EasingStyle.Quart,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    
    tween:Play()
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    return tween
end

local function AnimateIn(object, style, delay)
    if delay then
        wait(delay)
    end
    
    if style == "Scale" then
        local originalSize = object.Size
        object.Size = UDim2.new(0, 0, 0, 0)
        object.AnchorPoint = Vector2.new(0.5, 0.5)
        
        SmootTween(object, {Size = originalSize}, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
    elseif style == "Slide" then
        local originalPos = object.Position
        object.Position = originalPos + UDim2.new(0, 300, 0, 0)
        
        SmootTween(object, {Position = originalPos}, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        
    elseif style == "Fade" then
        local originalTransparency = object.BackgroundTransparency
        object.BackgroundTransparency = 1
        
        SmootTween(object, {BackgroundTransparency = originalTransparency}, 0.4)
    end
end

-- Rainbow Animation System
local function StartRainbowAnimation(object, property)
    if not ProMaxUI.CurrentTheme.IsRainbow then return end
    
    local hue = 0
    local connection
    
    connection = RunService.Heartbeat:Connect(function()
        hue = hue + (ProMaxUI.Config.RainbowSpeed / 100)
        if hue >= 1 then hue = 0 end
        
        local color = Color3.fromHSV(hue, 1, 1)
        object[property] = color
        
        if not object.Parent then
            connection:Disconnect()
        end
    end)
    
    return connection
end

-- Advanced Blur Effect
local function CreateBlur()
    local blur = Instance.new("BlurEffect")
    blur.Parent = Lighting
    blur.Size = 0
    
    SmootTween(blur, {Size = ProMaxUI.Config.BlurIntensity}, 0.5)
    
    return blur
end

-- Window Creation Function
function ProMaxUI:CreateWindow(config)
    config = config or {}
    
    local windowConfig = {
        Title = config.Title or "ProMax Ultimate",
        Subtitle = config.Subtitle or "v3.0 Premium",
        Size = config.Size or UDim2.new(0, 650, 0, 500),
        Theme = config.Theme or "UltraNeon",
        SaveConfig = config.SaveConfig ~= false,
        ConfigFolder = config.ConfigFolder or "ProMaxUI",
        KeyBind = config.KeyBind or Enum.KeyCode.Insert,
        Draggable = config.Draggable ~= false,
        Resizable = config.Resizable or false,
        MinSize = config.MinSize or UDim2.new(0, 400, 0, 300),
        FadeTime = config.FadeTime or 0.5
    }
    
    -- Set Theme
    if ProMaxUI.Themes[windowConfig.Theme] then
        ProMaxUI.CurrentTheme = ProMaxUI.Themes[windowConfig.Theme]
    end
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = HttpService:GenerateGUID(false):sub(1, 8) .. "_ProMax"
    ScreenGui.Parent = GuiParent
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    
    -- Background Blur
    local BlurEffect = CreateBlur()
    
    -- Main Container
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = ScreenGui
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0.5, -windowConfig.Size.X.Offset/2, 0.5, -windowConfig.Size.Y.Offset/2)
    Container.Size = windowConfig.Size
    Container.Active = true
    Container.ZIndex = 1
    
    -- Main Background with Advanced Styling
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Container
    MainFrame.BackgroundColor3 = ProMaxUI.CurrentTheme.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 2
    
    CreateCorner(15).Parent = MainFrame
    CreateStroke(2, ProMaxUI.CurrentTheme.Border, 0.2).Parent = MainFrame
    
    -- Advanced Background Gradient
    local bgGradient = CreateGradient(
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, ProMaxUI.CurrentTheme.Primary),
            ColorSequenceKeypoint.new(0.3, ProMaxUI.CurrentTheme.Secondary),
            ColorSequenceKeypoint.new(0.7, ProMaxUI.CurrentTheme.Secondary),
            ColorSequenceKeypoint.new(1, ProMaxUI.CurrentTheme.Primary)
        },
        45
    )
    bgGradient.Parent = MainFrame
    
    -- Glow Effects
    CreateGlow(MainFrame, ProMaxUI.CurrentTheme.Glow, 40, 0.4)
    
    -- Particles
    CreateParticles(MainFrame, ProMaxUI.CurrentTheme.Accent)
    
    -- Animated Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.ZIndex = 3
    
    CreateCorner(15).Parent = TitleBar
    CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.4).Parent = TitleBar
    
    -- Title Bar Gradient
    local titleGradient = CreateGradient(
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, ProMaxUI.CurrentTheme.Gradient1),
            ColorSequenceKeypoint.new(1, ProMaxUI.CurrentTheme.Gradient2)
        },
        90,
        NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.8),
            NumberSequenceKeypoint.new(1, 0.9)
        }
    )
    titleGradient.Parent = TitleBar
    
    -- Animated Logo/Icon
    local LogoFrame = Instance.new("Frame")
    LogoFrame.Name = "Logo"
    LogoFrame.Parent = TitleBar
    LogoFrame.BackgroundColor3 = ProMaxUI.CurrentTheme.Accent
    LogoFrame.BorderSizePixel = 0
    LogoFrame.Position = UDim2.new(0, 15, 0.5, -12)
    LogoFrame.Size = UDim2.new(0, 24, 0, 24)
    LogoFrame.ZIndex = 4
    
    CreateCorner(6).Parent = LogoFrame
    CreateGlow(LogoFrame, ProMaxUI.CurrentTheme.Accent, 15, 0.5)
    
    -- Rainbow animation for logo if theme is rainbow
    if ProMaxUI.CurrentTheme.IsRainbow then
        StartRainbowAnimation(LogoFrame, "BackgroundColor3")
    end
    
    -- Spinning animation for logo
    local logoSpin = TweenService:Create(LogoFrame,
        TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = 360}
    )
    logoSpin:Play()
    
    -- Title Text with Glow
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 50, 0, 5)
    TitleLabel.Size = UDim2.new(0, 300, 0, 25)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = windowConfig.Title
    TitleLabel.TextColor3 = ProMaxUI.CurrentTheme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 4
    
    CreateStroke(2, ProMaxUI.CurrentTheme.Glow, 0.8).Parent = TitleLabel
    
    -- Subtitle
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Parent = TitleBar
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Position = UDim2.new(0, 50, 0, 25)
    SubtitleLabel.Size = UDim2.new(0, 300, 0, 20)
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.Text = windowConfig.Subtitle
    SubtitleLabel.TextColor3 = ProMaxUI.CurrentTheme.TextDim
    SubtitleLabel.TextSize = 12
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.ZIndex = 4
    
    -- Control Buttons Container
    local ControlsFrame = Instance.new("Frame")
    ControlsFrame.Name = "Controls"
    ControlsFrame.Parent = TitleBar
    ControlsFrame.BackgroundTransparency = 1
    ControlsFrame.Position = UDim2.new(1, -120, 0, 10)
    ControlsFrame.Size = UDim2.new(0, 110, 0, 30)
    ControlsFrame.ZIndex = 4
    
    -- Settings Button
    local SettingsBtn = Instance.new("TextButton")
    SettingsBtn.Name = "Settings"
    SettingsBtn.Parent = ControlsFrame
    SettingsBtn.BackgroundColor3 = ProMaxUI.CurrentTheme.Accent
    SettingsBtn.BorderSizePixel = 0
    SettingsBtn.Position = UDim2.new(0, 0, 0, 0)
    SettingsBtn.Size = UDim2.new(0, 30, 0, 30)
    SettingsBtn.Font = Enum.Font.GothamBold
    SettingsBtn.Text = "⚙"
    SettingsBtn.TextColor3 = ProMaxUI.CurrentTheme.Text
    SettingsBtn.TextSize = 14
    SettingsBtn.ZIndex = 5
    
    CreateCorner(8).Parent = SettingsBtn
    CreateRipple(SettingsBtn)
    CreateGlow(SettingsBtn, ProMaxUI.CurrentTheme.Accent, 12)
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "Minimize"
    MinimizeBtn.Parent = ControlsFrame
    MinimizeBtn.BackgroundColor3 = ProMaxUI.CurrentTheme.Warning
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Position = UDim2.new(0, 40, 0, 0)
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "─"
    MinimizeBtn.TextColor3 = ProMaxUI.CurrentTheme.Text
    MinimizeBtn.TextSize = 14
    MinimizeBtn.ZIndex = 5
    
    CreateCorner(8).Parent = MinimizeBtn
    CreateRipple(MinimizeBtn, ProMaxUI.CurrentTheme.Warning)
    CreateGlow(MinimizeBtn, ProMaxUI.CurrentTheme.Warning, 12)
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Parent = ControlsFrame
    CloseBtn.BackgroundColor3 = ProMaxUI.CurrentTheme.Error
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(0, 80, 0, 0)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = ProMaxUI.CurrentTheme.Text
    CloseBtn.TextSize = 14
    CloseBtn.ZIndex = 5
    
    CreateCorner(8).Parent = CloseBtn
    CreateRipple(CloseBtn, ProMaxUI.CurrentTheme.Error)
    CreateGlow(CloseBtn, ProMaxUI.CurrentTheme.Error, 12)
    
    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 50)
    ContentFrame.Size = UDim2.new(1, 0, 1, -50)
    ContentFrame.ZIndex = 3
    
    -- Advanced Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = ContentFrame
    Sidebar.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.ZIndex = 4
    
    CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.4).Parent = Sidebar
    
    -- Sidebar Gradient
    local sidebarGradient = CreateGradient(
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, ProMaxUI.CurrentTheme.Secondary),
            ColorSequenceKeypoint.new(1, ProMaxUI.CurrentTheme.Tertiary)
        },
        180
    )
    sidebarGradient.Parent = Sidebar
    
    -- Tab Container with Smooth Scrolling
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 10)
    TabContainer.Size = UDim2.new(1, -20, 1, -20)
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = ProMaxUI.CurrentTheme.Accent
    TabContainer.ScrollBarImageTransparency = 0.3
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    TabContainer.ZIndex = 5
    
    -- Main Content Area
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.Parent = ContentFrame
    MainContent.BackgroundTransparency = 1
    MainContent.Position = UDim2.new(0, 160, 0, 0)
    MainContent.Size = UDim2.new(1, -160, 1, 0)
    MainContent.ZIndex = 4
    
    -- Status Bar
    local StatusBar = Instance.new("Frame")
    StatusBar.Name = "StatusBar"
    StatusBar.Parent = MainFrame
    StatusBar.BackgroundColor3 = ProMaxUI.CurrentTheme.Tertiary
    StatusBar.BorderSizePixel = 0
    StatusBar.Position = UDim2.new(0, 0, 1, -25)
    StatusBar.Size = UDim2.new(1, 0, 0, 25)
    StatusBar.ZIndex = 3
    
    CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.6).Parent = StatusBar
    
    -- Status Text
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "Status"
    StatusLabel.Parent = StatusBar
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 10, 0, 0)
    StatusLabel.Size = UDim2.new(0.5, 0, 1, 0)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = "Ready • Theme: " .. ProMaxUI.CurrentTheme.Name
    StatusLabel.TextColor3 = ProMaxUI.CurrentTheme.TextDim
    StatusLabel.TextSize = 10
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.ZIndex = 4
    
    -- FPS Counter
    local FPSLabel = Instance.new("TextLabel")
    FPSLabel.Name = "FPS"
    FPSLabel.Parent = StatusBar
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Position = UDim2.new(1, -100, 0, 0)
    FPSLabel.Size = UDim2.new(0, 90, 1, 0)
    FPSLabel.Font = Enum.Font.GothamBold
    FPSLabel.Text = "FPS: 60"
    FPSLabel.TextColor3 = ProMaxUI.CurrentTheme.Success
    FPSLabel.TextSize = 10
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Right
    FPSLabel.ZIndex = 4
    
    -- FPS Counter Logic
    local fps = 0
    local lastUpdate = tick()
    RunService.Heartbeat:Connect(function()
        fps = fps + 1
        if tick() - lastUpdate >= 1 then
            FPSLabel.Text = "FPS: " .. fps
            FPSLabel.TextColor3 = fps >= 50 and ProMaxUI.CurrentTheme.Success or 
                                  fps >= 30 and ProMaxUI.CurrentTheme.Warning or 
                                  ProMaxUI.CurrentTheme.Error
            fps = 0
            lastUpdate = tick()
        end
    end)
    
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
        StatusBar = StatusBar,
        StatusLabel = StatusLabel,
        BlurEffect = BlurEffect,
        Config = windowConfig,
        Tabs = {},
        CurrentTab = nil,
        Visible = true,
        Minimized = false,
        TabCount = 0
    }
    
    -- Window Methods
    function WindowObject:SetStatus(text, color)
        self.StatusLabel.Text = text
        if color then
            self.StatusLabel.TextColor3 = color
        end
    end
    
    function WindowObject:Toggle()
        self.Visible = not self.Visible
        
        if self.Visible then
            self.ScreenGui.Enabled = true
            AnimateIn(self.MainFrame, "Scale")
            SmootTween(self.BlurEffect, {Size = ProMaxUI.Config.BlurIntensity})
            PlaySound("Whoosh", 0.4)
        else
            SmootTween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
            SmootTween(self.BlurEffect, {Size = 0}, 0.3, nil, nil, function()
                self.ScreenGui.Enabled = false
            end)
        end
    end
    
    function WindowObject:Minimize()
        self.Minimized = not self.Minimized
        PlaySound("Click", 0.3)
        
        local targetSize = self.Minimized and UDim2.new(0, windowConfig.Size.X.Offset, 0, 50) or windowConfig.Size
        
        SmootTween(self.Container, {Size = targetSize}, 0.4, Enum.EasingStyle.Back)
        
        self.ContentFrame.Visible = not self.Minimized
        self.StatusBar.Visible = not self.Minimized
        
        self:SetStatus(self.Minimized and "Minimized" or "Ready • Theme: " .. ProMaxUI.CurrentTheme.Name)
    end
    
    function WindowObject:Destroy()
        PlaySound("Whoosh", 0.3)
        
        SmootTween(self.MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }, 0.4)
        
        SmootTween(self.BlurEffect, {Size = 0}, 0.4, nil, nil, function()
            self.ScreenGui:Destroy()
            self.BlurEffect:Destroy()
        end)
    end
    
    function WindowObject:CreateTab(config)
        config = config or {}
        local tabConfig = {
            Name = config.Name or "Tab",
            Icon = config.Icon or "📁",
            Color = config.Color or ProMaxUI.CurrentTheme.Accent,
            Visible = config.Visible ~= false
        }
        
        self.TabCount = self.TabCount + 1
        local tabIndex = self.TabCount
        
        -- Tab Button with Advanced Styling
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "Tab_" .. tabConfig.Name
        TabButton.Parent = self.TabContainer
        TabButton.BackgroundColor3 = ProMaxUI.CurrentTheme.Tertiary
        TabButton.BorderSizePixel = 0
        TabButton.Position = UDim2.new(0, 0, 0, (tabIndex - 1) * 50)
        TabButton.Size = UDim2.new(1, 0, 0, 45)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = ""
        TabButton.TextColor3 = ProMaxUI.CurrentTheme.TextDim
        TabButton.TextSize = 13
        TabButton.ZIndex = 6
        
        CreateCorner(8).Parent = TabButton
        CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.6).Parent = TabButton
        
        -- Tab Icon
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Name = "Icon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 15, 0, 0)
        TabIcon.Size = UDim2.new(0, 30, 1, 0)
        TabIcon.Font = Enum.Font.GothamBold
        TabIcon.Text = tabConfig.Icon
        TabIcon.TextColor3 = ProMaxUI.CurrentTheme.TextDim
        TabIcon.TextSize = 16
        TabIcon.TextXAlignment = Enum.TextXAlignment.Center
        TabIcon.ZIndex = 7
        
        -- Tab Text
        local TabText = Instance.new("TextLabel")
        TabText.Name = "Text"
        TabText.Parent = TabButton
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, 45, 0, 0)
        TabText.Size = UDim2.new(1, -50, 1, 0)
        TabText.Font = Enum.Font.GothamSemibold
        TabText.Text = tabConfig.Name
        TabText.TextColor3 = ProMaxUI.CurrentTheme.TextDim
        TabText.TextSize = 12
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.ZIndex = 7
        
        -- Tab Indicator
        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Parent = TabButton
        TabIndicator.BackgroundColor3 = tabConfig.Color
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Position = UDim2.new(0, 0, 0, 0)
        TabIndicator.Size = UDim2.new(0, 0, 1, 0)
        TabIndicator.ZIndex = 6
        
        CreateCorner(8).Parent = TabIndicator
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. tabConfig.Name
        TabContent.Parent = self.MainContent
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, 15, 0, 15)
        TabContent.Size = UDim2.new(1, -30, 1, -30)
        TabContent.ScrollBarThickness = 6
        TabContent.ScrollBarImageColor3 = ProMaxUI.CurrentTheme.Accent
        TabContent.ScrollBarImageTransparency = 0.4
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.ZIndex = 5
        
        -- Tab Object
        local TabObject = {
            Button = TabButton,
            Content = TabContent,
            Icon = TabIcon,
            Text = TabText,
            Indicator = TabIndicator,
            Config = tabConfig,
            Active = false,
            Elements = {},
            ElementCount = 0
        }
        
        function TabObject:Activate()
            if self.Active then return end
            
            PlaySound("Click", 0.2)
            
            -- Deactivate other tabs
            for _, tab in pairs(WindowObject.Tabs) do
                if tab.Active then
                    tab:Deactivate()
                end
            end
            
            self.Active = true
            WindowObject.CurrentTab = self
            
            -- Visual Updates with Smooth Animations
            SmootTween(self.Button, {BackgroundColor3 = tabConfig.Color}, 0.3)
            SmootTween(self.Icon, {TextColor3 = ProMaxUI.CurrentTheme.Text}, 0.3)
            SmootTween(self.Text, {TextColor3 = ProMaxUI.CurrentTheme.Text}, 0.3)
            SmootTween(self.Indicator, {Size = UDim2.new(0, 4, 1, 0)}, 0.4, Enum.EasingStyle.Back)
            
            -- Show content with animation
            self.Content.Visible = true
            AnimateIn(self.Content, "Fade")
            
            -- Add glow effect
            CreateGlow(self.Button, tabConfig.Color, 15, 0.3)
            
            WindowObject:SetStatus("Active: " .. tabConfig.Name, tabConfig.Color)
        end
        
        function TabObject:Deactivate()
            self.Active = false
            
            SmootTween(self.Button, {BackgroundColor3 = ProMaxUI.CurrentTheme.Tertiary}, 0.3)
            SmootTween(self.Icon, {TextColor3 = ProMaxUI.CurrentTheme.TextDim}, 0.3)
            SmootTween(self.Text, {TextColor3 = ProMaxUI.CurrentTheme.TextDim}, 0.3)
            SmootTween(self.Indicator, {Size = UDim2.new(0, 0, 1, 0)}, 0.3)
            
            self.Content.Visible = false
        end
        
        function TabObject:CreateButton(config)
            config = config or {}
            local buttonConfig = {
                Name = config.Name or "Button",
                Description = config.Description or "",
                Callback = config.Callback or function() end,
                Color = config.Color or ProMaxUI.CurrentTheme.Accent
            }
            
            local yPos = self.ElementCount * 70
            self.ElementCount = self.ElementCount + 1
            
            -- Button Container
            local ButtonContainer = Instance.new("Frame")
            ButtonContainer.Name = "ButtonContainer_" .. buttonConfig.Name
            ButtonContainer.Parent = self.Content
            ButtonContainer.BackgroundTransparency = 1
            ButtonContainer.Position = UDim2.new(0, 0, 0, yPos)
            ButtonContainer.Size = UDim2.new(1, 0, 0, 60)
            ButtonContainer.ZIndex = 6
            
            -- Main Button
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = ButtonContainer
            Button.BackgroundColor3 = buttonConfig.Color
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(0, 0, 0, 0)
            Button.Size = UDim2.new(1, 0, 1, -10)
            Button.Font = Enum.Font.GothamBold
            Button.Text = ""
            Button.TextColor3 = ProMaxUI.CurrentTheme.Text
            Button.TextSize = 14
            Button.ZIndex = 7
            
            CreateCorner(10).Parent = Button
            CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.4).Parent = Button
            CreateRipple(Button, buttonConfig.Color)
            CreateGlow(Button, buttonConfig.Color, 12, 0.2)
            
            -- Button Gradient
            local buttonGradient = CreateGradient(
                ColorSequence.new{
                    ColorSequenceKeypoint.new(0, buttonConfig.Color),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(
                        math.max(0, buttonConfig.Color.R * 255 - 20),
                        math.max(0, buttonConfig.Color.G * 255 - 20),
                        math.max(0, buttonConfig.Color.B * 255 - 20)
                    ))
                },
                90
            )
            buttonGradient.Parent = Button
            
            -- Button Icon
            local ButtonIcon = Instance.new("TextLabel")
            ButtonIcon.Name = "Icon"
            ButtonIcon.Parent = Button
            ButtonIcon.BackgroundTransparency = 1
            ButtonIcon.Position = UDim2.new(0, 15, 0, 0)
            ButtonIcon.Size = UDim2.new(0, 40, 1, 0)
            ButtonIcon.Font = Enum.Font.GothamBold
            ButtonIcon.Text = "🚀"
            ButtonIcon.TextColor3 = ProMaxUI.CurrentTheme.Text
            ButtonIcon.TextSize = 18
            ButtonIcon.TextXAlignment = Enum.TextXAlignment.Center
            ButtonIcon.ZIndex = 8
            
            -- Button Text
            local ButtonText = Instance.new("TextLabel")
            ButtonText.Name = "Text"
            ButtonText.Parent = Button
            ButtonText.BackgroundTransparency = 1
            ButtonText.Position = UDim2.new(0, 55, 0, 5)
            ButtonText.Size = UDim2.new(1, -60, 0, 25)
            ButtonText.Font = Enum.Font.GothamBold
            ButtonText.Text = buttonConfig.Name
            ButtonText.TextColor3 = ProMaxUI.CurrentTheme.Text
            ButtonText.TextSize = 14
            ButtonText.TextXAlignment = Enum.TextXAlignment.Left
            ButtonText.ZIndex = 8
            
            -- Button Description
            local ButtonDesc = Instance.new("TextLabel")
            ButtonDesc.Name = "Description"
            ButtonDesc.Parent = Button
            ButtonDesc.BackgroundTransparency = 1
            ButtonDesc.Position = UDim2.new(0, 55, 0, 25)
            ButtonDesc.Size = UDim2.new(1, -60, 0, 20)
            ButtonDesc.Font = Enum.Font.Gotham
            ButtonDesc.Text = buttonConfig.Description
            ButtonDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
            ButtonDesc.TextSize = 11
            ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
            ButtonDesc.ZIndex = 8
            
            -- Hover Effects
            Button.MouseEnter:Connect(function()
                PlaySound("Hover", 0.1)
                SmootTween(Button, {
                    Size = UDim2.new(1, 0, 1, -5),
                    BackgroundColor3 = Color3.fromRGB(
                        math.min(255, buttonConfig.Color.R * 255 + 20),
                        math.min(255, buttonConfig.Color.G * 255 + 20),
                        math.min(255, buttonConfig.Color.B * 255 + 20)
                    )
                }, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                SmootTween(Button, {
                    Size = UDim2.new(1, 0, 1, -10),
                    BackgroundColor3 = buttonConfig.Color
                }, 0.2)
            end)
            
            -- Click Event
            Button.MouseButton1Click:Connect(function()
                PlaySound("Click", 0.3)
                
                -- Click animation
                SmootTween(Button, {Size = UDim2.new(1, 0, 1, -15)}, 0.1, nil, nil, function()
                    SmootTween(Button, {Size = UDim2.new(1, 0, 1, -10)}, 0.1)
                end)
                
                -- Execute callback
                local success, err = pcall(buttonConfig.Callback)
                if not success then
                    ProMaxUI:Notify({
                        Title = "Error",
                        Description = "Button callback failed: " .. tostring(err),
                        Type = "Error"
                    })
                end
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
            
            -- Toggle Container
            local ToggleContainer = Instance.new("Frame")
            ToggleContainer.Name = "ToggleContainer_" .. toggleConfig.Name
            ToggleContainer.Parent = self.Content
            ToggleContainer.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
            ToggleContainer.BorderSizePixel = 0
            ToggleContainer.Position = UDim2.new(0, 0, 0, yPos)
            ToggleContainer.Size = UDim2.new(1, 0, 0, 60)
            ToggleContainer.ZIndex = 6
            
            CreateCorner(10).Parent = ToggleContainer
            CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.4).Parent = ToggleContainer
            
            -- Container Gradient
            local containerGradient = CreateGradient(
                ColorSequence.new{
                    ColorSequenceKeypoint.new(0, ProMaxUI.CurrentTheme.Secondary),
                    ColorSequenceKeypoint.new(1, ProMaxUI.CurrentTheme.Tertiary)
                },
                45
            )
            containerGradient.Parent = ToggleContainer
            
            -- Toggle Icon
            local ToggleIcon = Instance.new("TextLabel")
            ToggleIcon.Name = "Icon"
            ToggleIcon.Parent = ToggleContainer
            ToggleIcon.BackgroundTransparency = 1
            ToggleIcon.Position = UDim2.new(0, 15, 0, 0)
            ToggleIcon.Size = UDim2.new(0, 40, 1, 0)
            ToggleIcon.Font = Enum.Font.GothamBold
            ToggleIcon.Text = "🔘"
            ToggleIcon.TextColor3 = ProMaxUI.CurrentTheme.TextDim
            ToggleIcon.TextSize = 16
            ToggleIcon.TextXAlignment = Enum.TextXAlignment.Center
            ToggleIcon.ZIndex = 7
            
            -- Toggle Name
            local ToggleName = Instance.new("TextLabel")
            ToggleName.Name = "Name"
            ToggleName.Parent = ToggleContainer
            ToggleName.BackgroundTransparency = 1
            ToggleName.Position = UDim2.new(0, 55, 0, 8)
            ToggleName.Size = UDim2.new(0.6, 0, 0, 20)
            ToggleName.Font = Enum.Font.GothamBold
            ToggleName.Text = toggleConfig.Name
            ToggleName.TextColor3 = ProMaxUI.CurrentTheme.Text
            ToggleName.TextSize = 14
            ToggleName.TextXAlignment = Enum.TextXAlignment.Left
            ToggleName.ZIndex = 7
            
            -- Toggle Description
            local ToggleDesc = Instance.new("TextLabel")
            ToggleDesc.Name = "Description"
            ToggleDesc.Parent = ToggleContainer
            ToggleDesc.BackgroundTransparency = 1
            ToggleDesc.Position = UDim2.new(0, 55, 0, 28)
            ToggleDesc.Size = UDim2.new(0.6, 0, 0, 20)
            ToggleDesc.Font = Enum.Font.Gotham
            ToggleDesc.Text = toggleConfig.Description
            ToggleDesc.TextColor3 = ProMaxUI.CurrentTheme.TextDim
            ToggleDesc.TextSize = 11
            ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
            ToggleDesc.ZIndex = 7
            
            -- Toggle Switch Background
            local ToggleSwitchBG = Instance.new("Frame")
            ToggleSwitchBG.Name = "SwitchBG"
            ToggleSwitchBG.Parent = ToggleContainer
            ToggleSwitchBG.BackgroundColor3 = toggleConfig.Default and ProMaxUI.CurrentTheme.Success or ProMaxUI.CurrentTheme.Tertiary
            ToggleSwitchBG.BorderSizePixel = 0
            ToggleSwitchBG.Position = UDim2.new(1, -70, 0.5, -15)
            ToggleSwitchBG.Size = UDim2.new(0, 60, 0, 30)
            ToggleSwitchBG.ZIndex = 7
            
            CreateCorner(15).Parent = ToggleSwitchBG
            CreateGlow(ToggleSwitchBG, toggleConfig.Default and ProMaxUI.CurrentTheme.Success or ProMaxUI.CurrentTheme.Tertiary, 8)
            
            -- Toggle Switch Button
            local ToggleSwitchBtn = Instance.new("TextButton")
            ToggleSwitchBtn.Name = "SwitchBtn"
            ToggleSwitchBtn.Parent = ToggleSwitchBG
            ToggleSwitchBtn.BackgroundColor3 = ProMaxUI.CurrentTheme.Text
            ToggleSwitchBtn.BorderSizePixel = 0
            ToggleSwitchBtn.Position = UDim2.new(0, toggleConfig.Default and 32 or 4, 0, 4)
            ToggleSwitchBtn.Size = UDim2.new(0, 22, 0, 22)
            ToggleSwitchBtn.Text = ""
            ToggleSwitchBtn.ZIndex = 8
            
            CreateCorner(11).Parent = ToggleSwitchBtn
            CreateGlow(ToggleSwitchBtn, ProMaxUI.CurrentTheme.Text, 6)
            
            local isToggled = toggleConfig.Default
            
            -- Toggle Function
            local function Toggle()
                isToggled = not isToggled
                
                PlaySound("Click", 0.2)
                
                -- Animate switch
                SmootTween(ToggleSwitchBtn, {
                    Position = UDim2.new(0, isToggled and 32 or 4, 0, 4)
                }, 0.3, Enum.EasingStyle.Back)
                
                SmootTween(ToggleSwitchBG, {
                    BackgroundColor3 = isToggled and ProMaxUI.CurrentTheme.Success or ProMaxUI.CurrentTheme.Tertiary
                }, 0.3)
                
                SmootTween(ToggleIcon, {
                    TextColor3 = isToggled and ProMaxUI.CurrentTheme.Success or ProMaxUI.CurrentTheme.TextDim
                }, 0.3)
                
                -- Update glow
                ToggleSwitchBG:FindFirstChild("Glow"):Destroy()
                CreateGlow(ToggleSwitchBG, isToggled and ProMaxUI.CurrentTheme.Success or ProMaxUI.CurrentTheme.Tertiary, 8)
                
                -- Execute callback
                local success, err = pcall(toggleConfig.Callback, isToggled)
                if not success then
                    ProMaxUI:Notify({
                        Title = "Error",
                        Description = "Toggle callback failed: " .. tostring(err),
                        Type = "Error"
                    })
                end
            end
            
            -- Click events
            ToggleSwitchBtn.MouseButton1Click:Connect(Toggle)
            ToggleContainer.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Toggle()
                end
            end)
            
            -- Hover effects
            ToggleContainer.MouseEnter:Connect(function()
                PlaySound("Hover", 0.05)
                SmootTween(ToggleContainer, {BackgroundColor3 = Color3.fromRGB(
                    math.min(255, ProMaxUI.CurrentTheme.Secondary.R * 255 + 10),
                    math.min(255, ProMaxUI.CurrentTheme.Secondary.G * 255 + 10),
                    math.min(255, ProMaxUI.CurrentTheme.Secondary.B * 255 + 10)
                )}, 0.2)
            end)
            
            ToggleContainer.MouseLeave:Connect(function()
                SmootTween(ToggleContainer, {BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary}, 0.2)
            end)
            
            self:UpdateCanvasSize()
            return ToggleContainer
        end
        
        function TabObject:CreateSlider(config)
            config = config or {}
            local sliderConfig = {
                Name = config.Name or "Slider",
                Description = config.Description or "",
                Min = config.Min or 0,
                Max = config.Max or 100,
                Default = config.Default or 50,
                Increment = config.Increment or 1,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 80
            self.ElementCount = self.ElementCount + 1
            
            -- Slider Container
            local SliderContainer = Instance.new("Frame")
            SliderContainer.Name = "SliderContainer_" .. sliderConfig.Name
            SliderContainer.Parent = self.Content
            SliderContainer.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
            SliderContainer.BorderSizePixel = 0
            SliderContainer.Position = UDim2.new(0, 0, 0, yPos)
            SliderContainer.Size = UDim2.new(1, 0, 0, 70)
            SliderContainer.ZIndex = 6
            
            CreateCorner(10).Parent = SliderContainer
            CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.4).Parent = SliderContainer
            
            -- Container Gradient
            local containerGradient = CreateGradient(
                ColorSequence.new{
                    ColorSequenceKeypoint.new(0, ProMaxUI.CurrentTheme.Secondary),
                    ColorSequenceKeypoint.new(1, ProMaxUI.CurrentTheme.Tertiary)
                },
                45
            )
            containerGradient.Parent = SliderContainer
            
            -- Slider Icon
            local SliderIcon = Instance.new("TextLabel")
            SliderIcon.Name = "Icon"
            SliderIcon.Parent = SliderContainer
            SliderIcon.BackgroundTransparency = 1
            SliderIcon.Position = UDim2.new(0, 15, 0, 5)
            SliderIcon.Size = UDim2.new(0, 30, 0, 25)
            SliderIcon.Font = Enum.Font.GothamBold
            SliderIcon.Text = "🎚"
            SliderIcon.TextColor3 = ProMaxUI.CurrentTheme.Accent
            SliderIcon.TextSize = 16
            SliderIcon.TextXAlignment = Enum.TextXAlignment.Center
            SliderIcon.ZIndex = 7
            
            -- Slider Name
            local SliderName = Instance.new("TextLabel")
            SliderName.Name = "Name"
            SliderName.Parent = SliderContainer
            SliderName.BackgroundTransparency = 1
            SliderName.Position = UDim2.new(0, 50, 0, 5)
            SliderName.Size = UDim2.new(0.5, 0, 0, 20)
            SliderName.Font = Enum.Font.GothamBold
            SliderName.Text = sliderConfig.Name
            SliderName.TextColor3 = ProMaxUI.CurrentTheme.Text
            SliderName.TextSize = 14
            SliderName.TextXAlignment = Enum.TextXAlignment.Left
            SliderName.ZIndex = 7
            
            -- Value Display
            local ValueDisplay = Instance.new("TextLabel")
            ValueDisplay.Name = "Value"
            ValueDisplay.Parent = SliderContainer
            ValueDisplay.BackgroundColor3 = ProMaxUI.CurrentTheme.Accent
            ValueDisplay.BorderSizePixel = 0
            ValueDisplay.Position = UDim2.new(1, -70, 0, 8)
            ValueDisplay.Size = UDim2.new(0, 60, 0, 20)
            ValueDisplay.Font = Enum.Font.GothamBold
            ValueDisplay.Text = tostring(sliderConfig.Default)
            ValueDisplay.TextColor3 = ProMaxUI.CurrentTheme.Text
            ValueDisplay.TextSize = 12
            ValueDisplay.TextXAlignment = Enum.TextXAlignment.Center
            ValueDisplay.ZIndex = 7
            
            CreateCorner(10).Parent = ValueDisplay
            CreateGlow(ValueDisplay, ProMaxUI.CurrentTheme.Accent, 8)
            
            -- Slider Track
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "Track"
            SliderTrack.Parent = SliderContainer
            SliderTrack.BackgroundColor3 = ProMaxUI.CurrentTheme.Tertiary
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Position = UDim2.new(0, 15, 0, 45)
            SliderTrack.Size = UDim2.new(1, -30, 0, 8)
            SliderTrack.ZIndex = 7
            
            CreateCorner(4).Parent = SliderTrack
            
            -- Slider Fill
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.Parent = SliderTrack
            SliderFill.BackgroundColor3 = ProMaxUI.CurrentTheme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
            SliderFill.ZIndex = 8
            
            CreateCorner(4).Parent = SliderFill
            CreateGlow(SliderFill, ProMaxUI.CurrentTheme.Accent, 6)
            
            -- Slider Fill Gradient
            local fillGradient = CreateGradient(
                ColorSequence.new{
                    ColorSequenceKeypoint.new(0, ProMaxUI.CurrentTheme.Accent),
                    ColorSequenceKeypoint.new(1, ProMaxUI.CurrentTheme.Gradient2)
                },
                0
            )
            fillGradient.Parent = SliderFill
            
            -- Slider Knob
            local SliderKnob = Instance.new("Frame")
            SliderKnob.Name = "Knob"
            SliderKnob.Parent = SliderTrack
            SliderKnob.BackgroundColor3 = ProMaxUI.CurrentTheme.Text
            SliderKnob.BorderSizePixel = 0
            SliderKnob.Position = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), -8, 0.5, -8)
            SliderKnob.Size = UDim2.new(0, 16, 0, 16)
            SliderKnob.ZIndex = 9
            
            CreateCorner(8).Parent = SliderKnob
            CreateGlow(SliderKnob, ProMaxUI.CurrentTheme.Text, 8)
            CreateStroke(2, ProMaxUI.CurrentTheme.Accent, 0).Parent = SliderKnob
            
            local currentValue = sliderConfig.Default
            local isDragging = false
            
            -- Update function
            local function UpdateSlider(input)
                local trackPos = SliderTrack.AbsolutePosition.X
                local trackSize = SliderTrack.AbsoluteSize.X
                local mousePos = input.Position.X
                
                local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                local rawValue = sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percent
                currentValue = math.floor(rawValue / sliderConfig.Increment) * sliderConfig.Increment
                currentValue = math.clamp(currentValue, sliderConfig.Min, sliderConfig.Max)
                
                local finalPercent = (currentValue - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                
                -- Smooth animations
                SmootTween(SliderFill, {Size = UDim2.new(finalPercent, 0, 1, 0)}, 0.1)
                SmootTween(SliderKnob, {Position = UDim2.new(finalPercent, -8, 0.5, -8)}, 0.1)
                
                -- Update value display
                ValueDisplay.Text = tostring(currentValue)
                
                -- Execute callback
                local success, err = pcall(sliderConfig.Callback, currentValue)
                if not success then
                    ProMaxUI:Notify({
                        Title = "Error",
                        Description = "Slider callback failed: " .. tostring(err),
                        Type = "Error"
                    })
                end
            end
            
            -- Input handling
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    PlaySound("Click", 0.15)
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)
            
            self:UpdateCanvasSize()
            return SliderContainer
        end
        
        function TabObject:CreateDropdown(config)
            config = config or {}
            local dropdownConfig = {
                Name = config.Name or "Dropdown",
                Description = config.Description or "",
                Options = config.Options or {"Option 1", "Option 2", "Option 3"},
                Default = config.Default or config.Options[1],
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 70
            self.ElementCount = self.ElementCount + 1
            
            -- Dropdown Container
            local DropdownContainer = Instance.new("Frame")
            DropdownContainer.Name = "DropdownContainer_" .. dropdownConfig.Name
            DropdownContainer.Parent = self.Content
            DropdownContainer.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
            DropdownContainer.BorderSizePixel = 0
            DropdownContainer.Position = UDim2.new(0, 0, 0, yPos)
            DropdownContainer.Size = UDim2.new(1, 0, 0, 60)
            DropdownContainer.ZIndex = 6
            DropdownContainer.ClipsDescendants = false
            
            CreateCorner(10).Parent = DropdownContainer
            CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.4).Parent = DropdownContainer
            
            -- Dropdown Button
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "Button"
            DropdownButton.Parent = DropdownContainer
            DropdownButton.BackgroundColor3 = ProMaxUI.CurrentTheme.Tertiary
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Position = UDim2.new(1, -200, 0, 15)
            DropdownButton.Size = UDim2.new(0, 180, 0, 30)
            DropdownButton.Font = Enum.Font.GothamSemibold
            DropdownButton.Text = dropdownConfig.Default .. " ▼"
            DropdownButton.TextColor3 = ProMaxUI.CurrentTheme.Text
            DropdownButton.TextSize = 12
            DropdownButton.ZIndex = 7
            
            CreateCorner(8).Parent = DropdownButton
            CreateRipple(DropdownButton)
            
            -- Dropdown List
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "List"
            DropdownList.Parent = DropdownContainer
            DropdownList.BackgroundColor3 = ProMaxUI.CurrentTheme.Primary
            DropdownList.BorderSizePixel = 0
            DropdownList.Position = UDim2.new(1, -200, 0, 50)
            DropdownList.Size = UDim2.new(0, 180, 0, 0)
            DropdownList.Visible = false
            DropdownList.ZIndex = 15
            DropdownList.ClipsDescendants = true
            
            CreateCorner(8).Parent = DropdownList
            CreateStroke(2, ProMaxUI.CurrentTheme.Accent, 0.3).Parent = DropdownList
            
            local isOpen = false
            local selectedOption = dropdownConfig.Default
            
            -- Create option buttons
            for i, option in ipairs(dropdownConfig.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = "Option_" .. option
                OptionButton.Parent = DropdownList
                OptionButton.BackgroundColor3 = option == selectedOption and ProMaxUI.CurrentTheme.Accent or ProMaxUI.CurrentTheme.Secondary
                OptionButton.BorderSizePixel = 0
                OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 35)
                OptionButton.Size = UDim2.new(1, 0, 0, 35)
                OptionButton.Font = Enum.Font.GothamSemibold
                OptionButton.Text = option
                OptionButton.TextColor3 = ProMaxUI.CurrentTheme.Text
                OptionButton.TextSize = 12
                OptionButton.ZIndex = 16
                
                CreateRipple(OptionButton)
                
                -- Option click
                OptionButton.MouseButton1Click:Connect(function()
                    PlaySound("Click", 0.2)
                    
                    selectedOption = option
                    DropdownButton.Text = option .. " ▼"
                    
                    -- Update visual states
                    for _, btn in pairs(DropdownList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            SmootTween(btn, {
                                BackgroundColor3 = btn.Text == option and ProMaxUI.CurrentTheme.Accent or ProMaxUI.CurrentTheme.Secondary
                            }, 0.2)
                        end
                    end
                    
                    -- Close dropdown
                    isOpen = false
                    SmootTween(DropdownList, {Size = UDim2.new(0, 180, 0, 0)}, 0.3, nil, nil, function()
                        DropdownList.Visible = false
                    end)
                    
                    -- Execute callback
                    pcall(dropdownConfig.Callback, option)
                end)
            end
            
            -- Dropdown toggle
            DropdownButton.MouseButton1Click:Connect(function()
                PlaySound("Click", 0.2)
                isOpen = not isOpen
                
                if isOpen then
                    DropdownButton.Text = selectedOption .. " ▲"
                    DropdownList.Visible = true
                    SmootTween(DropdownList, {Size = UDim2.new(0, 180, 0, #dropdownConfig.Options * 35)}, 0.3, Enum.EasingStyle.Back)
                else
                    DropdownButton.Text = selectedOption .. " ▼"
                    SmootTween(DropdownList, {Size = UDim2.new(0, 180, 0, 0)}, 0.3, nil, nil, function()
                        DropdownList.Visible = false
                    end)
                end
            end)
            
            self:UpdateCanvasSize()
            return DropdownContainer
        end
        
        function TabObject:UpdateCanvasSize()
            local contentSize = self.ElementCount * 80 + 20
            SmootTween(self.Content, {CanvasSize = UDim2.new(0, 0, 0, contentSize)}, 0.3)
        end
        
        -- Connect tab activation
        TabButton.MouseButton1Click:Connect(function()
            TabObject:Activate()
        end)
        
        CreateRipple(TabButton, tabConfig.Color)
        
        -- Add tab to window
        self.Tabs[tabConfig.Name] = TabObject
        
        -- Auto-activate first tab
        if self.TabCount == 1 then
            TabObject:Activate()
        end
        
        -- Update tab container canvas
        self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, self.TabCount * 50 + 10)
        
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
    
    -- Dragging functionality
    if windowConfig.Draggable then
        local dragging = false
        local dragStart = nil
        local startPos = nil
        
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Container.Position
                PlaySound("Click", 0.1)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
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
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
    
    -- Initial animations
    AnimateIn(MainFrame, "Scale")
    
    -- Add window to list
    table.insert(ProMaxUI.Windows, WindowObject)
    
    return WindowObject
end

-- Advanced Notification System
function ProMaxUI:Notify(config)
    config = config or {}
    local notifConfig = {
        Title = config.Title or "Notification",
        Description = config.Description or "",
        Duration = config.Duration or 4,
        Type = config.Type or "Info",
        Position = config.Position or "TopRight"
    }
    
    local colors = {
        Info = {Primary = ProMaxUI.CurrentTheme.Accent, Icon = "ℹ️"},
        Success = {Primary = ProMaxUI.CurrentTheme.Success, Icon = "✅"},
        Warning = {Primary = ProMaxUI.CurrentTheme.Warning, Icon = "⚠️"},
        Error = {Primary = ProMaxUI.CurrentTheme.Error, Icon = "❌"}
    }
    
    local typeColor = colors[notifConfig.Type]
    
    -- Notification GUI
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "ProMaxNotification"
    NotifGui.Parent = GuiParent
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Parent = NotifGui
    NotifFrame.BackgroundColor3 = ProMaxUI.CurrentTheme.Primary
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Size = UDim2.new(0, 320, 0, 90)
    NotifFrame.Position = UDim2.new(1, 10, 0, 20 + (#ProMaxUI.Notifications * 100))
    
    CreateCorner(12).Parent = NotifFrame
    CreateStroke(2, typeColor.Primary, 0).Parent = NotifFrame
    CreateGlow(NotifFrame, typeColor.Primary, 20, 0.3)
    
    -- Notification Title
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = NotifFrame
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 15, 0, 15)
    NotifTitle.Size = UDim2.new(1, -30, 0, 25)
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = typeColor.Icon .. " " .. notifConfig.Title
    NotifTitle.TextColor3 = ProMaxUI.CurrentTheme.Text
    NotifTitle.TextSize = 14
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Notification Description
    local NotifDesc = Instance.new("TextLabel")
    NotifDesc.Parent = NotifFrame
    NotifDesc.BackgroundTransparency = 1
    NotifDesc.Position = UDim2.new(0, 15, 0, 40)
    NotifDesc.Size = UDim2.new(1, -30, 0, 35)
    NotifDesc.Font = Enum.Font.Gotham
    NotifDesc.Text = notifConfig.Description
    NotifDesc.TextColor3 = ProMaxUI.CurrentTheme.TextDim
    NotifDesc.TextSize = 12
    NotifDesc.TextXAlignment = Enum.TextXAlignment.Left
    NotifDesc.TextWrapped = true
    
    -- Add to notifications list
    table.insert(ProMaxUI.Notifications, NotifGui)
    
    -- Slide in animation
    SmootTween(NotifFrame, {Position = UDim2.new(1, -330, 0, 20 + ((#ProMaxUI.Notifications-1) * 100))}, 0.5, Enum.EasingStyle.Back)
    
    PlaySound("Notification", 0.4)
    
    -- Auto close
    Debris:AddItem(NotifGui, notifConfig.Duration)
    spawn(function()
        wait(notifConfig.Duration - 0.5)
        if NotifGui.Parent then
            SmootTween(NotifFrame, {Position = UDim2.new(1, 10, 0, NotifFrame.Position.Y.Offset)}, 0.3, nil, nil, function()
                -- Remove from list
                for i, notif in ipairs(ProMaxUI.Notifications) do
                    if notif == NotifGui then
                        table.remove(ProMaxUI.Notifications, i)
                        break
                    end
                end
            end)
        end
    end)
end

-- Theme Management
function ProMaxUI:SetTheme(themeName)
    if not ProMaxUI.Themes[themeName] then return end
    
    ProMaxUI.CurrentTheme = ProMaxUI.Themes[themeName]
    
    self:Notify({
        Title = "Theme Changed",
        Description = "UI theme updated to " .. themeName,
        Type = "Success"
    })
end

-- Utility Functions
function ProMaxUI:DestroyAllWindows()
    for _, window in pairs(ProMaxUI.Windows) do
        window:Destroy()
    end
    ProMaxUI.Windows = {}
end

function ProMaxUI:GetThemes()
    local themes = {}
    for name, _ in pairs(ProMaxUI.Themes) do
        table.insert(themes, name)
    end
    return themes
end

return ProMaxUI
