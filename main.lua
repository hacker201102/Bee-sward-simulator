-- ╔══════════════════════════════════════════════════════════╗
-- ║       NEXUS TELEPORT — Mobile 100% + Chat Avatar 🐱     ║
-- ║   LocalScript → StarterPlayer > StarterPlayerScripts    ║
-- ╚══════════════════════════════════════════════════════════╝

local Players      = game:GetService("Players")
local UserInputSvc = game:GetService("UserInputService")
local TweenSvc     = game:GetService("TweenService")
local LocalPlayer  = Players.LocalPlayer

-- ══════════════════════════════════════
--  ⚠️  REMPLACE PAR TON ASSET ID DU CHAT
--  Studio → Asset Manager → Upload Image → copie l'ID
-- ══════════════════════════════════════
local CAT_ID = "rbxassetid://TON_ID_ICI"

-- ══════════════════════════════════════
--  DÉTECTION MOBILE
-- ══════════════════════════════════════
local isMobile = UserInputSvc.TouchEnabled and not UserInputSvc.KeyboardEnabled

-- ══════════════════════════════════════
--  PALETTE
-- ══════════════════════════════════════
local C = {
	void      = Color3.fromRGB(6,   7,  14),
	deep      = Color3.fromRGB(10,  11,  22),
	glass     = Color3.fromRGB(20,  22,  45),
	glassHov  = Color3.fromRGB(28,  30,  62),
	cyan      = Color3.fromRGB(0,  220, 255),
	cyanDim   = Color3.fromRGB(0,  140, 170),
	cyanGhost = Color3.fromRGB(0,   50,  70),
	gold      = Color3.fromRGB(255, 200,  50),
	red       = Color3.fromRGB(255,  55,  90),
	green     = Color3.fromRGB(50,  230, 120),
	greenDark = Color3.fromRGB(15,   60,  35),
	white     = Color3.fromRGB(210, 230, 255),
	muted     = Color3.fromRGB(80,   95, 140),
	border    = Color3.fromRGB(30,   35,  70),
	borderHot = Color3.fromRGB(0,  180, 210),
}

-- ══════════════════════════════════════
--  TWEEN PRESETS
-- ══════════════════════════════════════
local TW = {
	snap   = TweenInfo.new(0.12, Enum.EasingStyle.Quart,  Enum.EasingDirection.Out),
	smooth = TweenInfo.new(0.22, Enum.EasingStyle.Quart,  Enum.EasingDirection.Out),
	spring = TweenInfo.new(0.45, Enum.EasingStyle.Back,   Enum.EasingDirection.Out),
	slow   = TweenInfo.new(0.55, Enum.EasingStyle.Quint,  Enum.EasingDirection.Out),
	pulse  = TweenInfo.new(1.4,  Enum.EasingStyle.Sine,   Enum.EasingDirection.InOut, -1, true),
	drift  = TweenInfo.new(2.5,  Enum.EasingStyle.Sine,   Enum.EasingDirection.InOut, -1, true),
}

-- ══════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════
local function corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 8)
	c.Parent = p
	return c
end

local function stroke(p, col, thick)
	local s = Instance.new("UIStroke")
	s.Color = col or C.border
	s.Thickness = thick or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = p
	return s
end

local function gradient(p, c0, c1, rot)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(c0, c1)
	g.Rotation = rot or 90
	g.Parent = p
	return g
end

local function tw(obj, props, info)
	TweenSvc:Create(obj, info or TW.smooth, props):Play()
end

local function newFrame(parent, props)
	local f = Instance.new("Frame")
	f.BorderSizePixel = 0
	for k, v in pairs(props) do f[k] = v end
	f.Parent = parent
	return f
end

local function newLabel(parent, props)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	for k, v in pairs(props) do l[k] = v end
	l.Parent = parent
	return l
end

local function newImage(parent, props)
	local i = Instance.new("ImageLabel")
	i.BackgroundTransparency = 1
	for k, v in pairs(props) do i[k] = v end
	i.Parent = parent
	return i
end

