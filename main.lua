-- ╔══════════════════════════════════════════════════════════╗
-- ║            NEXUS TELEPORT  —  Mod Menu Premium          ║
-- ║     LocalScript → StarterPlayer > StarterPlayerScripts  ║
-- ╚══════════════════════════════════════════════════════════╝

local Players      = game:GetService("Players")
local UserInputSvc = game:GetService("UserInputService")
local TweenSvc     = game:GetService("TweenService")
local LocalPlayer  = Players.LocalPlayer

-- ══════════════════════════════════════
--  PALETTE CYBERPUNK
-- ══════════════════════════════════════
local C = {
	void       = Color3.fromRGB(6,   7,  14),
	deep       = Color3.fromRGB(10,  11,  22),
	panel      = Color3.fromRGB(14,  15,  30),
	glass      = Color3.fromRGB(20,  22,  45),
	glassHov   = Color3.fromRGB(28,  30,  62),
	cyan       = Color3.fromRGB(0,  220, 255),
	cyanDim    = Color3.fromRGB(0,  140, 170),
	cyanGhost  = Color3.fromRGB(0,   50,  70),
	gold       = Color3.fromRGB(255, 200,  50),
	red        = Color3.fromRGB(255,  55,  90),
	green      = Color3.fromRGB(50,  230, 120),
	greenDark  = Color3.fromRGB(15,   60,  35),
	white      = Color3.fromRGB(210, 230, 255),
	muted      = Color3.fromRGB(80,   95, 140),
	border     = Color3.fromRGB(30,   35,  70),
	borderHot  = Color3.fromRGB(0,   180, 210),
}

