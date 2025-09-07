-- Fluent UI Style Library - Modern & Beautiful
-- ดีไซน์แบบ Microsoft Fluent UI

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

-- Configuration
FluentUI.Config = {
    AnimationSpeed = 0.4,
    SoundEffects = true,
    AcrylicBlur = true,
    MicaEffect = true
}

-- Fluent Design System Colors
FluentUI.Themes = {
    Light = {
        Name = "Light",
        -- Card and surfaces
        CardBackground = Color3.fromRGB(255, 255, 255),
        CardBackgroundSecondary = Color3.fromRGB(249, 249, 249),
        CardBackgroundTertiary = Color3.fromRGB(243, 243, 243),
        
        -- Control surfaces
        ControlFillDefault = Color3.fromRGB(255, 255, 255),
        ControlFillSecondary = Color3.fromRGB(246, 246, 246),
        ControlFillTertiary = Color3.fromRGB(240, 240, 240),
        ControlFillDisabled = Color3.fromRGB(249, 249, 249),
        
        -- Stroke colors
        ControlStrokeDefault = Color3.fromRGB(117, 117, 117),
        ControlStrokeSecondary = Color3.fromRGB(161, 161, 161),
        ControlStrokeOnAccentDefault = Color3.fromRGB(255, 255, 255),
        
        -- Text colors
        TextFillColorPrimary = Color3.fromRGB(32, 31, 30),
        TextFillColorSecondary = Color3.fromRGB(96, 94, 92),
        TextFillColorTertiary = Color3.fromRGB(128, 126, 124),
        TextFillColorDisabled = Color3.fromRGB(161, 159, 157),
        
        -- Accent colors
        AccentDefault = Color3.fromRGB(0, 120, 215),
        AccentSecondary = Color3.fromRGB(64, 156, 235),
        AccentTertiary = Color3.fromRGB(153, 209, 252),
        AccentDisabled = Color3.fromRGB(205, 205, 205),
        
        -- System colors
        SystemFillColorSuccess = Color3.fromRGB(16, 124, 16),
        SystemFillColorCaution = Color3.fromRGB(157, 93, 0),
        SystemFillColorCritical = Color3.fromRGB(196, 43, 28),
        SystemFillColorNeutral = Color3.fromRGB(96, 94, 92),
        
        -- Background
        ApplicationPageBackgroundThemeBrush = Color3.fromRGB(243, 243, 243),
        LayerFillColorDefault = Color3.fromRGB(255, 255, 255),
        LayerFillColorAlt = Color3.fromRGB(255, 255, 255),
        
        -- Shadow
        Shadow = Color3.fromRGB(0, 0, 0)
    },
    
    Dark = {
        Name = "Dark",
        -- Card and surfaces
        CardBackground = Color3.fromRGB(44, 44, 44),
        CardBackgroundSecondary = Color3.fromRGB(40, 40, 40),
        CardBackgroundTertiary = Color3.fromRGB(36, 36, 36),
        
        -- Control surfaces
        ControlFillDefault = Color3.fromRGB(69, 69, 69),
        ControlFillSecondary = Color3.fromRGB(61, 61, 61),
        ControlFillTertiary = Color3.fromRGB(53, 53, 53),
        ControlFillDisabled = Color3.fromRGB(41, 41, 41),
        
        -- Stroke colors
        ControlStrokeDefault = Color3.fromRGB(117, 117, 117),
        ControlStrokeSecondary = Color3.fromRGB(89, 89, 89),
        ControlStrokeOnAccentDefault = Color3.fromRGB(20, 20, 20),
        
        -- Text colors
        TextFillColorPrimary = Color3.fromRGB(255, 255, 255),
        TextFillColorSecondary = Color3.fromRGB(196, 196, 196),
        TextFillColorTertiary = Color3.fromRGB(140, 140, 140),
        TextFillColorDisabled = Color3.fromRGB(89, 89, 89),
        
        -- Accent colors
        AccentDefault = Color3.fromRGB(96, 205, 255),
        AccentSecondary = Color3.fromRGB(64, 156, 235),
        AccentTertiary = Color3.fromRGB(153, 209, 252),
        AccentDisabled = Color3.fromRGB(66, 66, 66),
        
        -- System colors
        SystemFillColorSuccess = Color3.fromRGB(108, 203, 95),
        SystemFillColorCaution = Color3.fromRGB(252, 225, 0),
        SystemFillColorCritical = Color3.fromRGB(255, 153, 164),
        SystemFillColorNeutral = Color3.fromRGB(140, 140, 140),
        
        -- Background
        ApplicationPageBackgroundThemeBrush = Color3.fromRGB(32, 32, 32),
        LayerFillColorDefault = Color3.fromRGB(58, 58, 58),
        LayerFillColorAlt = Color3.fromRGB(44, 44, 44),
        
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
    Click = "rbxassetid://421058925",
    Hover = "rbxassetid://421058925",
    Success = "rbxassetid://131961136",
    Error = "rbxassetid://131961136"
}

-- Utility Functions
local function PlaySound(soundName, volume)
    if not FluentUI.Config.SoundEffects then return end
    
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = Sounds[soundName] or Sounds.Click
        sound.Volume = volume or 0.1
        sound.Pitch = 1 + (math.random(-5, 5) / 100)
        sound.Parent = SoundService
        sound:Play()
        
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
end

local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 4)
    return corner
