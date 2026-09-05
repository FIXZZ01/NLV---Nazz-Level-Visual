-- ============================================================
-- NLV - Next Level Visuals
-- Version: VIP 100 Day
-- Creator: Nazz Dev
-- Powered By: Hostkita Team
-- Support: ALL Executors | No Key Required | Universal
-- Game Support: ALL Roblox Games
-- ============================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- NLV CONFIGURATION
-- ============================================================
local NLV = {
    Version = "VIP 100 Day",
    Creator = "Nazz Dev",
    Team = "Hostkita Team",
    IsVIP = true,
    CurrentMode = "Balanced",
    FPSUnlocked = false,
    FPSSuperX = false,
    FontMode = false,
    SelectedFont = "Gotham",

    Settings = {
        Low = {
            QualityLevel = Enum.QualityLevel.Level01,
            Shadows = false,
            AntiAliasing = false,
            TextureQuality = 0,
            ParticleLimit = 50,
            DrawDistance = 500,
            MeshDetail = 0,
            FrameRateCap = 60,
            Description = "Maximum performance, minimal visuals"
        },
        Balanced = {
            QualityLevel = Enum.QualityLevel.Level05,
            Shadows = true,
            AntiAliasing = true,
            TextureQuality = 2,
            ParticleLimit = 200,
            DrawDistance = 1000,
            MeshDetail = 2,
            FrameRateCap = 60,
            Description = "Best of both worlds"
        },
        Max = {
            QualityLevel = Enum.QualityLevel.Level21,
            Shadows = true,
            AntiAliasing = true,
            TextureQuality = 5,
            ParticleLimit = 1000,
            DrawDistance = 2000,
            MeshDetail = 5,
            FrameRateCap = 240,
            FPSUnlockEnabled = false,
            Description = "Maximum visuals, high performance"
        },
        VIP = {
            QualityLevel = Enum.QualityLevel.Level21,
            Shadows = true,
            AntiAliasing = true,
            TextureQuality = 10,
            ParticleLimit = 5000,
            DrawDistance = 5000,
            MeshDetail = 10,
            FrameRateCap = 999,
            FPSUnlockEnabled = true,
            HDMaps = true,
            UltraSmooth = true,
            CustomShaders = true,
            Description = "ULTIMATE - Full control, HD everything"
        }
    },

    Fonts = {
        "Gotham", "GothamBold", "GothamBlack",
        "SourceSans", "SourceSansBold", "SourceSansItalic", "SourceSansLight",
        "Arial", "ArialBold",
        "Bangers", "Cartoon", "Code", "Creepster",
        "DenkOne", "Fondamento", "FredokaOne",
        "Guru", "Highway", "IndieFlower",
        "JosefinSans", "Jura", "Kalam",
        "Legacy", "LilitaOne", "Michroma",
        "Nunito", "Oswald", "PatrickHand",
        "PermanentMarker", "Roboto", "RobotoCondensed",
        "RobotoMono", "Sarpanch", "SpecialElite",
        "TitilliumWeb", "Ubuntu", "Zekton"
    }
}

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
local Utility = {}

function Utility:Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        local success, err = pcall(function()
            instance[property] = value
        end)
        if not success then
            warn("NLV: Failed to set " .. tostring(property) .. " on " .. className)
        end
    end
    return instance
end

function Utility:Tween(instance, properties, duration, easingStyle, easingDirection, callback)
    if not instance or not instance.Parent then return nil end
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(
            duration or 0.4,
            easingStyle or Enum.EasingStyle.Quart,
            easingDirection or Enum.EasingDirection.Out
        ),
        properties
    )
    if callback then
        tween.Completed:Connect(callback)
    end
    tween:Play()
    return tween
end

function Utility:MakeDraggable(frame, handle)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

    handle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============================================================
-- PERFORMANCE ENGINE
-- ============================================================
local PerformanceEngine = {}

