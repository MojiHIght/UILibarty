-- Complete Fluent UI Library - All Elements
-- ครบครันทุกฟังก์ชันที่จำเป็น

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
    MicaEffect = true,
    CornerRadius = 12
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
    corner.CornerRadius = UDim.new(0, radius or FluentUI.Config.CornerRadius)
    return corner
end

local function CreateStroke(thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or FluentUI.CurrentTheme.ControlStrokeDefault
    stroke.Transparency = transparency or 0
    return stroke
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
        
        CreateCorner(FluentUI.Config.CornerRadius).Parent = reveal
        
        SmoothTween(reveal, {BackgroundTransparency = 0.95}, 0.2)
        
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
    
    table.insert(FluentUI.Connections, revealConnection)
end

local function CreatePressAnimation(button)
    local pressConnection
    pressConnection = button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            PlaySound("Click")
            
            SmoothTween(button, {
                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 2, button.Size.Y.Scale, button.Size.Y.Offset - 2)
            }, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                SmoothTween(button, {
                    Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 2, button.Size.Y.Scale, button.Size.Y.Offset + 2)
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
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Container
    MainFrame.BackgroundColor3 = FluentUI.CurrentTheme.CardBackground
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.ZIndex = 3
    
    CreateCorner(FluentUI.Config.CornerRadius).Parent = MainFrame
    CreateStroke(1, FluentUI.CurrentTheme.ControlStrokeDefault, 0.5).Parent = MainFrame
    CreateDropShadow(MainFrame, 4)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = FluentUI.CurrentTheme.CardBackgroundSecondary
    TitleBar.BackgroundTransparency = 0.3
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 48)
    TitleBar.ZIndex = 4
    
    CreateCorner(FluentUI.Config.CornerRadius).Parent = TitleBar
    
    -- App Icon
    local AppIcon = Instance.new("Frame")
    AppIcon.Name = "AppIcon"
    AppIcon.Parent = TitleBar
    AppIcon.BackgroundColor3 = FluentUI.CurrentTheme.AccentDefault
    AppIcon.BorderSizePixel = 0
    AppIcon.Position = UDim2.new(0, 16, 0.5, -12)
    AppIcon.Size = UDim2.new(0, 24, 0, 24)
    AppIcon.ZIndex = 5
    
    CreateCorner(6).Parent = AppIcon
    
    -- Title & Subtitle
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
    SubtitleLabel.ZIndex = 5
    
    -- Window Controls
    local WindowControls = Instance.new("Frame")
    WindowControls.Name = "WindowControls"
    WindowControls.Parent = TitleBar
    WindowControls.BackgroundTransparency = 1
    WindowControls.Position = UDim2.new(1, -100, 0, 12)
    WindowControls.Size = UDim2.new(0, 92, 0, 24)
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
    
    CreateCorner(6).Parent = MinimizeBtn
    CreateRevealEffect(MinimizeBtn)
    CreatePressAnimation(MinimizeBtn)
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Parent = WindowControls
    CloseBtn.BackgroundColor3 = FluentUI.CurrentTheme.ControlFillDefault
    CloseBtn.BackgroundTransparency = 0.7
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(0, 44, 0, 0)
    CloseBtn.Size = UDim2.new(0, 40, 0, 24)
    CloseBtn.Font = Enum.Font.GothamMedium
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
    CloseBtn.TextSize = 14
    CloseBtn.ZIndex = 6
    
    CreateCorner(6).Parent = CloseBtn
    
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
    
    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = NavPane
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 8, 0, 16)
    TabContainer.Size = UDim2.new(1, -16, 1, -24)
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
        
        CreateCorner(FluentUI.Config.CornerRadius).Parent = NavItem
        
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
        
        CreateCorner(3).Parent = SelectionIndicator
        
        -- Icon & Text
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
            
            for _, tab in pairs(WindowObject.Tabs) do
                if tab.Active then
                    tab:Deactivate()
                end
            end
            
            self.Active = true
            WindowObject.CurrentTab = self
            
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
        
        -- UI Elements Creation Functions
        
        function TabObject:CreateSection(name)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "Section_" .. name
            SectionFrame.Parent = self.Content
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Position = UDim2.new(0, 0, 0, self.ElementCount * 85)
            SectionFrame.Size = UDim2.new(1, 0, 0, 40)
            SectionFrame.ZIndex = 7
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Parent = SectionFrame
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Position = UDim2.new(0, 8, 0, 0)
            SectionLabel.Size = UDim2.new(1, -16, 1, 0)
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.Text = name
            SectionLabel.TextColor3 = FluentUI.CurrentTheme.AccentDefault
            SectionLabel.TextSize = 16
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.ZIndex = 8
            
            local SectionLine = Instance.new("Frame")
            SectionLine.Parent = SectionFrame
            SectionLine.BackgroundColor3 = FluentUI.CurrentTheme.ControlStrokeDefault
            SectionLine.BorderSizePixel = 0
            SectionLine.Position = UDim2.new(0, 8, 1, -2)
            SectionLine.Size = UDim2.new(1, -16, 0, 1)
            SectionLine.ZIndex = 8
            
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
            
            local yPos = self.ElementCount * 85
            self.ElementCount = self.ElementCount + 1
            
            local ButtonCard = Instance.new("Frame")
            ButtonCard.Name = "ButtonCard_" .. buttonConfig.Name
            ButtonCard.Parent = self.Content
            ButtonCard.BackgroundColor3 = FluentUI.CurrentTheme.CardBackground
            ButtonCard.BackgroundTransparency = 0.1
            ButtonCard.BorderSizePixel = 0
            ButtonCard.Position = UDim2.new(0, 0, 0, yPos)
            ButtonCard.Size = UDim2.new(1, -4, 0, 75)
            ButtonCard.ZIndex = 7
            
            CreateCorner(FluentUI.Config.CornerRadius).Parent = ButtonCard
            CreateStroke(1, FluentUI.CurrentTheme.ControlStrokeDefault, 0.7).Parent = ButtonCard
            CreateDropShadow(ButtonCard, 1)
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = ButtonCard
            Button.BackgroundColor3 = FluentUI.CurrentTheme.AccentDefault
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(1, -90, 0, 20)
            Button.Size = UDim2.new(0, 80, 0, 35)
            Button.Font = Enum.Font.GothamMedium
            Button.Text = "Execute"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 12
            Button.ZIndex = 8
            
            CreateCorner(8).Parent = Button
            CreateRevealEffect(Button)
            CreatePressAnimation(Button)
            
            local ButtonTitle = Instance.new("TextLabel")
            ButtonTitle.Parent = ButtonCard
            ButtonTitle.BackgroundTransparency = 1
            ButtonTitle.Position = UDim2.new(0, 16, 0, 15)
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
                ButtonDesc.Position = UDim2.new(0, 16, 0, 37)
                ButtonDesc.Size = UDim2.new(0.6, 0, 0, 20)
                ButtonDesc.Font = Enum.Font.Gotham
                ButtonDesc.Text = buttonConfig.Description
                ButtonDesc.TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary
                ButtonDesc.TextSize = 11
                ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
                ButtonDesc.ZIndex = 8
            end
            
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
        
        function TabObject:CreateToggle(config)
            config = config or {}
            
            local toggleConfig = {
                Name = config.Name or "Toggle",
                Description = config.Description or "",
                Default = config.Default or false,
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 85
            self.ElementCount = self.ElementCount + 1
            
            local ToggleCard = Instance.new("Frame")
            ToggleCard.Name = "ToggleCard_" .. toggleConfig.Name
            ToggleCard.Parent = self.Content
            ToggleCard.BackgroundColor3 = FluentUI.CurrentTheme.CardBackground
            ToggleCard.BackgroundTransparency = 0.1
            ToggleCard.BorderSizePixel = 0
            ToggleCard.Position = UDim2.new(0, 0, 0, yPos)
            ToggleCard.Size = UDim2.new(1, -4, 0, 75)
            ToggleCard.ZIndex = 7
            
            CreateCorner(FluentUI.Config.CornerRadius).Parent = ToggleCard
            CreateStroke(1, FluentUI.CurrentTheme.ControlStrokeDefault, 0.7).Parent = ToggleCard
            CreateDropShadow(ToggleCard, 1)
            
            local ToggleSwitch = Instance.new("Frame")
            ToggleSwitch.Name = "ToggleSwitch"
            ToggleSwitch.Parent = ToggleCard
            ToggleSwitch.BackgroundColor3 = toggleConfig.Default and FluentUI.CurrentTheme.AccentDefault or FluentUI.CurrentTheme.ControlStrokeDefault
            ToggleSwitch.BorderSizePixel = 0
            ToggleSwitch.Position = UDim2.new(1, -70, 0, 25)
            ToggleSwitch.Size = UDim2.new(0, 60, 0, 25)
            ToggleSwitch.ZIndex = 8
            
            CreateCorner(13).Parent = ToggleSwitch
            
            local ToggleKnob = Instance.new("Frame")
            ToggleKnob.Name = "ToggleKnob"
            ToggleKnob.Parent = ToggleSwitch
            ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleKnob.BorderSizePixel = 0
            ToggleKnob.Position = UDim2.new(0, toggleConfig.Default and 37 or 3, 0, 3)
            ToggleKnob.Size = UDim2.new(0, 19, 0, 19)
            ToggleKnob.ZIndex = 9
            
            CreateCorner(10).Parent = ToggleKnob
            CreateDropShadow(ToggleKnob, 1)
            
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
            ToggleTitle.Position = UDim2.new(0, 16, 0, 15)
            ToggleTitle.Size = UDim2.new(0.6, 0, 0, 22)
            ToggleTitle.Font = Enum.Font.GothamMedium
            ToggleTitle.Text = toggleConfig.Name
            ToggleTitle.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
            ToggleTitle.TextSize = 14
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            ToggleTitle.ZIndex = 8
            
            if toggleConfig.Description ~= "" then
                local ToggleDesc = Instance.new("TextLabel")
                ToggleDesc.Parent = ToggleCard
                ToggleDesc.BackgroundTransparency = 1
                ToggleDesc.Position = UDim2.new(0, 16, 0, 37)
                ToggleDesc.Size = UDim2.new(0.6, 0, 0, 20)
                ToggleDesc.Font = Enum.Font.Gotham
                ToggleDesc.Text = toggleConfig.Description
                ToggleDesc.TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary
                ToggleDesc.TextSize = 11
                ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
                ToggleDesc.ZIndex = 8
            end
            
            local isToggled = toggleConfig.Default
            
            ToggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                PlaySound("Click", 0.1)
                
                SmoothTween(ToggleSwitch, {
                    BackgroundColor3 = isToggled and FluentUI.CurrentTheme.AccentDefault or FluentUI.CurrentTheme.ControlStrokeDefault
                }, 0.3)
                
                SmoothTween(ToggleKnob, {
                    Position = UDim2.new(0, isToggled and 37 or 3, 0, 3)
                }, 0.3, Enum.EasingStyle.Back)
                
                local success, err = pcall(toggleConfig.Callback, isToggled)
                if not success then
                    FluentUI:Notify({
                        Title = "ข้อผิดพลาด",
                        Description = "เกิดข้อผิดพลาด: " .. tostring(err),
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
            
            local yPos = self.ElementCount * 85
            self.ElementCount = self.ElementCount + 1
            
            local SliderCard = Instance.new("Frame")
            SliderCard.Name = "SliderCard_" .. sliderConfig.Name
            SliderCard.Parent = self.Content
            SliderCard.BackgroundColor3 = FluentUI.CurrentTheme.CardBackground
            SliderCard.BackgroundTransparency = 0.1
            SliderCard.BorderSizePixel = 0
            SliderCard.Position = UDim2.new(0, 0, 0, yPos)
            SliderCard.Size = UDim2.new(1, -4, 0, 75)
            SliderCard.ZIndex = 7
            
            CreateCorner(FluentUI.Config.CornerRadius).Parent = SliderCard
            CreateStroke(1, FluentUI.CurrentTheme.ControlStrokeDefault, 0.7).Parent = SliderCard
            CreateDropShadow(SliderCard, 1)
            
            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Parent = SliderCard
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 16, 0, 8)
            SliderTitle.Size = UDim2.new(0.5, 0, 0, 20)
            SliderTitle.Font = Enum.Font.GothamMedium
            SliderTitle.Text = sliderConfig.Name
            SliderTitle.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
            SliderTitle.TextSize = 14
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            SliderTitle.ZIndex = 8
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderCard
            ValueLabel.BackgroundColor3 = FluentUI.CurrentTheme.AccentDefault
            ValueLabel.BorderSizePixel = 0
            ValueLabel.Position = UDim2.new(1, -70, 0, 8)
            ValueLabel.Size = UDim2.new(0, 60, 0, 20)
            ValueLabel.Font = Enum.Font.GothamMedium
            ValueLabel.Text = tostring(sliderConfig.Default)
            ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueLabel.TextSize = 12
            ValueLabel.ZIndex = 8
            
            CreateCorner(6).Parent = ValueLabel
            
            if sliderConfig.Description ~= "" then
                local SliderDesc = Instance.new("TextLabel")
                SliderDesc.Parent = SliderCard
                SliderDesc.BackgroundTransparency = 1
                SliderDesc.Position = UDim2.new(0, 16, 0, 28)
                SliderDesc.Size = UDim2.new(0.7, 0, 0, 15)
                SliderDesc.Font = Enum.Font.Gotham
                SliderDesc.Text = sliderConfig.Description
                SliderDesc.TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary
                SliderDesc.TextSize = 11
                SliderDesc.TextXAlignment = Enum.TextXAlignment.Left
                SliderDesc.ZIndex = 8
            end
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "SliderTrack"
            SliderTrack.Parent = SliderCard
            SliderTrack.BackgroundColor3 = FluentUI.CurrentTheme.ControlStrokeDefault
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Position = UDim2.new(0, 16, 0, 50)
            SliderTrack.Size = UDim2.new(1, -32, 0, 6)
            SliderTrack.ZIndex = 8
            
            CreateCorner(3).Parent = SliderTrack
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Parent = SliderTrack
            SliderFill.BackgroundColor3 = FluentUI.CurrentTheme.AccentDefault
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
            SliderFill.ZIndex = 9
            
            CreateCorner(3).Parent = SliderFill
            
            local SliderKnob = Instance.new("Frame")
            SliderKnob.Name = "SliderKnob"
            SliderKnob.Parent = SliderTrack
            SliderKnob.BackgroundColor3 = FluentUI.CurrentTheme.AccentDefault
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
                SmoothTween(SliderKnob, {Position = UDim2.new(finalPercent, -8, 0.5, -8)}, 0.1)
                
                ValueLabel.Text = tostring(currentValue)
                
                local success, err = pcall(sliderConfig.Callback, currentValue)
                if not success then
                    FluentUI:Notify({
                        Title = "ข้อผิดพลาด",
                        Description = "เกิดข้อผิดพลาด: " .. tostring(err),
                        Type = "Error"
                    })
                end
            end
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    PlaySound("Click", 0.1)
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
            
            local yPos = self.ElementCount * 85
            self.ElementCount = self.ElementCount + 1
            
            local DropdownCard = Instance.new("Frame")
            DropdownCard.Name = "DropdownCard_" .. dropdownConfig.Name
            DropdownCard.Parent = self.Content
            DropdownCard.BackgroundColor3 = FluentUI.CurrentTheme.CardBackground
            DropdownCard.BackgroundTransparency = 0.1
            DropdownCard.BorderSizePixel = 0
            DropdownCard.Position = UDim2.new(0, 0, 0, yPos)
            DropdownCard.Size = UDim2.new(1, -4, 0, 75)
            DropdownCard.ZIndex = 7
            DropdownCard.ClipsDescendants = false
            
            CreateCorner(FluentUI.Config.CornerRadius).Parent = DropdownCard
            CreateStroke(1, FluentUI.CurrentTheme.ControlStrokeDefault, 0.7).Parent = DropdownCard
            CreateDropShadow(DropdownCard, 1)
            
            local DropdownTitle = Instance.new("TextLabel")
            DropdownTitle.Parent = DropdownCard
            DropdownTitle.BackgroundTransparency = 1
            DropdownTitle.Position = UDim2.new(0, 16, 0, 8)
            DropdownTitle.Size = UDim2.new(0.4, 0, 0, 20)
            DropdownTitle.Font = Enum.Font.GothamMedium
            DropdownTitle.Text = dropdownConfig.Name
            DropdownTitle.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
            DropdownTitle.TextSize = 14
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropdownTitle.ZIndex = 8
            
            if dropdownConfig.Description ~= "" then
                local DropdownDesc = Instance.new("TextLabel")
                DropdownDesc.Parent = DropdownCard
                DropdownDesc.BackgroundTransparency = 1
                DropdownDesc.Position = UDim2.new(0, 16, 0, 28)
                DropdownDesc.Size = UDim2.new(0.4, 0, 0, 15)
                DropdownDesc.Font = Enum.Font.Gotham
                DropdownDesc.Text = dropdownConfig.Description
                DropdownDesc.TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary
                DropdownDesc.TextSize = 11
                DropdownDesc.TextXAlignment = Enum.TextXAlignment.Left
                DropdownDesc.ZIndex = 8
            end
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Parent = DropdownCard
            DropdownButton.BackgroundColor3 = FluentUI.CurrentTheme.ControlFillDefault
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Position = UDim2.new(0.5, 10, 0, 20)
            DropdownButton.Size = UDim2.new(0.5, -26, 0, 35)
            DropdownButton.Font = Enum.Font.GothamMedium
            DropdownButton.Text = dropdownConfig.Default .. " ▼"
            DropdownButton.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
            DropdownButton.TextSize = 12
            DropdownButton.ZIndex = 8
            
            CreateCorner(8).Parent = DropdownButton
            CreateStroke(1, FluentUI.CurrentTheme.ControlStrokeDefault, 0.5).Parent = DropdownButton
            CreateRevealEffect(DropdownButton)
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "DropdownList"
            DropdownList.Parent = DropdownCard
            DropdownList.BackgroundColor3 = FluentUI.CurrentTheme.CardBackground
            DropdownList.BorderSizePixel = 0
            DropdownList.Position = UDim2.new(0.5, 10, 0, 60)
            DropdownList.Size = UDim2.new(0.5, -26, 0, 0)
            DropdownList.Visible = false
            DropdownList.ZIndex = 20
            DropdownList.ClipsDescendants = true
            
            CreateCorner(8).Parent = DropdownList
            CreateStroke(1, FluentUI.CurrentTheme.AccentDefault, 0.3).Parent = DropdownList
            CreateDropShadow(DropdownList, 3)
            
            local isOpen = false
            local selectedOption = dropdownConfig.Default
            
            for i, option in ipairs(dropdownConfig.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = "Option_" .. option
                OptionButton.Parent = DropdownList
                OptionButton.BackgroundColor3 = option == selectedOption and FluentUI.CurrentTheme.AccentDefault or Color3.fromRGB(0, 0, 0)
                OptionButton.BackgroundTransparency = option == selectedOption and 0.2 or 1
                OptionButton.BorderSizePixel = 0
                OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.Font = Enum.Font.GothamMedium
                OptionButton.Text = option
                OptionButton.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
                OptionButton.TextSize = 11
                OptionButton.ZIndex = 21
                
                CreateRevealEffect(OptionButton)
                
                OptionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    DropdownButton.Text = option .. " ▼"
                    PlaySound("Click", 0.1)
                    
                    for _, btn in pairs(DropdownList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            SmoothTween(btn, {
                                BackgroundTransparency = btn.Text == option and 0.2 or 1
                            })
                        end
                    end
                    
                    isOpen = false
                    SmoothTween(DropdownList, {Size = UDim2.new(0.5, -26, 0, 0)}, 0.3, nil, nil, function()
                        DropdownList.Visible = false
                    end)
                    
                    local success, err = pcall(dropdownConfig.Callback, option)
                    if not success then
                        FluentUI:Notify({
                            Title = "ข้อผิดพลาด",
                            Description = "เกิดข้อผิดพลาด: " .. tostring(err),
                            Type = "Error"
                        })
                    end
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                PlaySound("Click", 0.1)
                
                if isOpen then
                    DropdownButton.Text = selectedOption .. " ▲"
                    DropdownList.Visible = true
                    SmoothTween(DropdownList, {Size = UDim2.new(0.5, -26, 0, #dropdownConfig.Options * 30)}, 0.3, Enum.EasingStyle.Back)
                else
                    DropdownButton.Text = selectedOption .. " ▼"
                    SmoothTween(DropdownList, {Size = UDim2.new(0.5, -26, 0, 0)}, 0.3, nil, nil, function()
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
                PlaceholderText = config.PlaceholderText or "กรอกข้อความ...",
                Callback = config.Callback or function() end
            }
            
            local yPos = self.ElementCount * 85
            self.ElementCount = self.ElementCount + 1
            
            local TextboxCard = Instance.new("Frame")
            TextboxCard.Name = "TextboxCard_" .. textboxConfig.Name
            TextboxCard.Parent = self.Content
            TextboxCard.BackgroundColor3 = FluentUI.CurrentTheme.CardBackground
            TextboxCard.BackgroundTransparency = 0.1
            TextboxCard.BorderSizePixel = 0
            TextboxCard.Position = UDim2.new(0, 0, 0, yPos)
            TextboxCard.Size = UDim2.new(1, -4, 0, 75)
            TextboxCard.ZIndex = 7
            
            CreateCorner(FluentUI.Config.CornerRadius).Parent = TextboxCard
            CreateStroke(1, FluentUI.CurrentTheme.ControlStrokeDefault, 0.7).Parent = TextboxCard
            CreateDropShadow(TextboxCard, 1)
            
            local TextboxTitle = Instance.new("TextLabel")
            TextboxTitle.Parent = TextboxCard
            TextboxTitle.BackgroundTransparency = 1
            TextboxTitle.Position = UDim2.new(0, 16, 0, 8)
            TextboxTitle.Size = UDim2.new(0.4, 0, 0, 20)
            TextboxTitle.Font = Enum.Font.GothamMedium
            TextboxTitle.Text = textboxConfig.Name
            TextboxTitle.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
            TextboxTitle.TextSize = 14
            TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left
            TextboxTitle.ZIndex = 8
            
            if textboxConfig.Description ~= "" then
                local TextboxDesc = Instance.new("TextLabel")
                TextboxDesc.Parent = TextboxCard
                TextboxDesc.BackgroundTransparency = 1
                TextboxDesc.Position = UDim2.new(0, 16, 0, 28)
                TextboxDesc.Size = UDim2.new(0.4, 0, 0, 15)
                TextboxDesc.Font = Enum.Font.Gotham
                TextboxDesc.Text = textboxConfig.Description
                TextboxDesc.TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary
                TextboxDesc.TextSize = 11
                TextboxDesc.TextXAlignment = Enum.TextXAlignment.Left
                TextboxDesc.ZIndex = 8
            end
            
            local Textbox = Instance.new("TextBox")
            Textbox.Name = "Textbox"
            Textbox.Parent = TextboxCard
            Textbox.BackgroundColor3 = FluentUI.CurrentTheme.ControlFillDefault
            Textbox.BorderSizePixel = 0
            Textbox.Position = UDim2.new(0.5, 10, 0, 20)
            Textbox.Size = UDim2.new(0.5, -26, 0, 35)
            Textbox.Font = Enum.Font.GothamMedium
            Textbox.PlaceholderText = textboxConfig.PlaceholderText
            Textbox.PlaceholderColor3 = FluentUI.CurrentTheme.TextFillColorTertiary
            Textbox.Text = ""
            Textbox.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
            Textbox.TextSize = 12
            Textbox.ZIndex = 8
            
            CreateCorner(8).Parent = Textbox
            CreateStroke(1, FluentUI.CurrentTheme.ControlStrokeDefault, 0.5).Parent = Textbox
            
            -- Focus effects
            Textbox.Focused:Connect(function()
                SmoothTween(Textbox:FindFirstChild("UIStroke"), {
                    Color = FluentUI.CurrentTheme.AccentDefault,
                    Transparency = 0
                }, 0.2)
            end)
            
            Textbox.FocusLost:Connect(function(enterPressed)
                SmoothTween(Textbox:FindFirstChild("UIStroke"), {
                    Color = FluentUI.CurrentTheme.ControlStrokeDefault,
                    Transparency = 0.5
                }, 0.2)
                
                if enterPressed then
                    local success, err = pcall(textboxConfig.Callback, Textbox.Text)
                    if not success then
                        FluentUI:Notify({
                            Title = "ข้อผิดพลาด",
                            Description = "เกิดข้อผิดพลาด: " .. tostring(err),
                            Type = "Error"
                        })
                    end
                end
            end)
            
            self:UpdateCanvasSize()
            return TextboxCard
        end
        
        function TabObject:UpdateCanvasSize()
            local contentSize = self.ElementCount * 90 + 20
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

-- Beautiful Notification System (Fixed)
function FluentUI:Notify(config)
    config = config or {}
    
    local notifConfig = {
        Title = config.Title or "แจ้งเตือน",
        Description = config.Description or "ไม่มีรายละเอียด",
        Duration = config.Duration or 5,
        Type = config.Type or "Info"
    }
    
    local typeIcons = {
        Info = "ℹ️",
        Success = "✅", 
        Warning = "⚠️",
        Error = "❌"
    }
    
    local typeColors = {
        Info = FluentUI.CurrentTheme.AccentDefault,
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
    NotifCard.BackgroundColor3 = FluentUI.CurrentTheme.CardBackground
    NotifCard.BackgroundTransparency = 0.05
    NotifCard.BorderSizePixel = 0
    NotifCard.Position = UDim2.new(1, 20, 1, -100 - (#FluentUI.Notifications * 110))
    NotifCard.Size = UDim2.new(0, 380, 0, 90)
    NotifCard.ZIndex = 100
    
    CreateCorner(FluentUI.Config.CornerRadius).Parent = NotifCard
    CreateStroke(2, typeColors[notifConfig.Type] or typeColors.Info, 0.3).Parent = NotifCard
    CreateDropShadow(NotifCard, 4)
    
    -- Icon
    local NotifIcon = Instance.new("TextLabel")
    NotifIcon.Parent = NotifCard
    NotifIcon.BackgroundTransparency = 1
    NotifIcon.Position = UDim2.new(0, 20, 0, 20)
    NotifIcon.Size = UDim2.new(0, 30, 0, 30)
    NotifIcon.Font = Enum.Font.GothamBold
    NotifIcon.Text = typeIcons[notifConfig.Type] or typeIcons.Info
    NotifIcon.TextColor3 = typeColors[notifConfig.Type] or typeColors.Info
    NotifIcon.TextSize = 20
    NotifIcon.ZIndex = 101
    
    -- Title
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = NotifCard
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 60, 0, 15)
    NotifTitle.Size = UDim2.new(1, -80, 0, 25)
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = notifConfig.Title
    NotifTitle.TextColor3 = FluentUI.CurrentTheme.TextFillColorPrimary
    NotifTitle.TextSize = 14
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.TextTruncate = Enum.TextTruncate.AtEnd
    NotifTitle.ZIndex = 101
    
    -- Description
    local NotifDesc = Instance.new("TextLabel")
    NotifDesc.Parent = NotifCard
    NotifDesc.BackgroundTransparency = 1
    NotifDesc.Position = UDim2.new(0, 60, 0, 40)
    NotifDesc.Size = UDim2.new(1, -80, 0, 35)
    NotifDesc.Font = Enum.Font.Gotham
    NotifDesc.Text = notifConfig.Description
    NotifDesc.TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary
    NotifDesc.TextSize = 12
    NotifDesc.TextXAlignment = Enum.TextXAlignment.Left
    NotifDesc.TextWrapped = true
    NotifDesc.TextYAlignment = Enum.TextYAlignment.Top
    NotifDesc.ZIndex = 101
    
    -- Close Button
    local CloseNotifBtn = Instance.new("TextButton")
    CloseNotifBtn.Parent = NotifCard
    CloseNotifBtn.BackgroundColor3 = FluentUI.CurrentTheme.ControlFillDefault
    CloseNotifBtn.BackgroundTransparency = 0.8
    CloseNotifBtn.BorderSizePixel = 0
    CloseNotifBtn.Position = UDim2.new(1, -35, 0, 10)
    CloseNotifBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseNotifBtn.Font = Enum.Font.GothamMedium
    CloseNotifBtn.Text = "×"
    CloseNotifBtn.TextColor3 = FluentUI.CurrentTheme.TextFillColorSecondary
    CloseNotifBtn.TextSize = 14
    CloseNotifBtn.ZIndex = 102
    
    CreateCorner(6).Parent = CloseNotifBtn
    CreateRevealEffect(CloseNotifBtn)
    
    CloseNotifBtn.MouseButton1Click:Connect(function()
        SmoothTween(NotifCard, {
            Position = UDim2.new(1, 20, NotifCard.Position.Y.Scale, NotifCard.Position.Y.Offset),
            Size = UDim2.new(0, 0, 0, 90)
        }, 0.4, nil, nil, function()
            for i, notif in ipairs(FluentUI.Notifications) do
                if notif == NotifGui then
                    table.remove(FluentUI.Notifications, i)
                    break
                end
            end
            NotifGui:Destroy()
        end)
    end)
    
    -- Add to list
    table.insert(FluentUI.Notifications, NotifGui)
    
    -- Slide in animation
    SmoothTween(NotifCard, {
        Position = UDim2.new(1, -390, 1, -100 - ((#FluentUI.Notifications-1) * 110))
    }, 0.5, Enum.EasingStyle.Back)
    
    PlaySound(notifConfig.Type == "Error" and "Error" or "Success", 0.2)
    
    -- Auto remove
    spawn(function()
        wait(notifConfig.Duration)
        if NotifGui.Parent then
            SmoothTween(NotifCard, {
                Position = UDim2.new(1, 20, NotifCard.Position.Y.Scale, NotifCard.Position.Y.Offset),
                Size = UDim2.new(0, 0, 0, 90)
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
            Description = "เปลี่ยนเป็นธีม " .. themeName .. " เรียบร้อยแล้ว",
            Type = "Success"
        })
    end
end

-- Cleanup function
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
