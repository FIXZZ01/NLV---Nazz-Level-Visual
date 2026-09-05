-- ═══════════════════════════════════════════════════════════════════
-- NLV (Nazz Level Visualizer) - Roblox Universal Graphics Optimizer
-- Created by Nazz Dev | Powered by Hostkita Team
-- Version: 3.0 VIP | No Key | 100 Day VIP Access
-- Support: ALL EXECUTORS (Synapse X, KRNL, Fluxus, Delta, etc.)
-- ═══════════════════════════════════════════════════════════════════

if not game:IsLoaded() then game.Loaded:Wait() end

local NLV = {
    Version = "3.0 VIP",
    Creator = "Nazz Dev",
    Team = "Hostkita Team",
    VIP_Days = 100,
    IsVIP = true,
    CurrentMode = "Balanced",
    FPS_Unlocked = false,
    FPS_SuperX = false,
    CurrentFont = "Gotham",
    Fonts = {"Gotham","GothamBold","GothamBlack","GothamMedium","SourceSans","SourceSansBold","SourceSansItalic","SourceSansLight","Arial","ArialBold","Legacy","Code","SciFi","Arcade","Bangers","Cartoon","Creepster","DenkOne","Fondamento","FredokaOne","GrenzeGotisch","IndieFlower","JosefinSans","Jura","Kalam","LuckiestGuy","Merriweather","Michroma","Nunito","Oswald","PatrickHand","PermanentMarker","Roboto","RobotoCondensed","RobotoMono","Sarpanch","SpecialElite","TitilliumWeb","Ubuntu"}
}

local S = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    Lighting = game:GetService("Lighting"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    CoreGui = game:GetService("CoreGui"),
    Workspace = game:GetService("Workspace"),
    StarterGui = game:GetService("StarterGui"),
    TextChatService = game:GetService("TextChatService")
}

local Player = S.Players.LocalPlayer
local Camera = S.Workspace.CurrentCamera

-- Utility
local function C(t,p) local i=Instance.new(t) for k,v in pairs(p) do pcall(function()i[k]=v end) end return i end
local function Tween(i,p,d,es,ed) d=d or 0.4;es=es or Enum.EasingStyle.Quart;ed=ed or Enum.EasingDirection.Out; local ti=TweenInfo.new(d,es,ed); local tw=S.TweenService:Create(i,ti,p); tw:Play(); return tw end
local function Round(n,dec) dec=dec or 0; local m=10^dec; return math.floor(n*m+0.5)/m end

-- Performance Monitor
local FPS,Ping,Memory = 0,0,0
spawn(function() local f=0; local lu=tick(); S.RunService.RenderStepped:Connect(function() f=f+1; if tick()-lu>=1 then FPS=f; f=0; lu=tick() end end) end)
spawn(function() while wait(1) do local s,r=pcall(function() return Player:GetNetworkPing()*1000 end) if s then Ping=Round(r,0) end end end)
spawn(function() while wait(2) do local s,r=pcall(function() return collectgarbage("count")/1024 end) if s then Memory=Round(r,1) end end end)

