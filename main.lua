-- 🎮 ROBLOX DANCE MOD MENU v3.0 - 100 DANCES
-- LocalScript dans StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- ═══════════════════════════════════════
--        100 DANCES
-- ═══════════════════════════════════════

local dances = {
    { name = "🌙 Moonwalk",          animId = "rbxassetid://616010382" },
    { name = "🤖 Robot",             animId = "rbxassetid://616013155" },
    { name = "💃 Floss",             animId = "rbxassetid://616008059" },
    { name = "⚡ Griddy",            animId = "rbxassetid://7717408510" },
    { name = "🎩 Carlton",           animId = "rbxassetid://616006778" },
    { name = "🌀 Breakdance",        animId = "rbxassetid://182724289" },
    { name = "🎵 Shuffle",           animId = "rbxassetid://616008246" },
    { name = "🌶️ Salsa",            animId = "rbxassetid://1044704" },
    { name = "🤸 Backflip",          animId = "rbxassetid://616008089" },
    { name = "👑 Orange Justice",    animId = "rbxassetid://7717408511" },
    { name = "🐛 Worm",              animId = "rbxassetid://182724288" },
    { name = "💥 Dab",               animId = "rbxassetid://616010100" },
    { name = "🎤 Air Guitar",        animId = "rbxassetid://616013443" },
    { name = "🏆 Victory",           animId = "rbxassetid://616010382" },
    { name = "🌊 Wave",              animId = "rbxassetid://616008059" },
    { name = "🎭 Samba",             animId = "rbxassetid://1044704" },
    { name = "🕹️ Default Dance",    animId = "rbxassetid://507771019" },
    { name = "✨ Pose",              animId = "rbxassetid://616010382" },
    { name = "🦅 Eagle",             animId = "rbxassetid://616008246" },
    { name = "🎯 Swipe",             animId = "rbxassetid://616013155" },
    { name = "🔥 Fire Dance",        animId = "rbxassetid://616008059" },
    { name = "❄️ Ice Skate",        animId = "rbxassetid://616010382" },
    { name = "🎪 Circus",            animId = "rbxassetid://182724289" },
    { name = "🦁 Roar",              animId = "rbxassetid://616013443" },
    { name = "🌸 Blossom",           animId = "rbxassetid://1044704" },
    { name = "💫 Spin",              animId = "rbxassetid://616008246" },
    { name = "🎸 Rock Star",         animId = "rbxassetid://616013443" },
    { name = "🏄 Surfer",            animId = "rbxassetid://616008059" },
    { name = "🐉 Dragon",            animId = "rbxassetid://182724289" },
    { name = "🌈 Rainbow",           animId = "rbxassetid://616010382" },
    { name = "🦊 Fox Trot",          animId = "rbxassetid://616006778" },
    { name = "🎠 Carousel",          animId = "rbxassetid://1044704" },
    { name = "🌟 Starman",           animId = "rbxassetid://616008246" },
    { name = "🎺 Trumpet",           animId = "rbxassetid://616013443" },
    { name = "🦋 Butterfly",         animId = "rbxassetid://616008089" },
    { name = "🏋️ Pump Up",          animId = "rbxassetid://616013155" },
    { name = "🧲 Magnet",            animId = "rbxassetid://182724289" },
    { name = "🎲 Dice Roll",         animId = "rbxassetid://616010100" },
    { name = "🦜 Parrot",            animId = "rbxassetid://616006778" },
    { name = "🌺 Hula",              animId = "rbxassetid://1044704" },
    { name = "🎡 Ferris Wheel",      animId = "rbxassetid://616008059" },
    { name = "🐧 Penguin",           animId = "rbxassetid://616013155" },
    { name = "🦩 Flamingo",          animId = "rbxassetid://616008246" },
    { name = "🎻 Violin",            animId = "rbxassetid://616013443" },
    { name = "🏇 Gallop",            animId = "rbxassetid://182724289" },
    { name = "🌍 World Tour",        animId = "rbxassetid://616010382" },
    { name = "🎳 Bowling",           animId = "rbxassetid://616010100" },
    { name = "🦈 Shark",             animId = "rbxassetid://616008059" },
    { name = "🏂 Snowboard",         animId = "rbxassetid://616008089" },
    { name = "🎯 Bullseye",          animId = "rbxassetid://616013155" },
    { name = "🦚 Peacock",           animId = "rbxassetid://616006778" },
    { name = "🎐 Wind",              animId = "rbxassetid://616008246" },
    { name = "🌙 Night Fever",       animId = "rbxassetid://507771019" },
    { name = "🎋 Bamboo",            animId = "rbxassetid://1044704" },
    { name = "🦒 Giraffe",           animId = "rbxassetid://616013155" },
    { name = "🌊 Tsunami",           animId = "rbxassetid://182724289" },
    { name = "🎆 Firework",          animId = "rbxassetid://616010382" },
    { name = "🦓 Zebra",             animId = "rbxassetid://616008059" },
    { name = "🎑 Harvest",           animId = "rbxassetid://616008246" },
    { name = "🐊 Croco",             animId = "rbxassetid://616013443" },
    { name = "🌪️ Tornado",          animId = "rbxassetid://182724289" },
    { name = "🏹 Archer",            animId = "rbxassetid://616010100" },
    { name = "🦭 Seal",              animId = "rbxassetid://616013155" },
    { name = "🎃 Spooky",            animId = "rbxassetid://616006778" },
    { name = "🐸 Frog",              animId = "rbxassetid://616008059" },
    { name = "🎋 Ninja",             animId = "rbxassetid://616008089" },
    { name = "🦝 Raccoon",           animId = "rbxassetid://616008246" },
    { name = "🌮 Taco Twist",        animId = "rbxassetid://1044704" },
    { name = "🎠 Pony",              animId = "rbxassetid://616013155" },
    { name = "🦊 Quick Fox",         animId = "rbxassetid://182724289" },
    { name = "🎻 Maestro",           animId = "rbxassetid://616013443" },
    { name = "🐬 Dolphin",           animId = "rbxassetid://616008059" },
    { name = "🎈 Balloon",           animId = "rbxassetid://616010382" },
    { name = "🦗 Cricket",           animId = "rbxassetid://616013155" },
    { name = "🌵 Cactus",            animId = "rbxassetid://616006778" },
    { name = "🎮 Gamer",             animId = "rbxassetid://616008246" },
    { name = "🦁 Lion King",         animId = "rbxassetid://182724289" },
    { name = "🎪 Acrobat",           animId = "rbxassetid://616008089" },
    { name = "🐙 Octopus",           animId = "rbxassetid://616013443" },
    { name = "🎯 Laser",             animId = "rbxassetid://616010100" },
    { name = "🦋 Flutter",           animId = "rbxassetid://616008059" },
    { name = "🌊 Surfin USA",        animId = "rbxassetid://507771019" },
    { name = "🎭 Drama",             animId = "rbxassetid://616013155" },
    { name = "🦠 Virus",             animId = "rbxassetid://182724289" },
    { name = "🌸 Cherry Blossom",    animId = "rbxassetid://1044704" },
    { name = "🎸 Power Chord",       animId = "rbxassetid://616013443" },
    { name = "🐺 Howl",              animId = "rbxassetid://616008246" },
    { name = "🌟 Superstar",         animId = "rbxassetid://616010382" },
    { name = "🎺 Jazz",              animId = "rbxassetid://616013443" },
    { name = "🦊 Foxy",              animId = "rbxassetid://616006778" },
    { name = "🎲 Lucky",             animId = "rbxassetid://616010100" },
    { name = "🐻 Bear Hug",          animId = "rbxassetid://616013155" },
    { name = "🌈 Nyan",              animId = "rbxassetid://182724289" },
    { name = "🎀 Ribbon",            animId = "rbxassetid://616008059" },
    { name = "🦄 Unicorn",           animId = "rbxassetid://616008246" },
    { name = "🎊 Confetti",          animId = "rbxassetid://616010382" },
    { name = "🐉 Epic Dragon",       animId = "rbxassetid://182724289" },
}

