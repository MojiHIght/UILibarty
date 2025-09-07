-- ProMax UI Library - Modern & Stylish
-- ModuleScript วางใน ReplicatedStorage

local ProMaxUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Configuration & Themes
ProMaxUI.Config = {
    AnimationSpeed = 0.3,
    BlurIntensity = 15,
    GlowEffect = true,
    ParticleEffects = true
}

ProMaxUI.Themes = {
    Neon = {
        Primary = Color3.fromRGB(15, 15, 25),
        Secondary = Color3.fromRGB(20, 20, 30),
        Tertiary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(138, 43, 226),
        AccentHover = Color3.fromRGB(186, 85, 211),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(150, 150, 150),
        Border = Color3.fromRGB(100, 100, 120),
        Glow = Color3.fromRGB(138, 43, 226)
    },
    Cyber = {
        Primary = Color3.fromRGB(10, 10, 15),
        Secondary = Color3.fromRGB(15, 25, 30),
        Tertiary = Color3.fromRGB(20, 30, 35),
        Accent = Color3.fromRGB(0, 255, 157),
        AccentHover = Color3.fromRGB(0, 200, 120),
        Success = Color3.fromRGB(0, 255, 157),
        Warning = Color3.fromRGB(255, 206, 84),
        Error = Color3.fromRGB(255, 71, 87),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(120, 255, 180),
        Border = Color3.fromRGB(0, 120, 80),
        Glow = Color3.fromRGB(0, 255, 157)
    }
}

ProMaxUI.CurrentTheme = ProMaxUI.Themes.Neon
ProMaxUI.Windows = {}

-- Utility Functions
local function CreateGradient(colorSequence, transparency)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSequence or ColorSequence.new(ProMaxUI.CurrentTheme.Primary, ProMaxUI.CurrentTheme.Secondary)
    if transparency then
        gradient.Transparency = transparency
    end
    return gradient
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

local function CreateGlow(parent, color, size)
    if not ProMaxUI.Config.GlowEffect then return end
    
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Parent = parent
    glow.BackgroundTransparency = 1
    glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    glow.ImageColor3 = color or ProMaxUI.CurrentTheme.Glow
    glow.ImageTransparency = 0.8
    glow.Size = UDim2.new(1, size or 20, 1, size or 20)
    glow.Position = UDim2.new(0, -(size or 20)/2, 0, -(size or 20)/2)
    glow.ZIndex = parent.ZIndex - 1
    
    CreateCorner(15).Parent = glow
    return glow
end

local function AnimateIn(object, style)
    style = style or "Scale"
    
    if style == "Scale" then
        object.Size = UDim2.new(0, 0, 0, 0)
        object.AnchorPoint = Vector2.new(0.5, 0.5)
        object.Position = object.Position + UDim2.new(0, object.AbsoluteSize.X/2, 0, object.AbsoluteSize.Y/2)
        
        local tween = TweenService:Create(object, 
            TweenInfo.new(ProMaxUI.Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = UDim2.new(1, 0, 1, 0)}
        )
        tween:Play()
        
    elseif style == "Slide" then
        local originalPos = object.Position
        object.Position = originalPos + UDim2.new(0, 500, 0, 0)
        
        local tween = TweenService:Create(object,
            TweenInfo.new(ProMaxUI.Config.AnimationSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Position = originalPos}
        )
        tween:Play()
    end
end

local function CreateRippleEffect(button)
    local function ripple(x, y)
        local rippleFrame = Instance.new("Frame")
        rippleFrame.Name = "Ripple"
        rippleFrame.Parent = button
        rippleFrame.BackgroundColor3 = ProMaxUI.CurrentTheme.Accent
        rippleFrame.BackgroundTransparency = 0.8
        rippleFrame.BorderSizePixel = 0
        rippleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        rippleFrame.Position = UDim2.new(0, x, 0, y)
        rippleFrame.Size = UDim2.new(0, 0, 0, 0)
        rippleFrame.ZIndex = button.ZIndex + 1
        
        CreateCorner(50).Parent = rippleFrame
        
        local tween = TweenService:Create(rippleFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Size = UDim2.new(0, math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2, 0, math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2),
                BackgroundTransparency = 1
            }
        )
        
        tween:Play()
        tween.Completed:Connect(function()
            rippleFrame:Destroy()
        end)
    end
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local x = input.Position.X - button.AbsolutePosition.X
            local y = input.Position.Y - button.AbsolutePosition.Y
            ripple(x, y)
        end
    end)
