local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = workspace
local Camera = Workspace.CurrentCamera
local LP = Players.LocalPlayer
local HS = game:GetService("HttpService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

local VERSION = "14.0"
local AccentColor = Color3.fromRGB(180, 100, 255)
local RGBMode = false
local RGBLogo = false
local AnimatedTheme = false
local AimPart = "Head"
local FOVSize = 120
local PredictionAmount = 0.15
local AimSmooth = 0.25
local AimMode = "Closest"
local AimVisibleOnly = false
local CurrentTheme = "Roxo"
local PanicKey = Enum.KeyCode.P
local MobileExtra = false
local KillAuraRange = 20
local ChatSpamText = "⚡ ZVH HUB ON TOP ⚡"
local CollectRange = 100
local LOGO_OLD = "rbxassetid://96373255363269"

local Config = {
    Aimbot = false, FOVCircle = false,
    AutoShoot = false, Triggerbot = false, WallBang = false,
    Prediction = false, AimSmoothToggle = false,
    ESP = false, Chams = false, Tracers = false, Watermark = true,
    Fullbright = false, NoFog = false, Bloom = false,
    Speed = false, Jump = false, BunnyHop = false, HighJump = false,
    Hit = false, KillAura = false, Invisible = false,
    AutoDodge = false, ChatSpam = false, AutoCollect = false
}

local GameName = "Universal"
local GameType = "Universal"
local ok, info = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)
if ok and info then GameName = info.Name end
local lower = GameName:lower()
if lower:find("rival") then GameType = "Rivals"
elseif lower:find("blade") then GameType = "Blade Ball"
elseif lower:find("steal") or lower:find("egg") then GameType = "Steal An Egg"
elseif lower:find("doors") then GameType = "Doors"
elseif lower:find("blox") then GameType = "Blox Fruits"
elseif lower:find("arsenal") then GameType = "Arsenal"
elseif lower:find("pet") then GameType = "Pet Simulator"
elseif lower:find("murder") then GameType = "MM2"
elseif lower:find("adopt") then GameType = "Adopt Me"
elseif lower:find("jailbreak") then GameType = "Jailbreak" end
print("[ZVH HUB] v" .. VERSION .. " | " .. GameType)

local Themes = {
    ["Roxo"] = Color3.fromRGB(180, 100, 255),
    ["Vermelho"] = Color3.fromRGB(255, 50, 50),
    ["Azul"] = Color3.fromRGB(50, 150, 255),
    ["Verde"] = Color3.fromRGB(50, 255, 100),
    ["Rosa"] = Color3.fromRGB(255, 20, 147),
    ["Amarelo"] = Color3.fromRGB(255, 220, 0),
    ["Laranja"] = Color3.fromRGB(255, 140, 0),
    ["Ciano"] = Color3.fromRGB(0, 255, 255),
    ["Dourado"] = Color3.fromRGB(255, 215, 0),
    ["Vinho"] = Color3.fromRGB(128, 0, 32),
    ["Neon"] = Color3.fromRGB(0, 255, 127)
}

local function SaveConfig()
    pcall(function() writefile("ZVH_Config.json", HS:JSONEncode(Config)) end)
end
local function LoadConfig()
    pcall(function()
        if isfile("ZVH_Config.json") then
            local d = HS:JSONDecode(readfile("ZVH_Config.json"))
            for k, v in pairs(d) do if Config[k] ~= nil then Config[k] = v end end
        end
    end)
end
LoadConfig()

local Presets = {
    ["PvP"] = {Aimbot=true, ESP=true, KillAura=true, Chams=true, Hit=true},
    ["Farm"] = {AutoCollect=true, Speed=true, Hit=true, Fullbright=true},
    ["Discreto"] = {Aimbot=true, Hit=true},
    ["Padrão"] = {Hit=true}
}
local function ApplyPreset(name)
    if not Presets[name] then return end
    for k in pairs(Config) do Config[k] = false end
    for k, v in pairs(Presets[name]) do Config[k] = v end
    SaveConfig()
end

local function PlaySound(id, vol)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. id
        s.Volume = vol or 0.3
        s.Parent = game:GetService("SoundService")
        s:Play()
        game:GetService("Debris"):AddItem(s, 2)
    end)
end
local function PlayClick() PlaySound("6042053626", 0.3) end
local function PlayHover() PlaySound("131961136", 0.08) end
local function PlayToggle() PlaySound("4612375230", 0.2) end
local function PlayIntroRiser() PlaySound("1836317389", 0.5) end
local function PlayIntroImpact() PlaySound("9118823100", 0.6) end
local function PlayOpen() PlaySound("9118823100", 0.4) end
local function PlayClose() PlaySound("6042053626", 0.3) end

local NotifGui = Instance.new("ScreenGui")
NotifGui.ResetOnSpawn = false
NotifGui.DisplayOrder = 1000
NotifGui.Parent = game:GetService("CoreGui")