function PerformanceEngine:ApplySettings(mode)
    local settings = NLV.Settings[mode]
    if not settings then 
        warn("NLV: Invalid mode " .. tostring(mode))
        return 
    end

    NLV.CurrentMode = mode

    -- Quality Level
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = settings.QualityLevel
    end)

    -- Lighting
    pcall(function()
        Lighting.GlobalShadows = settings.Shadows
        Lighting.Outlines = false

        if mode == "Low" then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = settings.DrawDistance
            Lighting.FogStart = settings.DrawDistance * 0.5
        elseif mode == "Max" or mode == "VIP" then
            Lighting.Brightness = 1.5
            Lighting.ClockTime = 14
            Lighting.FogEnd = 999999
            Lighting.FogStart = 999999

            if settings.HDMaps then
                Lighting.Ambient = Color3.fromRGB(120, 120, 130)
                Lighting.OutdoorAmbient = Color3.fromRGB(140, 140, 150)
                Lighting.ColorShift_Bottom = Color3.fromRGB(100, 100, 110)
                Lighting.ColorShift_Top = Color3.fromRGB(150, 150, 160)
            end
        end
    end)

    -- Workspace LOD
    pcall(function()
        Workspace.LevelOfDetailMode = mode == "Low" and Enum.ModelLevelOfDetail.Disabled or Enum.ModelLevelOfDetail.Automatic
    end)

    -- Texture Optimization
    pcall(function()
        for _, texture in pairs(Workspace:GetDescendants()) do
            if texture:IsA("Texture") or texture:IsA("Decal") then
                if mode == "Low" then
                    texture.Transparency = 0.3
                elseif mode == "VIP" then
                    texture.Transparency = 0
                end
            end
        end
    end)

    -- Particle Limit
    pcall(function()
        for _, particle in pairs(Workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") then
                if mode == "Low" then
                    particle.Rate = math.min(particle.Rate, settings.ParticleLimit / 10)
                    particle.Enabled = particle.Rate > 0
                elseif mode == "VIP" then
                    particle.Rate = particle.Rate * 2
                end
            end
        end
    end)

    -- Mesh Detail
    pcall(function()
        for _, mesh in pairs(Workspace:GetDescendants()) do
            if mesh:IsA("MeshPart") then
                if mode == "Low" then
                    mesh.RenderFidelity = Enum.RenderFidelity.Performance
                elseif mode == "VIP" then
                    mesh.RenderFidelity = Enum.RenderFidelity.Precise
                end
            end
        end
    end)

    -- VIP Features
    if mode == "VIP" then
        self:ApplyVIPFeatures()
    end

    -- FPS Handling
    self:HandleFPS(mode)
end

function PerformanceEngine:HandleFPS(mode)
    local settings = NLV.Settings[mode]

    if mode == "Max" and settings.FPSUnlockEnabled then
        NLV.FPSUnlocked = true
        pcall(function()
            setfpscap(240)
        end)
    elseif mode == "VIP" then
        NLV.FPSUnlocked = true
        pcall(function()
            setfpscap(999)
        end)
    else
        NLV.FPSUnlocked = false
        pcall(function()
            setfpscap(settings.FrameRateCap or 60)
        end)
    end

    if mode == "Low" and NLV.FPSSuperX then
        pcall(function()
            setfpscap(999)
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsA("MeshPart") then
                    obj.Material = Enum.Material.SmoothPlastic
                end
                if obj:IsA("UnionOperation") then
                    obj.UsePartColor = true
                end
            end
        end)
    end
end

function PerformanceEngine:ApplyVIPFeatures()
    pcall(function()
        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterColor = Color3.fromRGB(20, 80, 120)
            terrain.WaterTransparency = 0.3
            terrain.WaterWaveSize = 0.15
            terrain.WaterWaveSpeed = 10
        end

        local sky = Lighting:FindFirstChildOfClass("Sky")
        if not sky then
            sky = Instance.new("Sky")
            sky.Parent = Lighting
        end
        sky.SunTextureId = "rbxassetid://151165201"
        sky.MoonTextureId = "rbxassetid://151165214"
        sky.SunAngularSize = 15
        sky.MoonAngularSize = 11

        local bloom = Lighting:FindFirstChild("NLV_Bloom")
        if not bloom then
            bloom = Instance.new("BloomEffect")
            bloom.Name = "NLV_Bloom"
            bloom.Intensity = 2
            bloom.Size = 24
            bloom.Threshold = 2
            bloom.Parent = Lighting
        end

        local colorCorrection = Lighting:FindFirstChild("NLV_ColorCorrection")
        if not colorCorrection then
            colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.Name = "NLV_ColorCorrection"
            colorCorrection.Brightness = 0.05
            colorCorrection.Contrast = 0.1
            colorCorrection.Saturation = 0.15
            colorCorrection.TintColor = Color3.fromRGB(255, 248, 240)
            colorCorrection.Parent = Lighting
        end

        local blur = Lighting:FindFirstChild("NLV_Blur")
        if not blur then
            blur = Instance.new("BlurEffect")
            blur.Name = "NLV_Blur"
            blur.Size = 2
            blur.Parent = Lighting
        end
    end)
end

-- ============================================================
-- FONT ENGINE
-- ============================================================
local FontEngine = {}
FontEngine.Connection = nil

function FontEngine:ChangeFont(fontName)
    local fontEnum = Enum.Font[fontName]
    if not fontEnum then 
        warn("NLV: Invalid font " .. tostring(fontName))
        return 
    end

    NLV.SelectedFont = fontName
    NLV.FontMode = true

    local function changeTextFont(parent)
        for _, obj in pairs(parent:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                pcall(function()
                    obj.Font = fontEnum
                end)
            end
        end
    end

    pcall(function() changeTextFont(PlayerGui) end)
    pcall(function() changeTextFont(CoreGui) end)
    pcall(function() changeTextFont(StarterGui) end)

    if FontEngine.Connection then
        FontEngine.Connection:Disconnect()
    end

    FontEngine.Connection = RunService.Heartbeat:Connect(function()
        pcall(function() changeTextFont(PlayerGui) end)
    end)
end

function FontEngine:ResetFont()
    NLV.FontMode = false
    if FontEngine.Connection then
        FontEngine.Connection:Disconnect()
        FontEngine.Connection = nil
    end
end

-- ============================================================
-- UI CONSTRUCTION - GLASS THEME
-- ============================================================
local UI = {}

function UI:Init()
    -- ScreenGui
    self.ScreenGui = Utility:Create("ScreenGui", {
        Name = "NLV_VIP_100Day",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    -- Main Frame
    self.MainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 420, 0, 580),
        Position = UDim2.new(0.5, -210, 0.5, -290),
        BackgroundTransparency = 1,
        Parent = self.ScreenGui
    })

    -- Glass Background
    self.GlassBg = Utility:Create("Frame", {
        Name = "GlassBg",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(15, 15, 20),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })

    local mainCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 20),
        Parent = self.GlassBg
    })

    local mainStroke = Utility:Create("UIStroke", {
        Color = Color3.fromRGB(80, 120, 200),
        Thickness = 1.5,
        Transparency = 0.5,
        Parent = self.GlassBg
    })

    local glassGradient = Utility:Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 230, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 210, 240))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(0.5, 0.9),
            NumberSequenceKeypoint.new(1, 0.88)
        }),
        Rotation = 45,
        Parent = self.GlassBg
    })

    -- Blur Overlay
    local blurOverlay = Utility:Create("Frame", {
        Name = "BlurOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 10, 15),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })

    local blurCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 20),
        Parent = blurOverlay
    })

    -- Build UI
    self:CreateHeader()
    self:CreateContent()
    self:CreateToggleButton()

    -- Draggable
    Utility:MakeDraggable(self.MainFrame, self.Header)

    -- Entry Animation
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Utility:Tween(self.MainFrame, {
        Size = UDim2.new(0, 420, 0, 580),
        Position = UDim2.new(0.5, -210, 0.5, -290)
    }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Stats
    self:StartStatsUpdate()
end

function UI:CreateHeader()
    self.Header = Utility:Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 80),
        BackgroundTransparency = 1,
        Parent = self.MainFrame
    })

    -- Logo
    local logoCircle = Utility:Create("Frame", {
        Name = "Logo",
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 15, 0, 15),
        BackgroundColor3 = Color3.fromRGB(60, 100, 200),
        BorderSizePixel = 0,
        Parent = self.Header
    })

    local logoCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = logoCircle
    })

    local logoGradient = Utility:Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 150, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 180))
        }),
        Rotation = 135,
        Parent = logoCircle
    })

    local logoText = Utility:Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "N",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextScaled = true,
        Font = Enum.Font.GothamBlack,
        Parent = logoCircle
    })

    -- Title
    local title = Utility:Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 200, 0, 30),
        Position = UDim2.new(0, 75, 0, 15),
        BackgroundTransparency = 1,
        Text = "NLV",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 28,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })

    -- Subtitle
    local subtitle = Utility:Create("TextLabel", {
        Name = "Subtitle",
        Size = UDim2.new(0, 250, 0, 20),
        Position = UDim2.new(0, 75, 0, 45),
        BackgroundTransparency = 1,
        Text = "Next Level Visuals | VIP 100 Day",
        TextColor3 = Color3.fromRGB(150, 170, 220),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })

    -- VIP Badge
    local vipBadge = Utility:Create("Frame", {
        Name = "VIPBadge",
        Size = UDim2.new(0, 60, 0, 24),
        Position = UDim2.new(1, -75, 0, 28),
        BackgroundColor3 = Color3.fromRGB(255, 180, 0),
        BorderSizePixel = 0,
        Parent = self.Header
    })

    local vipCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = vipBadge
    })

    local vipText = Utility:Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "VIP",
        TextColor3 = Color3.fromRGB(30, 20, 0),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = vipBadge
    })

    -- Close Button
    local closeBtn = Utility:Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 10),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 100, 100),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = self.Header
    })

    closeBtn.MouseButton1Click:Connect(function()
        Utility:Tween(self.MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            self.ScreenGui.Enabled = false
            self.ToggleBtn.Visible = true
        end)
    end)