-- ══════════════════════════════════════
--  TWEEN PRESETS
-- ══════════════════════════════════════
local TW = {
	snap   = TweenInfo.new(0.12, Enum.EasingStyle.Quart,   Enum.EasingDirection.Out),
	smooth = TweenInfo.new(0.22, Enum.EasingStyle.Quart,   Enum.EasingDirection.Out),
	spring = TweenInfo.new(0.45, Enum.EasingStyle.Back,    Enum.EasingDirection.Out),
	slow   = TweenInfo.new(0.55, Enum.EasingStyle.Quint,   Enum.EasingDirection.Out),
	pulse  = TweenInfo.new(1.4,  Enum.EasingStyle.Sine,    Enum.EasingDirection.InOut, -1, true),
	drift  = TweenInfo.new(2.5,  Enum.EasingStyle.Sine,    Enum.EasingDirection.InOut, -1, true),
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
--  FAB (bouton flottant)
-- ══════════════════════════════════════
local fab = Instance.new("TextButton")
fab.Name = "FAB"
fab.Size = UDim2.new(0, 52, 0, 52)
fab.Position = UDim2.new(0, 16, 0.5, -26)
fab.BackgroundColor3 = C.cyan
fab.Text = ""
fab.AutoButtonColor = false
fab.ZIndex = 20
fab.Parent = Gui
corner(fab, 15)

-- Icône éclair dans le FAB
local fabIcon = newLabel(fab, {
	Size = UDim2.new(1,0,1,0),
	Text = "⚡",
	TextSize = 24,
	Font = Enum.Font.GothamBold,
	TextColor3 = C.void,
	ZIndex = 21,
})

-- Halo animé autour du FAB
local fabHalo = newFrame(Gui, {
	Size = UDim2.new(0, 72, 0, 72),
	Position = UDim2.new(0, 6, 0.5, -36),
	BackgroundColor3 = C.cyan,
	BackgroundTransparency = 0.75,
	ZIndex = 19,
})
corner(fabHalo, 20)
tw(fabHalo, {BackgroundTransparency = 0.92, Size = UDim2.new(0, 80, 0, 80), Position = UDim2.new(0, 2, 0.5, -40)}, TW.pulse)

-- Hover FAB
fab.MouseEnter:Connect(function()
	tw(fab, {BackgroundColor3 = C.white, Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(0, 14, 0.5, -28)})
	tw(fabIcon, {TextColor3 = C.cyan})
end)
fab.MouseLeave:Connect(function()
	tw(fab, {BackgroundColor3 = C.cyan, Size = UDim2.new(0, 52, 0, 52), Position = UDim2.new(0, 16, 0.5, -26)})
	tw(fabIcon, {TextColor3 = C.void})
end)

-- ══════════════════════════════════════
--  FENÊTRE PRINCIPALE
-- ══════════════════════════════════════
local Win = newFrame(Gui, {
	Name = "Window",
	Size = UDim2.new(0, 300, 0, 460),
	Position = UDim2.new(0, 80, 0.5, -230),
	BackgroundColor3 = C.void,
	ClipsDescendants = true,
	Visible = false,
	ZIndex = 10,
})
corner(Win, 18)
stroke(Win, C.border, 1)

-- Fond dégradé subtil
local winBg = newFrame(Win, {
	Size = UDim2.new(1,0,1,0),
	BackgroundColor3 = C.deep,
	ZIndex = 10,
})
corner(winBg, 18)
gradient(winBg, C.void, C.panel, 145)

-- Lueur top-left décorative
local cornerGlow = newFrame(Win, {
	Size = UDim2.new(0, 180, 0, 180),
	Position = UDim2.new(0, -60, 0, -60),
	BackgroundColor3 = C.cyan,
	BackgroundTransparency = 0.88,
	ZIndex = 11,
})
corner(cornerGlow, 90)
tw(cornerGlow, {BackgroundTransparency = 0.94}, TW.drift)

-- Lueur bottom-right décorative
local cornerGlow2 = newFrame(Win, {
	Size = UDim2.new(0, 140, 0, 140),
	Position = UDim2.new(1, -80, 1, -80),
	BackgroundColor3 = C.gold,
	BackgroundTransparency = 0.92,
	ZIndex = 11,
})
corner(cornerGlow2, 70)
tw(cornerGlow2, {BackgroundTransparency = 0.96}, TW.pulse)

-- ══════════════════════════════════════
--  HEADER
-- ══════════════════════════════════════
local header = newFrame(Win, {
	Name = "Header",
	Size = UDim2.new(1,0,0,68),
	BackgroundColor3 = C.glass,
	ZIndex = 12,
})

-- Ligne accent en bas du header
local headerLine = newFrame(header, {
	Size = UDim2.new(1,0,0,2),
	Position = UDim2.new(0,0,1,-2),
	BackgroundColor3 = C.cyan,
	ZIndex = 13,
})
gradient(headerLine, C.cyan, C.cyanGhost, 0)

-- Badge icône
local badge = newFrame(header, {
	Size = UDim2.new(0,40,0,40),
	Position = UDim2.new(0,14,0.5,-20),
	BackgroundColor3 = C.cyanGhost,
	ZIndex = 13,
})
corner(badge, 12)
stroke(badge, C.cyan, 1.5)

local badgeIcon = newLabel(badge, {
	Size = UDim2.new(1,0,1,0),
	Text = "⚡",
	TextSize = 20,
	Font = Enum.Font.GothamBold,
	TextColor3 = C.cyan,
	ZIndex = 14,
})

-- Titre NEXUS
local titleMain = newLabel(header, {
	Size = UDim2.new(1,-115,0,26),
	Position = UDim2.new(0,62,0,10),
	Text = "NEXUS",
	TextSize = 20,
	Font = Enum.Font.GothamBold,
	TextColor3 = C.white,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 13,
})

-- Sous-titre
local titleSub = newLabel(header, {
	Size = UDim2.new(1,-115,0,18),
	Position = UDim2.new(0,62,0,34),
	Text = "TELEPORT SYSTEM  v2.0",
	TextSize = 10,
	Font = Enum.Font.GothamBold,
	TextColor3 = C.cyanDim,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 13,
})

-- Bouton ✕
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,32,0,32)
closeBtn.Position = UDim2.new(1,-44,0.5,-16)
closeBtn.BackgroundColor3 = Color3.fromRGB(40,20,28)
closeBtn.Text = "✕"
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = C.red
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 14
closeBtn.Parent = header
corner(closeBtn, 10)
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
	Size = UDim2.new(1,-24,0,38),
	Position = UDim2.new(0,12,0,78),
	BackgroundColor3 = C.glass,
	ZIndex = 12,
})
corner(searchWrap, 12)
local searchStroke = stroke(searchWrap, C.border, 1.5)

