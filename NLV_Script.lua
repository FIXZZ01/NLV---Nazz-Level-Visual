-- ═══════════════════════════════════════════════════════════════════
-- NLV (Nazz Level Visualizer) - Roblox Universal Graphics Optimizer
-- Created by Nazz Dev | Powered by Hostkita Team
-- Version: 3.0 VIP | No Key | 100 Day VIP Access
-- Support: ALL EXECUTORS (Synapse X, KRNL, Fluxus, Delta, etc.)
-- ═══════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 1: CORE SYSTEM & INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════

local NLV = {
    Version = "3.0 VIP",
    Creator = "Nazz Dev",
    Team = "Hostkita Team",
    VIP_Days = 100,
    IsVIP = true,
    IsLoaded = false,
    CurrentMode = "Balanced", -- Balanced, Low, Max, VIP
    FPS_Unlocked = false,
    FPS_SuperX = false,
    CurrentFont = "Gotham",
    GlassTheme = true,
    AnimationsEnabled = true,

    -- Performance tracking
    FPS = 0,
    Ping = 0,
    Memory = 0,

    -- Settings storage
    Settings = {},
    OriginalSettings = {},

    -- Services
    Services = {},

    -- UI Elements
    UI = {},

    -- Font list
    Fonts = {
        "Gotham", "GothamBold", "GothamBlack", "GothamMedium",
        "SourceSans", "SourceSansBold", "SourceSansItalic", "SourceSansLight",
        "Arial", "ArialBold",
        "Legacy", "Code", "SciFi", "Arcade", "Bangers",
        "Cartoon", "Creepster", "DenkOne", "Fondamento", "FredokaOne",
        "GrenzeGotisch", "IndieFlower", "JosefinSans", "Jura", "Kalam",
        "LuckiestGuy", "Merriweather", "Michroma", "Nunito", "Oswald",
        "PatrickHand", "PermanentMarker", "Roboto", "RobotoCondensed",
        "RobotoMono", "Sarpanch", "SpecialElite", "TitilliumWeb", "Ubuntu"
    }
}

-- Initialize Services
NLV.Services.Players = game:GetService("Players")
NLV.Services.RunService = game:GetService("RunService")
NLV.Services.Lighting = game:GetService("Lighting")
NLV.Services.UserInputService = game:GetService("UserInputService")
NLV.Services.TweenService = game:GetService("TweenService")
NLV.Services.HttpService = game:GetService("HttpService")
NLV.Services.CoreGui = game:GetService("CoreGui")
NLV.Services.ReplicatedStorage = game:GetService("ReplicatedStorage")
NLV.Services.Workspace = game:GetService("Workspace")
NLV.Services.StarterGui = game:GetService("StarterGui")
NLV.Services.TextChatService = game:GetService("TextChatService")

local Player = NLV.Services.Players.LocalPlayer
local Camera = NLV.Services.Workspace.CurrentCamera

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 2: UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════

local function Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties) do
        pcall(function()
            instance[property] = value
        end)
    end
    return instance
end

local function Tween(instance, properties, duration, easingStyle, easingDirection)
    easingStyle = easingStyle or Enum.EasingStyle.Quart
    easingDirection = easingDirection or Enum.EasingDirection.Out
    duration = duration or 0.4

    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = NLV.Services.TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function RoundNumber(num, decimals)
    decimals = decimals or 0
    local mult = 10 ^ decimals
    return math.floor(num * mult + 0.5) / mult
end

local function FormatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(num)
    end
end

local function GetFPS()
    local fps = 0
    local lastUpdate = tick()
    NLV.Services.RunService.RenderStepped:Connect(function()
        fps = fps + 1
        if tick() - lastUpdate >= 1 then
            NLV.FPS = fps
            fps = 0
            lastUpdate = tick()
        end
    end)
end

local function GetPing()
    spawn(function()
        while wait(1) do
            local success, result = pcall(function()
                return NLV.Services.Players.LocalPlayer:GetNetworkPing() * 1000
            end)
            if success then
                NLV.Ping = RoundNumber(result, 0)
            end
        end
    end)
end

local function GetMemory()
    spawn(function()
        while wait(2) do
            local success, result = pcall(function()
                return collectgarbage("count") / 1024
            end)
            if success then
                NLV.Memory = RoundNumber(result, 1)
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 3: GLASSMORPHISM UI SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local GlassUI = {}

function GlassUI.CreateGlassFrame(parent, size, position, color)
    color = color or Color3.fromRGB(20, 20, 30)

    local frame = Create("Frame", {
        Name = "GlassFrame",
        Size = size or UDim2.new(0, 400, 0, 300),
        Position = position or UDim2.new(0.5, -200, 0.5, -150),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = parent,
        ClipsDescendants = true
    })

    -- Corner radius
    local corner = Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = frame
    })

    -- Stroke (glass border effect)
    local stroke = Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.85,
        Thickness = 1,
        Parent = frame
    })

    -- Glass shine effect (top highlight)
    local shine = Create("Frame", {
        Name = "Shine",
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = frame
    })

    -- Gradient overlay for glass effect
    local gradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 220)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 170))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.92),
            NumberSequenceKeypoint.new(0.5, 0.95),
            NumberSequenceKeypoint.new(1, 0.98)
        }),
        Rotation = 90,
        Parent = frame
    })

    return frame