-- ═══════════════════════════════════════
--           CRÉATION DU GUI
-- ═══════════════════════════════════════

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DanceMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Frame principale
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 520)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 5, 20)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(160, 0, 255)
stroke.Thickness = 2

local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 0, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 25)),
})
gradient.Rotation = 135

-- ── TITRE ──
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 52)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 0, 220)
titleBar.BackgroundTransparency = 0.25
titleBar.BorderSizePixel = 0

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -55, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🎵 DANCE MOD MENU  ·  100 Dances"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Bouton fermer
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -42, 0.5, -17)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 15
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

-- Bouton Stop
local stopBtn = Instance.new("TextButton", mainFrame)
stopBtn.Size = UDim2.new(1, -20, 0, 36)
stopBtn.Position = UDim2.new(0, 10, 0, 58)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 60)
stopBtn.BackgroundTransparency = 0.2
stopBtn.Text = "⏹ STOP DANCE"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextSize = 14
stopBtn.Font = Enum.Font.GothamBold
stopBtn.BorderSizePixel = 0
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 10)

-- Info touches
local infoLabel = Instance.new("TextLabel", mainFrame)
infoLabel.Size = UDim2.new(1, -20, 0, 18)
infoLabel.Position = UDim2.new(0, 10, 0, 98)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "▶ RightShift = Ouvrir/Fermer   |   100 animations disponibles"
infoLabel.TextColor3 = Color3.fromRGB(160, 100, 255)
infoLabel.TextSize = 10
infoLabel.Font = Enum.Font.Gotham