local function Notify(title, text, color)
    color = color or AccentColor
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 320, 0, 80)
    notif.Position = UDim2.new(0, -340, 0, 20)
    notif.BackgroundColor3 = Color3.fromRGB(12, 6, 16)
    notif.BorderSizePixel = 0
    notif.Parent = NotifGui
    local nc = Instance.new("UICorner")
    nc.CornerRadius = UDim.new(0, 14)
    nc.Parent = notif
    local ns = Instance.new("UIStroke")
    ns.Color = color
    ns.Thickness = 2
    ns.Transparency = 0.3
    ns.Parent = notif
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 4, 1, -18)
    line.Position = UDim2.new(0, 9, 0, 9)
    line.BackgroundColor3 = color
    line.BorderSizePixel = 0
    line.Parent = notif
    local lineC = Instance.new("UICorner")
    lineC.CornerRadius = UDim.new(1, 0)
    lineC.Parent = line
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -30, 0, 24)
    t.Position = UDim2.new(0, 22, 0, 10)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = color
    t.TextSize = 16
    t.Font = Enum.Font.SciFi
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = notif
    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -30, 0, 38)
    d.Position = UDim2.new(0, 22, 0, 36)
    d.BackgroundTransparency = 1
    d.Text = text
    d.TextColor3 = Color3.fromRGB(220, 220, 220)
    d.TextSize = 12
    d.Font = Enum.Font.SciFi
    d.TextWrapped = true
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Parent = notif
    notif:TweenPosition(UDim2.new(0, 20, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.4, true)
    task.spawn(function()
        task.wait(3)
        notif:TweenPosition(UDim2.new(0, -340, 0, 20), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
        task.wait(0.4)
        notif:Destroy()
    end)
end

-- INTRO
local IG = Instance.new("ScreenGui")
IG.ResetOnSpawn = false
IG.IgnoreGuiInset = true
IG.DisplayOrder = 999
IG.Parent = game:GetService("CoreGui")

local IBg = Instance.new("Frame")
IBg.Size = UDim2.new(1, 0, 1, 0)
IBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
IBg.BackgroundTransparency = 1
IBg.BorderSizePixel = 0
IBg.Parent = IG

local BgGlow = Instance.new("Frame")
BgGlow.Size = UDim2.new(0, 0, 0, 0)
BgGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
BgGlow.AnchorPoint = Vector2.new(0.5, 0.5)
BgGlow.BackgroundColor3 = Color3.fromRGB(80, 30, 150)
BgGlow.BackgroundTransparency = 1
BgGlow.BorderSizePixel = 0
BgGlow.Parent = IG
local BgGlowC = Instance.new("UICorner")
BgGlowC.CornerRadius = UDim.new(1, 0)
BgGlowC.Parent = BgGlow

local BgGlow2 = Instance.new("Frame")
BgGlow2.Size = UDim2.new(0, 0, 0, 0)
BgGlow2.Position = UDim2.new(0.5, 0, 0.5, 0)
BgGlow2.AnchorPoint = Vector2.new(0.5, 0.5)
BgGlow2.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
BgGlow2.BackgroundTransparency = 1
BgGlow2.BorderSizePixel = 0
BgGlow2.Parent = IG
local BgGlow2C = Instance.new("UICorner")
BgGlow2C.CornerRadius = UDim.new(1, 0)
BgGlow2C.Parent = BgGlow2

task.spawn(function()
    for i = 1, 100 do
        local star = Instance.new("Frame")
        local size = math.random(2, 6)
        star.Size = UDim2.new(0, size, 0, size)
        star.Position = UDim2.new(math.random(), 0, -0.1, 0)
        star.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
        star.BackgroundTransparency = 0.3
        star.BorderSizePixel = 0
        star.Parent = IG
        local sc = Instance.new("UICorner")
        sc.CornerRadius = UDim.new(1, 0)
        sc.Parent = star
        task.spawn(function()
            local speed = math.random(30, 100) / 1000
            for j = 0, 100 do
                star.Position = UDim2.new(star.Position.X.Scale, 0, star.Position.Y.Scale + speed, 0)
                star.BackgroundTransparency = 0.3 + (j/100) * 0.7
                task.wait(0.03)
            end
            star:Destroy()
        end)
    end
end)

task.spawn(function()
    for i = 1, 8 do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 2, 0, 0)
        line.Position = UDim2.new(math.random(), 0, 0.5, 0)
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
        line.BackgroundTransparency = 0.7
        line.BorderSizePixel = 0
        line.Parent = IG
        task.spawn(function()
            task.wait(math.random() * 2)
            line:TweenSize(UDim2.new(0, 2, 0, 800), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.6, true)
            task.wait(0.3)
            line:TweenSize(UDim2.new(0, 2, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.4, true)
            task.wait(0.5)
            line:Destroy()
        end)
    end
end)

local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 0, 0, 0)
LogoFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
LogoFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LogoFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 12)
LogoFrame.BorderSizePixel = 0
LogoFrame.Parent = IG
local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = LogoFrame
local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(180, 100, 255)
LogoStroke.Thickness = 4
LogoStroke.Transparency = 1
LogoStroke.Parent = LogoFrame

local IntroLogoImg = Instance.new("ImageLabel")
IntroLogoImg.Size = UDim2.new(1, -10, 1, -10)
IntroLogoImg.Position = UDim2.new(0, 5, 0, 5)
IntroLogoImg.BackgroundTransparency = 1
IntroLogoImg.Image = LOGO_OLD
IntroLogoImg.Parent = LogoFrame
local IntroLogoImgC = Instance.new("UICorner")
IntroLogoImgC.CornerRadius = UDim.new(1, 0)
IntroLogoImgC.Parent = IntroLogoImg

local Ring = Instance.new("Frame")
Ring.Size = UDim2.new(1, 20, 1, 20)
Ring.Position = UDim2.new(0, -10, 0, -10)
Ring.BackgroundTransparency = 1
Ring.Parent = LogoFrame
local RingC = Instance.new("UICorner")
RingC.CornerRadius = UDim.new(1, 0)
RingC.Parent = Ring
local RingStroke = Instance.new("UIStroke")
RingStroke.Color = Color3.fromRGB(180, 100, 255)
RingStroke.Thickness = 2
RingStroke.Transparency = 0.5
RingStroke.Parent = Ring

local ITitle = Instance.new("TextLabel")
ITitle.Size = UDim2.new(0, 500, 0, 60)
ITitle.Position = UDim2.new(0.5, 0, 0.62, 0)
ITitle.AnchorPoint = Vector2.new(0.5, 0.5)
ITitle.BackgroundTransparency = 1
ITitle.Text = "ZVH HUB"
ITitle.TextColor3 = Color3.fromRGB(180, 100, 255)
ITitle.TextSize = 64
ITitle.Font = Enum.Font.SciFi
ITitle.TextTransparency = 1
ITitle.Parent = IG

local ITitleStroke = Instance.new("UIStroke")
ITitleStroke.Color = Color3.fromRGB(255, 255, 255)
ITitleStroke.Thickness = 2
ITitleStroke.Transparency = 1
ITitleStroke.Parent = ITitle

