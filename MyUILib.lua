-- Complete Fluent UI Library for Game Executors
-- Includes all necessary components for modern executor interfaces

local FluentUI = {}

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

-- Enhanced Configuration
FluentUI.Config = {
    AnimationSpeed = 0.25,
    SoundEffects = true,
    AcrylicBlur = true,
    RevealEffect = true,
    CornerRadius = 8,
    ElevationShadows = true
}

-- Authentic Fluent Design System Colors
FluentUI.Themes = {
    Light = {
        Name = "Light",
        
        -- Backgrounds
        ApplicationPageBackgroundThemeBrush = Color3.fromRGB(243, 243, 243),
        SystemControlPageBackgroundChromeLowBrush = Color3.fromRGB(255, 255, 255),
        SystemControlPageBackgroundChromeMediumLowBrush = Color3.fromRGB(249, 249, 249),
        SystemControlPageBackgroundChromeMediumBrush = Color3.fromRGB(243, 243, 243),
        
        -- Cards
        SystemControlBackgroundChromeMediumLowBrush = Color3.fromRGB(243, 243, 243),
        SystemControlBackgroundChromeMediumBrush = Color3.fromRGB(237, 237, 237),
        SystemControlBackgroundChromeHighBrush = Color3.fromRGB(204, 204, 204),
        
        -- Strokes
        SystemControlForegroundBaseMediumBrush = Color3.fromRGB(113, 113, 113),
        SystemControlForegroundBaseMediumLowBrush = Color3.fromRGB(151, 151, 151),
        
        -- Text
        SystemControlForegroundBaseHighBrush = Color3.fromRGB(0, 0, 0),
        SystemControlForegroundBaseMediumHighBrush = Color3.fromRGB(68, 68, 68),
        SystemControlForegroundBaseLowBrush = Color3.fromRGB(151, 151, 151),
        
        -- Accent
        SystemControlHighlightAccentBrush = Color3.fromRGB(0, 120, 215),
        SystemControlHighlightAccentLowBrush = Color3.fromRGB(153, 209, 255),
        SystemControlHighlightAccentMediumBrush = Color3.fromRGB(64, 156, 255),
        
        -- System
        SystemFillColorSuccess = Color3.fromRGB(16, 124, 16),
        SystemFillColorCaution = Color3.fromRGB(157, 93, 0),
        SystemFillColorCritical = Color3.fromRGB(196, 43, 28),
        SystemFillColorNeutral = Color3.fromRGB(113, 113, 113),
        
        -- Shadow
        Shadow = Color3.fromRGB(0, 0, 0)
    },
    
    Dark = {
        Name = "Dark",
        
        -- Backgrounds
        ApplicationPageBackgroundThemeBrush = Color3.fromRGB(32, 32, 32),
        SystemControlPageBackgroundChromeLowBrush = Color3.fromRGB(45, 45, 45),
        SystemControlPageBackgroundChromeMediumLowBrush = Color3.fromRGB(40, 40, 40),
        SystemControlPageBackgroundChromeMediumBrush = Color3.fromRGB(35, 35, 35),
        
        -- Cards
        SystemControlBackgroundChromeMediumLowBrush = Color3.fromRGB(58, 58, 58),
        SystemControlBackgroundChromeMediumBrush = Color3.fromRGB(65, 65, 65),
        SystemControlBackgroundChromeHighBrush = Color3.fromRGB(76, 76, 76),
        
        -- Strokes
        SystemControlForegroundBaseMediumBrush = Color3.fromRGB(151, 151, 151),
        SystemControlForegroundBaseMediumLowBrush = Color3.fromRGB(113, 113, 113),
        
        -- Text
        SystemControlForegroundBaseHighBrush = Color3.fromRGB(255, 255, 255),
        SystemControlForegroundBaseMediumHighBrush = Color3.fromRGB(204, 204, 204),
        SystemControlForegroundBaseLowBrush = Color3.fromRGB(113, 113, 113),
        
        -- Accent
        SystemControlHighlightAccentBrush = Color3.fromRGB(96, 205, 255),
        SystemControlHighlightAccentLowBrush = Color3.fromRGB(64, 156, 255),
        SystemControlHighlightAccentMediumBrush = Color3.fromRGB(118, 185, 237),
        
        -- System
        SystemFillColorSuccess = Color3.fromRGB(108, 203, 95),
        SystemFillColorCaution = Color3.fromRGB(252, 225, 0),
        SystemFillColorCritical = Color3.fromRGB(255, 153, 164),
        SystemFillColorNeutral = Color3.fromRGB(151, 151, 151),
        
        -- Shadow
        Shadow = Color3.fromRGB(0, 0, 0)
    }
}

FluentUI.CurrentTheme = FluentUI.Themes.Dark
FluentUI.Windows = {}
FluentUI.Connections = {}
FluentUI.Notifications = {}

-- Sound System
local Sounds = {
    Click = "rbxassetid://131961136",
    Hover = "rbxassetid://131961136", 
    Success = "rbxassetid://131961136",
    Error = "rbxassetid://131961136",
    Navigation = "rbxassetid://131961136"
}

-- Utility Functions
local function PlaySound(soundName, volume, pitch)
    if not FluentUI.Config.SoundEffects then return end
    
    spawn(function()
        local success, _ = pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = Sounds[soundName] or Sounds.Click
            sound.Volume = volume or 0.05
            sound.Pitch = pitch or 1
            sound.Parent = SoundService
            sound:Play()
            
            sound.Ended:Connect(function()
                sound:Destroy()
            end)
        end)
    end)
end

local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or FluentUI.Config.CornerRadius)
    return corner
end

local function CreateStroke(thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush
    stroke.Transparency = transparency or 0.5
    return stroke
end

local function CreateDropShadow(parent, elevation, color)
    if not FluentUI.Config.ElevationShadows then return end
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.Parent = parent
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = color or FluentUI.CurrentTheme.Shadow
    shadow.ImageTransparency = 0.85 - (elevation * 0.05)
    shadow.Position = UDim2.new(0, -elevation, 0, elevation)
    shadow.Size = UDim2.new(1, elevation * 2, 1, elevation * 2)
    shadow.ZIndex = parent.ZIndex - 1
    
    CreateCorner(FluentUI.Config.CornerRadius + elevation).Parent = shadow
    
    return shadow
end

local function SmoothTween(object, properties, duration, style, direction, callback)
    local tweenInfo = TweenInfo.new(
        duration or FluentUI.Config.AnimationSpeed,
        style or Enum.EasingStyle.Cubic,
        direction or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    table.insert(FluentUI.Connections, tween)
    return tween
end

-- Enhanced Reveal Effect
local function CreateRevealEffect(button)
    if not FluentUI.Config.RevealEffect then return end
    
    local connection
    connection = button.MouseEnter:Connect(function()
        local reveal = Instance.new("Frame")
        reveal.Name = "RevealEffect" 
        reveal.Parent = button
        reveal.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
        reveal.BackgroundTransparency = 0.92
        reveal.BorderSizePixel = 0
        reveal.Size = UDim2.new(1, 0, 1, 0)
        reveal.ZIndex = button.ZIndex + 1
        
        CreateCorner(FluentUI.Config.CornerRadius).Parent = reveal
        
        reveal.BackgroundTransparency = 1
        SmoothTween(reveal, {BackgroundTransparency = 0.92}, 0.15)
        
        local leaveConnection
        leaveConnection = button.MouseLeave:Connect(function()
            SmoothTween(reveal, {BackgroundTransparency = 1}, 0.2, nil, nil, function()
                if reveal.Parent then
                    reveal:Destroy()
                end
                leaveConnection:Disconnect()
            end)
        end)
        
        table.insert(FluentUI.Connections, leaveConnection)
    end)
    
    table.insert(FluentUI.Connections, connection)
end

local function CreatePressAnimation(button)
    local pressConnection
    pressConnection = button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            PlaySound("Click", 0.05, 1.1)
            
            SmoothTween(button, {
                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 1, button.Size.Y.Scale, button.Size.Y.Offset - 1)
            }, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                SmoothTween(button, {
                    Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 1, button.Size.Y.Scale, button.Size.Y.Offset + 1)
                }, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            end)
        end
    end)
    
    table.insert(FluentUI.Connections, pressConnection)