-- ══════════════════════════════════════
--  TAILLES ADAPTATIVES MOBILE/PC
-- ══════════════════════════════════════
local WIN_W       = isMobile and UDim2.new(0.88, 0, 0, 0)    or UDim2.new(0, 300, 0, 0)
local WIN_OPEN    = isMobile and UDim2.new(0.88, 0, 0, 480)   or UDim2.new(0, 300, 0, 460)
local WIN_POS     = isMobile and UDim2.new(0.06, 0, 0.5, -240) or UDim2.new(0, 80, 0.5, -230)
local FAB_SIZE    = isMobile and UDim2.new(0, 64, 0, 64)       or UDim2.new(0, 52, 0, 52)
local FAB_POS     = isMobile and UDim2.new(0, 18, 0.5, -32)    or UDim2.new(0, 16, 0.5, -26)
local CARD_H      = isMobile and 68                             or 58
local TITLE_SIZE  = isMobile and 22                             or 20
local BODY_SIZE   = isMobile and 15                             or 13
local SMALL_SIZE  = isMobile and 12                             or 10
local AVATAR_SIZE = isMobile and 44                             or 38
local BTN_W       = isMobile and 64                             or 52
local BTN_H       = isMobile and 36                             or 32
local HEADER_H    = isMobile and 76                             or 68
local SEARCH_H    = isMobile and 46                             or 38

-- ══════════════════════════════════════
--  ROOT GUI
-- ══════════════════════════════════════
local Gui = Instance.new("ScreenGui")
Gui.Name = "NexusTeleport"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset = true
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════════════
--  FAB BOUTON FLOTTANT
-- ══════════════════════════════════════
local fab = Instance.new("TextButton")
fab.Name        = "FAB"
fab.Size        = FAB_SIZE
fab.Position    = FAB_POS
fab.BackgroundColor3 = C.cyan
fab.Text        = ""
fab.AutoButtonColor = false
fab.ZIndex      = 20
fab.Parent      = Gui
corner(fab, isMobile and 18 or 15)

local fabIcon = newLabel(fab, {
	Size     = UDim2.new(1, 0, 1, 0),
	Text     = "⚡",
	TextSize = isMobile and 28 or 24,
	Font     = Enum.Font.GothamBold,
	TextColor3 = C.void,
	ZIndex   = 21,
})

-- Halo animé
local fabHalo = newFrame(Gui, {
	Size     = isMobile and UDim2.new(0, 86, 0, 86) or UDim2.new(0, 72, 0, 72),
	Position = isMobile and UDim2.new(0, 7, 0.5, -43) or UDim2.new(0, 6, 0.5, -36),
	BackgroundColor3 = C.cyan,
	BackgroundTransparency = 0.78,
	ZIndex   = 19,
})
corner(fabHalo, isMobile and 43 or 36)
tw(fabHalo, {
	BackgroundTransparency = 0.93,
	Size     = isMobile and UDim2.new(0, 96, 0, 96) or UDim2.new(0, 80, 0, 80),
	Position = isMobile and UDim2.new(0, 2, 0.5, -48) or UDim2.new(0, 2, 0.5, -40),
}, TW.pulse)

fab.MouseEnter:Connect(function()
	tw(fab, {BackgroundColor3 = C.white})
	tw(fabIcon, {TextColor3 = C.cyan})
end)
fab.MouseLeave:Connect(function()
	tw(fab, {BackgroundColor3 = C.cyan})
	tw(fabIcon, {TextColor3 = C.void})
end)

-- ══════════════════════════════════════
--  FENÊTRE PRINCIPALE
-- ══════════════════════════════════════
local Win = newFrame(Gui, {
	Name     = "Window",
	Size     = isMobile and UDim2.new(0.88, 0, 0, 0) or UDim2.new(0, 300, 0, 0),
	Position = WIN_POS,
	BackgroundColor3 = C.void,
	ClipsDescendants = true,
	Visible  = false,
	ZIndex   = 10,
})
corner(Win, 20)
stroke(Win, C.border, 1)

-- Fond dégradé
local winBg = newFrame(Win, {
	Size     = UDim2.new(1, 0, 1, 0),
	BackgroundColor3 = C.deep,
	ZIndex   = 10,
})
corner(winBg, 20)
gradient(winBg, C.void, Color3.fromRGB(14, 15, 30), 145)

-- Lueur déco coin haut-gauche
local glow1 = newFrame(Win, {
	Size     = UDim2.new(0, 160, 0, 160),
	Position = UDim2.new(0, -55, 0, -55),
	BackgroundColor3 = C.cyan,
	BackgroundTransparency = 0.88,
	ZIndex   = 11,
})
corner(glow1, 80)
tw(glow1, {BackgroundTransparency = 0.94}, TW.drift)