end

function UI:CreateContent()
    self.ContentFrame = Utility:Create("ScrollingFrame", {
        Name = "Content",
        Size = UDim2.new(1, -20, 1, -110),
        Position = UDim2.new(0, 10, 0, 90),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255),
        CanvasSize = UDim2.new(0, 0, 0, 800),
        Parent = self.MainFrame
    })

    local contentLayout = Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.ContentFrame
    })

    self:CreateModeSection()
    self:CreateAdvancedSection()
    self:CreateFontSection()
    self:CreateVIPSection()
    self:CreateStatsSection()
end

function UI:CreateModeSection()
    local section = self:CreateSection("Performance Mode")

    local modes = {"Low", "Balanced", "Max", "VIP"}
    local colors = {
        Low = Color3.fromRGB(50, 200, 100),
        Balanced = Color3.fromRGB(100, 150, 255),
        Max = Color3.fromRGB(255, 100, 200),
        VIP = Color3.fromRGB(255, 180, 0)
    }

    for _, mode in ipairs(modes) do
        local btn = self:CreateModeButton(mode, colors[mode], NLV.Settings[mode].Description)
        btn.Parent = section

        btn.MouseButton1Click:Connect(function()
            for _, child in pairs(section:GetChildren()) do
                if child:IsA("TextButton") then
                    Utility:Tween(child, {BackgroundTransparency = 0.7}, 0.2)
                end
            end

            Utility:Tween(btn, {BackgroundTransparency = 0.3}, 0.2)
            PerformanceEngine:ApplySettings(mode)
            self:ShowNotification("Mode: " .. mode .. " activated!")
        end)
    end