local ISub = Instance.new("TextLabel")
ISub.Size = UDim2.new(0, 500, 0, 25)
ISub.Position = UDim2.new(0.5, 0, 0.7, 0)
ISub.AnchorPoint = Vector2.new(0.5, 0.5)
ISub.BackgroundTransparency = 1
ISub.Text = "ULTRA PREMIUM EDITION"
ISub.TextColor3 = Color3.fromRGB(200, 200, 200)
ISub.TextSize = 14
ISub.Font = Enum.Font.SciFi
ISub.TextTransparency = 1
ISub.Parent = IG

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 400, 0, 10)
BarBg.Position = UDim2.new(0.5, -200, 0.78, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
BarBg.BorderSizePixel = 0
BarBg.BackgroundTransparency = 1
BarBg.Parent = IG
local BarBgC = Instance.new("UICorner")
BarBgC.CornerRadius = UDim.new(1, 0)
BarBgC.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBg
local BarFillC = Instance.new("UICorner")
BarFillC.CornerRadius = UDim.new(1, 0)
BarFillC.Parent = BarFill
local BarGlow = Instance.new("UIStroke")
BarGlow.Color = Color3.fromRGB(255, 150, 255)
BarGlow.Thickness = 2
BarGlow.Transparency = 0.3
BarGlow.Parent = BarFill

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Size = UDim2.new(0, 100, 0, 20)
PercentLabel.Position = UDim2.new(0.5, 0, 0.83, 0)
PercentLabel.AnchorPoint = Vector2.new(0.5, 0.5)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(180, 100, 255)
PercentLabel.TextSize = 16
PercentLabel.Font = Enum.Font.SciFi
PercentLabel.TextTransparency = 1
PercentLabel.Parent = IG

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 500, 0, 20)
StatusLabel.Position = UDim2.new(0.5, 0, 0.87, 0)
StatusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.SciFi
StatusLabel.TextTransparency = 1
StatusLabel.Parent = IG

task.spawn(function()
    task.wait(0.3)
    PlayIntroRiser()
    for i = 0, 25 do IBg.BackgroundTransparency = 1 - (i/25) task.wait(0.02) end
    BgGlow:TweenSize(UDim2.new(0, 900, 0, 900), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1.8, true)
    BgGlow.BackgroundTransparency = 0.85
    task.wait(0.3)
    BgGlow2:TweenSize(UDim2.new(0, 500, 0, 500), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1.5, true)
    BgGlow2.BackgroundTransparency = 0.75
    task.wait(0.4)
    LogoFrame:TweenSize(UDim2.new(0, 140, 0, 140), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.8, true)
    LogoStroke.Transparency = 0
    PlayIntroImpact()
    task.wait(0.5)
    for i = 0, 20 do
        ITitle.TextTransparency = 1 - (i/20)
        ITitleStroke.Transparency = 1 - (i/20) * 0.7
        task.wait(0.02)
    end
    for i = 0, 15 do ISub.TextTransparency = 1 - (i/15) task.wait(0.02) end
    for i = 0, 10 do
        BarBg.BackgroundTransparency = 1 - (i/10)
        PercentLabel.TextTransparency = 1 - (i/10)
        StatusLabel.TextTransparency = 1 - (i/10)
        task.wait(0.02)
    end
    local statusList = {"Loading modules...", "Connecting...", "Injecting...", "Optimizing...", "Finalizing..."}
    task.spawn(function()
        for _, txt in ipairs(statusList) do
            if StatusLabel then StatusLabel.Text = txt task.wait(0.4) end
        end
    end)
    local steps = 100
    for i = 0, steps do
        local pct = i / steps
        BarFill.Size = UDim2.new(pct, 0, 1, 0)
        PercentLabel.Text = math.floor(pct * 100) .. "%"
        task.wait(2 / steps)
    end
    StatusLabel.Text = "✓ READY"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    PercentLabel.Text = "100%"
    PercentLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    ITitle.TextColor3 = Color3.fromRGB(0, 255, 100)
    LogoStroke.Color = Color3.fromRGB(0, 255, 100)
    BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    BarGlow.Color = Color3.fromRGB(0, 255, 100)
    task.wait(0.6)
    for i = 0, 30 do
        local t = i/30
        IBg.BackgroundTransparency = t
        LogoFrame.BackgroundTransparency = t
        LogoStroke.Transparency = t
        IntroLogoImg.ImageTransparency = t
        RingStroke.Transparency = t + 0.5
        ITitle.TextTransparency = t
        ITitleStroke.Transparency = t
        ISub.TextTransparency = t
        BarBg.BackgroundTransparency = t
        BarFill.BackgroundTransparency = t
        BarGlow.Transparency = t
        PercentLabel.TextTransparency = t
        StatusLabel.TextTransparency = t
        BgGlow.BackgroundTransparency = 1
        BgGlow2.BackgroundTransparency = 1
        task.wait(0.03)
    end
    IG:Destroy()
end)

task.spawn(function()
    local t = 0
    while IG and IG.Parent do
        task.wait(0.03)
        t = t + 0.1
        pcall(function() IntroLogoImg.Rotation = (IntroLogoImg.Rotation + 4) % 360 end)
        pcall(function() Ring.Rotation = (Ring.Rotation - 3) % 360 end)
        pcall(function() LogoStroke.Transparency = math.sin(t) * 0.3 + 0.3 end)
        pcall(function() BgGlow.BackgroundTransparency = 0.85 + math.sin(t) * 0.1 end)
        pcall(function() BgGlow2.BackgroundTransparency = 0.75 + math.sin(t * 1.5) * 0.15 end)
    end
end)

RunService.Heartbeat:Connect(function()
    local c = LP.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    if Config.Hit and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
end)

local LastTarget = nil
local LastTargetTime = 0

local function IsVisible(targetPart)
    if not AimVisibleOnly then return true end
    local origin = Camera.CFrame.Position
    local dir = (targetPart.Position - origin)
    local ray = Ray.new(origin, dir)
    local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {LP.Character, targetPart.Parent})
    return hit == nil
end

local function GetTarget()
    local best, bestScore = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    if LastTarget and LastTarget.Parent and tick() - LastTargetTime < 0.1 then
        local hum = LastTarget.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            return {part = LastTarget, pos = LastTarget.Position, plr = Players:GetPlayerFromCharacter(LastTarget.Parent)}
        end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local part = plr.Character:FindFirstChild(AimPart) or plr.Character:FindFirstChild("HumanoidRootPart")
                if part and IsVisible(part) then
                    local targetPos = part.Position
                    if Config.Prediction then
                        local ping = 0.1
                        pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000 end)
                        targetPos = targetPos + (part.Velocity * (PredictionAmount + ping))
                    end
                    local pos, onScreen = Camera:WorldToViewportPoint(targetPos)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist <= FOVSize then
                            local score = AimMode == "Lowest HP" and hum.Health or dist
                            if score < bestScore then
                                bestScore = score
                                best = {part = part, pos = targetPos, plr = plr}
                            end
                        end
                    end
                end
            end
        end
    end
    if best then LastTarget = best.part LastTargetTime = tick() end
    return best