end

local function CreateStroke(thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or FluentUI.CurrentTheme.ControlStrokeDefault
    stroke.Transparency = transparency or 0
    return stroke
end

local function CreateAcrylicEffect(parent)
    if not FluentUI.Config.AcrylicBlur then return end
    
    local acrylic = Instance.new("Frame")
    acrylic.Name = "AcrylicEffect"
    acrylic.Parent = parent
    acrylic.BackgroundColor3 = FluentUI.CurrentTheme.LayerFillColorDefault
    acrylic.BackgroundTransparency = 0.3
    acrylic.BorderSizePixel = 0
    acrylic.Size = UDim2.new(1, 0, 1, 0)
    acrylic.ZIndex = parent.ZIndex - 1
    
    CreateCorner(8).Parent = acrylic
    
    -- Noise texture simulation
    local noise = Instance.new("ImageLabel")
    noise.Parent = acrylic
    noise.BackgroundTransparency = 1
    noise.Size = UDim2.new(1, 0, 1, 0)
    noise.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    noise.ImageColor3 = Color3.fromRGB(255, 255, 255)
    noise.ImageTransparency = 0.95
    noise.ZIndex = acrylic.ZIndex + 1
    
    return acrylic
end

local function CreateMicaEffect(parent)
    if not FluentUI.Config.MicaEffect then return end
    
    local mica = Instance.new("Frame")
    mica.Name = "MicaEffect"
    mica.Parent = parent
    mica.BackgroundColor3 = FluentUI.CurrentTheme.ApplicationPageBackgroundThemeBrush
    mica.BackgroundTransparency = 0.1
    mica.BorderSizePixel = 0
    mica.Size = UDim2.new(1, 0, 1, 0)
    mica.ZIndex = parent.ZIndex - 2
    
    CreateCorner(8).Parent = mica
    
    return mica
end

local function CreateDropShadow(parent, elevation)
    elevation = elevation or 1
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.Parent = parent
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = FluentUI.CurrentTheme.Shadow
    shadow.ImageTransparency = 0.8 - (elevation * 0.1)
    shadow.Position = UDim2.new(0, -elevation, 0, elevation)
    shadow.Size = UDim2.new(1, elevation * 2, 1, elevation * 2)
    shadow.ZIndex = parent.ZIndex - 1
    
    CreateCorner(8 + elevation).Parent = shadow
    
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

local function CreateRevealEffect(button)
    local revealConnection
    revealConnection = button.MouseEnter:Connect(function()
        local reveal = Instance.new("Frame")
        reveal.Name = "RevealEffect"
        reveal.Parent = button
        reveal.BackgroundColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
        reveal.BackgroundTransparency = 0.9
        reveal.BorderSizePixel = 0
        reveal.Size = UDim2.new(1, 0, 1, 0)
        reveal.ZIndex = button.ZIndex + 1
        
        CreateCorner(4).Parent = reveal
        
        SmoothTween(reveal, {BackgroundTransparency = 0.95}, 0.2)
        
        local leaveConnection
        leaveConnection = button.MouseLeave:Connect(function()
            SmoothTween(reveal, {BackgroundTransparency = 1}, 0.2, nil, nil, function()
                reveal:Destroy()
                leaveConnection:Disconnect()
            end)
        end)
        
        table.insert(FluentUI.Connections, leaveConnection)
    end)
    
    table.insert(FluentUI.Connections, revealConnection)
end

local function CreatePressAnimation(button)
    local pressConnection
    pressConnection = button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            PlaySound("Click")
            
            SmoothTween(button, {
                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 1, button.Size.Y.Scale, button.Size.Y.Offset - 1)
            }, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                SmoothTween(button, {
                    Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 1, button.Size.Y.Scale, button.Size.Y.Offset + 1)
                }, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            end)
        end
    end)
    
    table.insert(FluentUI.Connections, pressConnection)