-- Lueur déco coin bas-droit
local glow2 = newFrame(Win, {
	Size     = UDim2.new(0, 120, 0, 120),
	Position = UDim2.new(1, -70, 1, -70),
	BackgroundColor3 = C.gold,
	BackgroundTransparency = 0.91,
	ZIndex   = 11,
})
corner(glow2, 60)
tw(glow2, {BackgroundTransparency = 0.96}, TW.pulse)

-- ══════════════════════════════════════
--  HEADER
-- ══════════════════════════════════════
local header = newFrame(Win, {
	Name     = "Header",
	Size     = UDim2.new(1, 0, 0, HEADER_H),
	BackgroundColor3 = C.glass,
	ZIndex   = 12,
})

local headerLine = newFrame(header, {
	Size     = UDim2.new(1, 0, 0, 2),
	Position = UDim2.new(0, 0, 1, -2),
	BackgroundColor3 = C.cyan,
	ZIndex   = 13,
})
gradient(headerLine, C.cyan, C.cyanGhost, 0)

-- Badge icône header
local badge = newFrame(header, {
	Size     = UDim2.new(0, isMobile and 46 or 40, 0, isMobile and 46 or 40),
	Position = UDim2.new(0, 14, 0.5, isMobile and -23 or -20),
	BackgroundColor3 = C.cyanGhost,
	ZIndex   = 13,
})
corner(badge, isMobile and 14 or 12)
stroke(badge, C.cyan, 1.5)

newLabel(badge, {
	Size     = UDim2.new(1, 0, 1, 0),
	Text     = "⚡",
	TextSize = isMobile and 24 or 20,
	Font     = Enum.Font.GothamBold,
	TextColor3 = C.cyan,
	ZIndex   = 14,
})

newLabel(header, {
	Size     = UDim2.new(1, -115, 0, isMobile and 28 or 26),
	Position = UDim2.new(0, isMobile and 70 or 62, 0, isMobile and 10 or 10),
	Text     = "NEXUS",
	TextSize = TITLE_SIZE,
	Font     = Enum.Font.GothamBold,
	TextColor3 = C.white,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex   = 13,
})

newLabel(header, {
	Size     = UDim2.new(1, -115, 0, 18),
	Position = UDim2.new(0, isMobile and 70 or 62, 0, isMobile and 38 or 34),
	Text     = "TELEPORT SYSTEM  v2.0",
	TextSize = SMALL_SIZE,
	Font     = Enum.Font.GothamBold,
	TextColor3 = C.cyanDim,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex   = 13,
})

-- Bouton fermer
local closeBtn = Instance.new("TextButton")
closeBtn.Size   = UDim2.new(0, isMobile and 38 or 32, 0, isMobile and 38 or 32)
closeBtn.Position = UDim2.new(1, isMobile and -50 or -44, 0.5, isMobile and -19 or -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 28)
closeBtn.Text   = "✕"
closeBtn.TextSize = isMobile and 16 or 14
closeBtn.Font   = Enum.Font.GothamBold
closeBtn.TextColor3 = C.red
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 14
closeBtn.Parent = header
corner(closeBtn, 11)
stroke(closeBtn, C.red, 1)

closeBtn.MouseEnter:Connect(function()
	tw(closeBtn, {BackgroundColor3 = C.red, TextColor3 = C.white})
end)
closeBtn.MouseLeave:Connect(function()
	tw(closeBtn, {BackgroundColor3 = Color3.fromRGB(40,20,28), TextColor3 = C.red})
end)

-- ══════════════════════════════════════
--  BARRE DE RECHERCHE
-- ══════════════════════════════════════
local searchWrap = newFrame(Win, {
	Size     = UDim2.new(1, -24, 0, SEARCH_H),
	Position = UDim2.new(0, 12, 0, HEADER_H + 10),
	BackgroundColor3 = C.glass,
	ZIndex   = 12,
})
corner(searchWrap, 13)
local searchStroke = stroke(searchWrap, C.border, 1.5)

newLabel(searchWrap, {
	Size     = UDim2.new(0, isMobile and 42 or 36, 1, 0),
	Text     = "🔍",
	TextSize = isMobile and 17 or 15,
	Font     = Enum.Font.Gotham,
	TextColor3 = C.muted,
	ZIndex   = 13,
})