end

function UI:CreateAdvancedSection()
    local section = self:CreateSection("Advanced Features")

    local fpsUnlock = self:CreateToggle("FPS Unlock (Max Mode)", "Unlocks frame rate to 240 FPS")
    fpsUnlock.Parent = section

    fpsUnlock.ToggleBtn.MouseButton1Click:Connect(function()
        NLV.FPSUnlocked = not NLV.FPSUnlocked
        self:UpdateToggle(fpsUnlock, NLV.FPSUnlocked)

        if NLV.FPSUnlocked then
            pcall(function() setfpscap(240) end)
            self:ShowNotification("FPS Unlocked to 240!")
        else
            pcall(function() setfpscap(60) end)
        end
    end)

    local fpsSuperX = self:CreateToggle("FPS SuperX (Low Mode)", "Extreme performance boost + high FPS")
    fpsSuperX.Parent = section

    fpsSuperX.ToggleBtn.MouseButton1Click:Connect(function()
        NLV.FPSSuperX = not NLV.FPSSuperX
        self:UpdateToggle(fpsSuperX, NLV.FPSSuperX)

        if NLV.FPSSuperX then
            pcall(function() setfpscap(999) end)
            self:ShowNotification("SuperX Performance Boost ON!")
        else
            pcall(function() setfpscap(60) end)
        end
    end)