end

function GlassUI.CreateGlassButton(parent, text, size, position, callback)
    local button = Create("TextButton", {
        Name = text .. "Button",
        Size = size or UDim2.new(0, 120, 0, 35),
        Position = position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 55),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font[NLV.CurrentFont],
        Parent = parent,
        AutoButtonColor = false,
        ClipsDescendants = true
    })

    local corner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = button
    })

    local stroke = Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.9,
        Thickness = 1,
        Parent = button
    })

    -- Hover effects
    button.MouseEnter:Connect(function()
        Tween(button, {BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(60, 60, 80)}, 0.2)
        Tween(stroke, {Transparency = 0.7}, 0.2)
    end)

    button.MouseLeave:Connect(function()
        Tween(button, {BackgroundTransparency = 0.4, BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.2)
        Tween(stroke, {Transparency = 0.9}, 0.2)
    end)

    button.MouseButton1Down:Connect(function()
        Tween(button, {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}, 0.1)
    end)

    button.MouseButton1Up:Connect(function()
        Tween(button, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}, 0.1)
    end)

    if callback then
        button.MouseButton1Click:Connect(callback)
    end

    return button
end

function GlassUI.CreateToggle(parent, text, defaultState, callback)
    local container = Create("Frame", {
        Name = text .. "Toggle",
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local label = Create("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font[NLV.CurrentFont],
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local toggleBg = Create("Frame", {
        Name = "Background",
        Size = UDim2.new(0, 50, 0, 26),
        Position = UDim2.new(1, -50, 0.5, -13),
        BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 70),
        BorderSizePixel = 0,
        Parent = container
    })

    local corner = Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = toggleBg
    })

    local circle = Create("Frame", {
        Name = "Circle",
        Size = UDim2.new(0, 22, 0, 22),
        Position = defaultState and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = toggleBg
    })

    local circleCorner = Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = circle
    })

    local state = defaultState

    local function Toggle()
        state = not state
        if state then
            Tween(toggleBg, {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}, 0.3)
            Tween(circle, {Position = UDim2.new(1, -24, 0.5, -11)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        else
            Tween(toggleBg, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}, 0.3)
            Tween(circle, {Position = UDim2.new(0, 2, 0.5, -11)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        end
        if callback then
            callback(state)
        end
    end

    toggleBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Toggle()
        end
    end)

    return container, Toggle
end

function GlassUI.CreateSlider(parent, text, min, max, default, callback)
    local container = Create("Frame", {
        Name = text .. "Slider",
        Size = UDim2.new(1, -20, 0, 50),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local label = Create("TextLabel", {
        Size = UDim2.new(0.5, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font[NLV.CurrentFont],
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local valueLabel = Create("TextLabel", {
        Size = UDim2.new(0.5, 0, 0, 20),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = Color3.fromRGB(0, 170, 255),
        TextSize = 14,
        Font = Enum.Font[NLV.CurrentFont],
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = container
    })

    local track = Create("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 32),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Parent = container
    })

    local trackCorner = Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = track
    })

    local fill = Create("Frame", {
        Name = "Fill",
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 170, 255),
        BorderSizePixel = 0,
        Parent = track
    })

    local fillCorner = Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = fill
    })

    local knob = Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = track
    })

    local knobCorner = Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = knob
    })

    local dragging = false

    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)

        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, -8, 0.5, -8)
        valueLabel.Text = tostring(value)

        if callback then
            callback(value)
        end
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)

    NLV.Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)

    NLV.Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return container
end