local searchBox = Instance.new("TextBox")
searchBox.Size   = UDim2.new(1, isMobile and -50 or -44, 1, 0)
searchBox.Position = UDim2.new(0, isMobile and 40 or 36, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.PlaceholderText = "Rechercher un joueur…"
searchBox.PlaceholderColor3 = C.muted
searchBox.Text   = ""
searchBox.TextSize = BODY_SIZE
searchBox.Font   = Enum.Font.Gotham
searchBox.TextColor3 = C.white
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false
searchBox.ZIndex = 13
searchBox.Parent = searchWrap

searchBox.Focused:Connect(function()
	tw(searchWrap, {BackgroundColor3 = C.glassHov})
	tw(searchStroke, {Color = C.cyan})
end)
searchBox.FocusLost:Connect(function()
	tw(searchWrap, {BackgroundColor3 = C.glass})
	tw(searchStroke, {Color = C.border})
end)

-- ══════════════════════════════════════
--  SÉPARATEUR + COMPTEUR
-- ══════════════════════════════════════
local sepY = HEADER_H + 10 + SEARCH_H + 10

newFrame(Win, {
	Size     = UDim2.new(1, -24, 0, 1),
	Position = UDim2.new(0, 12, 0, sepY),
	BackgroundColor3 = C.border,
	ZIndex   = 12,
})

local countLabel = newLabel(Win, {
	Size     = UDim2.new(1, -24, 0, 22),
	Position = UDim2.new(0, 12, 0, sepY + 4),
	Text     = "0 JOUEURS EN LIGNE",
	TextSize = SMALL_SIZE,
	Font     = Enum.Font.GothamBold,
	TextColor3 = C.muted,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex   = 12,
})

-- ══════════════════════════════════════
--  SCROLL LIST
-- ══════════════════════════════════════
local listTopY = sepY + 28

local scroll = Instance.new("ScrollingFrame")
scroll.Size   = UDim2.new(1, -24, 1, -(listTopY + 8))
scroll.Position = UDim2.new(0, 12, 0, listTopY)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = isMobile and 4 or 3
scroll.ScrollBarImageColor3 = C.cyan
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ZIndex = 12
scroll.Parent = Win

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, isMobile and 8 or 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scroll

-- État vide
local emptyState = newLabel(scroll, {
	Name     = "EmptyState",
	Size     = UDim2.new(1, 0, 0, 80),
	Text     = "😶 Aucun joueur trouvé",
	TextSize = BODY_SIZE,
	Font     = Enum.Font.Gotham,
	TextColor3 = C.muted,
	ZIndex   = 13,
	Visible  = false,
})

-- ══════════════════════════════════════
--  TOAST
-- ══════════════════════════════════════
local toast = newFrame(Gui, {
	Size     = UDim2.new(0, isMobile and 290 or 260, 0, isMobile and 56 or 48),
	Position = UDim2.new(0.5, isMobile and -145 or -130, 1, 80),
	BackgroundColor3 = C.glass,
	ZIndex   = 50,
})
corner(toast, 15)
stroke(toast, C.green, 1.5)

local toastBar = newFrame(toast, {
	Size     = UDim2.new(0, 4, 0, isMobile and 34 or 28),
	Position = UDim2.new(0, 12, 0.5, isMobile and -17 or -14),
	BackgroundColor3 = C.green,
	ZIndex   = 51,
})
corner(toastBar, 2)

local toastText = newLabel(toast, {
	Size     = UDim2.new(1, -34, 1, 0),
	Position = UDim2.new(0, 24, 0, 0),
	Text     = "Téléporté !",
	TextSize = isMobile and 14 or 13,
	Font     = Enum.Font.GothamBold,
	TextColor3 = C.white,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex   = 51,
})

local function showToast(msg, isErr)
	local col = isErr and C.red or C.green
	local toastStk = toast:FindFirstChildOfClass("UIStroke")
	if toastStk then tw(toastStk, {Color = col}) end
	tw(toastBar, {BackgroundColor3 = col})
	toastText.Text = msg
	local offY = isMobile and -70 or -68
	tw(toast, {Position = UDim2.new(0.5, isMobile and -145 or -130, 1, offY)}, TW.spring)
	task.delay(2.8, function()
		tw(toast, {Position = UDim2.new(0.5, isMobile and -145 or -130, 1, 80)}, TW.smooth)
	end)
end

-- ══════════════════════════════════════
--  TÉLÉPORTATION
-- ══════════════════════════════════════
local function teleport(target)
	local myChar  = LocalPlayer.Character
	local tgtChar = target.Character
	if not myChar or not tgtChar then
		showToast("❌  Personnage introuvable", true); return
	end
	local myRoot  = myChar:FindFirstChild("HumanoidRootPart")
	local tgtRoot = tgtChar:FindFirstChild("HumanoidRootPart")
	if myRoot and tgtRoot then
		myRoot.CFrame = tgtRoot.CFrame * CFrame.new(3.5, 0, 0)
		showToast("⚡  Téléporté → " .. target.Name)
	else
		showToast("❌  HumanoidRootPart manquant", true)
	end
end

-- ══════════════════════════════════════
--  CARTE JOUEUR (avec chat en avatar)
-- ══════════════════════════════════════
local function makeCard(player, order)
	local card = newFrame(scroll, {
		Name        = player.Name,
		Size        = UDim2.new(1, 0, 0, CARD_H),
		BackgroundColor3 = C.glass,
		LayoutOrder = order or 0,
		ZIndex      = 13,
	})
	corner(card, 13)
	local cardStroke = stroke(card, C.border, 1)

	-- Avatar : image du chat
	local avatarBg = newFrame(card, {
		Size     = UDim2.new(0, AVATAR_SIZE, 0, AVATAR_SIZE),
		Position = UDim2.new(0, 10, 0.5, -AVATAR_SIZE/2),
		BackgroundColor3 = C.cyanGhost,
		ZIndex   = 14,
	})
	corner(avatarBg, AVATAR_SIZE/2)
	stroke(avatarBg, C.cyanDim, 1.5)

	-- Image du chat dans le cercle
	local catImg = newImage(avatarBg, {
		Size     = UDim2.new(1, 0, 1, 0),
		Image    = CAT_ID,
		ScaleType = Enum.ScaleType.Crop,
		ZIndex   = 15,
	})
	corner(catImg, AVATAR_SIZE/2)

	-- Pastille online
	local dot = newFrame(avatarBg, {
		Size     = UDim2.new(0, isMobile and 12 or 10, 0, isMobile and 12 or 10),
		Position = UDim2.new(1, isMobile and -12 or -10, 1, isMobile and -12 or -10),
		BackgroundColor3 = C.green,
		ZIndex   = 16,
	})
	corner(dot, isMobile and 6 or 5)
	stroke(dot, C.void, 1.5)

	-- Nom joueur
	newLabel(card, {
		Size     = UDim2.new(1, -(AVATAR_SIZE + BTN_W + 28), 0, isMobile and 24 or 22),
		Position = UDim2.new(0, AVATAR_SIZE + 18, 0, isMobile and 10 or 8),
		Text     = player.Name,
		TextSize = BODY_SIZE,
		Font     = Enum.Font.GothamBold,
		TextColor3 = C.white,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex   = 14,
	})

	-- Badge LIVE
	local tag = newFrame(card, {
		Size     = UDim2.new(0, isMobile and 58 or 50, 0, isMobile and 18 or 16),
		Position = UDim2.new(0, AVATAR_SIZE + 18, 0, isMobile and 36 or 32),
		BackgroundColor3 = C.greenDark,
		ZIndex   = 14,
	})
	corner(tag, 6)
	newLabel(tag, {
		Size     = UDim2.new(1, 0, 1, 0),
		Text     = "● LIVE",
		TextSize = isMobile and 10 or 9,
		Font     = Enum.Font.GothamBold,
		TextColor3 = C.green,
		ZIndex   = 15,
	})

	-- Bouton TP
	local tpBtn = Instance.new("TextButton")
	tpBtn.Size     = UDim2.new(0, BTN_W, 0, BTN_H)
	tpBtn.Position = UDim2.new(1, -(BTN_W + 10), 0.5, -BTN_H/2)
	tpBtn.BackgroundColor3 = C.cyanGhost
	tpBtn.Text     = "TP ⚡"
	tpBtn.TextSize = isMobile and 13 or 11
	tpBtn.Font     = Enum.Font.GothamBold
	tpBtn.TextColor3 = C.cyan
	tpBtn.AutoButtonColor = false
	tpBtn.ZIndex   = 14
	tpBtn.Parent   = card
	corner(tpBtn, 10)
	local tpStroke = stroke(tpBtn, C.cyanDim, 1)

	local function onEnter()
		tw(card,     {BackgroundColor3 = C.glassHov})
		tw(cardStroke, {Color = C.borderHot})
		tw(tpBtn,    {BackgroundColor3 = C.cyan, TextColor3 = C.void})
		tw(tpStroke, {Color = C.cyan})
	end
	local function onLeave()
		tw(card,     {BackgroundColor3 = C.glass})
		tw(cardStroke, {Color = C.border})
		tw(tpBtn,    {BackgroundColor3 = C.cyanGhost, TextColor3 = C.cyan})
		tw(tpStroke, {Color = C.cyanDim})
	end

	-- Hover PC
	tpBtn.MouseEnter:Connect(onEnter)
	tpBtn.MouseLeave:Connect(onLeave)
	card.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement then onEnter() end
	end)
	card.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement then onLeave() end
	end)

	-- Click / Tap
	tpBtn.MouseButton1Click:Connect(function()
		tw(tpBtn, {BackgroundColor3 = C.gold}, TW.snap)
		task.delay(0.15, function() tw(tpBtn, {BackgroundColor3 = C.cyan}) end)
		teleport(player)
		closeMenu()
	end)

	return card