end

function UI:CreateFontSection()
    local section = self:CreateSection("Font Changer")

    local dropdown = self:CreateDropdown("Select Font", NLV.Fonts)
    dropdown.Parent = section
end

function UI:CreateVIPSection()
    local section = self:CreateSection("NLV VIP - Advanced Control")

    local warning = Utility:Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundTransparency = 1,
        Text = "⚠️ Use with caution - High system impact",
        TextColor3 = Color3.fromRGB(255, 150, 50),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        Parent = section
    })

    local features = {
        {name = "HD Maps", desc = "Ultra HD texture rendering"},
        {name = "Ultra Smooth", desc = "Maximum smoothness algorithm"},
        {name = "Custom Shaders", desc = "Advanced lighting effects"},
        {name = "Extreme Draw", desc = "5000+ draw distance"}
    }

    for _, feature in ipairs(features) do
        local toggle = self:CreateToggle(feature.name, feature.desc)
        toggle.Parent = section
    end
end

function UI:CreateStatsSection()
    local section = self:CreateSection("Live Stats")

    self.FPSLabel = Utility:Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        BackgroundTransparency = 1,
        Text = "FPS: --",
        TextColor3 = Color3.fromRGB(100, 255, 150),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = section
    })

    self.PingLabel = Utility:Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        BackgroundTransparency = 1,
        Text = "Ping: -- ms",
        TextColor3 = Color3.fromRGB(100, 200, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = section
    })

    self.MemoryLabel = Utility:Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        BackgroundTransparency = 1,
        Text = "Memory: -- MB",
        TextColor3 = Color3.fromRGB(255, 200, 100),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = section
    })

    self.ModeLabel = Utility:Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        BackgroundTransparency = 1,
        Text = "Mode: Balanced",
        TextColor3 = Color3.fromRGB(200, 200, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = section
    })
end

function UI:CreateSection(title)
    local section = Utility:Create("Frame", {
        Size = UDim2.new(1, -20, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = self.ContentFrame
    })

    local sectionBg = Utility:Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = section
    })

    local sectionCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = sectionBg
    })

    local titleLabel = Utility:Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(200, 210, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section
    })

    local layout = Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = section
    })

    local padding = Utility:Create("UIPadding", {
        PaddingTop = UDim.new(0, 40),
        PaddingBottom = UDim.new(0, 15),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = section
    })

    return section
end

function UI:CreateModeButton(mode, color, description)
    local btn = Utility:Create("TextButton", {
        Size = UDim2.new(1, -10, 0, 60),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.7,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false
    })

    local corner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = btn
    })

    local modeLabel = Utility:Create("TextLabel", {
        Size = UDim2.new(0.4, 0, 0, 25),
        Position = UDim2.new(0, 15, 0, 8),
        BackgroundTransparency = 1,
        Text = mode,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn
    })

    local descLabel = Utility:Create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 20),
        Position = UDim2.new(0, 15, 0, 35),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Color3.fromRGB(200, 200, 220),
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn
    })

    btn.MouseEnter:Connect(function()
        Utility:Tween(btn, {BackgroundTransparency = 0.5}, 0.2)
    end)

    btn.MouseLeave:Connect(function()
        if NLV.CurrentMode ~= mode then
            Utility:Tween(btn, {BackgroundTransparency = 0.7}, 0.2)
        end
    end)

    return btn
end