function GlassUI.CreateDropdown(parent, text, options, default, callback)
    local container = Create("Frame", {
        Name = text .. "Dropdown",
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundTransparency = 1,
        Parent = parent,
        ClipsDescendants = true
    })

    local label = Create("TextLabel", {
        Size = UDim2.new(0.5, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font[NLV.CurrentFont],
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local button = Create("TextButton", {
        Size = UDim2.new(0.5, 0, 0, 30),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 55),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Text = default or options[1] or "Select",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        Font = Enum.Font[NLV.CurrentFont],
        Parent = container,
        AutoButtonColor = false
    })

    local corner = Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = button
    })

    local stroke = Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.9,
        Thickness = 1,
        Parent = button
    })

    local dropdownFrame = Create("Frame", {
        Name = "DropdownList",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Parent = container,
        ClipsDescendants = true,
        Visible = false
    })

    local listCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = dropdownFrame
    })

    local listLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = dropdownFrame
    })

    local open = false

    for i, option in ipairs(options) do
        local optionBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = Color3.fromRGB(40, 40, 55),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = option,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            Font = Enum.Font[NLV.CurrentFont],
            Parent = dropdownFrame,
            AutoButtonColor = false
        })

        optionBtn.MouseEnter:Connect(function()
            Tween(optionBtn, {BackgroundTransparency = 0.2}, 0.2)
        end)

        optionBtn.MouseLeave:Connect(function()
            Tween(optionBtn, {BackgroundTransparency = 0.5}, 0.2)
        end)

        optionBtn.MouseButton1Click:Connect(function()
            button.Text = option
            open = false
            Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
            wait(0.3)
            dropdownFrame.Visible = false
            if callback then
                callback(option)
            end
        end)
    end

    button.MouseButton1Click:Connect(function()
        open = not open
        if open then
            dropdownFrame.Visible = true
            Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, math.min(#options * 30, 150))}, 0.3)
        else
            Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
            wait(0.3)
            dropdownFrame.Visible = false
        end
    end)

    return container
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 4: NLV MAIN UI CONSTRUCTION
-- ═══════════════════════════════════════════════════════════════════

function NLV.CreateMainUI()
    -- ScreenGui
    local screenGui = Create("ScreenGui", {
        Name = "NLV_GUI",
        Parent = NLV.Services.CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999
    })

    NLV.UI.ScreenGui = screenGui

    -- Main Glass Frame
    local mainFrame = GlassUI.CreateGlassFrame(screenGui, 
        UDim2.new(0, 500, 0, 380),
        UDim2.new(0.5, -250, 0.5, -190),
        Color3.fromRGB(15, 15, 25)
    )

    mainFrame.Name = "NLV_Main"
    NLV.UI.MainFrame = mainFrame

    -- Logo / Title Bar
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Color3.fromRGB(20, 20, 35),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local titleCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = titleBar
    })

    -- NLV Logo Text
    local logoText = Create("TextLabel", {
        Name = "Logo",
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = "NLV",
        TextColor3 = Color3.fromRGB(0, 170, 255),
        TextSize = 24,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    local subtitleText = Create("TextLabel", {
        Name = "Subtitle",
        Size = UDim2.new(0, 200, 0, 20),
        Position = UDim2.new(0, 15, 0, 28),
        BackgroundTransparency = 1,
        Text = "Nazz Level Visualizer | " .. NLV.Version,
        TextColor3 = Color3.fromRGB(150, 150, 170),
        TextSize = 10,
        Font = Enum.Font[NLV.CurrentFont],
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    -- VIP Badge
    local vipBadge = Create("Frame", {
        Name = "VIPBadge",
        Size = UDim2.new(0, 60, 0, 22),
        Position = UDim2.new(1, -140, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(255, 215, 0),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Parent = titleBar
    })

    local vipCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = vipBadge
    })

    local vipText = Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "VIP",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = vipBadge
    })

    -- Close Button
    local closeBtn = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(255, 70, 70),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = titleBar,
        AutoButtonColor = false
    })

    local closeCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = closeBtn
    })

    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0}, 0.2)
    end)

    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.3}, 0.2)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4)
        wait(0.4)
        screenGui.Enabled = false
    end)

    -- Minimize Button
    local minBtn = Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(255, 170, 0),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = "-",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = titleBar,
        AutoButtonColor = false
    })

    local minCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = minBtn
    })

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(mainFrame, {Size = UDim2.new(0, 500, 0, 45)}, 0.4)
        else
            Tween(mainFrame, {Size = UDim2.new(0, 500, 0, 380)}, 0.4)
        end
    end)

    -- Tab System
    local tabContainer = Create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 120, 1, -45),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundColor3 = Color3.fromRGB(20, 20, 30),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local tabLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = tabContainer
    })

    local tabPadding = Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = tabContainer
    })

    -- Content Area
    local contentFrame = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -120, 1, -45),
        Position = UDim2.new(0, 120, 0, 45),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    -- Stats Bar (Bottom)
    local statsBar = Create("Frame", {
        Name = "StatsBar",
        Size = UDim2.new(1, -120, 0, 30),
        Position = UDim2.new(0, 120, 1, -30),
        BackgroundColor3 = Color3.fromRGB(20, 20, 30),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local statsCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 0),
        Parent = statsBar
    })

    local fpsLabel = Create("TextLabel", {
        Name = "FPS",
        Size = UDim2.new(0.33, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "FPS: --",
        TextColor3 = Color3.fromRGB(0, 255, 100),
        TextSize = 11,
        Font = Enum.Font[NLV.CurrentFont],
        Parent = statsBar
    })

    local pingLabel = Create("TextLabel", {
        Name = "Ping",
        Size = UDim2.new(0.33, 0, 1, 0),
        Position = UDim2.new(0.33, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "Ping: --ms",
        TextColor3 = Color3.fromRGB(255, 200, 0),
        TextSize = 11,
        Font = Enum.Font[NLV.CurrentFont],
        Parent = statsBar
    })

    local memLabel = Create("TextLabel", {
        Name = "Memory",
        Size = UDim2.new(0.33, 0, 1, 0),
        Position = UDim2.new(0.66, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "MEM: --MB",
        TextColor3 = Color3.fromRGB(0, 170, 255),
        TextSize = 11,
        Font = Enum.Font[NLV.CurrentFont],
        Parent = statsBar
    })

    -- Update stats
    spawn(function()
        while wait(0.5) do
            fpsLabel.Text = "FPS: " .. NLV.FPS
            pingLabel.Text = "Ping: " .. NLV.Ping .. "ms"
            memLabel.Text = "MEM: " .. NLV.Memory .. "MB"
        end
    end)

    -- Tab creation function
    local tabs = {}
    local currentTab = nil

    local function CreateTab(name, icon)
        local tabBtn = Create("TextButton", {
            Name = name .. "Tab",
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Color3.fromRGB(30, 30, 45),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = "  " .. name,
            TextColor3 = Color3.fromRGB(180, 180, 200),
            TextSize = 12,
            Font = Enum.Font[NLV.CurrentFont],
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabContainer,
            AutoButtonColor = false
        })

        local tabBtnCorner = Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = tabBtn
        })

        local tabContent = Create("ScrollingFrame", {
            Name = name .. "Content",
            Size = UDim2.new(1, -20, 1, -10),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255),
            Visible = false,
            Parent = contentFrame
        })

        local contentLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = tabContent
        })

        local contentPadding = Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            Parent = tabContent
        })

        tabBtn.MouseButton1Click:Connect(function()
            if currentTab then
                Tween(tabs[currentTab].Button, {BackgroundColor3 = Color3.fromRGB(30, 30, 45), BackgroundTransparency = 0.5}, 0.2)
                tabs[currentTab].Button.TextColor3 = Color3.fromRGB(180, 180, 200)
                tabs[currentTab].Content.Visible = false
            end

            currentTab = name
            Tween(tabBtn, {BackgroundColor3 = Color3.fromRGB(0, 170, 255), BackgroundTransparency = 0.3}, 0.2)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabContent.Visible = true

            -- Animate content in
            tabContent.CanvasPosition = Vector2.new(0, 0)
        end)

        tabs[name] = {
            Button = tabBtn,
            Content = tabContent
        }

        return tabContent
    end

    -- Create Tabs
    local graphicsTab = CreateTab("Graphics", "")
    local fontTab = CreateTab("Font", "")
    local vipTab = CreateTab("VIP", "")
    local settingsTab = CreateTab("Settings", "")

    -- Select first tab
    tabs["Graphics"].Button.MouseButton1Click:Fire()

    NLV.UI.Tabs = tabs

    -- ═══════════════════════════════════════════════════════════════════
    -- SECTION 5: GRAPHICS TAB CONTENT
    -- ═══════════════════════════════════════════════════════════════════

    -- Mode Selection Section
    local modeSection = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "PERFORMANCE MODE",
        TextColor3 = Color3.fromRGB(0, 170, 255),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = graphicsTab
    })

    -- Mode Buttons Container
    local modeContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1,
        Parent = graphicsTab
    })

    local modeLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = modeContainer
    })

    local function CreateModeButton(name, color, description)
        local btn = GlassUI.CreateGlassButton(modeContainer, name, UDim2.new(0, 100, 0, 35), UDim2.new(0, 0, 0, 0))
        btn.BackgroundColor3 = color
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)

        btn.MouseButton1Click:Connect(function()
            NLV.SetMode(name)
        end)

        return btn
    end

    local lowBtn = CreateModeButton("LOW", Color3.fromRGB(0, 150, 100), "Maximum performance, minimal graphics")
    local balancedBtn = CreateModeButton("BALANCED", Color3.fromRGB(0, 120, 200), "Balanced performance and visuals")
    local maxBtn = CreateModeButton("MAX", Color3.fromRGB(200, 100, 0), "Maximum graphics, high performance needed")
    local vipBtn = CreateModeButton("VIP", Color3.fromRGB(255, 215, 0), "Ultra HD visuals with FPS boost")

    -- Advanced Features Section
    local advancedSection = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "ADVANCED FEATURES",
        TextColor3 = Color3.fromRGB(0, 170, 255),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = graphicsTab
    })

    -- FPS Unlock Toggle
    local fpsUnlockToggle, fpsUnlockFunc = GlassUI.CreateToggle(graphicsTab, "FPS Unlock", false, function(state)
        NLV.FPS_Unlocked = state
        NLV.ToggleFPSUnlock(state)
    end)

    -- FPS SuperX Toggle (Low mode advanced)
    local fpsSuperXToggle, fpsSuperXFunc = GlassUI.CreateToggle(graphicsTab, "FPS SuperX (Low Mode)", false, function(state)
        NLV.FPS_SuperX = state
        NLV.ToggleFPSSuperX(state)
    end)

    -- Remove Textures Toggle
    local textureToggle = GlassUI.CreateToggle(graphicsTab, "Remove Textures", false, function(state)
        NLV.ToggleTextures(not state)
    end)

    -- Remove Shadows Toggle
    local shadowToggle = GlassUI.CreateToggle(graphicsTab, "Remove Shadows", false, function(state)
        NLV.ToggleShadows(not state)
    end)

    -- Remove Effects Toggle
    local effectsToggle = GlassUI.CreateToggle(graphicsTab, "Remove Effects", false, function(state)
        NLV.ToggleEffects(not state)
    end)

    -- Remove Particles Toggle
    local particleToggle = GlassUI.CreateToggle(graphicsTab, "Remove Particles", false, function(state)
        NLV.ToggleParticles(not state)
    end)

    -- Optimize Terrain Toggle
    local terrainToggle = GlassUI.CreateToggle(graphicsTab, "Optimize Terrain", false, function(state)
        NLV.ToggleTerrainOptimization(state)
    end)

    -- ═══════════════════════════════════════════════════════════════════
    -- SECTION 6: FONT TAB CONTENT
    -- ═══════════════════════════════════════════════════════════════════

    local fontSection = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "GLOBAL FONT CHANGER",
        TextColor3 = Color3.fromRGB(0, 170, 255),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = fontTab
    })

    local fontDesc = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = "Changes ALL text in the game to selected font",
        TextColor3 = Color3.fromRGB(150, 150, 170),
        TextSize = 11,
        Font = Enum.Font[NLV.CurrentFont],
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = fontTab
    })

    -- Font Dropdown
    local fontDropdown = GlassUI.CreateDropdown(fontTab, "Select Font", NLV.Fonts, NLV.CurrentFont, function(selected)
        NLV.CurrentFont = selected
        NLV.ChangeGlobalFont(selected)
    end)

    -- Apply Font Button
    local applyFontBtn = GlassUI.CreateGlassButton(fontTab, "Apply Font", UDim2.new(0, 150, 0, 35), UDim2.new(0, 0, 0, 0))
    applyFontBtn.MouseButton1Click:Connect(function()
        NLV.ChangeGlobalFont(NLV.CurrentFont)
    end)

    -- Font Preview
    local previewLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BackgroundTransparency = 0.5,
        Text = "Preview: The quick brown fox",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font[NLV.CurrentFont],
        Parent = fontTab
    })

    local previewCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = previewLabel
    })

    -- ═══════════════════════════════════════════════════════════════════
    -- SECTION 7: VIP TAB CONTENT
    -- ═══════════════════════════════════════════════════════════════════

    local vipSection = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "NLV VIP FEATURES",
        TextColor3 = Color3.fromRGB(255, 215, 0),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = vipTab
    })

    local vipStatus = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = "Status: ACTIVE | Days Remaining: " .. NLV.VIP_Days,
        TextColor3 = Color3.fromRGB(0, 255, 100),
        TextSize = 11,
        Font = Enum.Font[NLV.CurrentFont],
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = vipTab
    })

    -- VIP Features
    local hdTexturesToggle = GlassUI.CreateToggle(vipTab, "HD Texture Boost", false, function(state)
        NLV.VIP_HDTextures(state)
    end)

    local smoothMapToggle = GlassUI.CreateToggle(vipTab, "Smooth Map Rendering", false, function(state)
        NLV.VIP_SmoothMap(state)
    end)

    local ultraRenderToggle = GlassUI.CreateToggle(vipTab, "Ultra Render Distance", false, function(state)
        NLV.VIP_UltraRender(state)
    end)

    local advancedLightingToggle = GlassUI.CreateToggle(vipTab, "Advanced Lighting", false, function(state)
        NLV.VIP_AdvancedLighting(state)
    end)

    local antiLagToggle = GlassUI.CreateToggle(vipTab, "Anti-Lag System", false, function(state)
        NLV.VIP_AntiLag(state)
    end)

    local memoryOptimizeToggle = GlassUI.CreateToggle(vipTab, "Memory Optimizer", false, function(state)
        NLV.VIP_MemoryOptimize(state)
    end)

    -- VIP Warning
    local vipWarning = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        BackgroundTransparency = 0.8,
        Text = "WARNING: VIP features are powerful. Use with caution on low-end devices.",
        TextColor3 = Color3.fromRGB(255, 100, 100),
        TextSize = 10,
        Font = Enum.Font[NLV.CurrentFont],
        TextWrapped = true,
        Parent = vipTab
    })

    local warningCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = vipWarning
    })

    -- ═══════════════════════════════════════════════════════════════════
    -- SECTION 8: SETTINGS TAB CONTENT
    -- ═══════════════════════════════════════════════════════════════════

    local settingsSection = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "SETTINGS & INFO",
        TextColor3 = Color3.fromRGB(0, 170, 255),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = settingsTab
    })

    -- Info Labels
    local infoLabels = {
        {"Version", NLV.Version},
        {"Creator", NLV.Creator},
        {"Team", NLV.Team},
        {"VIP Status", NLV.IsVIP and "Active" or "Inactive"},
        {"VIP Days", tostring(NLV.VIP_Days)},
        {"Current Mode", NLV.CurrentMode},
        {"Game", game.PlaceId ~= 0 and game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown"}
    }

    for _, info in ipairs(infoLabels) do
        local infoFrame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundTransparency = 1,
            Parent = settingsTab
        })

        Create("TextLabel", {
            Size = UDim2.new(0.4, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = info[1] .. ":",
            TextColor3 = Color3.fromRGB(150, 150, 170),
            TextSize = 12,
            Font = Enum.Font[NLV.CurrentFont],
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = infoFrame
        })

        Create("TextLabel", {
            Size = UDim2.new(0.6, 0, 1, 0),
            Position = UDim2.new(0.4, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = info[2],
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            Font = Enum.Font[NLV.CurrentFont],
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = infoFrame
        })
    end

    -- Reset Button
    local resetBtn = GlassUI.CreateGlassButton(settingsTab, "Reset All Settings", UDim2.new(0, 150, 0, 35), UDim2.new(0, 0, 0, 0))
    resetBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    resetBtn.MouseButton1Click:Connect(function()
        NLV.ResetSettings()
    end)

    -- ═══════════════════════════════════════════════════════════════════
    -- SECTION 9: TOGGLE KEY (F4)
    -- ═══════════════════════════════════════════════════════════════════

    NLV.Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.F4 then
            screenGui.Enabled = not screenGui.Enabled
            if screenGui.Enabled then
                mainFrame.Size = UDim2.new(0, 0, 0, 0)
                mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                Tween(mainFrame, {Size = UDim2.new(0, 500, 0, 380), Position = UDim2.new(0.5, -250, 0.5, -190)}, 0.4)
            end
        end
    end)

    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    NLV.Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    NLV.Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Intro Animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    wait(0.1)
    Tween(mainFrame, {Size = UDim2.new(0, 500, 0, 380), Position = UDim2.new(0.5, -250, 0.5, -190)}, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    return screenGui
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 10: GRAPHICS OPTIMIZATION FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════

function NLV.SetMode(mode)
    NLV.CurrentMode = mode

    if mode == "LOW" then
        -- Maximum performance settings
        settings().Rendering.QualityLevel = 1
        NLV.Services.Lighting.GlobalShadows = false
        NLV.Services.Lighting.FogEnd = 500

        -- Reduce render distance
        Camera.FieldOfView = 70

        -- Optimize workspace
        for _, obj in ipairs(NLV.Services.Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                if obj:IsA("MeshPart") then
                    obj.RenderFidelity = Enum.RenderFidelity.Performance
                end
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Lifetime = NumberRange.new(0)
            end
        end

        -- Disable effects
        for _, effect in ipairs(NLV.Services.Lighting:GetDescendants()) do
            if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or 
               effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or 
               effect:IsA("DepthOfFieldEffect") then
                effect.Enabled = false
            end
        end

        -- Terrain optimization
        local terrain = NLV.Services.Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 0
        end

        -- Enable FPS SuperX if toggled
        if NLV.FPS_SuperX then
            NLV.EnableFPSSuperX()
        end

    elseif mode == "BALANCED" then
        -- Balanced settings
        settings().Rendering.QualityLevel = 5
        NLV.Services.Lighting.GlobalShadows = true
        NLV.Services.Lighting.FogEnd = 3000
        Camera.FieldOfView = 80

    elseif mode == "MAX" then
        -- Maximum graphics
        settings().Rendering.QualityLevel = 10
        NLV.Services.Lighting.GlobalShadows = true
        NLV.Services.Lighting.FogEnd = 100000
        Camera.FieldOfView = 90

        -- Enable FPS Unlock if toggled
        if NLV.FPS_Unlocked then
            NLV.EnableFPSUnlock()
        end

    elseif mode == "VIP" then
        -- VIP Ultra settings
        settings().Rendering.QualityLevel = 10
        NLV.Services.Lighting.GlobalShadows = true
        NLV.Services.Lighting.FogEnd = 9e9
        Camera.FieldOfView = 100

        -- HD textures
        for _, obj in ipairs(NLV.Services.Workspace:GetDescendants()) do
            if obj:IsA("MeshPart") then
                obj.RenderFidelity = Enum.RenderFidelity.Precise
            end
            if obj:IsA("BasePart") then
                obj.CastShadow = true
            end
        end

        -- Enable all VIP features
        NLV.VIP_HDTextures(true)
        NLV.VIP_SmoothMap(true)
        NLV.VIP_UltraRender(true)
        NLV.VIP_AdvancedLighting(true)
        NLV.VIP_AntiLag(true)
        NLV.VIP_MemoryOptimize(true)

        -- FPS Unlock
        NLV.EnableFPSUnlock()
    end

    -- Notification
    NLV.Notify("Mode Changed", "Switched to " .. mode .. " mode", 3)
end

function NLV.ToggleFPSUnlock(enabled)
    if enabled then
        -- Set FPS cap to maximum
        setfpscap(9999)
        NLV.Notify("FPS Unlock", "FPS cap removed! Unlimited FPS enabled.", 3)
    else
        setfpscap(60)
        NLV.Notify("FPS Unlock", "FPS cap restored to 60.", 3)
    end
end

function NLV.EnableFPSUnlock()
    setfpscap(9999)
end

function NLV.ToggleFPSSuperX(enabled)
    if enabled then
        -- Aggressive performance optimizations
        settings().Rendering.EagerBulkExecution = false
        settings().Rendering.InterpolationThrottling = true

        -- Reduce texture quality
        for _, obj in ipairs(NLV.Services.Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                obj.Material = Enum.Material.SmoothPlastic
            end
        end

        NLV.Notify("FPS SuperX", "Super performance mode activated!", 3)
    else
        settings().Rendering.EagerBulkExecution = true
        settings().Rendering.InterpolationThrottling = false
        NLV.Notify("FPS SuperX", "Super performance mode disabled.", 3)
    end
end

function NLV.EnableFPSSuperX()
    settings().Rendering.EagerBulkExecution = false
    settings().Rendering.InterpolationThrottling = true
end

function NLV.ToggleTextures(enabled)
    if not enabled then
        for _, obj in ipairs(NLV.Services.Workspace:GetDescendants()) do
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            end
        end
        NLV.Notify("Textures", "All textures removed.", 2)
    else
        -- Cannot restore without storing originals
        NLV.Notify("Textures", "Textures removed. Restart to restore.", 2)
    end
end

function NLV.ToggleShadows(enabled)
    NLV.Services.Lighting.GlobalShadows = enabled
    for _, obj in ipairs(NLV.Services.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            obj.CastShadow = enabled
        end
    end
    NLV.Notify("Shadows", enabled and "Shadows enabled." or "Shadows disabled.", 2)
end

function NLV.ToggleEffects(enabled)
    for _, effect in ipairs(NLV.Services.Lighting:GetDescendants()) do
        if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or 
           effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or 
           effect:IsA("DepthOfFieldEffect") then
            effect.Enabled = enabled
        end
    end
    NLV.Notify("Effects", enabled and "Effects enabled." or "Effects disabled.", 2)
end

function NLV.ToggleParticles(enabled)
    for _, obj in ipairs(NLV.Services.Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = enabled
        end
    end
    NLV.Notify("Particles", enabled and "Particles enabled." or "Particles disabled.", 2)
end

function NLV.ToggleTerrainOptimization(enabled)
    local terrain = NLV.Services.Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        if enabled then
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
        else
            terrain.WaterWaveSize = 1
            terrain.WaterWaveSpeed = 1
            terrain.WaterReflectance = 1
        end
    end
    NLV.Notify("Terrain", enabled and "Terrain optimized." or "Terrain restored.", 2)
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 11: VIP FEATURES
-- ═══════════════════════════════════════════════════════════════════

function NLV.VIP_HDTextures(enabled)
    for _, obj in ipairs(NLV.Services.Workspace:GetDescendants()) do
        if obj:IsA("MeshPart") then
            obj.RenderFidelity = enabled and Enum.RenderFidelity.Precise or Enum.RenderFidelity.Automatic
        end
    end
end

function NLV.VIP_SmoothMap(enabled)
    if enabled then
        -- Smooth out terrain and map details
        local terrain = NLV.Services.Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterWaveSize = 0.5
            terrain.WaterWaveSpeed = 2
            terrain.WaterReflectance = 1
            terrain.WaterTransparency = 0.3
        end
    end
end

function NLV.VIP_UltraRender(enabled)
    if enabled then
        Camera.FieldOfView = 100
        settings().Rendering.QualityLevel = 10
        NLV.Services.Lighting.FogEnd = 9e9
    end
end

function NLV.VIP_AdvancedLighting(enabled)
    if enabled then
        NLV.Services.Lighting.GlobalShadows = true
        NLV.Services.Lighting.Outlines = false
        NLV.Services.Lighting.Brightness = 2
    end
end

function NLV.VIP_AntiLag(enabled)
    if enabled then
        -- Clear unused instances
        for _, obj in ipairs(NLV.Services.Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Anchored and not obj.CanCollide then
                -- Keep but optimize
                obj.CastShadow = false
            end
        end

        -- Optimize network
        settings().Network.IncomingReplicationLag = 0
    end
end

function NLV.VIP_MemoryOptimize(enabled)
    if enabled then
        -- Force garbage collection
        collectgarbage("collect")

        -- Clear unused textures from memory
        for _, obj in ipairs(NLV.Services.Workspace:GetDescendants()) do
            if obj:IsA("Decal") and obj.Transparency == 1 then
                obj:Destroy()
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 12: FONT CHANGER SYSTEM
-- ═══════════════════════════════════════════════════════════════════

function NLV.ChangeGlobalFont(fontName)
    local fontEnum = Enum.Font[fontName]
    if not fontEnum then
        NLV.Notify("Font Error", "Invalid font: " .. fontName, 3)
        return
    end

    -- Change all text in CoreGui
    local function ChangeFontInParent(parent)
        for _, obj in ipairs(parent:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                pcall(function()
                    obj.Font = fontEnum
                end)
            end
        end
    end

    -- Change in PlayerGui
    if Player:FindFirstChild("PlayerGui") then
        ChangeFontInParent(Player.PlayerGui)
    end

    -- Change in CoreGui (other scripts)
    ChangeFontInParent(NLV.Services.CoreGui)

    -- Change in StarterGui
    ChangeFontInParent(NLV.Services.StarterGui)

    -- Change in NLV UI itself
    ChangeFontInParent(NLV.UI.ScreenGui)

    -- Update current font
    NLV.CurrentFont = fontName

    NLV.Notify("Font Changed", "Global font changed to: " .. fontName, 3)
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 13: NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════

function NLV.Notify(title, message, duration)
    duration = duration or 3

    local notifGui = Create("ScreenGui", {
        Name = "NLV_Notification",
        Parent = NLV.Services.CoreGui,
        ResetOnSpawn = false,
        DisplayOrder = 1000
    })

    local notifFrame = GlassUI.CreateGlassFrame(notifGui,
        UDim2.new(0, 280, 0, 80),
        UDim2.new(1, -300, 1, -100),
        Color3.fromRGB(20, 20, 30)
    )

    notifFrame.Position = UDim2.new(1, 20, 1, -100)

    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 15, 0, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(0, 170, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notifFrame
    })

    local msgLabel = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 15, 0, 32),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Color3.fromRGB(200, 200, 220),
        TextSize = 12,
        Font = Enum.Font[NLV.CurrentFont],
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notifFrame
    })

    -- Animate in
    Tween(notifFrame, {Position = UDim2.new(1, -300, 1, -100)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Auto close
    delay(duration, function()
        Tween(notifFrame, {Position = UDim2.new(1, 20, 1, -100)}, 0.4)
        wait(0.4)
        notifGui:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 14: RESET & UTILITY
-- ═══════════════════════════════════════════════════════════════════

function NLV.ResetSettings()
    -- Reset all to default
    settings().Rendering.QualityLevel = 5
    NLV.Services.Lighting.GlobalShadows = true
    NLV.Services.Lighting.FogEnd = 3000
    Camera.FieldOfView = 80

    -- Reset FPS cap
    setfpscap(60)
    NLV.FPS_Unlocked = false
    NLV.FPS_SuperX = false

    -- Reset terrain
    local terrain = NLV.Services.Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterWaveSize = 1
        terrain.WaterWaveSpeed = 1
        terrain.WaterReflectance = 1
    end

    NLV.Notify("Reset", "All settings reset to default.", 3)
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 15: INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════

function NLV.Initialize()
    -- Check if already loaded
    if NLV.IsLoaded then
        return
    end

    NLV.IsLoaded = true

    -- Start performance monitoring
    GetFPS()
    GetPing()
    GetMemory()

    -- Create UI
    NLV.CreateMainUI()

    -- Welcome notification
    wait(1)
    NLV.Notify("NLV Loaded", "Welcome to NLV v" .. NLV.Version .. " | Press F4 to toggle", 4)
    NLV.Notify("VIP Active", "VIP access: " .. NLV.VIP_Days .. " days remaining", 4)

    print("[NLV] Nazz Level Visualizer v" .. NLV.Version .. " loaded successfully!")
    print("[NLV] Created by " .. NLV.Creator .. " | Powered by " .. NLV.Team)
end

-- Auto-initialize
NLV.Initialize()

-- Return NLV table for external access
return NLV