end

task.spawn(function()
    while true do
        task.wait(0.01)
        if Config.Aimbot then
            local t = GetTarget()
            if t and t.pos then
                local goal = CFrame.new(Camera.CFrame.Position, t.pos)
                if Config.AimSmoothToggle then
                    Camera.CFrame = Camera.CFrame:Lerp(goal, AimSmooth)
                else
                    Camera.CFrame = Camera.CFrame:Lerp(goal, 0.5)
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.05)
        if Config.AutoShoot or Config.Triggerbot then
            local t = GetTarget()
            if t then
                pcall(function() game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0)) end)
            end
        end
    end
end)

local okDraw, FOVCircle = pcall(function() return Drawing.new("Circle") end)
if okDraw and FOVCircle then
    FOVCircle.Thickness = 1
    FOVCircle.Color = Color3.fromRGB(180, 100, 255)
    FOVCircle.Filled = false
    FOVCircle.Transparency = 0.5
    FOVCircle.Visible = false
    RunService.RenderStepped:Connect(function()
        if Config.FOVCircle then
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            FOVCircle.Radius = FOVSize
            FOVCircle.Visible = true
        else
            FOVCircle.Visible = false
        end
    end)
end

local ESPObjs = {}
if okDraw then
    local function CreateESP(plr)
        if not plr.Character or ESPObjs[plr] then return end
        local ok1, box = pcall(function() return Drawing.new("Square") end)
        if not ok1 then return end
        box.Thickness = 1
        box.Filled = false
        box.Visible = false
        ESPObjs[plr] = box
    end
    RunService.RenderStepped:Connect(function()
        if not Config.ESP then
            for _, b in pairs(ESPObjs) do b.Visible = false end
            return
        end
        for plr, box in pairs(ESPObjs) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and hrp then
                    local hp, on = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,1,0))
                    local rp = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
                    if on then
                        local h = math.abs(hp.Y - rp.Y)
                        box.Size = Vector2.new(h/2, h)
                        box.Position = Vector2.new(hp.X - h/4, hp.Y)
                        box.Color = Themes[CurrentTheme]
                        box.Visible = true
                    else
                        box.Visible = false
                    end
                end
            end
        end
    end)
    Players.PlayerAdded:Connect(function(plr)
        if plr ~= LP then plr.CharacterAdded:Connect(function() task.wait(1) CreateESP(plr) end) end
    end)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then CreateESP(plr) end
    end
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if Config.Chams then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local hl = plr.Character:FindFirstChild("ZVH_Chams")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "ZVH_Chams"
                        hl.FillTransparency = 0.5
                        hl.OutlineColor = Color3.fromRGB(255,255,255)
                        hl.Parent = plr.Character
                    end
                    hl.FillColor = Themes[CurrentTheme]
                end
            end
        else
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local c = plr.Character:FindFirstChild("ZVH_Chams")
                    if c then c:Destroy() end
                end
            end
        end
    end
end)

local Tracers = {}
if okDraw then
    RunService.RenderStepped:Connect(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
                if Config.Tracers then
                    local head = plr.Character.Head
                    local pos, on = Camera:WorldToViewportPoint(head.Position)
                    if on then
                        local tracer = Tracers[plr]
                        if not tracer then
                            local ok, t = pcall(function() return Drawing.new("Line") end)
                            if ok then
                                t.Thickness = 1
                                t.Transparency = 0.7
                                tracer = t
                                Tracers[plr] = t
                            end
                        end
                        if tracer then
                            tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                            tracer.To = Vector2.new(pos.X, pos.Y)
                            tracer.Color = Themes[CurrentTheme]
                            tracer.Visible = true
                        end
                    elseif Tracers[plr] then
                        Tracers[plr].Visible = false
                    end
                elseif Tracers[plr] then
                    Tracers[plr].Visible = false
                end
            end
        end
    end)
end

local origLighting = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    FogEnd = Lighting.FogEnd
}
local bloom = Instance.new("BloomEffect")
bloom.Intensity = 0
bloom.Size = 24
bloom.Threshold = 2
bloom.Parent = Lighting

task.spawn(function()
    while true do
        task.wait(0.5)
        if Config.Fullbright then
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(255,255,255)
        else
            Lighting.Brightness = origLighting.Brightness
            Lighting.Ambient = origLighting.Ambient
        end
        if Config.NoFog then
            Lighting.FogEnd = math.huge
        else
            Lighting.FogEnd = origLighting.FogEnd
        end
        bloom.Intensity = Config.Bloom and 1 or 0
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if Config.KillAura then
            local c = LP.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local enemyHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        local enemyHum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if enemyHrp and enemyHum and enemyHum.Health > 0 then
                            if (enemyHrp.Position - hrp.Position).Magnitude <= KillAuraRange then
                                pcall(function() game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0)) end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        local c = LP.Character
        if c then
            for _, part in pairs(c:GetDescendants()) do
                if part:IsA("BasePart") then
                    if Config.Invisible then
                        part.Transparency = 1
                    elseif not Config.Invisible and part.Transparency == 1 then
                        part.Transparency = 0
                    end
                end
                if part:IsA("Decal") then part.Transparency = Config.Invisible and 1 or 0 end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if Config.AutoDodge then
            local c = LP.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local enemyHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if enemyHrp and (enemyHrp.Position - hrp.Position).Magnitude < 15 then
                            local rand = math.random(1,2)
                            hrp.CFrame = hrp.CFrame * CFrame.new(rand == 1 and 3 or -3, 0, 0)
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(5)
        if Config.ChatSpam then
            pcall(function()
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(ChatSpamText, "All")
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if Config.AutoCollect then
            local c = LP.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local name = obj.Name:lower()
                        if name:find("coin") or name:find("cash") or name:find("money") 
                           or name:find("gem") or name:find("egg") or name:find("orb") then
                            local dist = (obj.Position - hrp.Position).Magnitude
                            if dist < CollectRange and dist > 3 then
                                hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end
        end
    end
end)