local searchEmoji = newLabel(searchWrap, {
	Size = UDim2.new(0,36,1,0),
	Text = "🔍",
	TextSize = 15,
	Font = Enum.Font.Gotham,
	TextColor3 = C.muted,
	ZIndex = 13,
})

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1,-44,1,0)
searchBox.Position = UDim2.new(0,36,0,0)
searchBox.BackgroundTransparency = 1
searchBox.PlaceholderText = "Rechercher un joueur…"
searchBox.PlaceholderColor3 = C.muted
searchBox.Text = ""
searchBox.TextSize = 13
searchBox.Font = Enum.Font.Gotham
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
local sepLine = newFrame(Win, {
	Size = UDim2.new(1,-24,0,1),
	Position = UDim2.new(0,12,0,126),
	BackgroundColor3 = C.border,
	ZIndex = 12,
})

local countLabel = newLabel(Win, {
	Size = UDim2.new(1,-24,0,22),
	Position = UDim2.new(0,12,0,130),
	Text = "0 JOUEURS EN LIGNE",
	TextSize = 10,
	Font = Enum.Font.GothamBold,
	TextColor3 = C.muted,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 12,
})

-- ══════════════════════════════════════
--  SCROLL LIST
-- ══════════════════════════════════════
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-24,1,-166)
scroll.Position = UDim2.new(0,12,0,156)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = C.cyan
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ZIndex = 12
scroll.Parent = Win

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0,7)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scroll

-- ══════════════════════════════════════
--  ÉTAT « VIDE »
-- ══════════════════════════════════════
local emptyState = newLabel(scroll, {
	Name = "EmptyState",
	Size = UDim2.new(1,0,0,80),
	Text = "😶 Aucun joueur trouvé",
	TextSize = 13,
	Font = Enum.Font.Gotham,
	TextColor3 = C.muted,
	ZIndex = 13,
	Visible = false,
})

-- ══════════════════════════════════════
--  TOAST NOTIFICATION
-- ══════════════════════════════════════
local toast = newFrame(Gui, {
	Name = "Toast",
	Size = UDim2.new(0,260,0,48),
	Position = UDim2.new(0.5,-130,1,70),
	BackgroundColor3 = C.glass,
	ZIndex = 50,
})
corner(toast, 14)
stroke(toast, C.green, 1.5)

local toastBar = newFrame(toast, {
	Size = UDim2.new(0,4,0,28),
	Position = UDim2.new(0,10,0.5,-14),
	BackgroundColor3 = C.green,
	ZIndex = 51,
})
corner(toastBar, 2)

local toastText = newLabel(toast, {
	Size = UDim2.new(1,-30,1,0),
	Position = UDim2.new(0,22,0,0),
	Text = "Téléporté avec succès !",
	TextSize = 13,
	Font = Enum.Font.GothamBold,
	TextColor3 = C.white,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 51,
})