function UI:CreateToggle(title, description)
    local frame = Utility:Create("Frame", {
        Size = UDim2.new(1, -10, 0, 50),
        BackgroundTransparency = 1
    })

    local titleLabel = Utility:Create("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(220, 220, 240),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local descLabel = Utility:Create("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 18),
        Position = UDim2.new(0, 10, 0, 26),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Color3.fromRGB(150, 150, 170),
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local toggleBtn = Utility:Create("Frame", {
        Name = "ToggleBtn",
        Size = UDim2.new(0, 50, 0, 26),
        Position = UDim2.new(1, -60, 0, 12),
        BackgroundColor3 = Color3.fromRGB(60, 60, 70),
        BorderSizePixel = 0,
        Parent = frame
    })

    local toggleCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = toggleBtn
    })

    local toggleCircle = Utility:Create("Frame", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, 2, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = toggleBtn
    })

    local circleCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = toggleCircle
    })

    frame.ToggleBtn = toggleBtn
    frame.ToggleCircle = toggleCircle

    return frame
end

function UI:UpdateToggle(toggleFrame, enabled)
    if enabled then
        Utility:Tween(toggleFrame.ToggleBtn, {BackgroundColor3 = Color3.fromRGB(80, 200, 120)}, 0.2)
        Utility:Tween(toggleFrame.ToggleCircle, {Position = UDim2.new(1, -24, 0.5, -11)}, 0.2)
    else
        Utility:Tween(toggleFrame.ToggleBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}, 0.2)
        Utility:Tween(toggleFrame.ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -11)}, 0.2)
    end
end

function UI:CreateDropdown(title, options)
    local frame = Utility:Create("Frame", {
        Size = UDim2.new(1, -10, 0, 45),
        BackgroundTransparency = 1
    })

    local titleLabel = Utility:Create("TextLabel", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(220, 220, 240),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local dropdownBtn = Utility:Create("TextButton", {
        Size = UDim2.new(0, 150, 0, 35),
        Position = UDim2.new(1, -160, 0, 5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        Text = "Gotham ▼",
        TextColor3 = Color3.fromRGB(200, 200, 220),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        Parent = frame
    })

    local dropdownCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = dropdownBtn
    })

    local isOpen = false
    local dropdownList = nil

    dropdownBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen

        if isOpen then
            dropdownBtn.Text = "Gotham ▲"

            dropdownList = Utility:Create("Frame", {
                Size = UDim2.new(0, 150, 0, 200),
                Position = UDim2.new(0, 0, 1, 5),
                BackgroundColor3 = Color3.fromRGB(35, 35, 45),
                BorderSizePixel = 0,
                Parent = dropdownBtn
            })

            local listCorner = Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = dropdownList
            })

            local scrolling = Utility:Create("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 3,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                Parent = dropdownList
            })

            local listLayout = Utility:Create("UIListLayout", {
                Parent = scrolling
            })

            for _, fontName in ipairs(options) do
                local fontBtn = Utility:Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text = fontName,
                    TextColor3 = Color3.fromRGB(200, 200, 220),
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    Parent = scrolling
                })

                fontBtn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = fontName .. " ▼"
                    isOpen = false
                    if dropdownList then
                        dropdownList:Destroy()
                        dropdownList = nil
                    end
                    FontEngine:ChangeFont(fontName)
                    self:ShowNotification("Font changed to: " .. fontName)
                end)
            end

            scrolling.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
        else
            dropdownBtn.Text = "Gotham ▼"
            if dropdownList then
                dropdownList:Destroy()
                dropdownList = nil
            end
        end
    end)

    return frame
end