local function ApplySpeed()
    local c = LP.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = Config.Speed and 100 or 16 end
    end
end
UIS.JumpRequest:Connect(function()
    if Config.Jump or Config.BunnyHop then
        local c = LP.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
    if Config.HighJump then
        local c = LP.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then h.JumpPower = 200 end
        end
    end
end)

UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == PanicKey then
        for k in pairs(Config) do Config[k] = false end
        ApplySpeed()
        SaveConfig()
        if ScreenGui then ScreenGui.Enabled = false end
        Notify("🚨 PÂNICO", "Tudo desligado!", Color3.fromRGB(255, 50, 50))
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 500
ScreenGui.IgnoreGuiInset = true
pcall(function()
    if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = game:GetService("CoreGui") end
end)
if not ScreenGui.Parent then ScreenGui.Parent = game:GetService("CoreGui") end

local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.new(0, 240, 0, 32)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.BackgroundColor3 = Color3.fromRGB(10, 5, 12)
Watermark.BackgroundTransparency = 0.3
Watermark.BorderSizePixel = 0
Watermark.Text = "⚡ ZVH HUB v" .. VERSION
Watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
Watermark.TextSize = 14
Watermark.Font = Enum.Font.SciFi
Watermark.Visible = Config.Watermark
Watermark.Parent = ScreenGui
local WMC = Instance.new("UICorner")
WMC.CornerRadius = UDim.new(0, 8)
WMC.Parent = Watermark
local WMS = Instance.new("UIStroke")
WMS.Color = Themes[CurrentTheme]
WMS.Thickness = 1.5
WMS.Parent = Watermark

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(10, 5, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = false
Main.Parent = ScreenGui
local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0, 14)
MC.Parent = Main
local MS = Instance.new("UIStroke")
MS.Color = Themes[CurrentTheme]
MS.Thickness = 1.5
MS.Transparency = 1
MS.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = Color3.fromRGB(15, 8, 18)
Header.BorderSizePixel = 0
Header.BackgroundTransparency = 1
Header.Parent = Main
local HC = Instance.new("UICorner")
HC.CornerRadius = UDim.new(0, 14)
HC.Parent = Header
local HLine = Instance.new("Frame")
HLine.Size = UDim2.new(1, 0, 0, 2)
HLine.Position = UDim2.new(0, 0, 1, -2)
HLine.BackgroundColor3 = Themes[CurrentTheme]
HLine.BorderSizePixel = 0
HLine.BackgroundTransparency = 1
HLine.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZVH HUB | " .. GameType
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SciFi
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextTransparency = 1
Title.Parent = Header

local ConfigBtn = Instance.new("TextButton")
ConfigBtn.Size = UDim2.new(0, 32, 0, 28)
ConfigBtn.Position = UDim2.new(1, -80, 0, 8)
ConfigBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
ConfigBtn.BorderSizePixel = 0
ConfigBtn.Text = "⚙"
ConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfigBtn.TextSize = 18
ConfigBtn.Font = Enum.Font.SciFi
ConfigBtn.BackgroundTransparency = 1
ConfigBtn.Parent = Header
local ConfigBtnC = Instance.new("UICorner")
ConfigBtnC.CornerRadius = UDim.new(0, 6)
ConfigBtnC.Parent = ConfigBtn

local Col1 = Instance.new("ScrollingFrame")
Col1.Size = UDim2.new(0.5, -12, 1, -110)
Col1.Position = UDim2.new(0, 6, 0, 50)
Col1.BackgroundTransparency = 1
Col1.BorderSizePixel = 0
Col1.ScrollBarThickness = 4
Col1.ScrollBarImageColor3 = Themes[CurrentTheme]
Col1.CanvasSize = UDim2.new(0, 0, 0, 600)
Col1.Parent = Main
local Col1Lay = Instance.new("UIListLayout")
Col1Lay.Padding = UDim.new(0, 5)
Col1Lay.SortOrder = Enum.SortOrder.LayoutOrder
Col1Lay.Parent = Col1

local Col2 = Instance.new("ScrollingFrame")
Col2.Size = UDim2.new(0.5, -12, 1, -110)
Col2.Position = UDim2.new(0.5, 6, 0, 50)
Col2.BackgroundTransparency = 1
Col2.BorderSizePixel = 0
Col2.ScrollBarThickness = 4
Col2.ScrollBarImageColor3 = Themes[CurrentTheme]
Col2.CanvasSize = UDim2.new(0, 0, 0, 600)
Col2.Parent = Main
local Col2Lay = Instance.new("UIListLayout")
Col2Lay.Padding = UDim.new(0, 5)
Col2Lay.SortOrder = Enum.SortOrder.LayoutOrder
Col2Lay.Parent = Col2

local ConfigTab = Instance.new("ScrollingFrame")
ConfigTab.Size = UDim2.new(1, -12, 1, -54)
ConfigTab.Position = UDim2.new(0, 6, 0, 50)
ConfigTab.BackgroundTransparency = 1
ConfigTab.BorderSizePixel = 0
ConfigTab.ScrollBarThickness = 4
ConfigTab.ScrollBarImageColor3 = Themes[CurrentTheme]
ConfigTab.CanvasSize = UDim2.new(0, 0, 0, 800)
ConfigTab.Visible = false
ConfigTab.Parent = Main
local ConfigLay = Instance.new("UIListLayout")
ConfigLay.Padding = UDim.new(0, 5)
ConfigLay.SortOrder = Enum.SortOrder.LayoutOrder
ConfigLay.Parent = ConfigTab

ConfigBtn.MouseButton1Click:Connect(function()
    PlayClick()
    Col1.Visible = not Col1.Visible
    Col2.Visible = not Col2.Visible
    ConfigTab.Visible = not ConfigTab.Visible
end)