-- Glass UI Builder
local Glass = {}
function Glass.Frame(parent,sz,pos,col)
    col=col or Color3.fromRGB(20,20,30)
    local f=C("Frame",{Name="Glass",Size=sz or UDim2.new(0,400,0,300),Position=pos or UDim2.new(0.5,-200,0.5,-150),BackgroundColor3=col,BackgroundTransparency=0.3,BorderSizePixel=0,Parent=parent,ClipsDescendants=true})
    C("UICorner",{CornerRadius=UDim.new(0,12),Parent=f})
    C("UIStroke",{Color=Color3.fromRGB(255,255,255),Transparency=0.85,Thickness=1,Parent=f})
    C("Frame",{Name="Shine",Size=UDim2.new(1,0,0,1),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.7,BorderSizePixel=0,Parent=f})
    C("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(200,200,220)),ColorSequenceKeypoint.new(1,Color3.fromRGB(150,150,170))}),Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.92),NumberSequenceKeypoint.new(0.5,0.95),NumberSequenceKeypoint.new(1,0.98)}),Rotation=90,Parent=f})
    return f
end

function Glass.Button(parent,txt,sz,pos,cb)
    local b=C("TextButton",{Name=txt.."Btn",Size=sz or UDim2.new(0,120,0,35),Position=pos or UDim2.new(0,0,0,0),BackgroundColor3=Color3.fromRGB(40,40,55),BackgroundTransparency=0.4,BorderSizePixel=0,Text=txt,TextColor3=Color3.fromRGB(255,255,255),TextSize=14,Font=Enum.Font[NLV.CurrentFont],Parent=parent,AutoButtonColor=false,ClipsDescendants=true})
    C("UICorner",{CornerRadius=UDim.new(0,8),Parent=b})
    C("UIStroke",{Color=Color3.fromRGB(255,255,255),Transparency=0.9,Thickness=1,Parent=b})
    b.MouseEnter:Connect(function() Tween(b,{BackgroundTransparency=0.2,BackgroundColor3=Color3.fromRGB(60,60,80)},0.2) end)
    b.MouseLeave:Connect(function() Tween(b,{BackgroundTransparency=0.4,BackgroundColor3=Color3.fromRGB(40,40,55)},0.2) end)
    if cb then b.MouseButton1Click:Connect(cb) end
    return b
end

function Glass.Toggle(parent,txt,def,cb)
    local fr=C("Frame",{Name=txt.."Toggle",Size=UDim2.new(1,-20,0,40),BackgroundTransparency=1,Parent=parent})
    C("TextLabel",{Size=UDim2.new(0.7,0,1,0),BackgroundTransparency=1,Text=txt,TextColor3=Color3.fromRGB(255,255,255),TextSize=14,Font=Enum.Font[NLV.CurrentFont],TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
    local bg=C("Frame",{Name="Bg",Size=UDim2.new(0,50,0,26),Position=UDim2.new(1,-50,0.5,-13),BackgroundColor3=def and Color3.fromRGB(0,170,255) or Color3.fromRGB(60,60,70),BorderSizePixel=0,Parent=fr})
    C("UICorner",{CornerRadius=UDim.new(1,0),Parent=bg})
    local cir=C("Frame",{Name="Cir",Size=UDim2.new(0,22,0,22),Position=def and UDim2.new(1,-24,0.5,-11) or UDim2.new(0,2,0.5,-11),BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,Parent=bg})
    C("UICorner",{CornerRadius=UDim.new(1,0),Parent=cir})
    local st=def
    local function Tog() st=not st; if st then Tween(bg,{BackgroundColor3=Color3.fromRGB(0,170,255)},0.3); Tween(cir,{Position=UDim2.new(1,-24,0.5,-11)},0.3) else Tween(bg,{BackgroundColor3=Color3.fromRGB(60,60,70)},0.3); Tween(cir,{Position=UDim2.new(0,2,0.5,-11)},0.3) end; if cb then cb(st) end end
    bg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then Tog() end end)
    return fr,Tog
end

function Glass.Dropdown(parent,txt,opts,def,cb)
    local fr=C("Frame",{Name=txt.."Drop",Size=UDim2.new(1,-20,0,40),BackgroundTransparency=1,Parent=parent,ClipsDescendants=true})
    C("TextLabel",{Size=UDim2.new(0.5,0,0,20),BackgroundTransparency=1,Text=txt,TextColor3=Color3.fromRGB(255,255,255),TextSize=14,Font=Enum.Font[NLV.CurrentFont],TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
    local btn=C("TextButton",{Size=UDim2.new(0.5,0,0,30),Position=UDim2.new(0.5,0,0,0),BackgroundColor3=Color3.fromRGB(40,40,55),BackgroundTransparency=0.4,BorderSizePixel=0,Text=def or opts[1] or "Select",TextColor3=Color3.fromRGB(255,255,255),TextSize=13,Font=Enum.Font[NLV.CurrentFont],Parent=fr,AutoButtonColor=false})
    C("UICorner",{CornerRadius=UDim.new(0,6),Parent=btn})
    C("UIStroke",{Color=Color3.fromRGB(255,255,255),Transparency=0.9,Thickness=1,Parent=btn})
    local ddf=C("Frame",{Name="List",Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,35),BackgroundColor3=Color3.fromRGB(30,30,40),BackgroundTransparency=0.2,BorderSizePixel=0,Parent=fr,ClipsDescendants=true,Visible=false})
    C("UICorner",{CornerRadius=UDim.new(0,6),Parent=ddf})
    C("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=ddf})
    local op=false
    for i,opt in ipairs(opts) do
        local ob=C("TextButton",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Color3.fromRGB(40,40,55),BackgroundTransparency=0.5,BorderSizePixel=0,Text=opt,TextColor3=Color3.fromRGB(255,255,255),TextSize=12,Font=Enum.Font[NLV.CurrentFont],Parent=ddf,AutoButtonColor=false})
        ob.MouseEnter:Connect(function() Tween(ob,{BackgroundTransparency=0.2},0.2) end)
        ob.MouseLeave:Connect(function() Tween(ob,{BackgroundTransparency=0.5},0.2) end)
        ob.MouseButton1Click:Connect(function() btn.Text=opt; op=false; Tween(ddf,{Size=UDim2.new(1,0,0,0)},0.3); wait(0.3); ddf.Visible=false; if cb then cb(opt) end end)
    end
    btn.MouseButton1Click:Connect(function() op=not op; if op then ddf.Visible=true; Tween(ddf,{Size=UDim2.new(1,0,0,math.min(#opts*30,150))},0.3) else Tween(ddf,{Size=UDim2.new(1,0,0,0)},0.3); wait(0.3); ddf.Visible=false end end)
    return fr
end

-- Notification
function NLV.Notify(title,msg,dur)
    dur=dur or 3
    local sg=C("ScreenGui",{Name="NLV_Noti",Parent=S.CoreGui,ResetOnSpawn=false,DisplayOrder=1000})
    local fr=Glass.Frame(sg,UDim2.new(0,280,0,80),UDim2.new(1,20,1,-100),Color3.fromRGB(20,20,30))
    C("TextLabel",{Size=UDim2.new(1,-20,0,25),Position=UDim2.new(0,15,0,8),BackgroundTransparency=1,Text=title,TextColor3=Color3.fromRGB(0,170,255),TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
    C("TextLabel",{Size=UDim2.new(1,-20,0,40),Position=UDim2.new(0,15,0,32),BackgroundTransparency=1,Text=msg,TextColor3=Color3.fromRGB(200,200,220),TextSize=12,Font=Enum.Font[NLV.CurrentFont],TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=fr})
    Tween(fr,{Position=UDim2.new(1,-300,1,-100)},0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    delay(dur,function() Tween(fr,{Position=UDim2.new(1,20,1,-100)},0.4); wait(0.4); sg:Destroy() end)
end

-- Graphics Functions
function NLV.SetMode(mode)
    NLV.CurrentMode=mode
    if mode=="LOW" then
        settings().Rendering.QualityLevel=1
        S.Lighting.GlobalShadows=false
        S.Lighting.FogEnd=500
        Camera.FieldOfView=70
        for _,obj in ipairs(S.Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                obj.Material=Enum.Material.SmoothPlastic; obj.Reflectance=0
                if obj:IsA("MeshPart") then obj.RenderFidelity=Enum.RenderFidelity.Performance end
            elseif obj:IsA("Decal") or obj:IsA("Texture") then obj:Destroy()
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Lifetime=NumberRange.new(0) end
        end
        for _,ef in ipairs(S.Lighting:GetDescendants()) do
            if ef:IsA("BlurEffect") or ef:IsA("SunRaysEffect") or ef:IsA("ColorCorrectionEffect") or ef:IsA("BloomEffect") or ef:IsA("DepthOfFieldEffect") then ef.Enabled=false end
        end
        local ter=S.Workspace:FindFirstChildOfClass("Terrain")
        if ter then ter.WaterWaveSize=0; ter.WaterWaveSpeed=0; ter.WaterReflectance=0; ter.WaterTransparency=0 end
        if NLV.FPS_SuperX then setfpscap(9999); settings().Rendering.EagerBulkExecution=false; settings().Rendering.InterpolationThrottling=true end
    elseif mode=="BALANCED" then
        settings().Rendering.QualityLevel=5; S.Lighting.GlobalShadows=true; S.Lighting.FogEnd=3000; Camera.FieldOfView=80
    elseif mode=="MAX" then
        settings().Rendering.QualityLevel=10; S.Lighting.GlobalShadows=true; S.Lighting.FogEnd=100000; Camera.FieldOfView=90
        if NLV.FPS_Unlocked then setfpscap(9999) end
    elseif mode=="VIP" then
        settings().Rendering.QualityLevel=10; S.Lighting.GlobalShadows=true; S.Lighting.FogEnd=9e9; Camera.FieldOfView=100
        for _,obj in ipairs(S.Workspace:GetDescendants()) do
            if obj:IsA("MeshPart") then obj.RenderFidelity=Enum.RenderFidelity.Precise end
            if obj:IsA("BasePart") then obj.CastShadow=true end
        end
        setfpscap(9999)
    end
    NLV.Notify("Mode Changed","Switched to "..mode.." mode",3)
end

function NLV.ToggleFPSUnlock(en) if en then setfpscap(9999); NLV.Notify("FPS Unlock","FPS cap removed!",3) else setfpscap(60); NLV.Notify("FPS Unlock","FPS cap restored to 60.",3) end end
function NLV.ToggleFPSSuperX(en) if en then settings().Rendering.EagerBulkExecution=false; settings().Rendering.InterpolationThrottling=true; NLV.Notify("FPS SuperX","Super performance activated!",3) else settings().Rendering.EagerBulkExecution=true; settings().Rendering.InterpolationThrottling=false; NLV.Notify("FPS SuperX","Disabled.",3) end end
function NLV.ToggleTextures(en) if not en then for _,obj in ipairs(S.Workspace:GetDescendants()) do if obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1 end end; NLV.Notify("Textures","All textures removed.",2) end end
function NLV.ToggleShadows(en) S.Lighting.GlobalShadows=en; for _,obj in ipairs(S.Workspace:GetDescendants()) do if obj:IsA("BasePart") or obj:IsA("MeshPart") then obj.CastShadow=en end end; NLV.Notify("Shadows",en and "Enabled." or "Disabled.",2) end
function NLV.ToggleEffects(en) for _,ef in ipairs(S.Lighting:GetDescendants()) do if ef:IsA("BlurEffect") or ef:IsA("SunRaysEffect") or ef:IsA("ColorCorrectionEffect") or ef:IsA("BloomEffect") or ef:IsA("DepthOfFieldEffect") then ef.Enabled=en end end; NLV.Notify("Effects",en and "Enabled." or "Disabled.",2) end
function NLV.ToggleParticles(en) for _,obj in ipairs(S.Workspace:GetDescendants()) do if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Enabled=en end end; NLV.Notify("Particles",en and "Enabled." or "Disabled.",2) end
function NLV.ToggleTerrain(en) local ter=S.Workspace:FindFirstChildOfClass("Terrain"); if ter then if en then ter.WaterWaveSize=0; ter.WaterWaveSpeed=0; ter.WaterReflectance=0 else ter.WaterWaveSize=1; ter.WaterWaveSpeed=1; ter.WaterReflectance=1 end end; NLV.Notify("Terrain",en and "Optimized." or "Restored.",2) end

-- VIP Features
function NLV.VIP_HDTextures(en) for _,obj in ipairs(S.Workspace:GetDescendants()) do if obj:IsA("MeshPart") then obj.RenderFidelity=en and Enum.RenderFidelity.Precise or Enum.RenderFidelity.Automatic end end end
function NLV.VIP_SmoothMap(en) if en then local ter=S.Workspace:FindFirstChildOfClass("Terrain"); if ter then ter.WaterWaveSize=0.5; ter.WaterWaveSpeed=2; ter.WaterReflectance=1; ter.WaterTransparency=0.3 end end end
function NLV.VIP_UltraRender(en) if en then Camera.FieldOfView=100; settings().Rendering.QualityLevel=10; S.Lighting.FogEnd=9e9 end end
function NLV.VIP_AdvancedLighting(en) if en then S.Lighting.GlobalShadows=true; S.Lighting.Outlines=false; S.Lighting.Brightness=2 end end
function NLV.VIP_AntiLag(en) if en then for _,obj in ipairs(S.Workspace:GetDescendants()) do if obj:IsA("BasePart") and obj.Anchored and not obj.CanCollide then obj.CastShadow=false end end; settings().Network.IncomingReplicationLag=0 end end
function NLV.VIP_MemoryOptimize(en) if en then collectgarbage("collect"); for _,obj in ipairs(S.Workspace:GetDescendants()) do if obj:IsA("Decal") and obj.Transparency==1 then obj:Destroy() end end end end

-- Font Changer
function NLV.ChangeFont(font)
    local fe=Enum.Font[font]; if not fe then NLV.Notify("Font Error","Invalid font: "..font,3) return end
    local function CF(p) for _,obj in ipairs(p:GetDescendants()) do if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then pcall(function()obj.Font=fe end) end end end
    if Player:FindFirstChild("PlayerGui") then CF(Player.PlayerGui) end
    CF(S.CoreGui); CF(S.StarterGui)
    NLV.CurrentFont=font; NLV.Notify("Font Changed","Global font: "..font,3)
end

function NLV.Reset()
    settings().Rendering.QualityLevel=5; S.Lighting.GlobalShadows=true; S.Lighting.FogEnd=3000; Camera.FieldOfView=80; setfpscap(60)
    NLV.FPS_Unlocked=false; NLV.FPS_SuperX=false
    local ter=S.Workspace:FindFirstChildOfClass("Terrain"); if ter then ter.WaterWaveSize=1; ter.WaterWaveSpeed=1; ter.WaterReflectance=1 end
    NLV.Notify("Reset","All settings reset.",3)
end

-- ═══════════════════════════════════════════════════════════════════
-- MAIN UI
-- ═══════════════════════════════════════════════════════════════════

local sg=C("ScreenGui",{Name="NLV_GUI",Parent=S.CoreGui,ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=999})
local mf=Glass.Frame(sg,UDim2.new(0,500,0,380),UDim2.new(0.5,-250,0.5,-190),Color3.fromRGB(15,15,25))
mf.Name="NLV_Main"

-- Title Bar
local tb=C("Frame",{Name="TitleBar",Size=UDim2.new(1,0,0,45),BackgroundColor3=Color3.fromRGB(20,20,35),BackgroundTransparency=0.5,BorderSizePixel=0,Parent=mf})
C("UICorner",{CornerRadius=UDim.new(0,12),Parent=tb})
C("TextLabel",{Name="Logo",Size=UDim2.new(0,100,1,0),Position=UDim2.new(0,15,0,0),BackgroundTransparency=1,Text="NLV",TextColor3=Color3.fromRGB(0,170,255),TextSize=24,Font=Enum.Font.GothamBlack,TextXAlignment=Enum.TextXAlignment.Left,Parent=tb})
C("TextLabel",{Name="Sub",Size=UDim2.new(0,200,0,20),Position=UDim2.new(0,15,0,28),BackgroundTransparency=1,Text="Nazz Level Visualizer | "..NLV.Version,TextColor3=Color3.fromRGB(150,150,170),TextSize=10,Font=Enum.Font[NLV.CurrentFont],TextXAlignment=Enum.TextXAlignment.Left,Parent=tb})

-- VIP Badge
local vip=C("Frame",{Name="VIP",Size=UDim2.new(0,60,0,22),Position=UDim2.new(1,-140,0.5,-11),BackgroundColor3=Color3.fromRGB(255,215,0),BackgroundTransparency=0.2,BorderSizePixel=0,Parent=tb})
C("UICorner",{CornerRadius=UDim.new(0,4),Parent=vip})
C("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="VIP",TextColor3=Color3.fromRGB(0,0,0),TextSize=12,Font=Enum.Font.GothamBold,Parent=vip})

-- Close/Min Buttons
local cb=C("TextButton",{Name="Close",Size=UDim2.new(0,30,0,30),Position=UDim2.new(1,-35,0.5,-15),BackgroundColor3=Color3.fromRGB(255,70,70),BackgroundTransparency=0.3,BorderSizePixel=0,Text="X",TextColor3=Color3.fromRGB(255,255,255),TextSize=14,Font=Enum.Font.GothamBold,Parent=tb,AutoButtonColor=false})
C("UICorner",{CornerRadius=UDim.new(0,6),Parent=cb})
cb.MouseEnter:Connect(function() Tween(cb,{BackgroundTransparency=0},0.2) end)
cb.MouseLeave:Connect(function() Tween(cb,{BackgroundTransparency=0.3},0.2) end)
cb.MouseButton1Click:Connect(function() Tween(mf,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},0.4); wait(0.4); sg.Enabled=false end)

local mb=C("TextButton",{Name="Min",Size=UDim2.new(0,30,0,30),Position=UDim2.new(1,-70,0.5,-15),BackgroundColor3=Color3.fromRGB(255,170,0),BackgroundTransparency=0.3,BorderSizePixel=0,Text="-",TextColor3=Color3.fromRGB(255,255,255),TextSize=18,Font=Enum.Font.GothamBold,Parent=tb,AutoButtonColor=false})
C("UICorner",{CornerRadius=UDim.new(0,6),Parent=mb})
local min=false
mb.MouseButton1Click:Connect(function() min=not min; if min then Tween(mf,{Size=UDim2.new(0,500,0,45)},0.4) else Tween(mf,{Size=UDim2.new(0,500,0,380)},0.4) end end)

-- Tab Container
local tc=C("Frame",{Name="Tabs",Size=UDim2.new(0,120,1,-45),Position=UDim2.new(0,0,0,45),BackgroundColor3=Color3.fromRGB(20,20,30),BackgroundTransparency=0.6,BorderSizePixel=0,Parent=mf})
C("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4),Parent=tc})
C("UIPadding",{PaddingTop=UDim.new(0,10),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),Parent=tc})

-- Content Area
local cf=C("Frame",{Name="Content",Size=UDim2.new(1,-120,1,-45),Position=UDim2.new(0,120,0,45),BackgroundTransparency=1,Parent=mf})

-- Stats Bar
local sb=C("Frame",{Name="Stats",Size=UDim2.new(1,-120,0,30),Position=UDim2.new(0,120,1,-30),BackgroundColor3=Color3.fromRGB(20,20,30),BackgroundTransparency=0.7,BorderSizePixel=0,Parent=mf})
local fl=C("TextLabel",{Name="FPS",Size=UDim2.new(0.33,0,1,0),BackgroundTransparency=1,Text="FPS: --",TextColor3=Color3.fromRGB(0,255,100),TextSize=11,Font=Enum.Font[NLV.CurrentFont],Parent=sb})
local pl=C("TextLabel",{Name="Ping",Size=UDim2.new(0.33,0,1,0),Position=UDim2.new(0.33,0,0,0),BackgroundTransparency=1,Text="Ping: --ms",TextColor3=Color3.fromRGB(255,200,0),TextSize=11,Font=Enum.Font[NLV.CurrentFont],Parent=sb})
local ml=C("TextLabel",{Name="Mem",Size=UDim2.new(0.33,0,1,0),Position=UDim2.new(0.66,0,0,0),BackgroundTransparency=1,Text="MEM: --MB",TextColor3=Color3.fromRGB(0,170,255),TextSize=11,Font=Enum.Font[NLV.CurrentFont],Parent=sb})
spawn(function() while wait(0.5) do fl.Text="FPS: "..FPS; pl.Text="Ping: "..Ping.."ms"; ml.Text="MEM: "..Memory.."MB" end end)

-- Tab Creation
local Tabs={}; local curTab=nil
local function MakeTab(name)
    local btn=C("TextButton",{Name=name.."Tab",Size=UDim2.new(1,0,0,36),BackgroundColor3=Color3.fromRGB(30,30,45),BackgroundTransparency=0.5,BorderSizePixel=0,Text="  "..name,TextColor3=Color3.fromRGB(180,180,200),TextSize=12,Font=Enum.Font[NLV.CurrentFont],TextXAlignment=Enum.TextXAlignment.Left,Parent=tc,AutoButtonColor=false})
    C("UICorner",{CornerRadius=UDim.new(0,8),Parent=btn})
    local cont=C("ScrollingFrame",{Name=name.."Cont",Size=UDim2.new(1,-20,1,-10),Position=UDim2.new(0,10,0,5),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,ScrollBarImageColor3=Color3.fromRGB(0,170,255),Visible=false,Parent=cf})
    C("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8),Parent=cont})
    C("UIPadding",{PaddingTop=UDim.new(0,10),PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5),Parent=cont})
    btn.MouseButton1Click:Connect(function()
        if curTab then Tween(Tabs[curTab].Btn,{BackgroundColor3=Color3.fromRGB(30,30,45),BackgroundTransparency=0.5},0.2); Tabs[curTab].Btn.TextColor3=Color3.fromRGB(180,180,200); Tabs[curTab].Cont.Visible=false end
        curTab=name; Tween(btn,{BackgroundColor3=Color3.fromRGB(0,170,255),BackgroundTransparency=0.3},0.2); btn.TextColor3=Color3.fromRGB(255,255,255); cont.Visible=true
    end)
    Tabs[name]={Btn=btn,Cont=cont}
    return cont
end

local gTab=MakeTab("Graphics")
local fTab=MakeTab("Font")
local vTab=MakeTab("VIP")
local sTab=MakeTab("Settings")
Tabs["Graphics"].Btn.MouseButton1Click:Fire()

-- ═══════════════════════════════════════════════════════════════════
-- GRAPHICS TAB
-- ═══════════════════════════════════════════════════════════════════

C("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,Text="PERFORMANCE MODE",TextColor3=Color3.fromRGB(0,170,255),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=gTab})

local mc=C("Frame",{Size=UDim2.new(1,0,0,45),BackgroundTransparency=1,Parent=gTab})
C("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8),Parent=mc})

Glass.Button(mc,"LOW",UDim2.new(0,100,0,35),UDim2.new(0,0,0,0),function() NLV.SetMode("LOW") end).BackgroundColor3=Color3.fromRGB(0,150,100)
Glass.Button(mc,"BALANCED",UDim2.new(0,100,0,35),UDim2.new(0,0,0,0),function() NLV.SetMode("BALANCED") end).BackgroundColor3=Color3.fromRGB(0,120,200)
Glass.Button(mc,"MAX",UDim2.new(0,100,0,35),UDim2.new(0,0,0,0),function() NLV.SetMode("MAX") end).BackgroundColor3=Color3.fromRGB(200,100,0)
Glass.Button(mc,"VIP",UDim2.new(0,100,0,35),UDim2.new(0,0,0,0),function() NLV.SetMode("VIP") end).BackgroundColor3=Color3.fromRGB(255,215,0)

C("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,Text="ADVANCED FEATURES",TextColor3=Color3.fromRGB(0,170,255),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=gTab})

Glass.Toggle(gTab,"FPS Unlock",false,function(st) NLV.FPS_Unlocked=st; NLV.ToggleFPSUnlock(st) end)
Glass.Toggle(gTab,"FPS SuperX (Low)",false,function(st) NLV.FPS_SuperX=st; NLV.ToggleFPSSuperX(st) end)
Glass.Toggle(gTab,"Remove Textures",false,function(st) NLV.ToggleTextures(not st) end)
Glass.Toggle(gTab,"Remove Shadows",false,function(st) NLV.ToggleShadows(not st) end)
Glass.Toggle(gTab,"Remove Effects",false,function(st) NLV.ToggleEffects(not st) end)
Glass.Toggle(gTab,"Remove Particles",false,function(st) NLV.ToggleParticles(not st) end)
Glass.Toggle(gTab,"Optimize Terrain",false,function(st) NLV.ToggleTerrain(st) end)

-- ═══════════════════════════════════════════════════════════════════
-- FONT TAB
-- ═══════════════════════════════════════════════════════════════════

C("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,Text="GLOBAL FONT CHANGER",TextColor3=Color3.fromRGB(0,170,255),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=fTab})
C("TextLabel",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Text="Changes ALL text in the game to selected font",TextColor3=Color3.fromRGB(150,150,170),TextSize=11,Font=Enum.Font[NLV.CurrentFont],TextXAlignment=Enum.TextXAlignment.Left,Parent=fTab})

Glass.Dropdown(fTab,"Select Font",NLV.Fonts,NLV.CurrentFont,function(sel) NLV.CurrentFont=sel end)

local afb=Glass.Button(fTab,"Apply Font",UDim2.new(0,150,0,35),UDim2.new(0,0,0,0))
afb.MouseButton1Click:Connect(function() NLV.ChangeFont(NLV.CurrentFont) end)

local preview=C("TextLabel",{Size=UDim2.new(1,0,0,40),BackgroundColor3=Color3.fromRGB(30,30,40),BackgroundTransparency=0.5,Text="Preview: The quick brown fox",TextColor3=Color3.fromRGB(255,255,255),TextSize=16,Font=Enum.Font[NLV.CurrentFont],Parent=fTab})
C("UICorner",{CornerRadius=UDim.new(0,8),Parent=preview})

-- ═══════════════════════════════════════════════════════════════════
-- VIP TAB
-- ═══════════════════════════════════════════════════════════════════

C("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,Text="NLV VIP FEATURES",TextColor3=Color3.fromRGB(255,215,0),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=vTab})
C("TextLabel",{Size=UDim2.new(1,0,0,25),BackgroundTransparency=1,Text="Status: ACTIVE | Days: "..NLV.VIP_Days,TextColor3=Color3.fromRGB(0,255,100),TextSize=11,Font=Enum.Font[NLV.CurrentFont],TextXAlignment=Enum.TextXAlignment.Left,Parent=vTab})

Glass.Toggle(vTab,"HD Texture Boost",false,function(st) NLV.VIP_HDTextures(st) end)
Glass.Toggle(vTab,"Smooth Map Rendering",false,function(st) NLV.VIP_SmoothMap(st) end)
Glass.Toggle(vTab,"Ultra Render Distance",false,function(st) NLV.VIP_UltraRender(st) end)
Glass.Toggle(vTab,"Advanced Lighting",false,function(st) NLV.VIP_AdvancedLighting(st) end)
Glass.Toggle(vTab,"Anti-Lag System",false,function(st) NLV.VIP_AntiLag(st) end)
Glass.Toggle(vTab,"Memory Optimizer",false,function(st) NLV.VIP_MemoryOptimize(st) end)

local warn=C("TextLabel",{Size=UDim2.new(1,0,0,40),BackgroundColor3=Color3.fromRGB(255,50,50),BackgroundTransparency=0.8,Text="WARNING: VIP features are powerful. Use with caution on low-end devices.",TextColor3=Color3.fromRGB(255,100,100),TextSize=10,Font=Enum.Font[NLV.CurrentFont],TextWrapped=true,Parent=vTab})
C("UICorner",{CornerRadius=UDim.new(0,6),Parent=warn})

-- ═══════════════════════════════════════════════════════════════════
-- SETTINGS TAB
-- ═══════════════════════════════════════════════════════════════════

C("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,Text="SETTINGS & INFO",TextColor3=Color3.fromRGB(0,170,255),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=sTab})

local infos={{"Version",NLV.Version},{"Creator",NLV.Creator},{"Team",NLV.Team},{"VIP Status",NLV.IsVIP and "Active" or "Inactive"},{"VIP Days",tostring(NLV.VIP_Days)},{"Current Mode",NLV.CurrentMode}}
for _,info in ipairs(infos) do
    local fr=C("Frame",{Size=UDim2.new(1,0,0,25),BackgroundTransparency=1,Parent=sTab})
    C("TextLabel",{Size=UDim2.new(0.4,0,1,0),BackgroundTransparency=1,Text=info[1]..":",TextColor3=Color3.fromRGB(150,150,170),TextSize=12,Font=Enum.Font[NLV.CurrentFont],TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
    C("TextLabel",{Size=UDim2.new(0.6,0,1,0),Position=UDim2.new(0.4,0,0,0),BackgroundTransparency=1,Text=info[2],TextColor3=Color3.fromRGB(255,255,255),TextSize=12,Font=Enum.Font[NLV.CurrentFont],TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
end

local rb=Glass.Button(sTab,"Reset All",UDim2.new(0,150,0,35),UDim2.new(0,0,0,0))
rb.BackgroundColor3=Color3.fromRGB(255,70,70)
rb.MouseButton1Click:Connect(function() NLV.Reset() end)

-- ═══════════════════════════════════════════════════════════════════
-- KEYBIND & DRAG
-- ═══════════════════════════════════════════════════════════════════

S.UserInputService.InputBegan:Connect(function(i,gp) if not gp and i.KeyCode==Enum.KeyCode.F4 then sg.Enabled=not sg.Enabled; if sg.Enabled then mf.Size=UDim2.new(0,0,0,0); mf.Position=UDim2.new(0.5,0,0.5,0); Tween(mf,{Size=UDim2.new(0,500,0,380),Position=UDim2.new(0.5,-250,0.5,-190)},0.4) end end end)

local drag=false; local ds; local sp
tb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true; ds=i.Position; sp=mf.Position end end)
S.UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-ds; mf.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y) end end)
S.UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)

-- Intro Animation
mf.Size=UDim2.new(0,0,0,0); mf.Position=UDim2.new(0.5,0,0.5,0); wait(0.1)
Tween(mf,{Size=UDim2.new(0,500,0,380),Position=UDim2.new(0.5,-250,0.5,-190)},0.6,Enum.EasingStyle.Back,Enum.EasingDirection.Out)

-- Welcome
wait(1)
NLV.Notify("NLV Loaded","Welcome to NLV v"..NLV.Version.." | Press F4 to toggle",4)
NLV.Notify("VIP Active","VIP access: "..NLV.VIP_Days.." days remaining",4)

print("[NLV] Nazz Level Visualizer v"..NLV.Version.." loaded!")
print("[NLV] Created by "..NLV.Creator.." | Powered by "..NLV.Team)