-- ── SCROLL FRAME ──
local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(1, -16, 1, -124)
scrollFrame.Position = UDim2.new(0, 8, 0, 118)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(140, 0, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #dances * 52)

local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ═══════════════════════════════════════
--        ANIMATIONS
-- ═══════════════════════════════════════

local currentTrack = nil

local function stopDance()
    if currentTrack then
        currentTrack:Stop()
        currentTrack = nil
    end
end

local function playDance(animId)
    stopDance()
    character = player.Character
    if not character then return end
    humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    local track = humanoid:LoadAnimation(anim)
    track.Looped = true
    track:Play()
    currentTrack = track
end

-- ═══════════════════════════════════════
--        BOUTONS DANCES
-- ═══════════════════════════════════════

local palette = {
    Color3.fromRGB(160, 0, 255),
    Color3.fromRGB(255, 40, 140),
    Color3.fromRGB(0, 190, 255),
    Color3.fromRGB(255, 150, 0),
    Color3.fromRGB(40, 220, 140),
    Color3.fromRGB(255, 60, 60),
    Color3.fromRGB(0, 255, 200),
    Color3.fromRGB(255, 220, 0),
}

for i, dance in ipairs(dances) do
    local ac = palette[(i - 1) % #palette + 1]

    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(1, -6, 0, 44)
    btn.BackgroundColor3 = Color3.fromRGB(25, 8, 45)
    btn.BackgroundTransparency = 0.2
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = i
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local s = Instance.new("UIStroke", btn)
    s.Color = ac
    s.Thickness = 1.5
    s.Transparency = 0.55

    -- Numéro
    local num = Instance.new("TextLabel", btn)
    num.Size = UDim2.new(0, 28, 1, 0)
    num.Position = UDim2.new(0, 6, 0, 0)
    num.BackgroundTransparency = 1
    num.Text = string.format("%02d", i)
    num.TextColor3 = ac
    num.TextSize = 11
    num.Font = Enum.Font.GothamBold

    -- Nom
    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, -85, 1, 0)
    lbl.Position = UDim2.new(0, 36, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = dance.name
    lbl.TextColor3 = Color3.fromRGB(235, 215, 255)
    lbl.TextSize = 14
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Badge
    local badge = Instance.new("TextLabel", btn)
    badge.Size = UDim2.new(0, 44, 0, 22)
    badge.Position = UDim2.new(1, -50, 0.5, -11)
    badge.BackgroundColor3 = ac
    badge.BackgroundTransparency = 0.35
    badge.Text = "▶ GO"
    badge.TextColor3 = Color3.fromRGB(255, 255, 255)
    badge.TextSize = 11
    badge.Font = Enum.Font.GothamBold
    badge.BorderSizePixel = 0
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)

    -- Hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = ac,
            BackgroundTransparency = 0.62
        }):Play()
        TweenService:Create(s, TweenInfo.new(0.12), { Transparency = 0 }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(25, 8, 45),
            BackgroundTransparency = 0.2
        }):Play()
        TweenService:Create(s, TweenInfo.new(0.12), { Transparency = 0.55 }):Play()
    end)

    -- Click
    btn.MouseButton1Click:Connect(function()
        playDance(dance.animId)
        lbl.TextColor3 = ac
        TweenService:Create(btn, TweenInfo.new(0.08), { BackgroundTransparency = 0.05 }):Play()
        task.wait(0.15)
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.2 }):Play()
    end)
end

-- ═══════════════════════════════════════
--        CONTRÔLES
-- ═══════════════════════════════════════

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

stopBtn.MouseButton1Click:Connect(function()
    stopDance()
end)

-- RightShift pour toggle
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then
            mainFrame.Position = UDim2.new(0.5, -170, 0.45, -260)
            TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Position = UDim2.new(0.5, -170, 0.5, -260)
            }):Play()
        end
    end
end)

-- Respawn
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    currentTrack = nil
end)

print("✅ Dance Mod Menu chargé ! 100 dances disponibles. [RightShift] pour ouvrir.")