local function Btn(parent, t, o, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -6, 0, 36)
    b.BackgroundColor3 = Color3.fromRGB(90, 40, 130)
    b.BorderSizePixel = 0
    b.Text = t
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 11
    b.Font = Enum.Font.SciFi
    b.LayoutOrder = o
    b.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = b
    local s = Instance.new("UIStroke")
    s.Color = Themes[CurrentTheme]
    s.Thickness = 1
    s.Transparency = 0.3
    s.Parent = b
    local a = false
    b.MouseEnter:Connect(function() PlayHover() end)
    b.MouseButton1Click:Connect(function()
        a = not a
        PlayToggle()
        if a then
            b.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            b.Text = t .. " ✓"
        else
            b.BackgroundColor3 = Color3.fromRGB(90, 40, 130)
            b.Text = t
        end
        cb(a)
        SaveConfig()
    end)
end

Btn(Col1, "🎯 AIMBOT", 1, function(s) Config.Aimbot = s end)
Btn(Col1, "🎯 PREDIÇÃO", 2, function(s) Config.Prediction = s end)
Btn(Col1, "🎯 AIM SMOOTH", 3, function(s) Config.AimSmoothToggle = s end)
Btn(Col1, "🔫 AUTO SHOOT", 4, function(s) Config.AutoShoot = s end)
Btn(Col1, "🎯 TRIGGERBOT", 5, function(s) Config.Triggerbot = s end)
Btn(Col1, "🧱 WALL BANG", 6, function(s) Config.WallBang = s end)
Btn(Col1, "💀 KILL AURA", 7, function(s) Config.KillAura = s end)
Btn(Col1, "🏃 AUTO DODGE", 8, function(s) Config.AutoDodge = s end)
Btn(Col1, "🎯 FOV CIRCLE", 9, function(s) Config.FOVCircle = s end)
Btn(Col1, "👁️ ESP", 10, function(s) Config.ESP = s end)
Btn(Col1, "🎨 CHAMS", 11, function(s) Config.Chams = s end)
Btn(Col1, "📏 TRACERS", 12, function(s) Config.Tracers = s end)

Btn(Col2, "💡 FULLBRIGHT", 1, function(s) Config.Fullbright = s end)
Btn(Col2, "🌫️ NO FOG", 2, function(s) Config.NoFog = s end)
Btn(Col2, "✨ BLOOM", 3, function(s) Config.Bloom = s end)
Btn(Col2, "👻 INVISIBLE", 4, function(s) Config.Invisible = s end)
Btn(Col2, "🏃 SPEED", 5, function(s) Config.Speed = s ApplySpeed() end)
Btn(Col2, "🦘 INF JUMP", 6, function(s) Config.Jump = s end)
Btn(Col2, "🐰 BUNNY HOP", 7, function(s) Config.BunnyHop = s end)
Btn(Col2, "⬆️ HIGH JUMP", 8, function(s) Config.HighJump = s end)
Btn(Col2, "🛡️ ANTI-HIT", 9, function(s) Config.Hit = s end)
Btn(Col2, "🎁 AUTO COLLECT", 10, function(s) Config.AutoCollect = s end)
Btn(Col2, "💬 CHAT SPAM", 11, function(s) Config.ChatSpam = s end)

local BottomFrame = Instance.new("Frame")
BottomFrame.Size = UDim2.new(1, -12, 0, 100)
BottomFrame.Position = UDim2.new(0, 6, 1, -106)
BottomFrame.BackgroundColor3 = Color3.fromRGB(15, 8, 18)
BottomFrame.BorderSizePixel = 0
BottomFrame.Parent = Main
local BFC = Instance.new("UICorner")
BFC.CornerRadius = UDim.new(0, 10)
BFC.Parent = BottomFrame
local BFS = Instance.new("UIStroke")
BFS.Color = Themes[CurrentTheme]
BFS.Thickness = 1
BFS.Transparency = 0.5
BFS.Parent = BottomFrame

local SmoothLabel = Instance.new("TextLabel")
SmoothLabel.Size = UDim2.new(1, -10, 0, 18)
SmoothLabel.Position = UDim2.new(0, 5, 0, 5)
SmoothLabel.BackgroundTransparency = 1
SmoothLabel.Text = "🎯 Velocidade Mira: 25%"
SmoothLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SmoothLabel.TextSize = 11
SmoothLabel.Font = Enum.Font.SciFi
SmoothLabel.TextXAlignment = Enum.TextXAlignment.Left
SmoothLabel.Parent = BottomFrame

local SmoothSlider = Instance.new("TextButton")
SmoothSlider.Size = UDim2.new(1, -10, 0, 20)
SmoothSlider.Position = UDim2.new(0, 5, 0, 25)
SmoothSlider.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
SmoothSlider.BorderSizePixel = 0
SmoothSlider.Text = ""
SmoothSlider.Parent = BottomFrame
local SmoothSliderC = Instance.new("UICorner")
SmoothSliderC.CornerRadius = UDim.new(0, 6)
SmoothSliderC.Parent = SmoothSlider
local SmoothFill = Instance.new("Frame")
SmoothFill.Size = UDim2.new(0.25, 0, 1, 0)
SmoothFill.BackgroundColor3 = Themes[CurrentTheme]
SmoothFill.BorderSizePixel = 0
SmoothFill.Parent = SmoothSlider
local SmoothFillC = Instance.new("UICorner")
SmoothFillC.CornerRadius = UDim.new(0, 6)
SmoothFillC.Parent = SmoothFill

SmoothSlider.MouseButton1Down:Connect(function()
    local conn
    conn = RunService.RenderStepped:Connect(function()
        local m = UIS:GetMouseLocation()
        local rx = math.clamp((m.X - SmoothSlider.AbsolutePosition.X) / SmoothSlider.AbsoluteSize.X, 0, 1)
        local val = math.floor(rx * 100) / 100
        if val < 0.01 then val = 0.01 end
        AimSmooth = val
        SmoothFill.Size = UDim2.new(rx, 0, 1, 0)
        SmoothLabel.Text = "🎯 Velocidade Mira: " .. math.floor(val * 100) .. "%"
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if conn then conn:Disconnect() end
        end
    end)
end)

local AimModeBtn = Instance.new("TextButton")
AimModeBtn.Size = UDim2.new(0.5, -8, 0, 30)
AimModeBtn.Position = UDim2.new(0, 5, 0, 50)
AimModeBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
AimModeBtn.BorderSizePixel = 0
AimModeBtn.Text = "🎯 Modo: Próximo"
AimModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimModeBtn.TextSize = 10
AimModeBtn.Font = Enum.Font.SciFi
AimModeBtn.Parent = BottomFrame
local AimModeBtnC = Instance.new("UICorner")
AimModeBtnC.CornerRadius = UDim.new(0, 6)
AimModeBtnC.Parent = AimModeBtn

