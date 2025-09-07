-- Microsoft Fluent Design UI Library - Complete Implementation
-- Recreating the exact look and feel from Microsoft's Fluent UI

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
    AnimationSpeed = 0.2,
    SoundEffects = true,
    AcrylicBlur = true,
    RevealEffect = true,
    CornerRadius = 6,
    ElevationShadows = true
}

-- Authentic Microsoft Fluent Design Colors
FluentUI.Themes = {
    Light = {
        Name = "Light",
        
        -- Backgrounds
        ApplicationPageBackgroundThemeBrush = Color3.fromRGB(243, 243, 243),
        SystemControlPageBackgroundChromeLowBrush = Color3.fromRGB(255, 255, 255),
        SystemControlPageBackgroundChromeMediumLowBrush = Color3.fromRGB(249, 249, 249),
        SystemControlPageBackgroundChromeMediumBrush = Color3.fromRGB(243, 243, 243),
        SystemControlPageBackgroundChromeHighBrush = Color3.fromRGB(230, 230, 230),
        
        -- Cards and surfaces
        SystemControlBackgroundChromeMediumLowBrush = Color3.fromRGB(243, 243, 243),
        SystemControlBackgroundChromeMediumBrush = Color3.fromRGB(237, 237, 237),
        SystemControlBackgroundChromeHighBrush = Color3.fromRGB(204, 204, 204),
        
        -- Navigation
        NavigationViewExpandedPaneBackground = Color3.fromRGB(249, 249, 249),
        NavigationViewDefaultPaneBackground = Color3.fromRGB(249, 249, 249),
        
        -- Text colors
        SystemControlForegroundBaseHighBrush = Color3.fromRGB(0, 0, 0),
        SystemControlForegroundBaseMediumHighBrush = Color3.fromRGB(68, 68, 68),
        SystemControlForegroundBaseMediumBrush = Color3.fromRGB(113, 113, 113),
        SystemControlForegroundBaseLowBrush = Color3.fromRGB(151, 151, 151),
        
        -- Accent colors
        SystemAccentColor = Color3.fromRGB(0, 120, 215),
        SystemAccentColorLight1 = Color3.fromRGB(64, 156, 255),
        SystemAccentColorLight2 = Color3.fromRGB(153, 209, 255),
        SystemAccentColorDark1 = Color3.fromRGB(0, 99, 177),
        
        -- Control colors
        SystemControlHighlightAccentBrush = Color3.fromRGB(0, 120, 215),
        SystemControlHighlightTransparentBrush = Color3.fromRGB(0, 0, 0),
        
        -- System colors
        SystemFillColorSuccess = Color3.fromRGB(16, 124, 16),
        SystemFillColorCaution = Color3.fromRGB(157, 93, 0),
        SystemFillColorCritical = Color3.fromRGB(196, 43, 28),
        
        -- Shadow
        Shadow = Color3.fromRGB(0, 0, 0)
    },
    
    Dark = {
        Name = "Dark",
        
        -- Backgrounds - Exact Microsoft Dark Theme Colors
        ApplicationPageBackgroundThemeBrush = Color3.fromRGB(32, 32, 32),
        SystemControlPageBackgroundChromeLowBrush = Color3.fromRGB(44, 44, 44),
        SystemControlPageBackgroundChromeMediumLowBrush = Color3.fromRGB(40, 40, 40),
        SystemControlPageBackgroundChromeMediumBrush = Color3.fromRGB(35, 35, 35),
        SystemControlPageBackgroundChromeHighBrush = Color3.fromRGB(30, 30, 30),
        
        -- Cards and surfaces
        SystemControlBackgroundChromeMediumLowBrush = Color3.fromRGB(58, 58, 58),
        SystemControlBackgroundChromeMediumBrush = Color3.fromRGB(65, 65, 65),
        SystemControlBackgroundChromeHighBrush = Color3.fromRGB(76, 76, 76),
        
        -- Navigation
        NavigationViewExpandedPaneBackground = Color3.fromRGB(44, 44, 44),
        NavigationViewDefaultPaneBackground = Color3.fromRGB(44, 44, 44),
        
        -- Text colors
        SystemControlForegroundBaseHighBrush = Color3.fromRGB(255, 255, 255),
        SystemControlForegroundBaseMediumHighBrush = Color3.fromRGB(204, 204, 204),
        SystemControlForegroundBaseMediumBrush = Color3.fromRGB(151, 151, 151),
        SystemControlForegroundBaseLowBrush = Color3.fromRGB(113, 113, 113),
        
        -- Accent colors
        SystemAccentColor = Color3.fromRGB(96, 205, 255),
        SystemAccentColorLight1 = Color3.fromRGB(118, 214, 255),
        SystemAccentColorLight2 = Color3.fromRGB(153, 235, 255),
        SystemAccentColorDark1 = Color3.fromRGB(64, 156, 255),
        
        -- Control colors
        SystemControlHighlightAccentBrush = Color3.fromRGB(96, 205, 255),
        SystemControlHighlightTransparentBrush = Color3.fromRGB(255, 255, 255),
        
        -- System colors
        SystemFillColorSuccess = Color3.fromRGB(108, 203, 95),
        SystemFillColorCaution = Color3.fromRGB(252, 225, 0),
        SystemFillColorCritical = Color3.fromRGB(255, 153, 164),
        
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
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = Sounds[soundName] or Sounds.Click
            sound.Volume = volume or 0.3
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
    stroke.Color = color or FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
    stroke.Transparency = transparency or 0.8
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
    shadow.ImageTransparency = 0.9 - (elevation * 0.02)
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

-- Microsoft-style Reveal Effect
local function CreateRevealEffect(button)
    if not FluentUI.Config.RevealEffect then return end
    
    local connection
    connection = button.MouseEnter:Connect(function()
        local reveal = Instance.new("Frame")
        reveal.Name = "RevealEffect" 
        reveal.Parent = button
        reveal.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlHighlightTransparentBrush
        reveal.BackgroundTransparency = 0.95
        reveal.BorderSizePixel = 0
        reveal.Size = UDim2.new(1, 0, 1, 0)
        reveal.ZIndex = button.ZIndex + 1
        
        CreateCorner(FluentUI.Config.CornerRadius).Parent = reveal
        
        SmoothTween(reveal, {BackgroundTransparency = 0.9}, 0.15)
        
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
            PlaySound("Click", 0.3, 1.05)
            
            SmoothTween(button, {
                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 1, button.Size.Y.Scale, button.Size.Y.Offset - 1)
            }, 0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                SmoothTween(button, {
                    Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 1, button.Size.Y.Scale, button.Size.Y.Offset + 1)
                }, 0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
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
    acrylic.BackgroundTransparency = 0.3
    acrylic.BorderSizePixel = 0
    acrylic.Size = UDim2.new(1, 0, 1, 0)
    acrylic.ZIndex = frame.ZIndex - 1
    
    CreateCorner(FluentUI.Config.CornerRadius).Parent = acrylic
    
    return acrylic
end

-- Window Creation matching Microsoft Fluent UI exactly
function FluentUI:CreateWindow(config)
    config = config or {}
    
    local windowConfig = {
        Title = config.Title or "Fluent 110",
        Subtitle = config.Subtitle or "by dawid",
        Size = config.Size or UDim2.new(0, 580, 0, 460),
        Theme = config.Theme or "Dark",
        KeyBind = config.KeyBind or Enum.KeyCode.Insert,
        Draggable = config.Draggable ~= false
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
    BackgroundOverlay.BackgroundTransparency = 0.4
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
    
    -- Main Frame with exact Microsoft styling
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Container
    MainFrame.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlPageBackgroundChromeLowBrush
    MainFrame.BackgroundTransparency = 0
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.ZIndex = 3
    
    CreateCorner(8).Parent = MainFrame
    CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.8).Parent = MainFrame
    CreateDropShadow(MainFrame, 10)
    
    -- Title Bar - Exact Microsoft style
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlPageBackgroundChromeLowBrush
    TitleBar.BackgroundTransparency = 0
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.ZIndex = 4
    
    -- Title and subtitle exactly like Microsoft
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 20, 0, 8)
    TitleLabel.Size = UDim2.new(0.6, 0, 0, 16)
    TitleLabel.Font = Enum.Font.Gotham
    TitleLabel.Text = windowConfig.Title
    TitleLabel.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 5
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Parent = TitleBar
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Position = UDim2.new(0, 20, 0, 22)
    SubtitleLabel.Size = UDim2.new(0.6, 0, 0, 12)
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.Text = windowConfig.Subtitle
    SubtitleLabel.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
    SubtitleLabel.TextSize = 10
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 5
    
    -- Window Controls - Microsoft style
    local WindowControls = Instance.new("Frame")
    WindowControls.Name = "WindowControls"
    WindowControls.Parent = TitleBar
    WindowControls.BackgroundTransparency = 1
    WindowControls.Position = UDim2.new(1, -120, 0, 8)
    WindowControls.Size = UDim2.new(0, 112, 0, 24)
    WindowControls.ZIndex = 5
    
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "Minimize"
    MinimizeBtn.Parent = WindowControls
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    MinimizeBtn.Size = UDim2.new(0, 32, 0, 24)
    MinimizeBtn.Font = Enum.Font.Gotham
    MinimizeBtn.Text = "─"
    MinimizeBtn.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
    MinimizeBtn.TextSize = 10
    MinimizeBtn.ZIndex = 6
    
    CreateCorner(4).Parent = MinimizeBtn
    CreateRevealEffect(MinimizeBtn)
    CreatePressAnimation(MinimizeBtn)
    
    local MaximizeBtn = Instance.new("TextButton")
    MaximizeBtn.Name = "Maximize"
    MaximizeBtn.Parent = WindowControls
    MaximizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MaximizeBtn.BackgroundTransparency = 1
    MaximizeBtn.BorderSizePixel = 0
    MaximizeBtn.Position = UDim2.new(0, 36, 0, 0)
    MaximizeBtn.Size = UDim2.new(0, 32, 0, 24)
    MaximizeBtn.Font = Enum.Font.Gotham
    MaximizeBtn.Text = "🗖"
    MaximizeBtn.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
    MaximizeBtn.TextSize = 8
    MaximizeBtn.ZIndex = 6
    
    CreateCorner(4).Parent = MaximizeBtn
    CreateRevealEffect(MaximizeBtn)
    CreatePressAnimation(MaximizeBtn)
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Parent = WindowControls
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(0, 72, 0, 0)
    CloseBtn.Size = UDim2.new(0, 32, 0, 24)
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
    CloseBtn.TextSize = 10
    CloseBtn.ZIndex = 6
    
    CreateCorner(4).Parent = CloseBtn
    
    -- Special hover effect for close button
    CloseBtn.MouseEnter:Connect(function()
        SmoothTween(CloseBtn, {
            BackgroundColor3 = Color3.fromRGB(232, 17, 35),
            BackgroundTransparency = 0
        }, 0.15)
        SmoothTween(CloseBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        SmoothTween(CloseBtn, {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1
        }, 0.15)
        SmoothTween(CloseBtn, {TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush}, 0.15)
    end)
    
    CreatePressAnimation(CloseBtn)
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    ContentFrame.ZIndex = 4
    
    -- Navigation Pane - Microsoft style
    local NavPane = Instance.new("Frame")
    NavPane.Name = "NavigationPane"
    NavPane.Parent = ContentFrame
    NavPane.BackgroundColor3 = FluentUI.CurrentTheme.NavigationViewExpandedPaneBackground
    NavPane.BackgroundTransparency = 0
    NavPane.BorderSizePixel = 0
    NavPane.Size = UDim2.new(0, 180, 1, 0)
    NavPane.ZIndex = 5
    
    CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.9).Parent = NavPane
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = NavPane
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 8)
    TabContainer.Size = UDim2.new(1, 0, 1, -16)
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = FluentUI.CurrentTheme.SystemAccentColor
    TabContainer.ScrollBarImageTransparency = 0.6
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ZIndex = 6
    
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.Parent = ContentFrame
    MainContent.BackgroundTransparency = 1
    MainContent.Position = UDim2.new(0, 180, 0, 0)
    MainContent.Size = UDim2.new(1, -180, 1, 0)
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
            }, 0.4, Enum.EasingStyle.Back)
            
            SmoothTween(self.MainFrame, {BackgroundTransparency = 0}, 0.3)
            SmoothTween(self.BackgroundOverlay, {BackgroundTransparency = 0.4}, 0.3)
            
            PlaySound("Success", 0.4, 1.1)
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
        PlaySound("Navigation", 0.3, 0.9)
        
        local targetSize = self.Minimized and UDim2.new(0, windowConfig.Size.X.Offset, 0, 40) or windowConfig.Size
        
        SmoothTween(self.Container, {Size = targetSize}, 0.3, Enum.EasingStyle.Cubic)
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
        
        PlaySound("Click", 0.3, 0.8)
        
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
            Icon = config.Icon or ""
        }
        
        self.TabCount = self.TabCount + 1
        local tabIndex = self.TabCount
        
        -- Navigation Item - Microsoft style
        local NavItem = Instance.new("Frame")
        NavItem.Name = "NavItem_" .. tabConfig.Name
        NavItem.Parent = self.TabContainer
        NavItem.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NavItem.BackgroundTransparency = 1
        NavItem.BorderSizePixel = 0
        NavItem.Position = UDim2.new(0, 0, 0, (tabIndex - 1) * 36)
        NavItem.Size = UDim2.new(1, 0, 0, 32)
        NavItem.ZIndex = 7
        
        CreateCorner(4).Parent = NavItem
        
        local NavButton = Instance.new("TextButton")
        NavButton.Name = "NavButton"
        NavButton.Parent = NavItem
        NavButton.BackgroundTransparency = 1
        NavButton.Size = UDim2.new(1, 0, 1, 0)
        NavButton.Font = Enum.Font.Gotham
        NavButton.Text = ""
        NavButton.ZIndex = 8
        
        -- Selection Indicator - Blue accent bar on left
        local SelectionIndicator = Instance.new("Frame")
        SelectionIndicator.Name = "SelectionIndicator"
        SelectionIndicator.Parent = NavItem
        SelectionIndicator.BackgroundColor3 = FluentUI.CurrentTheme.SystemAccentColor
        SelectionIndicator.BorderSizePixel = 0
        SelectionIndicator.Position = UDim2.new(0, 0, 0, 0)
        SelectionIndicator.Size = UDim2.new(0, 0, 1, 0)
        SelectionIndicator.ZIndex = 9
        
        -- Tab Icon and Text
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Name = "Icon"
        TabIcon.Parent = NavItem
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 16, 0, 0)
        TabIcon.Size = UDim2.new(0, 16, 1, 0)
        TabIcon.Font = Enum.Font.Gotham
        TabIcon.Text = tabConfig.Icon
        TabIcon.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
        TabIcon.TextSize = 12
        TabIcon.TextXAlignment = Enum.TextXAlignment.Center
        TabIcon.ZIndex = 8
        
        local TabText = Instance.new("TextLabel")
        TabText.Name = "Text"
        TabText.Parent = NavItem
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, 40, 0, 0)
        TabText.Size = UDim2.new(1, -48, 1, 0)
        TabText.Font = Enum.Font.Gotham
        TabText.Text = tabConfig.Name
        TabText.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
        TabText.TextSize = 12
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.ZIndex = 8
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. tabConfig.Name
        TabContent.Parent = self.MainContent
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, 24, 0, 24)
        TabContent.Size = UDim2.new(1, -48, 1, -48)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = FluentUI.CurrentTheme.SystemAccentColor
        TabContent.ScrollBarImageTransparency = 0.6
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.ZIndex = 6
        
        -- Page Title like Microsoft
        local PageTitle = Instance.new("TextLabel")
        PageTitle.Name = "PageTitle"
        PageTitle.Parent = TabContent
        PageTitle.BackgroundTransparency = 1
        PageTitle.Position = UDim2.new(0, 0, 0, 0)
        PageTitle.Size = UDim2.new(1, 0, 0, 40)
        PageTitle.Font = Enum.Font.GothamBold
        PageTitle.Text = tabConfig.Name
        PageTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
        PageTitle.TextSize = 24
        PageTitle.TextXAlignment = Enum.TextXAlignment.Left
        PageTitle.ZIndex = 7
        
        local TabObject = {
            NavItem = NavItem,
            NavButton = NavButton,
            SelectionIndicator = SelectionIndicator,
            Icon = TabIcon,
            Text = TabText,
            Content = TabContent,
            PageTitle = PageTitle,
            Config = tabConfig,
            Active = false,
            ElementCount = 1 -- Start at 1 because of PageTitle
        }
        
        function TabObject:Activate()
            if self.Active then return end
            
            PlaySound("Navigation", 0.3, 1.05)
            
            for _, tab in pairs(WindowObject.Tabs) do
                if tab.Active then
                    tab:Deactivate()
                end
            end
            
            self.Active = true
            WindowObject.CurrentTab = self
            
            SmoothTween(self.NavItem, {BackgroundTransparency = 0.9}, 0.15)
            SmoothTween(self.SelectionIndicator, {Size = UDim2.new(0, 3, 1, 0)}, 0.2, Enum.EasingStyle.Cubic)
            SmoothTween(self.Icon, {TextColor3 = FluentUI.CurrentTheme.SystemAccentColor}, 0.15)
            SmoothTween(self.Text, {TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush}, 0.15)
            
            self.Content.Visible = true
        end
        
        function TabObject:Deactivate()
            self.Active = false
            
            SmoothTween(self.NavItem, {BackgroundTransparency = 1}, 0.15)
            SmoothTween(self.SelectionIndicator, {Size = UDim2.new(0, 0, 1, 0)}, 0.15)
            SmoothTween(self.Icon, {TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush}, 0.15)
            SmoothTween(self.Text, {TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush}, 0.15)
            
            self.Content.Visible = false
        end
        
        -- Microsoft-style UI Elements
        
        function TabObject:CreateParagraph(config)
            config = config or {}
            
            local paragraphConfig = {
                Title = config.Title or "Paragraph",
                Content = config.Content or "This is a paragraph\nSecond line!"
            }
            
            local yPos = self.ElementCount * 64 + 40
            self.ElementCount = self.ElementCount + 1
            
            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Name = "Paragraph_" .. paragraphConfig.Title
            ParagraphFrame.Parent = self.Content
            ParagraphFrame.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            ParagraphFrame.BackgroundTransparency = 0
            ParagraphFrame.BorderSizePixel = 0
            ParagraphFrame.Position = UDim2.new(0, 0, 0, yPos)
            ParagraphFrame.Size = UDim2.new(1, -12, 0, 56)
            ParagraphFrame.ZIndex = 7
            
            CreateCorner(6).Parent = ParagraphFrame
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.9).Parent = ParagraphFrame
            
            local ParagraphTitle = Instance.new("TextLabel")
            ParagraphTitle.Parent = ParagraphFrame
            ParagraphTitle.BackgroundTransparency = 1
            ParagraphTitle.Position = UDim2.new(0, 16, 0, 8)
            ParagraphTitle.Size = UDim2.new(1, -32, 0, 16)
            ParagraphTitle.Font = Enum.Font.GothamMedium
            ParagraphTitle.Text = paragraphConfig.Title
            ParagraphTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            ParagraphTitle.TextSize = 13
            ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphTitle.ZIndex = 8
            
            local ParagraphContent = Instance.new("TextLabel")
            ParagraphContent.Parent = ParagraphFrame
            ParagraphContent.BackgroundTransparency = 1
            ParagraphContent.Position = UDim2.new(0, 16, 0, 26)
            ParagraphContent.Size = UDim2.new(1, -32, 0, 24)
            ParagraphContent.Font = Enum.Font.Gotham
            ParagraphContent.Text = paragraphConfig.Content
            ParagraphContent.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
            ParagraphContent.TextSize = 11
            ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
            ParagraphContent.TextWrapped = true
            ParagraphContent.ZIndex = 8
            
            self:UpdateCanvasSize()
            return ParagraphFrame
        end
        
        function TabObject:CreateButton(config)
            config = config or {}
            
            local buttonConfig = {
                Title = config.Title or "Button",
                Description = config.Description or "Very important button",
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 64 + 40
            self.ElementCount = self.ElementCount + 1
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "Button_" .. buttonConfig.Title
            ButtonFrame.Parent = self.Content
            ButtonFrame.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            ButtonFrame.BackgroundTransparency = 0
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Position = UDim2.new(0, 0, 0, yPos)
            ButtonFrame.Size = UDim2.new(1, -12, 0, 56)
            ButtonFrame.ZIndex = 7
            
            CreateCorner(6).Parent = ButtonFrame
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.9).Parent = ButtonFrame
            
            local ButtonTitle = Instance.new("TextLabel")
            ButtonTitle.Parent = ButtonFrame
            ButtonTitle.BackgroundTransparency = 1
            ButtonTitle.Position = UDim2.new(0, 16, 0, 8)
            ButtonTitle.Size = UDim2.new(0.7, 0, 0, 16)
            ButtonTitle.Font = Enum.Font.GothamMedium
            ButtonTitle.Text = buttonConfig.Title
            ButtonTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            ButtonTitle.TextSize = 13
            ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
            ButtonTitle.ZIndex = 8
            
            local ButtonDesc = Instance.new("TextLabel")
            ButtonDesc.Parent = ButtonFrame
            ButtonDesc.BackgroundTransparency = 1
            ButtonDesc.Position = UDim2.new(0, 16, 0, 26)
            ButtonDesc.Size = UDim2.new(0.7, 0, 0, 24)
            ButtonDesc.Font = Enum.Font.Gotham
            ButtonDesc.Text = buttonConfig.Description
            ButtonDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
            ButtonDesc.TextSize = 11
            ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
            ButtonDesc.TextYAlignment = Enum.TextYAlignment.Top
            ButtonDesc.TextWrapped = true
            ButtonDesc.ZIndex = 8
            
            -- Chevron icon
            local ChevronIcon = Instance.new("TextLabel")
            ChevronIcon.Parent = ButtonFrame
            ChevronIcon.BackgroundTransparency = 1
            ChevronIcon.Position = UDim2.new(1, -32, 0, 0)
            ChevronIcon.Size = UDim2.new(0, 24, 1, 0)
            ChevronIcon.Font = Enum.Font.Gotham
            ChevronIcon.Text = ">"
            ChevronIcon.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
            ChevronIcon.TextSize = 12
            ChevronIcon.ZIndex = 8
            
            local ButtonClickable = Instance.new("TextButton")
            ButtonClickable.Name = "ButtonClickable"
            ButtonClickable.Parent = ButtonFrame
            ButtonClickable.BackgroundTransparency = 1
            ButtonClickable.Size = UDim2.new(1, 0, 1, 0)
            ButtonClickable.Text = ""
            ButtonClickable.ZIndex = 9
            
            CreateRevealEffect(ButtonClickable)
            CreatePressAnimation(ButtonClickable)
            
            ButtonClickable.MouseButton1Click:Connect(function()
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
            return ButtonFrame
        end
        
        function TabObject:CreateToggle(config)
            config = config or {}
            
            local toggleConfig = {
                Title = config.Title or "Toggle",
                Description = config.Description or "",
                Default = config.Default or false,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 64 + 40
            self.ElementCount = self.ElementCount + 1
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle_" .. toggleConfig.Title
            ToggleFrame.Parent = self.Content
            ToggleFrame.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            ToggleFrame.BackgroundTransparency = 0
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Position = UDim2.new(0, 0, 0, yPos)
            ToggleFrame.Size = UDim2.new(1, -12, 0, 56)
            ToggleFrame.ZIndex = 7
            
            CreateCorner(6).Parent = ToggleFrame
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.9).Parent = ToggleFrame
            
            local ToggleTitle = Instance.new("TextLabel")
            ToggleTitle.Parent = ToggleFrame
            ToggleTitle.BackgroundTransparency = 1
            ToggleTitle.Position = UDim2.new(0, 16, 0, 8)
            ToggleTitle.Size = UDim2.new(0.7, 0, 0, 16)
            ToggleTitle.Font = Enum.Font.GothamMedium
            ToggleTitle.Text = toggleConfig.Title
            ToggleTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            ToggleTitle.TextSize = 13
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            ToggleTitle.ZIndex = 8
            
            if toggleConfig.Description ~= "" then
                local ToggleDesc = Instance.new("TextLabel")
                ToggleDesc.Parent = ToggleFrame
                ToggleDesc.BackgroundTransparency = 1
                ToggleDesc.Position = UDim2.new(0, 16, 0, 26)
                ToggleDesc.Size = UDim2.new(0.7, 0, 0, 24)
                ToggleDesc.Font = Enum.Font.Gotham
                ToggleDesc.Text = toggleConfig.Description
                ToggleDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
                ToggleDesc.TextSize = 11
                ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
                ToggleDesc.TextYAlignment = Enum.TextYAlignment.Top
                ToggleDesc.TextWrapped = true
                ToggleDesc.ZIndex = 8
            end
            
            -- Microsoft-style Toggle Switch
            local ToggleSwitch = Instance.new("Frame")
            ToggleSwitch.Name = "ToggleSwitch"
            ToggleSwitch.Parent = ToggleFrame
            ToggleSwitch.BackgroundColor3 = toggleConfig.Default and FluentUI.CurrentTheme.SystemAccentColor or FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
            ToggleSwitch.BorderSizePixel = 0
            ToggleSwitch.Position = UDim2.new(1, -60, 0.5, -10)
            ToggleSwitch.Size = UDim2.new(0, 40, 0, 20)
            ToggleSwitch.ZIndex = 8
            
            CreateCorner(10).Parent = ToggleSwitch
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.7).Parent = ToggleSwitch
            
            local ToggleKnob = Instance.new("Frame")
            ToggleKnob.Name = "ToggleKnob"
            ToggleKnob.Parent = ToggleSwitch
            ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleKnob.BorderSizePixel = 0
            ToggleKnob.Position = UDim2.new(0, toggleConfig.Default and 22 or 2, 0, 2)
            ToggleKnob.Size = UDim2.new(0, 16, 0, 16)
            ToggleKnob.ZIndex = 9
            
            CreateCorner(8).Parent = ToggleKnob
            CreateDropShadow(ToggleKnob, 1)
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = ToggleSwitch
            ToggleButton.BackgroundTransparency = 1
            ToggleButton.Size = UDim2.new(1, 0, 1, 0)
            ToggleButton.Text = ""
            ToggleButton.ZIndex = 10
            
            local isToggled = toggleConfig.Default
            
            ToggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                PlaySound("Click", 0.2, isToggled and 1.1 or 0.9)
                
                SmoothTween(ToggleSwitch, {
                    BackgroundColor3 = isToggled and FluentUI.CurrentTheme.SystemAccentColor or FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
                }, 0.2)
                
                SmoothTween(ToggleKnob, {
                    Position = UDim2.new(0, isToggled and 22 or 2, 0, 2)
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
            return ToggleFrame
        end
        
        function TabObject:CreateSlider(config)
            config = config or {}
            
            local sliderConfig = {
                Title = config.Title or "Slider",
                Description = config.Description or "This is a slider",
                Min = config.Min or 0,
                Max = config.Max or 100,
                Default = config.Default or 50,
                Increment = config.Increment or 1,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 64 + 40
            self.ElementCount = self.ElementCount + 1
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider_" .. sliderConfig.Title
            SliderFrame.Parent = self.Content
            SliderFrame.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            SliderFrame.BackgroundTransparency = 0
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Position = UDim2.new(0, 0, 0, yPos)
            SliderFrame.Size = UDim2.new(1, -12, 0, 56)
            SliderFrame.ZIndex = 7
            
            CreateCorner(6).Parent = SliderFrame
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.9).Parent = SliderFrame
            
            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Parent = SliderFrame
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 16, 0, 8)
            SliderTitle.Size = UDim2.new(0.7, 0, 0, 16)
            SliderTitle.Font = Enum.Font.GothamMedium
            SliderTitle.Text = sliderConfig.Title
            SliderTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            SliderTitle.TextSize = 13
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            SliderTitle.ZIndex = 8
            
            -- Value display
            local ValueDisplay = Instance.new("TextLabel")
            ValueDisplay.Parent = SliderFrame
            ValueDisplay.BackgroundTransparency = 1
            ValueDisplay.Position = UDim2.new(1, -50, 0, 8)
            ValueDisplay.Size = UDim2.new(0, 40, 0, 16)
            ValueDisplay.Font = Enum.Font.GothamMedium
            ValueDisplay.Text = tostring(sliderConfig.Default)
            ValueDisplay.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
            ValueDisplay.TextSize = 12
            ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
            ValueDisplay.ZIndex = 8
            
            if sliderConfig.Description ~= "" then
                local SliderDesc = Instance.new("TextLabel")
                SliderDesc.Parent = SliderFrame
                SliderDesc.BackgroundTransparency = 1
                SliderDesc.Position = UDim2.new(0, 16, 0, 26)
                SliderDesc.Size = UDim2.new(0.7, 0, 0, 12)
                SliderDesc.Font = Enum.Font.Gotham
                SliderDesc.Text = sliderConfig.Description
                SliderDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
                SliderDesc.TextSize = 11
                SliderDesc.TextXAlignment = Enum.TextXAlignment.Left
                SliderDesc.ZIndex = 8
            end
            
            -- Slider Track
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "SliderTrack"
            SliderTrack.Parent = SliderFrame
            SliderTrack.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
            SliderTrack.BackgroundTransparency = 0.3
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Position = UDim2.new(0, 16, 1, -12)
            SliderTrack.Size = UDim2.new(1, -32, 0, 4)
            SliderTrack.ZIndex = 8
            
            CreateCorner(2).Parent = SliderTrack
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Parent = SliderTrack
            SliderFill.BackgroundColor3 = FluentUI.CurrentTheme.SystemAccentColor
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
            SliderFill.ZIndex = 9
            
            CreateCorner(2).Parent = SliderFill
            
            local SliderKnob = Instance.new("Frame")
            SliderKnob.Name = "SliderKnob"
            SliderKnob.Parent = SliderTrack
            SliderKnob.BackgroundColor3 = FluentUI.CurrentTheme.SystemAccentColor
            SliderKnob.BorderSizePixel = 0
            SliderKnob.Position = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), -8, 0.5, -8)
            SliderKnob.Size = UDim2.new(0, 16, 0, 16)
            SliderKnob.ZIndex = 10
            
            CreateCorner(8).Parent = SliderKnob
            CreateDropShadow(SliderKnob, 2)
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Parent = SliderTrack
            SliderButton.BackgroundTransparency = 1
            SliderButton.Size = UDim2.new(1, 0, 3, 0)
            SliderButton.Position = UDim2.new(0, 0, -1, 0)
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
                SmoothTween(SliderKnob, {Position = UDim2.new(finalPercent, -8, 0.5, -8)}, 0.1)
                
                ValueDisplay.Text = tostring(currentValue)
                
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
                    PlaySound("Click", 0.1, 1.05)
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
            return SliderFrame
        end
        
        function TabObject:CreateDropdown(config)
            config = config or {}
            
            local dropdownConfig = {
                Title = config.Title or "Dropdown",
                Description = config.Description or "You can select multiple values",
                Options = config.Options or {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven"},
                Default = config.Default or config.Options[1],
                Multi = config.Multi or false,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 64 + 40
            self.ElementCount = self.ElementCount + 1
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "Dropdown_" .. dropdownConfig.Title
            DropdownFrame.Parent = self.Content
            DropdownFrame.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            DropdownFrame.BackgroundTransparency = 0
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Position = UDim2.new(0, 0, 0, yPos)
            DropdownFrame.Size = UDim2.new(1, -12, 0, 56)
            DropdownFrame.ZIndex = 7
            DropdownFrame.ClipsDescendants = false
            
            CreateCorner(6).Parent = DropdownFrame
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.9).Parent = DropdownFrame
            
            local DropdownTitle = Instance.new("TextLabel")
            DropdownTitle.Parent = DropdownFrame
            DropdownTitle.BackgroundTransparency = 1
            DropdownTitle.Position = UDim2.new(0, 16, 0, 8)
            DropdownTitle.Size = UDim2.new(0.7, 0, 0, 16)
            DropdownTitle.Font = Enum.Font.GothamMedium
            DropdownTitle.Text = dropdownConfig.Title
            DropdownTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            DropdownTitle.TextSize = 13
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropdownTitle.ZIndex = 8
            
            if dropdownConfig.Description ~= "" then
                local DropdownDesc = Instance.new("TextLabel")
                DropdownDesc.Parent = DropdownFrame
                DropdownDesc.BackgroundTransparency = 1
                DropdownDesc.Position = UDim2.new(0, 16, 0, 26)
                DropdownDesc.Size = UDim2.new(0.7, 0, 0, 24)
                DropdownDesc.Font = Enum.Font.Gotham
                DropdownDesc.Text = dropdownConfig.Description
                DropdownDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
                DropdownDesc.TextSize = 11
                DropdownDesc.TextXAlignment = Enum.TextXAlignment.Left
                DropdownDesc.TextYAlignment = Enum.TextYAlignment.Top
                DropdownDesc.TextWrapped = true
                DropdownDesc.ZIndex = 8
            end
            
            -- Current selection display
            local CurrentSelection = Instance.new("TextLabel")
            CurrentSelection.Parent = DropdownFrame
            CurrentSelection.BackgroundTransparency = 1
            CurrentSelection.Position = UDim2.new(1, -120, 0, 8)
            CurrentSelection.Size = UDim2.new(0, 100, 0, 16)
            CurrentSelection.Font = Enum.Font.GothamMedium
            CurrentSelection.Text = dropdownConfig.Default
            CurrentSelection.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
            CurrentSelection.TextSize = 12
            CurrentSelection.TextXAlignment = Enum.TextXAlignment.Right
            CurrentSelection.ZIndex = 8
            
            -- Chevron icon
            local ChevronIcon = Instance.new("TextLabel")
            ChevronIcon.Parent = DropdownFrame
            ChevronIcon.BackgroundTransparency = 1
            ChevronIcon.Position = UDim2.new(1, -32, 0, 0)
            ChevronIcon.Size = UDim2.new(0, 24, 1, 0)
            ChevronIcon.Font = Enum.Font.Gotham
            ChevronIcon.Text = "⌄"
            ChevronIcon.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
            ChevronIcon.TextSize = 12
            ChevronIcon.ZIndex = 8
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 1, 0)
            DropdownButton.Text = ""
            DropdownButton.ZIndex = 9
            
            CreateRevealEffect(DropdownButton)
            CreatePressAnimation(DropdownButton)
            
            -- Dropdown List
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "DropdownList"
            DropdownList.Parent = DropdownFrame
            DropdownList.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            DropdownList.BorderSizePixel = 0
            DropdownList.Position = UDim2.new(0, 0, 1, 4)
            DropdownList.Size = UDim2.new(1, 0, 0, 0)
            DropdownList.Visible = false
            DropdownList.ZIndex = 20
            DropdownList.ClipsDescendants = true
            
            CreateCorner(6).Parent = DropdownList
            CreateStroke(1, FluentUI.CurrentTheme.SystemAccentColor, 0.5).Parent = DropdownList
            CreateDropShadow(DropdownList, 8)
            CreateAcrylicEffect(DropdownList)
            
            local DropdownScrollFrame = Instance.new("ScrollingFrame")
            DropdownScrollFrame.Parent = DropdownList
            DropdownScrollFrame.BackgroundTransparency = 1
            DropdownScrollFrame.BorderSizePixel = 0
            DropdownScrollFrame.Size = UDim2.new(1, 0, 1, 0)
            DropdownScrollFrame.ScrollBarThickness = 2
            DropdownScrollFrame.ScrollBarImageColor3 = FluentUI.CurrentTheme.SystemAccentColor
            DropdownScrollFrame.ScrollBarImageTransparency = 0.6
            DropdownScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #dropdownConfig.Options * 28)
            DropdownScrollFrame.ZIndex = 21
            
            local isOpen = false
            local selectedOptions = dropdownConfig.Multi and {dropdownConfig.Default} or dropdownConfig.Default
            
            for i, option in ipairs(dropdownConfig.Options) do
                local OptionFrame = Instance.new("Frame")
                OptionFrame.Name = "Option_" .. option
                OptionFrame.Parent = DropdownScrollFrame
                OptionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                OptionFrame.BackgroundTransparency = 1
                OptionFrame.BorderSizePixel = 0
                OptionFrame.Position = UDim2.new(0, 0, 0, (i-1) * 28)
                OptionFrame.Size = UDim2.new(1, 0, 0, 28)
                OptionFrame.ZIndex = 22
                
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = "OptionButton"
                OptionButton.Parent = OptionFrame
                OptionButton.BackgroundTransparency = 1
                OptionButton.Size = UDim2.new(1, 0, 1, 0)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = option
                OptionButton.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
                OptionButton.TextSize = 11
                OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                OptionButton.ZIndex = 23
                
                -- Selection indicator
                local SelectionIndicator = Instance.new("Frame")
                SelectionIndicator.Name = "SelectionIndicator"
                SelectionIndicator.Parent = OptionFrame
                SelectionIndicator.BackgroundColor3 = FluentUI.CurrentTheme.SystemAccentColor
                SelectionIndicator.BorderSizePixel = 0
                SelectionIndicator.Position = UDim2.new(0, 0, 0, 0)
                SelectionIndicator.Size = UDim2.new(0, 0, 1, 0)
                SelectionIndicator.ZIndex = 22
                
                CreateRevealEffect(OptionButton)
                
                -- Check if option is selected
                if (dropdownConfig.Multi and table.find(selectedOptions, option)) or (not dropdownConfig.Multi and selectedOptions == option) then
                    SelectionIndicator.Size = UDim2.new(0, 3, 1, 0)
                end
                
                OptionButton.MouseButton1Click:Connect(function()
                    PlaySound("Click", 0.2, 1.05)
                    
                    if dropdownConfig.Multi then
                        local index = table.find(selectedOptions, option)
                        if index then
                            table.remove(selectedOptions, index)
                            SmoothTween(SelectionIndicator, {Size = UDim2.new(0, 0, 1, 0)}, 0.15)
                        else
                            table.insert(selectedOptions, option)
                            SmoothTween(SelectionIndicator, {Size = UDim2.new(0, 3, 1, 0)}, 0.15)
                        end
                        CurrentSelection.Text = #selectedOptions > 0 and #selectedOptions .. " selected" or "None"
                    else
                        selectedOptions = option
                        CurrentSelection.Text = option
                        
                        -- Update all indicators
                        for _, optFrame in pairs(DropdownScrollFrame:GetChildren()) do
                            if optFrame:IsA("Frame") then
                                local indicator = optFrame:FindFirstChild("SelectionIndicator")
                                if indicator then
                                    SmoothTween(indicator, {
                                        Size = UDim2.new(0, optFrame.Name == "Option_" .. option and 3 or 0, 1, 0)
                                    }, 0.15)
                                end
                            end
                        end
                        
                        -- Close dropdown
                        isOpen = false
                        ChevronIcon.Text = "⌄"
                        SmoothTween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, nil, nil, function()
                            DropdownList.Visible = false
                        end)
                    end
                    
                    local success, err = pcall(dropdownConfig.Callback, selectedOptions)
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
                PlaySound("Click", 0.2, 1.0)
                
                if isOpen then
                    ChevronIcon.Text = "⌃"
                    DropdownList.Visible = true
                    local listHeight = math.min(#dropdownConfig.Options * 28, 200)
                    SmoothTween(DropdownList, {Size = UDim2.new(1, 0, 0, listHeight)}, 0.2, Enum.EasingStyle.Cubic)
                else
                    ChevronIcon.Text = "⌄"
                    SmoothTween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, nil, nil, function()
                        DropdownList.Visible = false
                    end)
                end
            end)
            
            self:UpdateCanvasSize()
            return DropdownFrame
        end
        
        function TabObject:CreateColorpicker(config)
            config = config or {}
            
            local colorConfig = {
                Title = config.Title or "Colorpicker",
                Description = config.Description or "but you can change the transparency",
                Default = config.Default or Color3.fromRGB(96, 205, 255),
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 64 + 40
            self.ElementCount = self.ElementCount + 1
            
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Name = "Colorpicker_" .. colorConfig.Title
            ColorFrame.Parent = self.Content
            ColorFrame.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            ColorFrame.BackgroundTransparency = 0
            ColorFrame.BorderSizePixel = 0
            ColorFrame.Position = UDim2.new(0, 0, 0, yPos)
            ColorFrame.Size = UDim2.new(1, -12, 0, 56)
            ColorFrame.ZIndex = 7
            
            CreateCorner(6).Parent = ColorFrame
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.9).Parent = ColorFrame
            
            local ColorTitle = Instance.new("TextLabel")
            ColorTitle.Parent = ColorFrame
            ColorTitle.BackgroundTransparency = 1
            ColorTitle.Position = UDim2.new(0, 16, 0, 8)
            ColorTitle.Size = UDim2.new(0.7, 0, 0, 16)
            ColorTitle.Font = Enum.Font.GothamMedium
            ColorTitle.Text = colorConfig.Title
            ColorTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            ColorTitle.TextSize = 13
            ColorTitle.TextXAlignment = Enum.TextXAlignment.Left
            ColorTitle.ZIndex = 8
            
            if colorConfig.Description ~= "" then
                local ColorDesc = Instance.new("TextLabel")
                ColorDesc.Parent = ColorFrame
                ColorDesc.BackgroundTransparency = 1
                ColorDesc.Position = UDim2.new(0, 16, 0, 26)
                ColorDesc.Size = UDim2.new(0.7, 0, 0, 24)
                ColorDesc.Font = Enum.Font.Gotham
                ColorDesc.Text = colorConfig.Description
                ColorDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
                ColorDesc.TextSize = 11
                ColorDesc.TextXAlignment = Enum.TextXAlignment.Left
                ColorDesc.TextYAlignment = Enum.TextYAlignment.Top
                ColorDesc.TextWrapped = true
                ColorDesc.ZIndex = 8
            end
            
            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Name = "ColorDisplay"
            ColorDisplay.Parent = ColorFrame
            ColorDisplay.BackgroundColor3 = colorConfig.Default
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Position = UDim2.new(1, -60, 0.5, -12)
            ColorDisplay.Size = UDim2.new(0, 48, 0, 24)
            ColorDisplay.ZIndex = 8
            
            CreateCorner(4).Parent = ColorDisplay
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.7).Parent = ColorDisplay
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
                PlaySound("Click", 0.2, 1.1)
                
                -- Simple color randomizer (in real implementation, you'd want a proper color picker)
                local newColor = Color3.fromRGB(
                    math.random(0, 255),
                    math.random(0, 255), 
                    math.random(0, 255)
                )
                
                currentColor = newColor
                SmoothTween(ColorDisplay, {BackgroundColor3 = newColor}, 0.2)
                
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
            return ColorFrame
        end
        
        function TabObject:CreateKeybind(config)
            config = config or {}
            
            local keybindConfig = {
                Title = config.Title or "KeyBind",
                Description = config.Description or "",
                Default = config.Default or Enum.KeyCode.MB2,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 64 + 40
            self.ElementCount = self.ElementCount + 1
            
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Name = "Keybind_" .. keybindConfig.Title
            KeybindFrame.Parent = self.Content
            KeybindFrame.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            KeybindFrame.BackgroundTransparency = 0
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Position = UDim2.new(0, 0, 0, yPos)
            KeybindFrame.Size = UDim2.new(1, -12, 0, 56)
            KeybindFrame.ZIndex = 7
            
            CreateCorner(6).Parent = KeybindFrame
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.9).Parent = KeybindFrame
            
            local KeybindTitle = Instance.new("TextLabel")
            KeybindTitle.Parent = KeybindFrame
            KeybindTitle.BackgroundTransparency = 1
            KeybindTitle.Position = UDim2.new(0, 16, 0, 8)
            KeybindTitle.Size = UDim2.new(0.7, 0, 0, 16)
            KeybindTitle.Font = Enum.Font.GothamMedium
            KeybindTitle.Text = keybindConfig.Title
            KeybindTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            KeybindTitle.TextSize = 13
            KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left
            KeybindTitle.ZIndex = 8
            
            if keybindConfig.Description ~= "" then
                local KeybindDesc = Instance.new("TextLabel")
                KeybindDesc.Parent = KeybindFrame
                KeybindDesc.BackgroundTransparency = 1
                KeybindDesc.Position = UDim2.new(0, 16, 0, 26)
                KeybindDesc.Size = UDim2.new(0.7, 0, 0, 24)
                KeybindDesc.Font = Enum.Font.Gotham
                KeybindDesc.Text = keybindConfig.Description
                KeybindDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
                KeybindDesc.TextSize = 11
                KeybindDesc.TextXAlignment = Enum.TextXAlignment.Left
                KeybindDesc.TextYAlignment = Enum.TextYAlignment.Top
                KeybindDesc.TextWrapped = true
                KeybindDesc.ZIndex = 8
            end
            
            local KeybindDisplay = Instance.new("TextLabel")
            KeybindDisplay.Parent = KeybindFrame
            KeybindDisplay.BackgroundTransparency = 1
            KeybindDisplay.Position = UDim2.new(1, -60, 0, 8)
            KeybindDisplay.Size = UDim2.new(0, 50, 0, 16)
            KeybindDisplay.Font = Enum.Font.GothamMedium
            KeybindDisplay.Text = keybindConfig.Default.Name
            KeybindDisplay.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
            KeybindDisplay.TextSize = 12
            KeybindDisplay.TextXAlignment = Enum.TextXAlignment.Right
            KeybindDisplay.ZIndex = 8
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Name = "KeybindButton"
            KeybindButton.Parent = KeybindFrame
            KeybindButton.BackgroundTransparency = 1
            KeybindButton.Size = UDim2.new(1, 0, 1, 0)
            KeybindButton.Text = ""
            KeybindButton.ZIndex = 9
            
            CreateRevealEffect(KeybindButton)
            CreatePressAnimation(KeybindButton)
            
            local currentKey = keybindConfig.Default
            local listening = false
            
            KeybindButton.MouseButton1Click:Connect(function()
                if listening then return end
                
                listening = true
                KeybindDisplay.Text = "..."
                KeybindDisplay.TextColor3 = FluentUI.CurrentTheme.SystemAccentColor
                PlaySound("Click", 0.2, 1.2)
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                        currentKey = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
                        KeybindDisplay.Text = currentKey.Name or "Unknown"
                        KeybindDisplay.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
                        listening = false
                        connection:Disconnect()
                        
                        PlaySound("Success", 0.2, 1.1)
                    end
                end)
            end)
            
            -- Bind the keybind functionality
            local keybindConnection
            keybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if (input.KeyCode == currentKey) or (input.UserInputType == currentKey) then
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
            return KeybindFrame
        end
        
        function TabObject:CreateInput(config)
            config = config or {}
            
            local inputConfig = {
                Title = config.Title or "Input",
                Description = config.Description or "",
                Default = config.Default or "Default",
                PlaceholderText = config.PlaceholderText or "Type here...",
                Numeric = config.Numeric or false,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 64 + 40
            self.ElementCount = self.ElementCount + 1
            
            local InputFrame = Instance.new("Frame")
            InputFrame.Name = "Input_" .. inputConfig.Title
            InputFrame.Parent = self.Content
            InputFrame.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumLowBrush
            InputFrame.BackgroundTransparency = 0
            InputFrame.BorderSizePixel = 0
            InputFrame.Position = UDim2.new(0, 0, 0, yPos)
            InputFrame.Size = UDim2.new(1, -12, 0, 56)
            InputFrame.ZIndex = 7
            
            CreateCorner(6).Parent = InputFrame
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.9).Parent = InputFrame
            
            local InputTitle = Instance.new("TextLabel")
            InputTitle.Parent = InputFrame
            InputTitle.BackgroundTransparency = 1
            InputTitle.Position = UDim2.new(0, 16, 0, 8)
            InputTitle.Size = UDim2.new(0.5, 0, 0, 16)
            InputTitle.Font = Enum.Font.GothamMedium
            InputTitle.Text = inputConfig.Title
            InputTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            InputTitle.TextSize = 13
            InputTitle.TextXAlignment = Enum.TextXAlignment.Left
            InputTitle.ZIndex = 8
            
            if inputConfig.Description ~= "" then
                local InputDesc = Instance.new("TextLabel")
                InputDesc.Parent = InputFrame
                InputDesc.BackgroundTransparency = 1
                InputDesc.Position = UDim2.new(0, 16, 0, 26)
                InputDesc.Size = UDim2.new(0.5, 0, 0, 24)
                InputDesc.Font = Enum.Font.Gotham
                InputDesc.Text = inputConfig.Description
                InputDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
                InputDesc.TextSize = 11
                InputDesc.TextXAlignment = Enum.TextXAlignment.Left
                InputDesc.TextYAlignment = Enum.TextYAlignment.Top
                InputDesc.TextWrapped = true
                InputDesc.ZIndex = 8
            end
            
            local InputBox = Instance.new("TextBox")
            InputBox.Name = "InputBox"
            InputBox.Parent = InputFrame
            InputBox.BackgroundColor3 = FluentUI.CurrentTheme.SystemControlBackgroundChromeMediumBrush
            InputBox.BackgroundTransparency = 0.3
            InputBox.BorderSizePixel = 0
            InputBox.Position = UDim2.new(0.5, 8, 0, 16)
            InputBox.Size = UDim2.new(0.5, -24, 0, 24)
            InputBox.Font = Enum.Font.Gotham
            InputBox.PlaceholderText = inputConfig.PlaceholderText
            InputBox.PlaceholderColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
            InputBox.Text = inputConfig.Default
            InputBox.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
            InputBox.TextSize = 12
            InputBox.ZIndex = 8
            
            CreateCorner(4).Parent = InputBox
            CreateStroke(1, FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush, 0.7).Parent = InputBox
            
            -- Focus effects
            InputBox.Focused:Connect(function()
                SmoothTween(InputBox:FindFirstChild("UIStroke"), {
                    Color = FluentUI.CurrentTheme.SystemAccentColor,
                    Transparency = 0.3
                }, 0.2)
                SmoothTween(InputBox, {BackgroundTransparency = 0.1}, 0.2)
            end)
            
            InputBox.FocusLost:Connect(function(enterPressed)
                SmoothTween(InputBox:FindFirstChild("UIStroke"), {
                    Color = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush,
                    Transparency = 0.7
                }, 0.2)
                SmoothTween(InputBox, {BackgroundTransparency = 0.3}, 0.2)
                
                if enterPressed then
                    local value = InputBox.Text
                    if inputConfig.Numeric then
                        value = tonumber(value) or 0
                    end
                    
                    local success, err = pcall(inputConfig.Callback, value)
                    if not success then
                        FluentUI:Notify({
                            Title = "Error",
                            Description = "Input error: " .. tostring(err),
                            Type = "Error"
                        })
                    end
                end
            end)
            
            self:UpdateCanvasSize()
            return InputFrame
        end
        
        function TabObject:UpdateCanvasSize()
            local contentSize = self.ElementCount * 70 + 60
            SmoothTween(self.Content, {CanvasSize = UDim2.new(0, 0, 0, contentSize)}, 0.1)
        end
        
        CreateRevealEffect(NavButton)
        
        NavButton.MouseButton1Click:Connect(function()
            TabObject:Activate()
        end)
        
        self.Tabs[tabConfig.Name] = TabObject
        
        if self.TabCount == 1 then
            TabObject:Activate()
        end
        
        self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, self.TabCount * 36 + 8)
        
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
    }, 0.4, Enum.EasingStyle.Back)
    
    SmoothTween(MainFrame, {BackgroundTransparency = 0}, 0.25)
    SmoothTween(BackgroundOverlay, {BackgroundTransparency = 0.4}, 0.25)
    
    PlaySound("Success", 0.4, 1.1)
    
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
        Info = FluentUI.CurrentTheme.SystemAccentColor,
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
    NotifCard.BackgroundTransparency = 0
    NotifCard.BorderSizePixel = 0
    NotifCard.Position = UDim2.new(1, 20, 1, -110 - (#FluentUI.Notifications * 120))
    NotifCard.Size = UDim2.new(0, 380, 0, 100)
    NotifCard.ZIndex = 100
    
    CreateCorner(6).Parent = NotifCard
    CreateStroke(1, typeColors[notifConfig.Type] or typeColors.Info, 0.6).Parent = NotifCard
    CreateDropShadow(NotifCard, 8)
    CreateAcrylicEffect(NotifCard)
    
    local NotifIcon = Instance.new("TextLabel")
    NotifIcon.Parent = NotifCard
    NotifIcon.BackgroundTransparency = 1
    NotifIcon.Position = UDim2.new(0, 20, 0, 20)
    NotifIcon.Size = UDim2.new(0, 24, 0, 24)
    NotifIcon.Font = Enum.Font.GothamBold
    NotifIcon.Text = typeIcons[notifConfig.Type] or typeIcons.Info
    NotifIcon.TextColor3 = typeColors[notifConfig.Type] or typeColors.Info
    NotifIcon.TextSize = 16
    NotifIcon.ZIndex = 101
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = NotifCard
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 54, 0, 16)
    NotifTitle.Size = UDim2.new(1, -74, 0, 20)
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = notifConfig.Title
    NotifTitle.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseHighBrush
    NotifTitle.TextSize = 13
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.TextTruncate = Enum.TextTruncate.AtEnd
    NotifTitle.ZIndex = 101
    
    local NotifDesc = Instance.new("TextLabel")
    NotifDesc.Parent = NotifCard
    NotifDesc.BackgroundTransparency = 1
    NotifDesc.Position = UDim2.new(0, 54, 0, 36)
    NotifDesc.Size = UDim2.new(1, -74, 0, 50)
    NotifDesc.Font = Enum.Font.Gotham
    NotifDesc.Text = notifConfig.Description
    NotifDesc.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
    NotifDesc.TextSize = 11
    NotifDesc.TextXAlignment = Enum.TextXAlignment.Left
    NotifDesc.TextWrapped = true
    NotifDesc.TextYAlignment = Enum.TextYAlignment.Top
    NotifDesc.ZIndex = 101
    
    local CloseNotifBtn = Instance.new("TextButton")
    CloseNotifBtn.Parent = NotifCard
    CloseNotifBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseNotifBtn.BackgroundTransparency = 1
    CloseNotifBtn.BorderSizePixel = 0
    CloseNotifBtn.Position = UDim2.new(1, -28, 0, 8)
    CloseNotifBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseNotifBtn.Font = Enum.Font.Gotham
    CloseNotifBtn.Text = "✕"
    CloseNotifBtn.TextColor3 = FluentUI.CurrentTheme.SystemControlForegroundBaseMediumBrush
    CloseNotifBtn.TextSize = 10
    CloseNotifBtn.ZIndex = 102
    
    CreateCorner(4).Parent = CloseNotifBtn
    CreateRevealEffect(CloseNotifBtn)
    
    CloseNotifBtn.MouseButton1Click:Connect(function()
        SmoothTween(NotifCard, {
            Position = UDim2.new(1, 20, NotifCard.Position.Y.Scale, NotifCard.Position.Y.Offset),
            Size = UDim2.new(0, 0, 0, 100)
        }, 0.25, nil, nil, function()
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
        Position = UDim2.new(1, -390, 1, -110 - ((#FluentUI.Notifications-1) * 120))
    }, 0.3, Enum.EasingStyle.Back)
    
    PlaySound(notifConfig.Type == "Error" and "Error" or "Success", 0.3, 1.05)
    
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