end

-- Main Window Creation
function ProMaxUI:CreateWindow(config)
    config = config or {}
    local windowConfig = {
        Title = config.Title or "ProMax UI",
        Subtitle = config.Subtitle or "Modern Interface",
        Size = config.Size or UDim2.new(0, 580, 0, 460),
        Theme = config.Theme or "Neon",
        Draggable = config.Draggable ~= false,
        Resizable = config.Resizable or false,
        MinSize = config.MinSize or UDim2.new(0, 400, 0, 300),
        KeyBind = config.KeyBind or Enum.KeyCode.RightControl
    }
    
    -- Set theme
    if ProMaxUI.Themes[windowConfig.Theme] then
        ProMaxUI.CurrentTheme = ProMaxUI.Themes[windowConfig.Theme]
    end
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ProMaxUI_" .. windowConfig.Title
    ScreenGui.Parent = PlayerGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Background Blur
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Parent = workspace.CurrentCamera
    BlurEffect.Size = 0
    
    -- Main Container
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = ScreenGui
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0.5, -windowConfig.Size.X.Offset/2, 0.5, -windowConfig.Size.Y.Offset/2)
    Container.Size = windowConfig.Size
    Container.ZIndex = 10
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Container
    MainFrame.BackgroundColor3 = ProMaxUI.CurrentTheme.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.ClipsDescendants = true
    
    CreateCorner(12).Parent = MainFrame
    CreateStroke(2, ProMaxUI.CurrentTheme.Border, 0.2).Parent = MainFrame
    
    -- Gradient Background
    local bgGradient = CreateGradient(
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, ProMaxUI.CurrentTheme.Primary),
            ColorSequenceKeypoint.new(0.5, ProMaxUI.CurrentTheme.Secondary),
            ColorSequenceKeypoint.new(1, ProMaxUI.CurrentTheme.Primary)
        }
    )
    bgGradient.Rotation = 45
    bgGradient.Parent = MainFrame
    
    -- Glow Effect
    CreateGlow(MainFrame, ProMaxUI.CurrentTheme.Glow, 30)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
    TitleBar.BackgroundTransparency = 0.1
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    
    local titleGradient = CreateGradient(
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, ProMaxUI.CurrentTheme.Secondary),
            ColorSequenceKeypoint.new(1, ProMaxUI.CurrentTheme.Tertiary)
        }
    )
    titleGradient.Rotation = 90
    titleGradient.Parent = TitleBar
    
    CreateCorner(12).Parent = TitleBar
    
    -- Title Text
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 5)
    TitleLabel.Size = UDim2.new(0.7, 0, 0, 25)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = windowConfig.Title
    TitleLabel.TextColor3 = ProMaxUI.CurrentTheme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Subtitle
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "SubtitleLabel"
    SubtitleLabel.Parent = TitleBar
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Position = UDim2.new(0, 15, 0, 25)
    SubtitleLabel.Size = UDim2.new(0.7, 0, 0, 20)
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.Text = windowConfig.Subtitle
    SubtitleLabel.TextColor3 = ProMaxUI.CurrentTheme.TextDim
    SubtitleLabel.TextSize = 12
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundColor3 = ProMaxUI.CurrentTheme.Error
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -40, 0, 10)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    
    CreateCorner(6).Parent = CloseButton
    CreateRippleEffect(CloseButton)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundColor3 = ProMaxUI.CurrentTheme.Warning
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -75, 0, 10)
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "─"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 14
    
    CreateCorner(6).Parent = MinimizeButton
    CreateRippleEffect(MinimizeButton)
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 50)
    ContentFrame.Size = UDim2.new(1, 0, 1, -50)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = ContentFrame
    Sidebar.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
    Sidebar.BackgroundTransparency = 0.2
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    
    local sidebarGradient = CreateGradient(
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, ProMaxUI.CurrentTheme.Secondary),
            ColorSequenceKeypoint.new(1, ProMaxUI.CurrentTheme.Tertiary)
        }
    )
    sidebarGradient.Rotation = 180
    sidebarGradient.Parent = Sidebar
    
    CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.5).Parent = Sidebar
    
    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 10)
    TabContainer.Size = UDim2.new(1, -20, 1, -20)
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = ProMaxUI.CurrentTheme.Accent
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.FillDirection = Enum.FillDirection.Vertical
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Spacing = UDim.new(0, 5)
    
    -- Main Content Area
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.Parent = ContentFrame
    MainContent.BackgroundTransparency = 1
    MainContent.Position = UDim2.new(0, 150, 0, 0)
    MainContent.Size = UDim2.new(1, -150, 1, 0)
    
    -- Tab Content Container
    local TabContentContainer = Instance.new("Frame")
    TabContentContainer.Name = "TabContentContainer"
    TabContentContainer.Parent = MainContent
    TabContentContainer.BackgroundTransparency = 1
    TabContentContainer.Position = UDim2.new(0, 10, 0, 10)
    TabContentContainer.Size = UDim2.new(1, -20, 1, -20)
    
    -- Window Object
    local WindowObject = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        TitleBar = TitleBar,
        ContentFrame = ContentFrame,
        Sidebar = Sidebar,
        TabContainer = TabContainer,
        TabContentContainer = TabContentContainer,
        TabLayout = TabLayout,
        BlurEffect = BlurEffect,
        Config = windowConfig,
        Tabs = {},
        CurrentTab = nil,
        Visible = true
    }
    
    -- Window Functions
    function WindowObject:Toggle()
        self.Visible = not self.Visible
        local targetTransparency = self.Visible and 0 or 1
        local targetBlur = self.Visible and ProMaxUI.Config.BlurIntensity or 0
        
        local tween = TweenService:Create(self.MainFrame,
            TweenInfo.new(ProMaxUI.Config.AnimationSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {BackgroundTransparency = targetTransparency}
        )
        
        local blurTween = TweenService:Create(self.BlurEffect,
            TweenInfo.new(ProMaxUI.Config.AnimationSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = targetBlur}
        )
        
        tween:Play()
        blurTween:Play()
        
        if not self.Visible then
            AnimateOut(self.MainFrame, "Scale")
        else
            AnimateIn(self.MainFrame, "Scale")
        end
    end
    
    function WindowObject:Destroy()
        self.ScreenGui:Destroy()
        self.BlurEffect:Destroy()
    end
    
    function WindowObject:CreateTab(config)
        config = config or {}
        local tabConfig = {
            Name = config.Name or "Tab",
            Icon = config.Icon or "⚡",
            Active = config.Active or false
        }
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "Tab_" .. tabConfig.Name
        TabButton.Parent = self.TabContainer
        TabButton.BackgroundColor3 = ProMaxUI.CurrentTheme.Tertiary
        TabButton.BackgroundTransparency = 0.3
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tabConfig.Icon .. " " .. tabConfig.Name
        TabButton.TextColor3 = ProMaxUI.CurrentTheme.TextDim
        TabButton.TextSize = 12
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        
        CreateCorner(6).Parent = TabButton
        CreateRippleEffect(TabButton)
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. tabConfig.Name
        TabContent.Parent = self.TabContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 6
        TabContent.ScrollBarImageColor3 = ProMaxUI.CurrentTheme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.FillDirection = Enum.FillDirection.Vertical
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Spacing = UDim.new(0, 10)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        
        -- Auto-resize canvas
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Object
        local TabObject = {
            Button = TabButton,
            Content = TabContent,
            Layout = ContentLayout,
            Config = tabConfig,
            Active = false,
            Elements = {}
        }
        
        -- Tab activation
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
            
            -- Visual feedback
            local activeTween = TweenService:Create(self.Button,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    BackgroundColor3 = ProMaxUI.CurrentTheme.Accent,
                    TextColor3 = ProMaxUI.CurrentTheme.Text,
                    BackgroundTransparency = 0
                }
            )
            activeTween:Play()
            
            -- Show content
            self.Content.Visible = true
            AnimateIn(self.Content, "Slide")
        end
        
        function TabObject:Deactivate()
            self.Active = false
            
            local inactiveTween = TweenService:Create(self.Button,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    BackgroundColor3 = ProMaxUI.CurrentTheme.Tertiary,
                    TextColor3 = ProMaxUI.CurrentTheme.TextDim,
                    BackgroundTransparency = 0.3
                }
            )
            inactiveTween:Play()
            
            self.Content.Visible = false
        end
        
        -- Tab Elements Creation Functions
        function TabObject:CreateButton(config)
            config = config or {}
            local buttonConfig = {
                Name = config.Name or "Button",
                Description = config.Description or "",
                Callback = config.Callback or function() end
            }
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "Button_" .. buttonConfig.Name
            ButtonFrame.Parent = self.Content
            ButtonFrame.BackgroundTransparency = 1
            ButtonFrame.Size = UDim2.new(1, 0, 0, 50)
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = ButtonFrame
            Button.BackgroundColor3 = ProMaxUI.CurrentTheme.Accent
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = buttonConfig.Name
            Button.TextColor3 = ProMaxUI.CurrentTheme.Text
            Button.TextSize = 14
            
            CreateCorner(8).Parent = Button
            CreateGlow(Button, ProMaxUI.CurrentTheme.Accent, 15)
            CreateRippleEffect(Button)
            
            -- Hover effects
            Button.MouseEnter:Connect(function()
                local hoverTween = TweenService:Create(Button,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = ProMaxUI.CurrentTheme.AccentHover}
                )
                hoverTween:Play()
            end)
            
            Button.MouseLeave:Connect(function()
                local leaveTween = TweenService:Create(Button,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = ProMaxUI.CurrentTheme.Accent}
                )
                leaveTween:Play()
            end)
            
            Button.MouseButton1Click:Connect(function()
                buttonConfig.Callback()
            end)
            
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
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle_" .. toggleConfig.Name
            ToggleFrame.Parent = self.Content
            ToggleFrame.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
            ToggleFrame.BackgroundTransparency = 0.2
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(1, 0, 0, 60)
            
            CreateCorner(8).Parent = ToggleFrame
            CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.4).Parent = ToggleFrame
            
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
            ToggleButton.BackgroundColor3 = toggleConfig.Default and ProMaxUI.CurrentTheme.Accent or ProMaxUI.CurrentTheme.Tertiary
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(1, -70, 0.5, -12)
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
            CreateGlow(ToggleKnob, ProMaxUI.CurrentTheme.Text, 8)
            
            local isToggled = toggleConfig.Default
            
            ToggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                
                local buttonTween = TweenService:Create(ToggleButton,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = isToggled and ProMaxUI.CurrentTheme.Accent or ProMaxUI.CurrentTheme.Tertiary}
                )
                
                local knobTween = TweenService:Create(ToggleKnob,
                    TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {Position = UDim2.new(0, isToggled and 28 or 2, 0, 2)}
                )
                
                buttonTween:Play()
                knobTween:Play()
                
                toggleConfig.Callback(isToggled)
            end)
            
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
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider_" .. sliderConfig.Name
            SliderFrame.Parent = self.Content
            SliderFrame.BackgroundColor3 = ProMaxUI.CurrentTheme.Secondary
            SliderFrame.BackgroundTransparency = 0.2
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Size = UDim2.new(1, 0, 0, 80)
            
            CreateCorner(8).Parent = SliderFrame
            CreateStroke(1, ProMaxUI.CurrentTheme.Border, 0.4).Parent = SliderFrame
            
            local NameLabel = Instance.new("TextLabel")
            NameLabel.Parent = SliderFrame
            NameLabel.BackgroundTransparency = 1
            NameLabel.Position = UDim2.new(0, 15, 0, 10)
            NameLabel.Size = UDim2.new(0.6, 0, 0, 20)
            NameLabel.Font = Enum.Font.GothamSemibold
            NameLabel.Text = sliderConfig.Name
            NameLabel.TextColor3 = ProMaxUI.CurrentTheme.Text
            NameLabel.TextSize = 14
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(0.7, 0, 0, 10)
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
            SliderTrack.Position = UDim2.new(0, 15, 0, 45)
            SliderTrack.Size = UDim2.new(1, -30, 0, 6)
            
            CreateCorner(3).Parent = SliderTrack
            
            -- Slider Fill
            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderTrack
            SliderFill.BackgroundColor3 = ProMaxUI.CurrentTheme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
            
            CreateCorner(3).Parent = SliderFill
            CreateGlow(SliderFill, ProMaxUI.CurrentTheme.Accent, 10)
            
            -- Slider Knob
            local SliderKnob = Instance.new("Frame")
            SliderKnob.Parent = SliderTrack
            SliderKnob.BackgroundColor3 = ProMaxUI.CurrentTheme.Text
            SliderKnob.BorderSizePixel = 0
            SliderKnob.Position = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), -8, 0.5, -8)
            SliderKnob.Size = UDim2.new(0, 16, 0, 16)
            SliderKnob.ZIndex = SliderTrack.ZIndex + 1
            
            CreateCorner(8).Parent = SliderKnob
            CreateGlow(SliderKnob, ProMaxUI.CurrentTheme.Text, 12)
            
            local isDragging = false
            local currentValue = sliderConfig.Default
            
            local function updateSlider(input)
                local trackPos = SliderTrack.AbsolutePosition.X
                local trackSize = SliderTrack.AbsoluteSize.X
                local mousePos = input.Position.X
                
                local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                currentValue = math.floor(sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percent)
                
                local fillTween = TweenService:Create(SliderFill,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(percent, 0, 1, 0)}
                )
                
                local knobTween = TweenService:Create(SliderKnob,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Position = UDim2.new(percent, -8, 0.5, -8)}
                )
                
                fillTween:Play()
                knobTween:Play()
                
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
            
            return SliderFrame
        end
        
        -- Connect tab button
        TabButton.MouseButton1Click:Connect(function()
            TabObject:Activate()
        end)
        
        -- Add to window
        self.Tabs[tabConfig.Name] = TabObject
        
        -- Auto-activate first tab
        if tabConfig.Active or #self.Tabs == 1 then
            TabObject:Activate()
        end
        
        return TabObject
    end
    
    -- Event Connections
    CloseButton.MouseButton1Click:Connect(function()
        WindowObject:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        WindowObject:Toggle()
    end)
    
    -- Keybind toggle
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
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                Container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
    
    local blurTween = TweenService:Create(BlurEffect,
        TweenInfo.new(ProMaxUI.Config.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = ProMaxUI.Config.BlurIntensity}
    )
    blurTween:Play()
    
    -- Update canvas size for tabs
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Add to windows list
    table.insert(ProMaxUI.Windows, WindowObject)
    
    return WindowObject