AimModeBtn.MouseButton1Click:Connect(function()
    PlayClick()
    if AimMode == "Closest" then
        AimMode = "Lowest HP"
        AimModeBtn.Text = "🎯 Modo: Menos Vida"
    else
        AimMode = "Closest"
        AimModeBtn.Text = "🎯 Modo: Próximo"
    end
end)

local VisibleBtn = Instance.new("TextButton")
VisibleBtn.Size = UDim2.new(0.5, -8, 0, 30)
VisibleBtn.Position = UDim2.new(0.5, 3, 0, 50)
VisibleBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
VisibleBtn.BorderSizePixel = 0
VisibleBtn.Text = "👁️ Só Visível: OFF"
VisibleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VisibleBtn.TextSize = 10
VisibleBtn.Font = Enum.Font.SciFi
VisibleBtn.Parent = BottomFrame
local VisibleBtnC = Instance.new("UICorner")
VisibleBtnC.CornerRadius = UDim.new(0, 6)
VisibleBtnC.Parent = VisibleBtn

VisibleBtn.MouseButton1Click:Connect(function()
    PlayClick()
    AimVisibleOnly = not AimVisibleOnly
    if AimVisibleOnly then
        VisibleBtn.Text = "👁️ Só Visível: ON"
        VisibleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    else
        VisibleBtn.Text = "👁️ Só Visível: OFF"
        VisibleBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
    end
end)

local function ConfigBtnFunc(parent, text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 12
    b.Font = Enum.Font.SciFi
    b.Parent = parent
    b.LayoutOrder = #parent:GetChildren()
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    b.MouseButton1Click:Connect(function()
        PlayClick()
        cb()
    end)
end

ConfigBtnFunc(ConfigTab, "📝 Watermark ON/OFF", function()
    Config.Watermark = not Config.Watermark
    Watermark.Visible = Config.Watermark
end)
ConfigBtnFunc(ConfigTab, "🌈 RGB MODE", function() RGBMode = not RGBMode end)
ConfigBtnFunc(ConfigTab, "🌈 RGB LOGO", function() RGBLogo = not RGBLogo end)
ConfigBtnFunc(ConfigTab, "🎨 TEMA ANIMADO", function() AnimatedTheme = not AnimatedTheme end)
ConfigBtnFunc(ConfigTab, "📱 Mobile Extra", function()
    MobileExtra = not MobileExtra
    Main.Size = MobileExtra and UDim2.new(0, 700, 0, 450) or UDim2.new(0, 620, 0, 400)
end)
ConfigBtnFunc(ConfigTab, "🎮 Mudar Tecla Pânico", function()
    Notify("🎮 KEYBIND", "Aperte uma tecla...", Color3.fromRGB(255, 200, 0))
    local conn
    conn = UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            PanicKey = input.KeyCode
            Notify("🎮 KEYBIND", "Nova tecla: " .. input.KeyCode.Name, Themes[CurrentTheme])
            conn:Disconnect()
        end
    end)
end)
ConfigBtnFunc(ConfigTab, "💾 Salvar Config", function()
    SaveConfig()
    Notify("💾 CONFIG", "Salvo!", Color3.fromRGB(0, 255, 100))
end)
ConfigBtnFunc(ConfigTab, "⚔️ Preset PvP", function()
    ApplyPreset("PvP")
    Notify("⚔️ PVP", "Aplicado!", Color3.fromRGB(255, 50, 50))
end)
ConfigBtnFunc(ConfigTab, "🌾 Preset Farm", function()
    ApplyPreset("Farm")
    Notify("🌾 FARM", "Aplicado!", Color3.fromRGB(50, 255, 100))
end)
ConfigBtnFunc(ConfigTab, "🕵️ Preset Discreto", function()
    ApplyPreset("Discreto")
    Notify("🕵️ DISCRETO", "Aplicado!", Color3.fromRGB(200, 200, 200))
end)

task.spawn(function()
    local h = 0
    while true do
        task.wait(0.05)
        if RGBMode or AnimatedTheme then
            h = (h + 0.005) % 1
            local c = Color3.fromHSV(h, 0.7, 1)
            pcall(function() MS.Color = c end)
            pcall(function() HLine.BackgroundColor3 = c end)
            pcall(function() Title.TextColor3 = c end)
            pcall(function() WMS.Color = c end)
            pcall(function() ConfigBtn.BackgroundColor3 = c end)
            if okDraw and FOVCircle then FOVCircle.Color = c end
            for _, btn in pairs(Col1:GetChildren()) do
                if btn:IsA("TextButton") then btn.TextColor3 = c end
            end
            for _, btn in pairs(Col2:GetChildren()) do
                if btn:IsA("TextButton") then btn.TextColor3 = c end
            end
            for _, btn in pairs(ConfigTab:GetChildren()) do
                if btn:IsA("TextButton") then btn.TextColor3 = c end
            end
        end
    end
end)

local IsOpen = false
local Opening = false

local FlashGui = Instance.new("ScreenGui")
FlashGui.ResetOnSpawn = false
FlashGui.DisplayOrder = 2000
pcall(function()
    if gethui then FlashGui.Parent = gethui() else FlashGui.Parent = game:GetService("CoreGui") end
end)
if not FlashGui.Parent then FlashGui.Parent = game:GetService("CoreGui") end

local FlashFrame = Instance.new("Frame")
FlashFrame.Size = UDim2.new(1, 0, 1, 0)
FlashFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FlashFrame.BackgroundTransparency = 1
FlashFrame.BorderSizePixel = 0
FlashFrame.Parent = FlashGui