local function showToast(msg, isError)
	local col = isError and C.red or C.green
	tw(toast, {}, TW.snap)
	stroke(toast, col, 1.5)
	tw(toastBar, {BackgroundColor3 = col})
	toastText.Text = msg
	tw(toast, {Position = UDim2.new(0.5,-130,1,-68)}, TW.spring)
	task.delay(2.8, function()
		tw(toast, {Position = UDim2.new(0.5,-130,1,70)}, TW.smooth)
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
--  CARTE JOUEUR
-- ══════════════════════════════════════
local function makeCard(player, order)
	local card = newFrame(scroll, {
		Name = player.Name,
		Size = UDim2.new(1,0,0,58),
		BackgroundColor3 = C.glass,
		LayoutOrder = order or 0,
		ZIndex = 13,
	})
	corner(card, 12)
	local cardStroke = stroke(card, C.border, 1)

	-- Avatar cercle avec initiale
	local avatarBg = newFrame(card, {
		Size = UDim2.new(0,38,0,38),
		Position = UDim2.new(0,10,0.5,-19),
		BackgroundColor3 = C.cyanGhost,
		ZIndex = 14,
	})
	corner(avatarBg, 19)
	stroke(avatarBg, C.cyanDim, 1.5)

	newLabel(avatarBg, {
		Size = UDim2.new(1,0,1,0),
		Text = string.upper(string.sub(player.Name, 1, 1)),
		TextSize = 17,
		Font = Enum.Font.GothamBold,
		TextColor3 = C.cyan,
		ZIndex = 15,
	})

	-- Pastille verte "online"
	local dot = newFrame(avatarBg, {
		Size = UDim2.new(0,10,0,10),
		Position = UDim2.new(1,-10,1,-10),
		BackgroundColor3 = C.green,
		ZIndex = 16,
	})
	corner(dot, 5)
	stroke(dot, C.void, 1.5)

	-- Nom
	newLabel(card, {
		Size = UDim2.new(1,-110,0,22),
		Position = UDim2.new(0,56,0,8),
		Text = player.Name,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		TextColor3 = C.white,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 14,
	})

	-- Tag "JOUEUR"
	local tag = newFrame(card, {
		Size = UDim2.new(0,50,0,16),
		Position = UDim2.new(0,56,0,32),
		BackgroundColor3 = C.greenDark,
		ZIndex = 14,
	})
	corner(tag, 5)
	newLabel(tag, {
		Size = UDim2.new(1,0,1,0),
		Text = "● LIVE",
		TextSize = 9,
		Font = Enum.Font.GothamBold,
		TextColor3 = C.green,
		ZIndex = 15,
	})

	-- Bouton TP
	local tpBtn = Instance.new("TextButton")
	tpBtn.Size = UDim2.new(0,52,0,32)
	tpBtn.Position = UDim2.new(1,-62,0.5,-16)
	tpBtn.BackgroundColor3 = C.cyanGhost
	tpBtn.Text = "TP ⚡"
	tpBtn.TextSize = 11
	tpBtn.Font = Enum.Font.GothamBold
	tpBtn.TextColor3 = C.cyan
	tpBtn.AutoButtonColor = false
	tpBtn.ZIndex = 14
	tpBtn.Parent = card
	corner(tpBtn, 9)
	local tpStroke = stroke(tpBtn, C.cyanDim, 1)

	-- Hover card
	local function onEnter()
		tw(card, {BackgroundColor3 = C.glassHov})
		tw(cardStroke, {Color = C.borderHot})
		tw(tpBtn, {BackgroundColor3 = C.cyan, TextColor3 = C.void})
		tw(tpStroke, {Color = C.cyan})
	end
	local function onLeave()
		tw(card, {BackgroundColor3 = C.glass})
		tw(cardStroke, {Color = C.border})
		tw(tpBtn, {BackgroundColor3 = C.cyanGhost, TextColor3 = C.cyan})
		tw(tpStroke, {Color = C.cyanDim})
	end

	tpBtn.MouseEnter:Connect(onEnter)
	tpBtn.MouseLeave:Connect(onLeave)
	card.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement then onEnter() end
	end)
	card.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement then onLeave() end
	end)

	-- Click
	tpBtn.MouseButton1Click:Connect(function()
		tw(tpBtn, {BackgroundColor3 = C.gold}, TW.snap)
		task.delay(0.12, function() tw(tpBtn, {BackgroundColor3 = C.cyan}) end)
		teleport(player)
		closeMenu()
	end)

	return card
end

-- ══════════════════════════════════════
--  REFRESH LISTE
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

	table.sort(list, function(a,b) return a.Name < b.Name end)

	emptyState.Visible = #list == 0
	for i, p in ipairs(list) do makeCard(p, i) end

	local n = #list
	countLabel.Text = n .. " JOUEUR" .. (n~=1 and "S" or "") .. " EN LIGNE"
	scroll.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 8)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	refresh(searchBox.Text)
end)

-- ══════════════════════════════════════
--  OUVERTURE / FERMETURE
-- ══════════════════════════════════════
local isOpen = false

local function openMenu()
	isOpen = true
	Win.Size = UDim2.new(0,300,0,0)
	Win.Visible = true
	tw(Win, {Size = UDim2.new(0,300,0,460)}, TW.spring)
	tw(fabIcon, {TextColor3 = C.void})
	tw(fab, {BackgroundColor3 = C.white})
	refresh()
end

function closeMenu()
	isOpen = false
	tw(Win, {Size = UDim2.new(0,300,0,0)}, TW.smooth)
	tw(fab, {BackgroundColor3 = C.cyan})
	tw(fabIcon, {TextColor3 = C.void})
	task.delay(0.23, function()
		if not isOpen then Win.Visible = false end
	end)
end

fab.MouseButton1Click:Connect(function()
	if isOpen then closeMenu() else openMenu() end
end)
closeBtn.MouseButton1Click:Connect(closeMenu)

-- ══════════════════════════════════════
--  DRAG & DROP (barre header)
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
	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement or
		input.UserInputType == Enum.UserInputType.Touch
	) then
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