end

-- Additional Utility Functions
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
    
    -- Create notification GUI
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "ProMaxNotification"
    NotifGui.Parent = PlayerGui
    NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Parent = NotifGui
    NotifFrame.BackgroundColor3 = ProMaxUI.CurrentTheme.Primary
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(1, 10, 0, 50)
    NotifFrame.Size = UDim2.new(0, 300, 0, 80)
    
    CreateCorner(8).Parent = NotifFrame
    CreateStroke(2, colors[notifConfig.Type], 0).Parent = NotifFrame
    CreateGlow(NotifFrame, colors[notifConfig.Type], 20)
    
    -- Slide in animation
    local slideIn = TweenService:Create(NotifFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -310, 0, 50)}
    )
    slideIn:Play()
    
    -- Auto dismiss
    wait(notifConfig.Duration)
    local slideOut = TweenService:Create(NotifFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = UDim2.new(1, 10, 0, 50)}
    )
    slideOut:Play()
    slideOut.Completed:Connect(function()
        NotifGui:Destroy()
    end)
end

function ProMaxUI:SetTheme(themeName)
    if ProMaxUI.Themes[themeName] then
        ProMaxUI.CurrentTheme = ProMaxUI.Themes[themeName]
        -- Update all existing windows
        for _, window in pairs(ProMaxUI.Windows) do
            -- Theme update logic here
        end
    end
end

return ProMaxUI