end

local function CreateAcrylicEffect(frame)
    if not FluentUI.Config.AcrylicBlur then return end
    
    local acrylic = Instance.new("Frame")
    acrylic.Name = "AcrylicBackground"
    acrylic.Parent = frame
    acrylic.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlPageBackgroundChromeLowBrush
    acrylic.BackgroundTransparency = 0.2
    acrylic.BorderSizePixel = 0
    acrylic.Size = UDim2.new(1, 0, 1, 0)
    acrylic.ZIndex = frame.ZIndex - 1
    
    CreateCorner(FluentUI.Config.CornerRadius).Parent = acrylic
    
    return acrylic
end

-- Window Creation
function FluentUI:CreateWindow(config)
    config = config or {}
    
    local windowConfig = {
        Title = config.Title or "Fluent Executor",
        Subtitle = config.Subtitle or "Version 1.0.1 by Developer",
        Size = config.Size or UDim2.new(0, 700, 0, 500),
        Theme = config.Theme or "Dark",
        KeyBind = config.KeyBind or Enum.KeyCode.Insert,
        Draggable = config.Draggable ~= false,
        MinimizeKey = config.MinimizeKey
    }
    
    if FluentUI.Themes[windowConfig.Theme] then
        FluentUI.CurrentTheme = FluentUI.Themes[windowConfig.Theme]
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FluentUI_" .. HttpService:GenerateGUID(false):sub(1, 8)
    ScreenGui.Parent = GuiParent
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    
    local BackgroundOverlay = Instance.new("Frame")
    BackgroundOverlay.Name = "BackgroundOverlay"
    BackgroundOverlay.Parent = ScreenGui
    BackgroundOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BackgroundOverlay.BackgroundTransparency = 0.3
    BackgroundOverlay.BorderSizePixel = 0
    BackgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
    BackgroundOverlay.ZIndex = 1
    
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = ScreenGui
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0.5, -windowConfig.Size.X.Offset/2, 0.5, -windowConfig.Size.Y.Offset/2)
    Container.Size = windowConfig.Size
    Container.ZIndex = 2
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Container
    MainFrame.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlPageBackgroundChromeLowBrush
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.ZIndex = 3
    
    CreateCorner(FluentUI.Config.CornerRadius).Parent = MainFrame
    CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.3).Parent = MainFrame
    CreateDropShadow(MainFrame, 8)
    CreateAcrylicEffect(MainFrame)
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
    TitleBar.BackgroundTransparency = 0.4
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 48)
    TitleBar.ZIndex = 4
    
    CreateCorner(FluentUI.Config.CornerRadius).Parent = TitleBar
    
    local AppIcon = Instance.new("Frame")
    AppIcon.Name = "AppIcon"
    AppIcon.Parent = TitleBar
    AppIcon.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush
    AppIcon.BorderSizePixel = 0
    AppIcon.Position = UDim2.new(0, 16, 0.5, -10)
    AppIcon.Size = UDim2.new(0, 20, 0, 20)
    AppIcon.ZIndex = 5
    
    CreateCorner(4).Parent = AppIcon
    
    local IconSymbol = Instance.new("TextLabel")
    IconSymbol.Parent = AppIcon
    IconSymbol.BackgroundTransparency = 1
    IconSymbol.Size = UDim2.new(1, 0, 1, 0)
    IconSymbol.Font = Enum.Font.GothamBold
    IconSymbol.Text = "◈"
    IconSymbol.TextColor3 = Color3.fromRGB(255, 255, 255)
    IconSymbol.TextSize = 12
    IconSymbol.ZIndex = 6
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 46, 0, 6)
    TitleLabel.Size = UDim2.new(0.6, 0, 0, 20)
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.Text = windowConfig.Title
    TitleLabel.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 5
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Parent = TitleBar
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Position = UDim2.new(0, 46, 0, 26)
    SubtitleLabel.Size = UDim2.new(0.6, 0, 0, 16)
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.Text = windowConfig.Subtitle
    SubtitleLabel.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
    SubtitleLabel.TextSize = 10
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.ZIndex = 5
    
    local WindowControls = Instance.new("Frame")
    WindowControls.Name = "WindowControls"
    WindowControls.Parent = TitleBar
    WindowControls.BackgroundTransparency = 1
    WindowControls.Position = UDim2.new(1, -100, 0, 12)
    WindowControls.Size = UDim2.new(0, 92, 0, 24)
    WindowControls.ZIndex = 5
    
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "Minimize"
    MinimizeBtn.Parent = WindowControls
    MinimizeBtn.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumBrush
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    MinimizeBtn.Size = UDim2.new(0, 40, 0, 24)
    MinimizeBtn.Font = Enum.Font.GothamMedium
    MinimizeBtn.Text = "─"
    MinimizeBtn.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
    MinimizeBtn.TextSize = 12
    MinimizeBtn.ZIndex = 6
    
    CreateCorner(4).Parent = MinimizeBtn
    CreateRevealEffect(MinimizeBtn)
    CreatePressAnimation(MinimizeBtn)
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Parent = WindowControls
    CloseBtn.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumBrush
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(0, 44, 0, 0)
    CloseBtn.Size = UDim2.new(0, 40, 0, 24)
    CloseBtn.Font = Enum.Font.GothamMedium
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
    CloseBtn.TextSize = 16
    CloseBtn.ZIndex = 6
    
    CreateCorner(4).Parent = CloseBtn
    
    CloseBtn.MouseEnter:Connect(function()
        SmoothTween(CloseBtn, {
            BackgroundColor3 = FluentUI.CurrentTheme.SystemFillColorCritical,
            BackgroundTransparency = 0
        }, 0.15)
        SmoothTween(CloseBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        SmoothTween(CloseBtn, {
            BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumBrush,
            BackgroundTransparency = 1
        }, 0.15)
        SmoothTween(CloseBtn, {TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush}, 0.15)
    end)
    
    CreatePressAnimation(CloseBtn)
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 48)
    ContentFrame.Size = UDim2.new(1, 0, 1, -48)
    ContentFrame.ZIndex = 4
    
    local NavPane = Instance.new("Frame")
    NavPane.Name = "NavigationPane"
    NavPane.Parent = ContentFrame
    NavPane.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlPageBackgroundChromeMediumLowBrush
    NavPane.BackgroundTransparency = 0.3
    NavPane.BorderSizePixel = 0
    NavPane.Size = UDim2.new(0, 220, 1, 0)
    NavPane.ZIndex = 5
    
    CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.6).Parent = NavPane
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = NavPane
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 12, 0, 16)
    TabContainer.Size = UDim2.new(1, -24, 1, -32)
    TabContainer.ScrollBarThickness = 3
    TabContainer.ScrollBarImageColor3 = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush
    TabContainer.ScrollBarImageTransparency = 0.4
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ZIndex = 6
    
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.Parent = ContentFrame
    MainContent.BackgroundTransparency = 1
    MainContent.Position = UDim2.new(0, 220, 0, 0)
    MainContent.Size = UDim2.new(1, -220, 1, 0)
    MainContent.ZIndex = 5
    
    local WindowObject = {
        ScreenGui = ScreenGui,
        Container = Container,
        MainFrame = MainFrame,
        TitleBar = TitleBar,
        ContentFrame = ContentFrame,
        NavPane = NavPane,
        TabContainer = TabContainer,
        MainContent = MainContent,
        BackgroundOverlay = BackgroundOverlay,
        Config = windowConfig,
        Tabs = {},
        CurrentTab = nil,
        Visible = true,
        Minimized = false,
        TabCount = 0
    }
    
    function WindowObject:Toggle()
        self.Visible = not self.Visible
        
        if self.Visible then
            self.ScreenGui.Enabled = true
            self.Container.Size = UDim2.new(0, 0, 0, 0)
            self.Container.Position = UDim2.new(0.5, 0, 0.5, 0)
            self.MainFrame.BackgroundTransparency = 1
            
            SmoothTween(self.Container, {
                Size = windowConfig.Size,
                Position = UDim2.new(0.5, -windowConfig.Size.X.Offset/2, 0.5, -windowConfig.Size.Y.Offset/2)
            }, 0.5, Enum.EasingStyle.Back)
            
            SmoothTween(self.MainFrame, {BackgroundTransparency = 0.1}, 0.3)
            SmoothTween(self.BackgroundOverlay, {BackgroundTransparency = 0.3}, 0.3)
            
            PlaySound("Success", 0.1, 1.2)
        else
            SmoothTween(self.Container, {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }, 0.3, Enum.EasingStyle.Back)
            
            SmoothTween(self.MainFrame, {BackgroundTransparency = 1}, 0.3)
            SmoothTween(self.BackgroundOverlay, {BackgroundTransparency = 1}, 0.3, nil, nil, function()
                self.ScreenGui.Enabled = false
            end)
        end
    end
    
    function WindowObject:Minimize()
        self.Minimized = not self.Minimized
        PlaySound("Navigation", 0.08, 0.9)
        
        local targetSize = self.Minimized and UDim2.new(0, windowConfig.Size.X.Offset, 0, 48) or windowConfig.Size
        
        SmoothTween(self.Container, {Size = targetSize}, 0.4, Enum.EasingStyle.Cubic)
        self.ContentFrame.Visible = not self.Minimized
    end
    
    function WindowObject:Destroy()
        for _, connection in pairs(FluentUI.Connections) do
            if typeof(connection) == "RBXScriptConnection" then
                connection:Disconnect()
            elseif typeof(connection) == "Tween" then
                connection:Cancel()
            end
        end
        
        PlaySound("Click", 0.1, 0.8)
        
        SmoothTween(self.Container, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.3, Enum.EasingStyle.Back)
        
        SmoothTween(self.BackgroundOverlay, {BackgroundTransparency = 1}, 0.3, nil, nil, function()
            self.ScreenGui:Destroy()
        end)
        
        for i, window in pairs(FluentUI.Windows) do
            if window == self then
                table.remove(FluentUI.Windows, i)
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
        
        local NavItem = Instance.new("Frame")
        NavItem.Name = "NavItem_" .. tabConfig.Name
        NavItem.Parent = self.TabContainer
        NavItem.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumBrush
        NavItem.BackgroundTransparency = 1
        NavItem.BorderSizePixel = 0
        NavItem.Position = UDim2.new(0, 0, 0, (tabIndex - 1) * 44)
        NavItem.Size = UDim2.new(1, 0, 0, 40)
        NavItem.ZIndex = 7
        
        CreateCorner(6).Parent = NavItem
        
        local NavButton = Instance.new("TextButton")
        NavButton.Name = "NavButton"
        NavButton.Parent = NavItem
        NavButton.BackgroundTransparency = 1
        NavButton.Size = UDim2.new(1, 0, 1, 0)
        NavButton.Font = Enum.Font.Gotham
        NavButton.Text = ""
        NavButton.ZIndex = 8
        
        local SelectionIndicator = Instance.new("Frame")
        SelectionIndicator.Name = "SelectionIndicator"
        SelectionIndicator.Parent = NavItem
        SelectionIndicator.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush
        SelectionIndicator.BorderSizePixel = 0
        SelectionIndicator.Position = UDim2.new(0, 0, 0.5, -10)
        SelectionIndicator.Size = UDim2.new(0, 0, 0, 20)
        SelectionIndicator.ZIndex = 9
        
        CreateCorner(2).Parent = SelectionIndicator
        
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Name = "Icon"
        TabIcon.Parent = NavItem
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 16, 0, 0)
        TabIcon.Size = UDim2.new(0, 24, 1, 0)
        TabIcon.Font = Enum.Font.GothamMedium
        TabIcon.Text = tabConfig.Icon
        TabIcon.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
        TabIcon.TextSize = 14
        TabIcon.TextXAlignment = Enum.TextXAlignment.Center
        TabIcon.ZIndex = 8
        
        local TabText = Instance.new("TextLabel")
        TabText.Name = "Text"
        TabText.Parent = NavItem
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, 48, 0, 0)
        TabText.Size = UDim2.new(1, -56, 1, 0)
        TabText.Font = Enum.Font.GothamMedium
        TabText.Text = tabConfig.Name
        TabText.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
        TabText.TextSize = 13
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.ZIndex = 8
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. tabConfig.Name
        TabContent.Parent = self.MainContent
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, 24, 0, 24)
        TabContent.Size = UDim2.new(1, -48, 1, -48)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush
        TabContent.ScrollBarImageTransparency = 0.4
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.ZIndex = 6
        
        local TabObject = {
            NavItem = NavItem,
            NavButton = NavButton,
            SelectionIndicator = SelectionIndicator,
            Icon = TabIcon,
            Text = TabText,
            Content = TabContent,
            Config = tabConfig,
            Active = false,
            ElementCount = 0
        }
        
        function TabObject:Activate()
            if self.Active then return end
            
            PlaySound("Navigation", 0.06, 1.1)
            
            for _, tab in pairs(WindowObject.Tabs) do
                if tab.Active then
                    tab:Deactivate()
                end
            end
            
            self.Active = true
            WindowObject.CurrentTab = self
            
            SmoothTween(self.NavItem, {BackgroundTransparency = 0.6}, 0.2)
            SmoothTween(self.SelectionIndicator, {Size = UDim2.new(0, 3, 0, 20)}, 0.3, Enum.EasingStyle.Back)
            SmoothTween(self.Icon, {TextColor3 = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush}, 0.2)
            SmoothTween(self.Text, {TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush}, 0.2)
            
            self.Content.Visible = true
        end
        
        function TabObject:Deactivate()
            self.Active = false
            
            SmoothTween(self.NavItem, {BackgroundTransparency = 1}, 0.2)
            SmoothTween(self.SelectionIndicator, {Size = UDim2.new(0, 0, 0, 20)}, 0.2)
            SmoothTween(self.Icon, {TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush}, 0.2)
            SmoothTween(self.Text, {TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush}, 0.2)
            
            self.Content.Visible = false
        end
        
        -- COMPLETE UI ELEMENTS FOR EXECUTOR
        
        function TabObject:CreateSection(name)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "Section_" .. name
            SectionFrame.Parent = self.Content
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Position = UDim2.new(0, 0, 0, self.ElementCount * 90)
            SectionFrame.Size = UDim2.new(1, 0, 0, 36)
            SectionFrame.ZIndex = 7
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Parent = SectionFrame
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Position = UDim2.new(0, 0, 0, 0)
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.Text = name
            SectionLabel.TextColor3 = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush
            SectionLabel.TextSize = 15
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.ZIndex = 8
            
            self.ElementCount = self.ElementCount + 1
            self:UpdateCanvasSize()
            
            return SectionFrame
        end
        
        function TabObject:CreateButton(config)
            config = config or {}
            
            local buttonConfig = {
                Name = config.Name or "Button",
                Description = config.Description or "",
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 90
            self.ElementCount = self.ElementCount + 1
            
            local ButtonCard = Instance.new("Frame")
            ButtonCard.Name = "ButtonCard_" .. buttonConfig.Name
            ButtonCard.Parent = self.Content
            ButtonCard.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            ButtonCard.BackgroundTransparency = 0.2
            ButtonCard.BorderSizePixel = 0
            ButtonCard.Position = UDim2.new(0, 0, 0, yPos)
            ButtonCard.Size = UDim2.new(1, -8, 0, 80)
            ButtonCard.ZIndex = 7
            
            CreateCorner(8).Parent = ButtonCard
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.6).Parent = ButtonCard
            CreateDropShadow(ButtonCard, 2)
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = ButtonCard
            Button.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(1, -100, 0, 22)
            Button.Size = UDim2.new(0, 85, 0, 36)
            Button.Font = Enum.Font.GothamMedium
            Button.Text = "Execute"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 13
            Button.ZIndex = 8
            
            CreateCorner(6).Parent = Button
            CreateRevealEffect(Button)
            CreatePressAnimation(Button)
            
            local ButtonTitle = Instance.new("TextLabel")
            ButtonTitle.Parent = ButtonCard
            ButtonTitle.BackgroundTransparency = 1
            ButtonTitle.Position = UDim2.new(0, 20, 0, 18)
            ButtonTitle.Size = UDim2.new(0.6, 0, 0, 24)
            ButtonTitle.Font = Enum.Font.GothamMedium
            ButtonTitle.Text = buttonConfig.Name
            ButtonTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            ButtonTitle.TextSize = 14
            ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
            ButtonTitle.ZIndex = 8
            
            if buttonConfig.Description ~= "" then
                local ButtonDesc = Instance.new("TextLabel")
                ButtonDesc.Parent = ButtonCard
                ButtonDesc.BackgroundTransparency = 1
                ButtonDesc.Position = UDim2.new(0, 20, 0, 42)
                ButtonDesc.Size = UDim2.new(0.6, 0, 0, 20)
                ButtonDesc.Font = Enum.Font.Gotham
                ButtonDesc.Text = buttonConfig.Description
                ButtonDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
                ButtonDesc.TextSize = 11
                ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
                ButtonDesc.ZIndex = 8
            end
            
            Button.MouseButton1Click:Connect(function()
                local success, err = pcall(buttonConfig.Callback)
                if not success then
                    FluentUI:Notify({
                        Title = "Error",
                        Description = "An error occurred: " .. tostring(err),
                        Type = "Error"
                    })
                end
            end)
            
            self:UpdateCanvasSize()
            return ButtonCard
        end
        
        function TabObject:CreateToggle(config)
            config = config or {}
            
            local toggleConfig = {
                Name = config.Name or "Toggle",
                Description = config.Description or "",
                Default = config.Default or false,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 90
            self.ElementCount = self.ElementCount + 1
            
            local ToggleCard = Instance.new("Frame")
            ToggleCard.Name = "ToggleCard_" .. toggleConfig.Name
            ToggleCard.Parent = self.Content
            ToggleCard.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            ToggleCard.BackgroundTransparency = 0.2
            ToggleCard.BorderSizePixel = 0
            ToggleCard.Position = UDim2.new(0, 0, 0, yPos)
            ToggleCard.Size = UDim2.new(1, -8, 0, 80)
            ToggleCard.ZIndex = 7
            
            CreateCorner(8).Parent = ToggleCard
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.6).Parent = ToggleCard
            CreateDropShadow(ToggleCard, 2)
            
            local ToggleSwitch = Instance.new("Frame")
            ToggleSwitch.Name = "ToggleSwitch"
            ToggleSwitch.Parent = ToggleCard
            ToggleSwitch.BackgroundColor3 = toggleConfig.Default and FluentUI.CurrentTheme.SystemControlHighlightAccentBrush or FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
            ToggleSwitch.BorderSizePixel = 0
            ToggleSwitch.Position = UDim2.new(1, -70, 0, 25)
            ToggleSwitch.Size = UDim2.new(0, 60, 0, 30)
            ToggleSwitch.ZIndex = 8
            
            CreateCorner(15).Parent = ToggleSwitch
            
            local ToggleKnob = Instance.new("Frame")
            ToggleKnob.Name = "ToggleKnob"
            ToggleKnob.Parent = ToggleSwitch
            ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleKnob.BorderSizePixel = 0
            ToggleKnob.Position = UDim2.new(0, toggleConfig.Default and 32 or 2, 0, 2)
            ToggleKnob.Size = UDim2.new(0, 26, 0, 26)
            ToggleKnob.ZIndex = 9
            
            CreateCorner(13).Parent = ToggleKnob
            CreateDropShadow(ToggleKnob, 2)
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = ToggleSwitch
            ToggleButton.BackgroundTransparency = 1
            ToggleButton.Size = UDim2.new(1, 0, 1, 0)
            ToggleButton.Text = ""
            ToggleButton.ZIndex = 10
            
            local ToggleTitle = Instance.new("TextLabel")
            ToggleTitle.Parent = ToggleCard
            ToggleTitle.BackgroundTransparency = 1
            ToggleTitle.Position = UDim2.new(0, 20, 0, 18)
            ToggleTitle.Size = UDim2.new(0.6, 0, 0, 24)
            ToggleTitle.Font = Enum.Font.GothamMedium
            ToggleTitle.Text = toggleConfig.Name
            ToggleTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            ToggleTitle.TextSize = 14
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            ToggleTitle.ZIndex = 8
            
            if toggleConfig.Description ~= "" then
                local ToggleDesc = Instance.new("TextLabel")
                ToggleDesc.Parent = ToggleCard
                ToggleDesc.BackgroundTransparency = 1
                ToggleDesc.Position = UDim2.new(0, 20, 0, 42)
                ToggleDesc.Size = UDim2.new(0.6, 0, 0, 20)
                ToggleDesc.Font = Enum.Font.Gotham
                ToggleDesc.Text = toggleConfig.Description
                ToggleDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
                ToggleDesc.TextSize = 11
                ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
                ToggleDesc.ZIndex = 8
            end
            
            local isToggled = toggleConfig.Default
            
            ToggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                PlaySound("Click", 0.05, isToggled and 1.2 or 0.8)
                
                SmoothTween(ToggleSwitch, {
                    BackgroundColor3 = isToggled and FluentUI.CurrentTheme.SystemControlHighlightAccentBrush or FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
                }, 0.2)
                
                SmoothTween(ToggleKnob, {
                    Position = UDim2.new(0, isToggled and 32 or 2, 0, 2)
                }, 0.2, Enum.EasingStyle.Cubic)
                
                local success, err = pcall(toggleConfig.Callback, isToggled)
                if not success then
                    FluentUI:Notify({
                        Title = "Error",
                        Description = "Toggle error: " .. tostring(err),
                        Type = "Error"
                    })
                end
            end)
            
            self:UpdateCanvasSize()
            return ToggleCard
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
            
            local yPos = self.ElementCount * 90
            self.ElementCount = self.ElementCount + 1
            
            local SliderCard = Instance.new("Frame")
            SliderCard.Name = "SliderCard_" .. sliderConfig.Name
            SliderCard.Parent = self.Content
            SliderCard.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            SliderCard.BackgroundTransparency = 0.2
            SliderCard.BorderSizePixel = 0
            SliderCard.Position = UDim2.new(0, 0, 0, yPos)
            SliderCard.Size = UDim2.new(1, -8, 0, 80)
            SliderCard.ZIndex = 7
            
            CreateCorner(8).Parent = SliderCard
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.6).Parent = SliderCard
            CreateDropShadow(SliderCard, 2)
            
            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Parent = SliderCard
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 20, 0, 12)
            SliderTitle.Size = UDim2.new(0.5, 0, 0, 20)
            SliderTitle.Font = Enum.Font.GothamMedium
            SliderTitle.Text = sliderConfig.Name
            SliderTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            SliderTitle.TextSize = 14
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            SliderTitle.ZIndex = 8
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderCard
            ValueLabel.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush
            ValueLabel.BorderSizePixel = 0
            ValueLabel.Position = UDim2.new(1, -70, 0, 12)
            ValueLabel.Size = UDim2.new(0, 60, 0, 20)
            ValueLabel.Font = Enum.Font.GothamMedium
            ValueLabel.Text = tostring(sliderConfig.Default)
            ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueLabel.TextSize = 12
            ValueLabel.ZIndex = 8
            
            CreateCorner(4).Parent = ValueLabel
            
            if sliderConfig.Description ~= "" then
                local SliderDesc = Instance.new("TextLabel")
                SliderDesc.Parent = SliderCard
                SliderDesc.BackgroundTransparency = 1
                SliderDesc.Position = UDim2.new(0, 20, 0, 32)
                SliderDesc.Size = UDim2.new(0.7, 0, 0, 15)
                SliderDesc.Font = Enum.Font.Gotham
                SliderDesc.Text = sliderConfig.Description
                SliderDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
                SliderDesc.TextSize = 11
                SliderDesc.TextXAlignment = Enum.TextXAlignment.Left
                SliderDesc.ZIndex = 8
            end
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "SliderTrack"
            SliderTrack.Parent = SliderCard
            SliderTrack.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Position = UDim2.new(0, 20, 0, 55)
            SliderTrack.Size = UDim2.new(1, -40, 0, 6)
            SliderTrack.ZIndex = 8
            
            CreateCorner(3).Parent = SliderTrack
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Parent = SliderTrack
            SliderFill.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
            SliderFill.ZIndex = 9
            
            CreateCorner(3).Parent = SliderFill
            
            local SliderKnob = Instance.new("Frame")
            SliderKnob.Name = "SliderKnob"
            SliderKnob.Parent = SliderTrack
            SliderKnob.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush
            SliderKnob.BorderSizePixel = 0
            SliderKnob.Position = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), -10, 0.5, -10)
            SliderKnob.Size = UDim2.new(0, 20, 0, 20)
            SliderKnob.ZIndex = 10
            
            CreateCorner(10).Parent = SliderKnob
            CreateDropShadow(SliderKnob, 3)
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Parent = SliderTrack
            SliderButton.BackgroundTransparency = 1
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.Text = ""
            SliderButton.ZIndex = 11
            
            local currentValue = sliderConfig.Default
            local isDragging = false
            
            local function UpdateSlider(input)
                local trackPos = SliderTrack.AbsolutePosition.X
                local trackSize = SliderTrack.AbsoluteSize.X
                local mousePos = input.Position.X
                
                local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                local rawValue = sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percent
                currentValue = math.floor(rawValue / sliderConfig.Increment + 0.5) * sliderConfig.Increment
                currentValue = math.clamp(currentValue, sliderConfig.Min, sliderConfig.Max)
                
                local finalPercent = (currentValue - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                
                SmoothTween(SliderFill, {Size = UDim2.new(finalPercent, 0, 1, 0)}, 0.1)
                SmoothTween(SliderKnob, {Position = UDim2.new(finalPercent, -10, 0.5, -10)}, 0.1)
                
                ValueLabel.Text = tostring(currentValue)
                
                local success, err = pcall(sliderConfig.Callback, currentValue)
                if not success then
                    FluentUI:Notify({
                        Title = "Error",
                        Description = "Slider error: " .. tostring(err),
                        Type = "Error"
                    })
                end
            end
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    PlaySound("Click", 0.03, 1.1)
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
            return SliderCard
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
            
            local yPos = self.ElementCount * 90
            self.ElementCount = self.ElementCount + 1
            
            local DropdownCard = Instance.new("Frame")
            DropdownCard.Name = "DropdownCard_" .. dropdownConfig.Name
            DropdownCard.Parent = self.Content
            DropdownCard.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            DropdownCard.BackgroundTransparency = 0.2
            DropdownCard.BorderSizePixel = 0
            DropdownCard.Position = UDim2.new(0, 0, 0, yPos)
            DropdownCard.Size = UDim2.new(1, -8, 0, 80)
            DropdownCard.ZIndex = 7
            DropdownCard.ClipsDescendants = false
            
            CreateCorner(8).Parent = DropdownCard
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.6).Parent = DropdownCard
            CreateDropShadow(DropdownCard, 2)
            
            local DropdownTitle = Instance.new("TextLabel")
            DropdownTitle.Parent = DropdownCard
            DropdownTitle.BackgroundTransparency = 1
            DropdownTitle.Position = UDim2.new(0, 20, 0, 12)
            DropdownTitle.Size = UDim2.new(0.4, 0, 0, 20)
            DropdownTitle.Font = Enum.Font.GothamMedium
            DropdownTitle.Text = dropdownConfig.Name
            DropdownTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            DropdownTitle.TextSize = 14
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropdownTitle.ZIndex = 8
            
            if dropdownConfig.Description ~= "" then
                local DropdownDesc = Instance.new("TextLabel")
                DropdownDesc.Parent = DropdownCard
                DropdownDesc.BackgroundTransparency = 1
                DropdownDesc.Position = UDim2.new(0, 20, 0, 32)
                DropdownDesc.Size = UDim2.new(0.4, 0, 0, 15)
                DropdownDesc.Font = Enum.Font.Gotham
                DropdownDesc.Text = dropdownConfig.Description
                DropdownDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
                DropdownDesc.TextSize = 11
                DropdownDesc.TextXAlignment = Enum.TextXAlignment.Left
                DropdownDesc.ZIndex = 8
            end
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Parent = DropdownCard
            DropdownButton.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumBrush
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Position = UDim2.new(0.5, 10, 0, 22)
            DropdownButton.Size = UDim2.new(0.5, -30, 0, 36)
            DropdownButton.Font = Enum.Font.GothamMedium
            DropdownButton.Text = dropdownConfig.Default .. " ⌄"
            DropdownButton.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            DropdownButton.TextSize = 12
            DropdownButton.ZIndex = 8
            
            CreateCorner(6).Parent = DropdownButton
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.5).Parent = DropdownButton
            CreateRevealEffect(DropdownButton)
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "DropdownList"
            DropdownList.Parent = DropdownCard
            DropdownList.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            DropdownList.BorderSizePixel = 0
            DropdownList.Position = UDim2.new(0.5, 10, 0, 62)
            DropdownList.Size = UDim2.new(0.5, -30, 0, 0)
            DropdownList.Visible = false
            DropdownList.ZIndex = 20
            DropdownList.ClipsDescendants = true
            
            CreateCorner(6).Parent = DropdownList
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlHighlightAccentBrush, 0.4).Parent = DropdownList
            CreateDropShadow(DropdownList, 4)
            CreateAcrylicEffect(DropdownList)
            
            local isOpen = false
            local selectedOption = dropdownConfig.Default
            
            for i, option in ipairs(dropdownConfig.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = "Option_" .. option
                OptionButton.Parent = DropdownList
                OptionButton.BackgroundColor3 = option == selectedOption and FluentUI.CurrentTheme.SystemControlHighlightAccentBrush or Color3.fromRGB(0, 0, 0)
                OptionButton.BackgroundTransparency = option == selectedOption and 0.2 or 1
                OptionButton.BorderSizePixel = 0
                OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 32)
                OptionButton.Size = UDim2.new(1, 0, 0, 32)
                OptionButton.Font = Enum.Font.GothamMedium
                OptionButton.Text = option
                OptionButton.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
                OptionButton.TextSize = 11
                OptionButton.ZIndex = 21
                
                CreateRevealEffect(OptionButton)
                
                OptionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    DropdownButton.Text = option .. " ⌄"
                    PlaySound("Click", 0.05, 1.0)
                    
                    for _, btn in pairs(DropdownList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            SmoothTween(btn, {
                                BackgroundTransparency = btn.Text == option and 0.2 or 1
                            })
                        end
                    end
                    
                    isOpen = false
                    SmoothTween(DropdownList, {Size = UDim2.new(0.5, -30, 0, 0)}, 0.2, nil, nil, function()
                        DropdownList.Visible = false
                    end)
                    
                    local success, err = pcall(dropdownConfig.Callback, option)
                    if not success then
                        FluentUI:Notify({
                            Title = "Error",
                            Description = "Dropdown error: " .. tostring(err),
                            Type = "Error"
                        })
                    end
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                PlaySound("Click", 0.05, 1.0)
                
                if isOpen then
                    DropdownButton.Text = selectedOption .. " ⌃"
                    DropdownList.Visible = true
                    SmoothTween(DropdownList, {Size = UDim2.new(0.5, -30, 0, #dropdownConfig.Options * 32)}, 0.2, Enum.EasingStyle.Back)
                else
                    DropdownButton.Text = selectedOption .. " ⌄"
                    SmoothTween(DropdownList, {Size = UDim2.new(0.5, -30, 0, 0)}, 0.2, nil, nil, function()
                        DropdownList.Visible = false
                    end)
                end
            end)
            
            self:UpdateCanvasSize()
            return DropdownCard
        end
        
        function TabObject:CreateTextbox(config)
            config = config or {}
            
            local textboxConfig = {
                Name = config.Name or "Textbox",
                Description = config.Description or "",
                PlaceholderText = config.PlaceholderText or "Enter text...",
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 90
            self.ElementCount = self.ElementCount + 1
            
            local TextboxCard = Instance.new("Frame")
            TextboxCard.Name = "TextboxCard_" .. textboxConfig.Name
            TextboxCard.Parent = self.Content
            TextboxCard.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            TextboxCard.BackgroundTransparency = 0.2
            TextboxCard.BorderSizePixel = 0
            TextboxCard.Position = UDim2.new(0, 0, 0, yPos)
            TextboxCard.Size = UDim2.new(1, -8, 0, 80)
            TextboxCard.ZIndex = 7
            
            CreateCorner(8).Parent = TextboxCard
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.6).Parent = TextboxCard
            CreateDropShadow(TextboxCard, 2)
            
            local TextboxTitle = Instance.new("TextLabel")
            TextboxTitle.Parent = TextboxCard
            TextboxTitle.BackgroundTransparency = 1
            TextboxTitle.Position = UDim2.new(0, 20, 0, 12)
            TextboxTitle.Size = UDim2.new(0.4, 0, 0, 20)
            TextboxTitle.Font = Enum.Font.GothamMedium
            TextboxTitle.Text = textboxConfig.Name
            TextboxTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            TextboxTitle.TextSize = 14
            TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left
            TextboxTitle.ZIndex = 8
            
            if textboxConfig.Description ~= "" then
                local TextboxDesc = Instance.new("TextLabel")
                TextboxDesc.Parent = TextboxCard
                TextboxDesc.BackgroundTransparency = 1
                TextboxDesc.Position = UDim2.new(0, 20, 0, 32)
                TextboxDesc.Size = UDim2.new(0.4, 0, 0, 15)
                TextboxDesc.Font = Enum.Font.Gotham
                TextboxDesc.Text = textboxConfig.Description
                TextboxDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
                TextboxDesc.TextSize = 11
                TextboxDesc.TextXAlignment = Enum.TextXAlignment.Left
                TextboxDesc.ZIndex = 8
            end
            
            local Textbox = Instance.new("TextBox")
            Textbox.Name = "Textbox"
            Textbox.Parent = TextboxCard
            Textbox.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumBrush
            Textbox.BorderSizePixel = 0
            Textbox.Position = UDim2.new(0.5, 10, 0, 22)
            Textbox.Size = UDim2.new(0.5, -30, 0, 36)
            Textbox.Font = Enum.Font.GothamMedium
            Textbox.PlaceholderText = textboxConfig.PlaceholderText
            Textbox.PlaceholderColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseLowBrush
            Textbox.Text = ""
            Textbox.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            Textbox.TextSize = 12
            Textbox.ZIndex = 8
            
            CreateCorner(6).Parent = Textbox
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.5).Parent = Textbox
            
            Textbox.Focused:Connect(function()
                SmoothTween(Textbox:FindFirstChild("UIStroke"), {
                    Color = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush,
                    Transparency = 0
                }, 0.2)
            end)
            
            Textbox.FocusLost:Connect(function(enterPressed)
                SmoothTween(Textbox:FindFirstChild("UIStroke"), {
                    Color = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush,
                    Transparency = 0.5
                }, 0.2)
                
                if enterPressed then
                    local success, err = pcall(textboxConfig.Callback, Textbox.Text)
                    if not success then
                        FluentUI:Notify({
                            Title = "Error",
                            Description = "Textbox error: " .. tostring(err),
                            Type = "Error"
                        })
                    end
                end
            end)
            
            self:UpdateCanvasSize()
            return TextboxCard
        end
        
        function TabObject:CreateKeybind(config)
            config = config or {}
            
            local keybindConfig = {
                Name = config.Name or "Keybind",
                Description = config.Description or "",
                Default = config.Default or Enum.KeyCode.E,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 90
            self.ElementCount = self.ElementCount + 1
            
            local KeybindCard = Instance.new("Frame")
            KeybindCard.Name = "KeybindCard_" .. keybindConfig.Name
            KeybindCard.Parent = self.Content
            KeybindCard.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            KeybindCard.BackgroundTransparency = 0.2
            KeybindCard.BorderSizePixel = 0
            KeybindCard.Position = UDim2.new(0, 0, 0, yPos)
            KeybindCard.Size = UDim2.new(1, -8, 0, 80)
            KeybindCard.ZIndex = 7
            
            CreateCorner(8).Parent = KeybindCard
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.6).Parent = KeybindCard
            CreateDropShadow(KeybindCard, 2)
            
            local KeybindTitle = Instance.new("TextLabel")
            KeybindTitle.Parent = KeybindCard
            KeybindTitle.BackgroundTransparency = 1
            KeybindTitle.Position = UDim2.new(0, 20, 0, 18)
            KeybindTitle.Size = UDim2.new(0.6, 0, 0, 24)
            KeybindTitle.Font = Enum.Font.GothamMedium
            KeybindTitle.Text = keybindConfig.Name
            KeybindTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            KeybindTitle.TextSize = 14
            KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left
            KeybindTitle.ZIndex = 8
            
            if keybindConfig.Description ~= "" then
                local KeybindDesc = Instance.new("TextLabel")
                KeybindDesc.Parent = KeybindCard
                KeybindDesc.BackgroundTransparency = 1
                KeybindDesc.Position = UDim2.new(0, 20, 0, 42)
                KeybindDesc.Size = UDim2.new(0.6, 0, 0, 20)
                KeybindDesc.Font = Enum.Font.Gotham
                KeybindDesc.Text = keybindConfig.Description
                KeybindDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
                KeybindDesc.TextSize = 11
                KeybindDesc.TextXAlignment = Enum.TextXAlignment.Left
                KeybindDesc.ZIndex = 8
            end
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Name = "KeybindButton"
            KeybindButton.Parent = KeybindCard
            KeybindButton.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumBrush
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Position = UDim2.new(1, -100, 0, 22)
            KeybindButton.Size = UDim2.new(0, 85, 0, 36)
            KeybindButton.Font = Enum.Font.GothamMedium
            KeybindButton.Text = keybindConfig.Default.Name
            KeybindButton.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            KeybindButton.TextSize = 12
            KeybindButton.ZIndex = 8
            
            CreateCorner(6).Parent = KeybindButton
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.5).Parent = KeybindButton
            CreateRevealEffect(KeybindButton)
            CreatePressAnimation(KeybindButton)
            
            local currentKey = keybindConfig.Default
            local listening = false
            
            KeybindButton.MouseButton1Click:Connect(function()
                if listening then return end
                
                listening = true
                KeybindButton.Text = "Press key..."
                KeybindButton.TextColor3 = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush
                PlaySound("Click", 0.05, 1.2)
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        KeybindButton.Text = input.KeyCode.Name
                        KeybindButton.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
                        listening = false
                        connection:Disconnect()
                        
                        PlaySound("Success", 0.05, 1.1)
                    end
                end)
            end)
            
            -- Bind the keybind functionality
            local keybindConnection
            keybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.KeyCode == currentKey then
                    local success, err = pcall(keybindConfig.Callback)
                    if not success then
                        FluentUI:Notify({
                            Title = "Error", 
                            Description = "Keybind error: " .. tostring(err),
                            Type = "Error"
                        })
                    end
                end
            end)
            
            table.insert(FluentUI.Connections, keybindConnection)
            
            self:UpdateCanvasSize()
            return KeybindCard
        end
        
        function TabObject:CreateColorPicker(config)
            config = config or {}
            
            local colorConfig = {
                Name = config.Name or "Color Picker",
                Description = config.Description or "",
                Default = config.Default or Color3.fromRGB(255, 255, 255),
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 90
            self.ElementCount = self.ElementCount + 1
            
            local ColorCard = Instance.new("Frame")
            ColorCard.Name = "ColorCard_" .. colorConfig.Name
            ColorCard.Parent = self.Content
            ColorCard.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            ColorCard.BackgroundTransparency = 0.2
            ColorCard.BorderSizePixel = 0
            ColorCard.Position = UDim2.new(0, 0, 0, yPos)
            ColorCard.Size = UDim2.new(1, -8, 0, 80)
            ColorCard.ZIndex = 7
            
            CreateCorner(8).Parent = ColorCard
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.6).Parent = ColorCard
            CreateDropShadow(ColorCard, 2)
            
            local ColorTitle = Instance.new("TextLabel")
            ColorTitle.Parent = ColorCard
            ColorTitle.BackgroundTransparency = 1
            ColorTitle.Position = UDim2.new(0, 20, 0, 18)
            ColorTitle.Size = UDim2.new(0.6, 0, 0, 24)
            ColorTitle.Font = Enum.Font.GothamMedium
            ColorTitle.Text = colorConfig.Name
            ColorTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            ColorTitle.TextSize = 14
            ColorTitle.TextXAlignment = Enum.TextXAlignment.Left
            ColorTitle.ZIndex = 8
            
            if colorConfig.Description ~= "" then
                local ColorDesc = Instance.new("TextLabel")
                ColorDesc.Parent = ColorCard
                ColorDesc.BackgroundTransparency = 1
                ColorDesc.Position = UDim2.new(0, 20, 0, 42)
                ColorDesc.Size = UDim2.new(0.6, 0, 0, 20)
                ColorDesc.Font = Enum.Font.Gotham
                ColorDesc.Text = colorConfig.Description
                ColorDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
                ColorDesc.TextSize = 11
                ColorDesc.TextXAlignment = Enum.TextXAlignment.Left
                ColorDesc.ZIndex = 8
            end
            
            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Name = "ColorDisplay"
            ColorDisplay.Parent = ColorCard
            ColorDisplay.BackgroundColor3 = colorConfig.Default
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Position = UDim2.new(1, -85, 0, 22)
            ColorDisplay.Size = UDim2.new(0, 70, 0, 36)
            ColorDisplay.ZIndex = 8
            
            CreateCorner(6).Parent = ColorDisplay
            CreateStroke(2, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumLowBrush, 0.3).Parent = ColorDisplay
            CreateDropShadow(ColorDisplay, 2)
            
            local ColorButton = Instance.new("TextButton")
            ColorButton.Name = "ColorButton"
            ColorButton.Parent = ColorDisplay
            ColorButton.BackgroundTransparency = 1
            ColorButton.Size = UDim2.new(1, 0, 1, 0)
            ColorButton.Text = ""
            ColorButton.ZIndex = 9
            
            CreateRevealEffect(ColorButton)
            CreatePressAnimation(ColorButton)
            
            local currentColor = colorConfig.Default
            
            ColorButton.MouseButton1Click:Connect(function()
                PlaySound("Click", 0.05, 1.1)
                
                -- Simple color randomizer for demo (in real implementation, you'd want a full color picker)
                local newColor = Color3.fromRGB(
                    math.random(0, 255),
                    math.random(0, 255), 
                    math.random(0, 255)
                )
                
                currentColor = newColor
                SmoothTween(ColorDisplay, {BackgroundColor3 = newColor}, 0.3)
                
                local success, err = pcall(colorConfig.Callback, newColor)
                if not success then
                    FluentUI:Notify({
                        Title = "Error",
                        Description = "Color picker error: " .. tostring(err),
                        Type = "Error"
                    })
                end
            end)
            
            self:UpdateCanvasSize()
            return ColorCard
        end
        
        function TabObject:CreateLabel(config)
            config = config or {}
            
            local labelConfig = {
                Name = config.Name or "Label",
                Description = config.Description or ""
            }
            
            local yPos = self.ElementCount * 90
            self.ElementCount = self.ElementCount + 1
            
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "Label_" .. labelConfig.Name
            LabelFrame.Parent = self.Content
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.Position = UDim2.new(0, 0, 0, yPos)
            LabelFrame.Size = UDim2.new(1, 0, 0, 60)
            LabelFrame.ZIndex = 7
            
            local LabelTitle = Instance.new("TextLabel")
            LabelTitle.Parent = LabelFrame
            LabelTitle.BackgroundTransparency = 1
            LabelTitle.Position = UDim2.new(0, 0, 0, 10)
            LabelTitle.Size = UDim2.new(1, 0, 0, 24)
            LabelTitle.Font = Enum.Font.GothamBold
            LabelTitle.Text = labelConfig.Name
            LabelTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            LabelTitle.TextSize = 16
            LabelTitle.TextXAlignment = Enum.TextXAlignment.Left
            LabelTitle.ZIndex = 8
            
            if labelConfig.Description ~= "" then
                local LabelDesc = Instance.new("TextLabel")
                LabelDesc.Parent = LabelFrame
                LabelDesc.BackgroundTransparency = 1
                LabelDesc.Position = UDim2.new(0, 0, 0, 34)
                LabelDesc.Size = UDim2.new(1, 0, 0, 20)
                LabelDesc.Font = Enum.Font.Gotham
                LabelDesc.Text = labelConfig.Description
                LabelDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
                LabelDesc.TextSize = 12
                LabelDesc.TextXAlignment = Enum.TextXAlignment.Left
                LabelDesc.TextWrapped = true
                LabelDesc.ZIndex = 8
            end
            
            self:UpdateCanvasSize()
            return LabelFrame
        end
        
        function TabObject:UpdateCanvasSize()
            local contentSize = self.ElementCount * 95 + 24
            SmoothTween(self.Content, {CanvasSize = UDim2.new(0, 0, 0, contentSize)}, 0.2)
        end
        
        CreateRevealEffect(NavButton)
        
        NavButton.MouseButton1Click:Connect(function()
            TabObject:Activate()
        end)
        
        self.Tabs[tabConfig.Name] = TabObject
        
        if self.TabCount == 1 then
            TabObject:Activate()
        end
        
        self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, self.TabCount * 44 + 8)
        
        return TabObject
    end
    
    CloseBtn.MouseButton1Click:Connect(function()
        WindowObject:Destroy()
    end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        WindowObject:Minimize()
    end)
    
    if windowConfig.Draggable then
        local dragging = false
        local dragStart = nil
        local startPos = nil
        
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Container.Position
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
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == windowConfig.KeyBind then
            WindowObject:Toggle()
        end
    end)
    
    BackgroundOverlay.BackgroundTransparency = 1
    Container.Size = UDim2.new(0, 0, 0, 0)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundTransparency = 1
    
    wait(0.1)
    
    SmoothTween(Container, {
        Size = windowConfig.Size,
        Position = UDim2.new(0.5, -windowConfig.Size.X.Offset/2, 0.5, -windowConfig.Size.Y.Offset/2)
    }, 0.5, Enum.EasingStyle.Back)
    
    SmoothTween(MainFrame, {BackgroundTransparency = 0.1}, 0.3)
    SmoothTween(BackgroundOverlay, {BackgroundTransparency = 0.3}, 0.3)
    
    PlaySound("Success", 0.1, 1.2)
    
    table.insert(FluentUI.Windows, WindowObject)
    return WindowObject