end

-- Window Creation
function FluentUI:CreateWindow(config)
    config = config or {}
    
    local windowConfig = {
        Title = config.Title or "Fluent UI",
        Subtitle = config.Subtitle or "Modern Design System",
        Size = config.Size or UDim2.new(0, 650, 0, 450),
        Theme = config.Theme or "Dark",
        KeyBind = config.KeyBind or Enum.KeyCode.Insert,
        Draggable = config.Draggable ~= false
    }
    
    -- Set theme
    if FluentUI.Themes[windowConfig.Theme] then
        FluentUI.CurrentTheme = FluentUI.Themes[windowConfig.Theme]
    end
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FluentUI_" .. HttpService:GenerateGUID(false):sub(1, 8)
    ScreenGui.Parent = GuiParent
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    
    -- Background Overlay
    local BackgroundOverlay = Instance.new("Frame")
    BackgroundOverlay.Name = "BackgroundOverlay"
    BackgroundOverlay.Parent = ScreenGui
    BackgroundOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BackgroundOverlay.BackgroundTransparency = 0.2
    BackgroundOverlay.BorderSizePixel = 0
    BackgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
    BackgroundOverlay.ZIndex = 1
    
    -- Main Container
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = ScreenGui
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0.5, -windowConfig.Size.X.Offset/2, 0.5, -windowConfig.Size.Y.Offset/2)
    Container.Size = windowConfig.Size
    Container.ZIndex = 2
    
    -- Main Frame with Acrylic Background
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Container
    MainFrame.BackgroundColor3 = FluentUI.CurrentTheme.CardBackground
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.ZIndex = 3
    
    CreateCorner(8).Parent = MainFrame
    CreateStroke(1, FluentUI.CurrentTheme.ControlStrokeDefault, 0.5).Parent = MainFrame
    CreateDropShadow(MainFrame, 4)
    CreateMicaEffect(MainFrame)
    CreateAcrylicEffect(MainFrame)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = FluentUI.CurrentTheme.CardBackgroundSecondary
    TitleBar.BackgroundTransparency = 0.3
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 48)
    TitleBar.ZIndex = 4
    
    CreateCorner(8).Parent = TitleBar
    
    -- App Icon
    local AppIcon = Instance.new("Frame")
    AppIcon.Name = "AppIcon"
    AppIcon.Parent = TitleBar
    AppIcon.BackgroundColor3 = FluentUI.CurrentTheme.AccentDefault
    AppIcon.BorderSizePixel = 0
    AppIcon.Position = UDim2.new(0, 16, 0.5, -12)
    AppIcon.Size = UDim2.new(0, 24, 0, 24)
    AppIcon.ZIndex = 5
    
    CreateCorner(4).Parent = AppIcon
    
    -- App Icon Symbol
    local IconSymbol = Instance.new("TextLabel")
    IconSymbol.Parent = AppIcon
    IconSymbol.BackgroundTransparency = 1
    IconSymbol.Size = UDim2.new(1, 0, 1, 0)
    IconSymbol.Font = Enum.Font.GothamBold
    IconSymbol.Text = "F"
    IconSymbol.TextColor3 = Color3.fromRGB(255, 255, 255)
    IconSymbol.TextSize = 14
    IconSymbol.ZIndex = 6
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 50, 0, 8)
    TitleLabel.Size = UDim2.new(0.6, 0, 0, 22)
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.Text = windowConfig.Title
    TitleLabel.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 5
    
    -- Subtitle
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Parent = TitleBar
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Position = UDim2.new(0, 50, 0, 28)
    SubtitleLabel.Size = UDim2.new(0.6, 0, 0, 16)
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.Text = windowConfig.Subtitle
    SubtitleLabel.TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary
    SubtitleLabel.TextSize = 11
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 5
    
    -- Window Controls
    local WindowControls = Instance.new("Frame")
    WindowControls.Name = "WindowControls"
    WindowControls.Parent = TitleBar
    WindowControls.BackgroundTransparency = 1
    WindowControls.Position = UDim2.new(1, -140, 0, 12)
    WindowControls.Size = UDim2.new(0, 132, 0, 24)
    WindowControls.ZIndex = 5
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "Minimize"
    MinimizeBtn.Parent = WindowControls
    MinimizeBtn.BackgroundColor3 = FluentUI.CurrentTheme.ControlFillDefault
    MinimizeBtn.BackgroundTransparency = 0.7
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    MinimizeBtn.Size = UDim2.new(0, 40, 0, 24)
    MinimizeBtn.Font = Enum.Font.GothamMedium
    MinimizeBtn.Text = "─"
    MinimizeBtn.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
    MinimizeBtn.TextSize = 12
    MinimizeBtn.ZIndex = 6
    
    CreateCorner(4).Parent = MinimizeBtn
    CreateRevealEffect(MinimizeBtn)
    CreatePressAnimation(MinimizeBtn)
    
    -- Maximize Button
    local MaximizeBtn = Instance.new("TextButton")
    MaximizeBtn.Name = "Maximize"
    MaximizeBtn.Parent = WindowControls
    MaximizeBtn.BackgroundColor3 = FluentUI.CurrentTheme.ControlFillDefault
    MaximizeBtn.BackgroundTransparency = 0.7
    MaximizeBtn.BorderSizePixel = 0
    MaximizeBtn.Position = UDim2.new(0, 44, 0, 0)
    MaximizeBtn.Size = UDim2.new(0, 40, 0, 24)
    MaximizeBtn.Font = Enum.Font.GothamMedium
    MaximizeBtn.Text = "🗖"
    MaximizeBtn.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
    MaximizeBtn.TextSize = 12
    MaximizeBtn.ZIndex = 6
    
    CreateCorner(4).Parent = MaximizeBtn
    CreateRevealEffect(MaximizeBtn)
    CreatePressAnimation(MaximizeBtn)
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Parent = WindowControls
    CloseBtn.BackgroundColor3 = FluentUI.CurrentTheme.ControlFillDefault
    CloseBtn.BackgroundTransparency = 0.7
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(0, 88, 0, 0)
    CloseBtn.Size = UDim2.new(0, 40, 0, 24)
    CloseBtn.Font = Enum.Font.GothamMedium
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
    CloseBtn.TextSize = 12
    CloseBtn.ZIndex = 6
    
    CreateCorner(4).Parent = CloseBtn
    
    -- Special hover effect for close button
    CloseBtn.MouseEnter:Connect(function()
        SmoothTween(CloseBtn, {
            BackgroundColor3 = FluentUI.CurrentTheme.SystemFillColorCritical,
            BackgroundTransparency = 0
        }, 0.2)
        SmoothTween(CloseBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        SmoothTween(CloseBtn, {
            BackgroundColor3 = FluentUI.CurrentTheme.ControlFillDefault,
            BackgroundTransparency = 0.7
        }, 0.2)
        SmoothTween(CloseBtn, {TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary}, 0.2)
    end)
    
    CreatePressAnimation(CloseBtn)
    
    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 48)
    ContentFrame.Size = UDim2.new(1, 0, 1, -48)
    ContentFrame.ZIndex = 4
    
    -- Navigation Pane
    local NavPane = Instance.new("Frame")
    NavPane.Name = "NavigationPane"
    NavPane.Parent = ContentFrame
    NavPane.BackgroundColor3 = FluentUI.CurrentTheme.LayerFillColorAlt
    NavPane.BackgroundTransparency = 0.4
    NavPane.BorderSizePixel = 0
    NavPane.Size = UDim2.new(0, 200, 1, 0)
    NavPane.ZIndex = 5
    
    CreateStroke(1, FluentUI.CurrentTheme.ControlStrokeSecondary, 0.7).Parent = NavPane
    
    -- Navigation Header
    local NavHeader = Instance.new("Frame")
    NavHeader.Name = "NavigationHeader"
    NavHeader.Parent = NavPane
    NavHeader.BackgroundTransparency = 1
    NavHeader.Position = UDim2.new(0, 0, 0, 0)
    NavHeader.Size = UDim2.new(1, 0, 0, 40)
    NavHeader.ZIndex = 6
    
    local NavTitle = Instance.new("TextLabel")
    NavTitle.Parent = NavHeader
    NavTitle.BackgroundTransparency = 1
    NavTitle.Position = UDim2.new(0, 16, 0, 0)
    NavTitle.Size = UDim2.new(1, -32, 1, 0)
    NavTitle.Font = Enum.Font.GothamMedium
    NavTitle.Text = "เมนู"
    NavTitle.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
    NavTitle.TextSize = 16
    NavTitle.TextXAlignment = Enum.TextXAlignment.Left
    NavTitle.ZIndex = 7
    
    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = NavPane
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 8, 0, 48)
    TabContainer.Size = UDim2.new(1, -16, 1, -56)
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = FluentUI.CurrentTheme.AccentDefault
    TabContainer.ScrollBarImageTransparency = 0.6
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ZIndex = 6
    
    -- Main Content
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.Parent = ContentFrame
    MainContent.BackgroundTransparency = 1
    MainContent.Position = UDim2.new(0, 200, 0, 0)
    MainContent.Size = UDim2.new(1, -200, 1, 0)
    MainContent.ZIndex = 5
    
    -- Window Object
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
    
    -- Window Methods
    function WindowObject:Toggle()
        self.Visible = not self.Visible
        
        if self.Visible then
            self.ScreenGui.Enabled = true
            -- Entrance animation
            self.Container.Size = UDim2.new(0, 50, 0, 50)
            self.Container.Position = UDim2.new(0.5, -25, 0.5, -25)
            self.MainFrame.BackgroundTransparency = 1
            
            SmoothTween(self.Container, {
                Size = windowConfig.Size,
                Position = UDim2.new(0.5, -windowConfig.Size.X.Offset/2, 0.5, -windowConfig.Size.Y.Offset/2)
            }, 0.6, Enum.EasingStyle.Back)
            
            SmoothTween(self.MainFrame, {BackgroundTransparency = 0.05}, 0.4)
            SmoothTween(self.BackgroundOverlay, {BackgroundTransparency = 0.2}, 0.4)
            
            PlaySound("Success", 0.2)
        else
            SmoothTween(self.Container, {
                Size = UDim2.new(0, 50, 0, 50),
                Position = UDim2.new(0.5, -25, 0.5, -25)
            }, 0.4, Enum.EasingStyle.Back)
            
            SmoothTween(self.MainFrame, {BackgroundTransparency = 1}, 0.4)
            SmoothTween(self.BackgroundOverlay, {BackgroundTransparency = 1}, 0.4, nil, nil, function()
                self.ScreenGui.Enabled = false
            end)
        end
    end
    
    function WindowObject:Minimize()
        self.Minimized = not self.Minimized
        PlaySound("Click", 0.15)
        
        local targetSize = self.Minimized and UDim2.new(0, windowConfig.Size.X.Offset, 0, 48) or windowConfig.Size
        
        SmoothTween(self.Container, {Size = targetSize}, 0.5, Enum.EasingStyle.Cubic)
        self.ContentFrame.Visible = not self.Minimized
    end
    
    function WindowObject:Destroy()
        -- Clean up
        for _, connection in pairs(FluentUI.Connections) do
            if typeof(connection) == "RBXScriptConnection" then
                connection:Disconnect()
            elseif typeof(connection) == "Tween" then
                connection:Cancel()
            end
        end
        
        PlaySound("Click", 0.15)
        
        SmoothTween(self.Container, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.4, Enum.EasingStyle.Back)
        
        SmoothTween(self.BackgroundOverlay, {BackgroundTransparency = 1}, 0.4, nil, nil, function()
            self.ScreenGui:Destroy()
        end)
        
        -- Remove from list
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
        
        -- Navigation Item
        local NavItem = Instance.new("Frame")
        NavItem.Name = "NavItem_" .. tabConfig.Name
        NavItem.Parent = self.TabContainer
        NavItem.BackgroundColor3 = FluentUI.CurrentTheme.ControlFillDefault
        NavItem.BackgroundTransparency = 1
        NavItem.BorderSizePixel = 0
        NavItem.Position = UDim2.new(0, 0, 0, (tabIndex - 1) * 48)
        NavItem.Size = UDim2.new(1, 0, 0, 44)
        NavItem.ZIndex = 7
        
        CreateCorner(6).Parent = NavItem
        
        -- Navigation Button
        local NavButton = Instance.new("TextButton")
        NavButton.Name = "NavButton"
        NavButton.Parent = NavItem
        NavButton.BackgroundTransparency = 1
        NavButton.Size = UDim2.new(1, 0, 1, 0)
        NavButton.Font = Enum.Font.Gotham
        NavButton.Text = ""
        NavButton.ZIndex = 8
        
        -- Selection Indicator
        local SelectionIndicator = Instance.new("Frame")
        SelectionIndicator.Name = "SelectionIndicator"
        SelectionIndicator.Parent = NavItem
        SelectionIndicator.BackgroundColor3 = FluentUI.CurrentTheme.AccentDefault
        SelectionIndicator.BorderSizePixel = 0
        SelectionIndicator.Position = UDim2.new(0, 0, 0.5, -12)
        SelectionIndicator.Size = UDim2.new(0, 0, 0, 24)
        SelectionIndicator.ZIndex = 9
        
        CreateCorner(2).Parent = SelectionIndicator
        
        -- Icon
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Name = "Icon"
        TabIcon.Parent = NavItem
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 16, 0, 0)
        TabIcon.Size = UDim2.new(0, 32, 1, 0)
        TabIcon.Font = Enum.Font.GothamMedium
        TabIcon.Text = tabConfig.Icon
        TabIcon.TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary
        TabIcon.TextSize = 16
        TabIcon.TextXAlignment = Enum.TextXAlignment.Center
        TabIcon.ZIndex = 8
        
        -- Text
        local TabText = Instance.new("TextLabel")
        TabText.Name = "Text"
        TabText.Parent = NavItem
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, 52, 0, 0)
        TabText.Size = UDim2.new(1, -60, 1, 0)
        TabText.Font = Enum.Font.GothamMedium
        TabText.Text = tabConfig.Name
        TabText.TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary
        TabText.TextSize = 14
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.ZIndex = 8
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. tabConfig.Name
        TabContent.Parent = self.MainContent
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, 20, 0, 20)
        TabContent.Size = UDim2.new(1, -40, 1, -40)
        TabContent.ScrollBarThickness = 6
        TabContent.ScrollBarImageColor3 = FluentUI.CurrentTheme.AccentDefault
        TabContent.ScrollBarImageTransparency = 0.6
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.ZIndex = 6
        
        -- Tab Object
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
            
            PlaySound("Click", 0.1)
            
            -- Deactivate others
            for _, tab in pairs(WindowObject.Tabs) do
                if tab.Active then
                    tab:Deactivate()
                end
            end
            
            self.Active = true
            WindowObject.CurrentTab = self
            
            -- Visual updates
            SmoothTween(self.NavItem, {BackgroundTransparency = 0.8}, 0.3)
            SmoothTween(self.SelectionIndicator, {Size = UDim2.new(0, 3, 0, 24)}, 0.4, Enum.EasingStyle.Back)
            SmoothTween(self.Icon, {TextColor3 = FluentUI.CurrentTheme.AccentDefault}, 0.3)
            SmoothTween(self.Text, {TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary}, 0.3)
            
            self.Content.Visible = true
        end
        
        function TabObject:Deactivate()
            self.Active = false
            
            SmoothTween(self.NavItem, {BackgroundTransparency = 1}, 0.3)
            SmoothTween(self.SelectionIndicator, {Size = UDim2.new(0, 0, 0, 24)}, 0.3)
            SmoothTween(self.Icon, {TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary}, 0.3)
            SmoothTween(self.Text, {TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary}, 0.3)
            
            self.Content.Visible = false
        end
        
        function TabObject:CreateButton(config)
            config = config or {}
            
            local buttonConfig = {
                Name = config.Name or "Button",
                Description = config.Description or "",
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 80
            self.ElementCount = self.ElementCount + 1
            
            local ButtonCard = Instance.new("Frame")
            ButtonCard.Name = "ButtonCard_" .. buttonConfig.Name
            ButtonCard.Parent = self.Content
            ButtonCard.BackgroundColor3 = FluentUI.CurrentTheme.CardBackground
            ButtonCard.BackgroundTransparency = 0.1
            ButtonCard.BorderSizePixel = 0
            ButtonCard.Position = UDim2.new(0, 0, 0, yPos)
            ButtonCard.Size = UDim2.new(1, -4, 0, 70)
            ButtonCard.ZIndex = 7
            
            CreateCorner(8).Parent = ButtonCard
            CreateStroke(1, FluentUI.CurrentTheme.ControlStrokeDefault, 0.7).Parent = ButtonCard
            CreateDropShadow(ButtonCard, 1)
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = ButtonCard
            Button.BackgroundColor3 = FluentUI.CurrentTheme.AccentDefault
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(1, -80, 0, 15)
            Button.Size = UDim2.new(0, 70, 0, 32)
            Button.Font = Enum.Font.GothamMedium
            Button.Text = "Execute"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 12
            Button.ZIndex = 8
            
            CreateCorner(4).Parent = Button
            CreateRevealEffect(Button)
            CreatePressAnimation(Button)
            
            -- Button Text
            local ButtonTitle = Instance.new("TextLabel")
            ButtonTitle.Parent = ButtonCard
            ButtonTitle.BackgroundTransparency = 1
            ButtonTitle.Position = UDim2.new(0, 16, 0, 12)
            ButtonTitle.Size = UDim2.new(0.6, 0, 0, 22)
            ButtonTitle.Font = Enum.Font.GothamMedium
            ButtonTitle.Text = buttonConfig.Name
            ButtonTitle.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
            ButtonTitle.TextSize = 14
            ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
            ButtonTitle.ZIndex = 8
            
            if buttonConfig.Description ~= "" then
                local ButtonDesc = Instance.new("TextLabel")
                ButtonDesc.Parent = ButtonCard
                ButtonDesc.BackgroundTransparency = 1
                ButtonDesc.Position = UDim2.new(0, 16, 0, 34)
                ButtonDesc.Size = UDim2.new(0.6, 0, 0, 20)
                ButtonDesc.Font = Enum.Font.Gotham
                ButtonDesc.Text = buttonConfig.Description
                ButtonDesc.TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary
                ButtonDesc.TextSize = 11
                ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
                ButtonDesc.ZIndex = 8
            end
            
            -- Click handler
            Button.MouseButton1Click:Connect(function()
                local success, err = pcall(buttonConfig.Callback)
                if not success then
                    FluentUI:Notify({
                        Title = "ข้อผิดพลาด",
                        Description = "เกิดข้อผิดพลาด: " .. tostring(err),
                        Type = "Error"
                    })
                end
            end)
            
            self:UpdateCanvasSize()
            return ButtonCard
        end
        
        function TabObject:UpdateCanvasSize()
            local contentSize = self.ElementCount * 85 + 20
            SmoothTween(self.Content, {CanvasSize = UDim2.new(0, 0, 0, contentSize)}, 0.3)
        end
        
        -- Connect events
        CreateRevealEffect(NavButton)
        
        NavButton.MouseButton1Click:Connect(function()
            TabObject:Activate()
        end)
        
        self.Tabs[tabConfig.Name] = TabObject
        
        if self.TabCount == 1 then
            TabObject:Activate()
        end
        
        self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, self.TabCount * 48 + 8)
        
        return TabObject
    end
    
    -- Connect window controls
    CloseBtn.MouseButton1Click:Connect(function()
        WindowObject:Destroy()
    end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        WindowObject:Minimize()
    end)
    
    -- Dragging
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
    
    -- KeyBind
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == windowConfig.KeyBind then
            WindowObject:Toggle()
        end
    end)
    
    -- Initial animation
    BackgroundOverlay.BackgroundTransparency = 1
    Container.Size = UDim2.new(0, 50, 0, 50)
    Container.Position = UDim2.new(0.5, -25, 0.5, -25)
    MainFrame.BackgroundTransparency = 1
    
    SmoothTween(Container, {
        Size = windowConfig.Size,
        Position = UDim2.new(0.5, -windowConfig.Size.X.Offset/2, 0.5, -windowConfig.Size.Y.Offset/2)
    }, 0.6, Enum.EasingStyle.Back)
    
    SmoothTween(MainFrame, {BackgroundTransparency = 0.05}, 0.4)
    SmoothTween(BackgroundOverlay, {BackgroundTransparency = 0.2}, 0.4)
    
    table.insert(FluentUI.Windows, WindowObject)
    return WindowObject