local function OpenPanel()
    if Opening then return end
    Opening = true
    PlayOpen()
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundTransparency = 1
    MS.Transparency = 1
    Header.BackgroundTransparency = 1
    HLine.BackgroundTransparency = 1
    Col1.Visible = false
    Col2.Visible = false
    BottomFrame.Visible = false
    Title.TextTransparency = 1
    ConfigBtn.BackgroundTransparency = 1
    FlashFrame.BackgroundTransparency = 0.5
    task.wait(0.05)
    for i = 0, 10 do
        FlashFrame.BackgroundTransparency = 0.5 + (i/10) * 0.5
        task.wait(0.02)
    end
    FlashFrame.BackgroundTransparency = 1
    task.spawn(function()
        for i = 1, 20 do
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0, 6, 0, 6)
            particle.Position = UDim2.new(0.5, 0, 0.5, 0)
            particle.AnchorPoint = Vector2.new(0.5, 0.5)
            particle.BackgroundColor3 = Themes[CurrentTheme]
            particle.BorderSizePixel = 0
            particle.Parent = Main
            local pc = Instance.new("UICorner")
            pc.CornerRadius = UDim.new(1, 0)
            pc.Parent = particle
            task.spawn(function()
                local angle = math.random() * math.pi * 2
                local distance = math.random(100, 200)
                local targetX = 0.5 + math.cos(angle) * (distance / 1000)
                local targetY = 0.5 + math.sin(angle) * (distance / 1000)
                for j = 0, 30 do
                    local t = j / 30
                    particle.Position = UDim2.new(0.5 + (targetX - 0.5) * t, 0, 0.5 + (targetY - 0.5) * t, 0)
                    particle.BackgroundTransparency = t
                    particle.Size = UDim2.new(0, 6 * (1 - t), 0, 6 * (1 - t))
                    task.wait(0.02)
                end
                particle:Destroy()
            end)
        end
    end)
    task.wait(0.1)
    Main.BackgroundTransparency = 0
    MS.Transparency = 0.2
    Header.BackgroundTransparency = 0
    HLine.BackgroundTransparency = 0
    TS:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 620, 0, 400),
        Position = UDim2.new(1, -640, 0, 30),
        AnchorPoint = Vector2.new(0, 0)
    }):Play()
    task.wait(0.3)
    for i = 0, 15 do
        Title.TextTransparency = 1 - (i/15)
        ConfigBtn.BackgroundTransparency = 1 - (i/15)
        task.wait(0.02)
    end
    Col1.Visible = true
    Col2.Visible = true
    BottomFrame.Visible = true
    local function AnimateButtons(parent)
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("TextButton") then
                local originalSize = child.Size
                child.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 0)
                child.TextTransparency = 1
                task.spawn(function()
                    task.wait(math.random(1, 10) * 0.03)
                    TS:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize}):Play()
                    for i = 0, 10 do
                        child.TextTransparency = 1 - (i/10)
                        task.wait(0.02)
                    end
                end)
            end
        end
    end
    AnimateButtons(Col1)
    AnimateButtons(Col2)
    task.spawn(function()
        for i = 1, 3 do
            TS:Create(MS, TweenInfo.new(0.3), {Transparency = 0.8}):Play()
            task.wait(0.3)
            TS:Create(MS, TweenInfo.new(0.3), {Transparency = 0.2}):Play()
            task.wait(0.3)
        end
    end)
    task.wait(0.5)
    Opening = false
    IsOpen = true
end

local function ClosePanel()
    if Opening then return end
    Opening = true
    PlayClose()
    TS:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    for i = 0, 15 do
        Main.BackgroundTransparency = (i/15)
        MS.Transparency = (i/15)
        Header.BackgroundTransparency = (i/15)
        HLine.BackgroundTransparency = (i/15)
        Title.TextTransparency = (i/15)
        ConfigBtn.BackgroundTransparency = (i/15)
        task.wait(0.02)
    end
    Main.Visible = false
    Opening = false
    IsOpen = false
end

local TB = Instance.new("TextButton")
TB.Size = UDim2.new(0, 60, 0, 60)
TB.Position = UDim2.new(1, -80, 0, 60)
TB.BackgroundColor3 = Color3.fromRGB(25, 12, 35)
TB.BorderSizePixel = 0
TB.Text = ""
TB.Parent = ScreenGui
local TC = Instance.new("UICorner")
TC.CornerRadius = UDim.new(1, 0)
TC.Parent = TB
local TS_Stroke = Instance.new("UIStroke")
TS_Stroke.Color = Themes[CurrentTheme]
TS_Stroke.Thickness = 2
TS_Stroke.Parent = TB
local TI = Instance.new("ImageLabel")
TI.Size = UDim2.new(1, -6, 1, -6)
TI.Position = UDim2.new(0, 3, 0, 3)
TI.BackgroundTransparency = 1
TI.Image = LOGO_OLD
TI.Parent = TB
local TIC = Instance.new("UICorner")
TIC.CornerRadius = UDim.new(1, 0)
TIC.Parent = TI

task.spawn(function()
    local h = 0
    while true do
        task.wait(0.05)
        if RGBLogo then
            h = (h + 0.005) % 1
            local c = Color3.fromHSV(h, 0.7, 1)
            pcall(function() TI.ImageColor3 = c end)
            pcall(function() TS_Stroke.Color = c end)
        else
            pcall(function() TI.ImageColor3 = Color3.fromRGB(255, 255, 255) end)
            pcall(function() TS_Stroke.Color = Themes[CurrentTheme] end)
        end
    end
end)

task.spawn(function()
    local t = 0
    while true do
        task.wait(0.03)
        t = t + 0.1
        pcall(function() TI.Rotation = (TI.Rotation + 5) % 360 end)
        local pulse = 1 + math.sin(t) * 0.05
        pcall(function() TB.Size = UDim2.new(0, 60 * pulse, 0, 60 * pulse) end)
    end
end)

local OriginalSize = UDim2.new(0, 60, 0, 60)
local PressedSize = UDim2.new(0, 48, 0, 48)

TB.MouseButton1Down:Connect(function()
    TS:Create(TB, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = PressedSize}):Play()
    TS:Create(TB, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(60, 30, 90)}):Play()
    PlayClick()
end)

TB.MouseButton1Up:Connect(function()
    TS:Create(TB, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = OriginalSize}):Play()
    TS:Create(TB, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 12, 35)}):Play()
end)

TB.MouseButton1Click:Connect(function()
    if IsOpen then ClosePanel() else OpenPanel() end
end)

LP.CharacterAdded:Connect(function() task.wait(1) ApplySpeed() end)

task.wait(9)
Notify("✅ ZVH HUB ULTRA", "v" .. VERSION .. " carregado!", Color3.fromRGB(0, 255, 100))