function UI:CreateToggleButton()
    self.ToggleBtn = Utility:Create("TextButton", {
        Name = "NLV_Toggle",
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 20, 0.5, -25),
        BackgroundColor3 = Color3.fromRGB(60, 100, 200),
        Text = "N",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 24,
        Font = Enum.Font.GothamBlack,
        BorderSizePixel = 0,
        Visible = false,
        Parent = self.ScreenGui
    })

    local toggleCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.ToggleBtn
    })

    local toggleGradient = Utility:Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 150, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 180))
        }),
        Rotation = 135,
        Parent = self.ToggleBtn
    })

    local toggleStroke = Utility:Create("UIStroke", {
        Color = Color3.fromRGB(100, 160, 255),
        Thickness = 2,
        Transparency = 0.5,
        Parent = self.ToggleBtn
    })

    self.ToggleBtn.MouseButton1Click:Connect(function()
        self.ScreenGui.Enabled = true
        self.ToggleBtn.Visible = false
        self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
        self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        Utility:Tween(self.MainFrame, {
            Size = UDim2.new(0, 420, 0, 580),
            Position = UDim2.new(0.5, -210, 0.5, -290)
        }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    spawn(function()
        while self.ToggleBtn do
            if self.ToggleBtn.Visible then
                Utility:Tween(self.ToggleBtn, {Position = UDim2.new(0, 20, 0.5, -30)}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                wait(1)
                if self.ToggleBtn then
                    Utility:Tween(self.ToggleBtn, {Position = UDim2.new(0, 20, 0.5, -20)}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                end
                wait(1)
            else
                wait(0.5)
            end
        end
    end)
end

function UI:ShowNotification(text)
    local notif = Utility:Create("Frame", {
        Size = UDim2.new(0, 280, 0, 50),
        Position = UDim2.new(0.5, -140, 1, 60),
        BackgroundColor3 = Color3.fromRGB(40, 45, 60),
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })

    local notifCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = notif
    })

    local notifStroke = Utility:Create("UIStroke", {
        Color = Color3.fromRGB(80, 130, 220),
        Thickness = 1,
        Transparency = 0.6,
        Parent = notif
    })

    local notifText = Utility:Create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = notif
    })

    Utility:Tween(notif, {Position = UDim2.new(0.5, -140, 1, -70)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    delay(3, function()
        Utility:Tween(notif, {Position = UDim2.new(0.5, -140, 1, 60)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            notif:Destroy()
        end)
    end)
end

function UI:StartStatsUpdate()
    local lastUpdate = 0
    local frameCount = 0

    RunService.RenderStepped:Connect(function(deltaTime)
        frameCount = frameCount + 1
        lastUpdate = lastUpdate + deltaTime

        if lastUpdate >= 1 then
            local fps = math.round(frameCount / lastUpdate)
            frameCount = 0
            lastUpdate = 0

            if self.FPSLabel then
                self.FPSLabel.Text = "FPS: " .. fps
            end

            if self.PingLabel then
                local ping = 0
                pcall(function()
                    ping = LocalPlayer:GetNetworkPing() * 1000
                end)
                self.PingLabel.Text = "Ping: " .. math.round(ping) .. " ms"
            end

            if self.MemoryLabel then
                local memory = 0
                pcall(function()
                    memory = Stats:GetTotalMemoryUsageMb()
                end)
                self.MemoryLabel.Text = "Memory: " .. math.round(memory) .. " MB"
            end

            if self.ModeLabel then
                self.ModeLabel.Text = "Mode: " .. NLV.CurrentMode
            end
        end
    end)
end

-- ============================================================
-- ANTI-DETECTION & COMPATIBILITY
-- ============================================================
local AntiDetection = {}

function AntiDetection:Init()
    -- Randomize GUI name
    pcall(function()
        local randomName = "NLV_" .. tostring(math.random(100000, 999999))
        UI.ScreenGui.Name = randomName
    end)

    -- Protect GUI (synapse, krnl, etc)
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(UI.ScreenGui)
        elseif gethui then
            UI.ScreenGui.Parent = gethui()
        end
    end)

    -- Anti-AFK
    pcall(function()
        LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        end)
    end)
end

-- ============================================================
-- INITIALIZATION
-- ============================================================
local function Initialize()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    wait(2)

    UI:Init()
    AntiDetection:Init()
    PerformanceEngine:ApplySettings("Balanced")

    delay(1, function()
        UI:ShowNotification("NLV VIP 100 Day - Loaded Successfully!")
    end)

    print("================================================")
    print("  NLV - Next Level Visuals")
    print("  Version: VIP 100 Day")
    print("  Creator: Nazz Dev")
    print("  Powered By: Hostkita Team")
    print("  Status: ACTIVE")
    print("================================================")
end

Initialize()