end

-- ══════════════════════════════════════
--  REFRESH
-- ══════════════════════════════════════
local function refresh(filter)
	filter = (filter or ""):lower()
	for _, c in pairs(scroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end

	local list = {}
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			if filter == "" or p.Name:lower():find(filter, 1, true) then
				table.insert(list, p)
			end
		end
	end

	table.sort(list, function(a, b) return a.Name < b.Name end)
	emptyState.Visible = (#list == 0)

	for i, p in ipairs(list) do makeCard(p, i) end

	local n = #list
	countLabel.Text = n .. " JOUEUR" .. (n ~= 1 and "S" or "") .. " EN LIGNE"
	scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	refresh(searchBox.Text)
end)

-- ══════════════════════════════════════
--  OPEN / CLOSE
-- ══════════════════════════════════════
local isOpen = false

local function openMenu()
	isOpen = true
	Win.Size    = isMobile and UDim2.new(0.88, 0, 0, 0) or UDim2.new(0, 300, 0, 0)
	Win.Visible = true
	tw(Win, WIN_OPEN, TW.spring)
	tw(fab, {BackgroundColor3 = C.white})
	tw(fabIcon, {TextColor3 = C.cyan})
	refresh()
end

function closeMenu()
	isOpen = false
	tw(Win, isMobile and UDim2.new(0.88, 0, 0, 0) or UDim2.new(0, 300, 0, 0), TW.smooth)
	tw(fab, {BackgroundColor3 = C.cyan})
	tw(fabIcon, {TextColor3 = C.void})
	task.delay(0.24, function()
		if not isOpen then Win.Visible = false end
	end)
end

fab.MouseButton1Click:Connect(function()
	if isOpen then closeMenu() else openMenu() end
end)
closeBtn.MouseButton1Click:Connect(closeMenu)

-- ══════════════════════════════════════
--  DRAG & DROP (header) — PC + Mobile
-- ══════════════════════════════════════
local dragging, dragStart, winStart = false, nil, nil

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging  = true
		dragStart = input.Position
		winStart  = Win.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputSvc.InputChanged:Connect(function(input)
	if not dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		local d  = input.Position - dragStart
		local sx = Gui.AbsoluteSize.X
		local sy = Gui.AbsoluteSize.Y
		local ws = Win.AbsoluteSize
		local nx = math.clamp(winStart.X.Offset + d.X, 0, sx - ws.X)
		local ny = math.clamp(winStart.Y.Offset + d.Y, 0, sy - ws.Y)
		Win.Position = UDim2.new(winStart.X.Scale, nx, winStart.Y.Scale, ny)
	end
end)

UserInputSvc.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- ══════════════════════════════════════
--  MISE À JOUR DYNAMIQUE
-- ══════════════════════════════════════
Players.PlayerAdded:Connect(function()
	if isOpen then refresh(searchBox.Text) end
end)
Players.PlayerRemoving:Connect(function()
	if isOpen then refresh(searchBox.Text) end
end)