end

-- Notification System
function FluentUI:Notify(config)
    config = config or {}
    
    local notifConfig = {
        Title = config.Title or "แจ้งเตือน",
        Description = config.Description or "",
        Duration = config.Duration or 5,
        Type = config.Type or "Info"
    }
    
    local colors = {
        Info = FluentUI.CurrentTheme.AccentDefault,
        Success = FluentUI.CurrentTheme.SystemFillColorSuccess,
        Warning = FluentUI.CurrentTheme.SystemFillColorCaution,
        Error = FluentUI.CurrentTheme.SystemFillColorCritical
    }
    
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "FluentNotification"
    NotifGui.Parent = GuiParent
    
    local NotifCard = Instance.new("Frame")
    NotifCard.Parent = NotifGui
    NotifCard.BackgroundColor3 = FluentUI.CurrentTheme.CardBackground
    NotifCard.BackgroundTransparency = 0.05
    NotifCard.BorderSizePixel = 0
    NotifCard.Position = UDim2.new(1, 20, 0, 20 + (#FluentUI.Notifications * 90))
    NotifCard.Size = UDim2.new(0, 360, 0, 80)
    NotifCard.ZIndex = 100
    
    CreateCorner(8).Parent = NotifCard
    CreateStroke(1, colors[notifConfig.Type] or colors.Info, 0.5).Parent = NotifCard
    CreateDropShadow(NotifCard, 3)
    CreateAcrylicEffect(NotifCard)
    
    table.insert(FluentUI.Notifications, NotifGui)
    
    -- Slide in
    SmoothTween(NotifCard, {Position = UDim2.new(1, -370, 0, 20 + ((#FluentUI.Notifications-1) * 90))}, 0.5, Enum.EasingStyle.Back)
    
    PlaySound("Success", 0.2)
    
    -- Auto remove
    spawn(function()
        wait(notifConfig.Duration)
        if NotifGui.Parent then
            SmoothTween(NotifCard, {
                Position = UDim2.new(1, 20, 0, NotifCard.Position.Y.Offset),
                Size = UDim2.new(0, 0, 0, 80)
            }, 0.4, nil, nil, function()
                for i, notif in ipairs(FluentUI.Notifications) do
                    if notif == NotifGui then
                        table.remove(FluentUI.Notifications, i)
                        break
                    end
                end
                NotifGui:Destroy()
            end)
        end
    end)
end

-- Theme Management
function FluentUI:SetTheme(themeName)
    if FluentUI.Themes[themeName] then
        FluentUI.CurrentTheme = FluentUI.Themes[themeName]
        
        self:Notify({
            Title = "เปลี่ยนธีมสำเร็จ",
            Description = "เปลี่ยนเป็นธีม " .. themeName .. " แล้ว",
            Type = "Success"
        })
    end
end

return FluentUI
