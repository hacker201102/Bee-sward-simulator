-- LocalScript dans StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

-- 50 Animations / Danses
local danceAnimations = {
    -- 🎮 DANSES OFFICIELLES
    ["Dance 1"]        = "507771019",
    ["Dance 2"]        = "507776043",
    ["Dance 3"]        = "507777268",

    -- 😂 EMOTES OFFICIELS
    ["Wave"]           = "507770239",
    ["Point"]          = "507770453",
    ["Cheer"]          = "507770677",
    ["Laugh"]          = "507770818",
    ["Salute"]         = "3360686468",

    -- 🕺 DANSES STYLÉES
    ["Moonwalk"]       = "30196114",
    ["Stanky Legs"]    = "87986341",
    ["Happi Dance"]    = "248335946",
    ["Partyanimate"]   = "33796059",
    ["Old Dance"]      = "27789359",

    -- 😱 EXPRESSIONS
    ["Scared"]         = "180612465",
    ["Scream"]         = "180611870",
    ["Lay Down"]       = "182749109",
    ["Take a Dunk"]    = "182724289",
    ["Crouch"]         = "287325678",

    -- 🎯 POSES
    ["Pose It"]        = "248336163",
    ["Tilt Head"]      = "283545583",
    ["Look"]           = "283119655",
    ["Lay Better"]     = "282574440",
    ["Weird Pose"]     = "248336677",
    ["No Legs"]        = "248336459",

    -- ⚔️ ACTIONS
    ["Roar"]           = "75354915",
    ["Taunt"]          = "74901237",
    ["Slap"]           = "273717479",
    ["Barrel Roll"]    = "136801964",
    ["Bear Hug"]       = "27432686",
    ["Upper Cut"]      = "28160593",
    ["Fire Breath"]    = "163209885",

    -- 🏃 MOUVEMENTS
    ["Smelly Run"]     = "30235165",
    ["Soccer Walk"]    = "28440069",
    ["Walk Staff"]     = "27759788",

    -- 🎪 SPÉCIALES
    ["Floating Head"]  = "121572214",
    ["Balloon Float"]  = "148831003",
    ["Beatbox"]        = "45504977",
    ["Keyframe Loop"]  = "54144120",
    ["Goal"]           = "28488254",
    ["Cymbal Slam"]    = "162250536",

    -- 🌊 ANIMATIONS SYMPAS
    ["Frisbee Throw"]  = "174347769",
    ["Head Throw"]     = "35154961",
    ["Plunger Throw"]  = "259438880",
    ["Mace Swing"]     = "168801331",
    ["Staff Spin"]     = "27763939",
    ["Grenade Loop"]   = "168160500",

    -- 🎶 BONUS
    ["Sit 2"]          = "168138731",
    ["Hold Dat"]       = "161268368",
    ["Hold Dat 2"]     = "225975820",
    ["Start Rest"]     = "75416338",
}

-- GUI simple pour afficher les danses
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DanceMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local frame = Instance.new("ScrollingFrame")
frame.Size = UDim2.new(0, 250, 0, 400)
frame.Position = UDim2.new(0, 10, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.ScrollBarThickness = 4
frame.CanvasSize = UDim2.new(0, 0, 0, #danceAnimations * 45)
frame.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 4)
layout.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingAll = UDim.new(0, 6)
padding.Parent = frame

local currentAnim = nil
local isDancing = false

local function stopDance()
    if currentAnim then
        currentAnim:Stop()
        currentAnim = nil
        isDancing = false
    end
end

local function playDance(id, btn)
    stopDance()
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. id
    currentAnim = animator:LoadAnimation(animation)
    currentAnim.Priority = Enum.AnimationPriority.Action
    currentAnim.Looped = true
    currentAnim:Play()
    isDancing = true
end

local i = 0
for name, id in pairs(danceAnimations) do
    i = i + 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Text = "🕺 " .. name
    btn.LayoutOrder = i
    btn.BorderSizePixel = 0
    btn.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        playDance(id, btn)
        btn.BackgroundColor3 = Color3.fromRGB(120, 60, 200)
    end)
end

-- Touche X pour arrêter
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.X then
        stopDance()
    end
end)

humanoid.Running:Connect(function(speed)
    if speed > 0 and isDancing then stopDance() end
end)