end

function FluentUI:Notify(config)
    config = config or {}
    
    local notifConfig = {
        Title = config.Title or "Notification",
        Description = config.Description or "No description provided",
        Duration = config.Duration or 4,
        Type = config.Type or "Info"
    }
    
    local typeIcons = {
        Info = "ℹ",
        Success = "✓", 
        Warning = "⚠",
        Error = "✕"
    }
    
    local typeColors = {
        Info = FluentUI.CurrentTheme.SystemControlHighlightAccentBrush,
        Success = FluentUI.CurrentTheme.SystemFillColorSuccess,
        Warning = FluentUI.CurrentTheme.SystemFillColorCaution,
        Error = FluentUI.CurrentTheme.SystemFillColorCritical
    }
    
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "FluentNotification"
    NotifGui.Parent = GuiParent
    NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local NotifCard = Instance.new("Frame")
    NotifCard.Parent = NotifGui
    NotifCard.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
    NotifCard.BackgroundTransparency = 0.1
    NotifCard.BorderSizePixel = 0
    NotifCard.Position = UDim2.new(1, 20, 1, -110 - (#FluentUI.Notifications * 120))
    NotifCard.Size = UDim2.new(0, 400, 0, 100)
    NotifCard.ZIndex = 100
    
    CreateCorner(8).Parent = NotifCard
    CreateStroke(1, typeColors[notifConfig.Type] or typeColors.Info, 0.4).Parent = NotifCard
    CreateDropShadow(NotifCard, 6)
    CreateAcrylicEffect(NotifCard)
    
    local NotifIcon = Instance.new("TextLabel")
    NotifIcon.Parent = NotifCard
    NotifIcon.BackgroundTransparency = 1
    NotifIcon.Position = UDim2.new(0, 20, 0, 20)
    NotifIcon.Size = UDim2.new(0, 30, 0, 30)
    NotifIcon.Font = Enum.Font.GothamBold
    NotifIcon.Text = typeIcons[notifConfig.Type] or typeIcons.Info
    NotifIcon.TextColor3 = typeColors[notifConfig.Type] or typeColors.Info
    NotifIcon.TextSize = 18
    NotifIcon.ZIndex = 101
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = NotifCard
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 60, 0, 15)
    NotifTitle.Size = UDim2.new(1, -80, 0, 25)
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = notifConfig.Title
    NotifTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
    NotifTitle.TextSize = 14
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.TextTruncate = Enum.TextTruncate.AtEnd
    NotifTitle.ZIndex = 101
    
    local NotifDesc = Instance.new("TextLabel")
    NotifDesc.Parent = NotifCard
    NotifDesc.BackgroundTransparency = 1
    NotifDesc.Position = UDim2.new(0, 60, 0, 40)
    NotifDesc.Size = UDim2.new(1, -80, 0, 45)
    NotifDesc.Font = Enum.Font.Gotham
    NotifDesc.Text = notifConfig.Description
    NotifDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
    NotifDesc.TextSize = 12
    NotifDesc.TextXAlignment = Enum.TextXAlignment.Left
    NotifDesc.TextWrapped = true
    NotifDesc.TextYAlignment = Enum.TextYAlignment.Top
    NotifDesc.ZIndex = 101
    
    local CloseNotifBtn = Instance.new("TextButton")
    CloseNotifBtn.Parent = NotifCard
    CloseNotifBtn.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumBrush
    CloseNotifBtn.BackgroundTransparency = 1
    CloseNotifBtn.BorderSizePixel = 0
    CloseNotifBtn.Position = UDim2.new(1, -35, 0, 10)
    CloseNotifBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseNotifBtn.Font = Enum.Font.GothamMedium
    CloseNotifBtn.Text = "×"
    CloseNotifBtn.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumHighBrush
    CloseNotifBtn.TextSize = 14
    CloseNotifBtn.ZIndex = 102
    
    CreateCorner(6).Parent = CloseNotifBtn
    CreateRevealEffect(CloseNotifBtn)
    
    CloseNotifBtn.MouseButton1Click:Connect(function()
        SmoothTween(NotifCard, {
            Position = UDim2.new(1, 20, NotifCard.Position.Y.Scale, NotifCard.Position.Y.Offset),
            Size = UDim2.new(0, 0, 0, 100)
        }, 0.3, nil, nil, function()
            for i, notif in ipairs(FluentUI.Notifications) do
                if notif == NotifGui then
                    table.remove(FluentUI.Notifications, i)
                    break
                end
            end
            NotifGui:Destroy()
        end)
    end)
    
    table.insert(FluentUI.Notifications, NotifGui)
    
    SmoothTween(NotifCard, {
        Position = UDim2.new(1, -410, 1, -110 - ((#FluentUI.Notifications-1) * 120))
    }, 0.4, Enum.EasingStyle.Back)
    
    PlaySound(notifConfig.Type == "Error" and "Error" or "Success", 0.08, 1.1)
    
    spawn(function()
        wait(notifConfig.Duration)
        if NotifGui.Parent then
            CloseNotifBtn.MouseButton1Click:Fire()
        end
    end)
end

function FluentUI:SetTheme(themeName)
    if FluentUI.Themes[themeName] then
        FluentUI.CurrentTheme = FluentUI.Themes[themeName]
        
        self:Notify({
            Title = "Theme Changed",
            Description = "Successfully changed to " .. themeName .. " theme",
            Type = "Success"
        })
    end
end

function FluentUI:Cleanup()
    for _, connection in pairs(FluentUI.Connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif typeof(connection) == "Tween" then
            connection:Cancel()
        end
    end
    
    FluentUI.Connections = {}
    
    for _, window in pairs(FluentUI.Windows) do
        window:Destroy()
    end
    
    FluentUI.Windows = {}
    FluentUI.Notifications = {}
end

return FluentUI
