--// Dance Hub Premium Mobile
--// LocalScript - StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- éviter les doublons
local old = playerGui:FindFirstChild("DanceHubPremium")
if old then
	old:Destroy()
end

-- =========================
-- CONFIG
-- =========================
local HUB_NAME = "DanceHubPremium"
local MOBILE_OPEN_POS = UDim2.new(0, 18, 0.72, 0)
local HUB_SIZE = UDim2.new(0, 320, 0, 430)

-- pack de vraies danses / emotes connues
-- note: pour monter à 200+, ajoute simplement d'autres entrées dans DANCES
local DANCES = {
	{ Name = "Dance 1", Icon = "💃", AnimationId = "rbxassetid://507771019", Favorite = true },
	{ Name = "Dance 2", Icon = "🎵", AnimationId = "rbxassetid://507771955", Favorite = false },
	{ Name = "Dance 3", Icon = "✨", AnimationId = "rbxassetid://507772104", Favorite = false },

	-- Creator Store / exemples réels
	{ Name = "Gangnam Style", Icon = "🕺", AnimationId = "rbxassetid://102001896", Favorite = true },
	{ Name = "California Girls", Icon = "🌴", AnimationId = "rbxassetid://11165082872", Favorite = false },
	{ Name = "Dancing Animation", Icon = "🎶", AnimationId = "rbxassetid://12485694016", Favorite = false },
	{ Name = "R15 Dance 2 Store", Icon = "🔥", AnimationId = "rbxassetid://12192378501", Favorite = false },
	{ Name = "R15 Dance 3 Store", Icon = "🌈", AnimationId = "rbxassetid://12192400053", Favorite = false },
	{ Name = "DANCE ANIMATION R6", Icon = "⚡", AnimationId = "rbxassetid://8903870018", Favorite = false },
	{ Name = "Magnetic Dance", Icon = "🪩", AnimationId = "rbxassetid://16855275316", Favorite = false },
}

-- duplique pour obtenir 200+ slots modifiables
local seedCount = #DANCES
for i = seedCount + 1, 220 do
	local src = DANCES[((i - 1) % seedCount) + 1]
	table.insert(DANCES, {
		Name = src.Name .. " #" .. i,
		Icon = src.Icon,
		AnimationId = src.AnimationId,
		Favorite = false,
	})
end

-- =========================
-- HELPERS
-- =========================
local function make(className, props, parent)
	local obj = Instance.new(className)
	for k, v in pairs(props or {}) do
		obj[k] = v
	end
	if parent then
		obj.Parent = parent
	end
	return obj
end

local function round(parent, radius)
	return make("UICorner", { CornerRadius = UDim.new(0, radius or 12) }, parent)
end

local function stroke(parent, color, thickness, transparency)
	return make("UIStroke", {
		Color = color or Color3.fromRGB(120, 170, 255),
		Thickness = thickness or 1.4,
		Transparency = transparency or 0
	}, parent)
end

local function gradient(parent, c1, c2, rot)
	return make("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, c1),
			ColorSequenceKeypoint.new(1, c2)
		}),
		Rotation = rot or 0
	}, parent)
end

local function getHumanoid()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:FindFirstChildOfClass("Humanoid"), char
end

local function getAnimator()
	local humanoid = getHumanoid()
	if not humanoid then return nil end
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end
	return animator, humanoid
end

local function safeLower(s)
	return string.lower(tostring(s or ""))
end

-- =========================
-- GUI ROOT
-- =========================
local gui = make("ScreenGui", {
	Name = HUB_NAME,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	IgnoreGuiInset = true
}, playerGui)

-- bouton flottant
local openButton = make("TextButton", {
	Name = "OpenButton",
	Size = UDim2.new(0, 64, 0, 64),
	Position = MOBILE_OPEN_POS,
	Text = "💃",
	TextScaled = true,
	Font = Enum.Font.GothamBold,
	BackgroundColor3 = Color3.fromRGB(55, 70, 135),
	TextColor3 = Color3.fromRGB(255,255,255),
	AutoButtonColor = false,
	ZIndex = 20
}, gui)
round(openButton, 18)
stroke(openButton, Color3.fromRGB(160, 200, 255), 1.5, 0.15)
gradient(openButton, Color3.fromRGB(82, 104, 200), Color3.fromRGB(163, 85, 255), 45)

local openGlow = make("ImageLabel", {
	BackgroundTransparency = 1,
	Image = "rbxassetid://5028857084",
	ImageTransparency = 0.25,
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(24,24,276,276),
	Size = UDim2.new(1, 22, 1, 22),
	Position = UDim2.new(0, -11, 0, -11),
	ZIndex = 19
}, openButton)

-- fenêtre
local hub = make("Frame", {
	Name = "Hub",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Size = HUB_SIZE,
	Position = UDim2.new(0.5, 0, 0.5, 0),
	BackgroundColor3 = Color3.fromRGB(20, 22, 30),
	Visible = false,
	ZIndex = 10
}, gui)
round(hub, 18)
stroke(hub, Color3.fromRGB(116, 152, 255), 1.8, 0.15)
gradient(hub, Color3.fromRGB(28, 32, 48), Color3.fromRGB(18, 18, 27), 90)

local hubGlow = make("ImageLabel", {
	BackgroundTransparency = 1,
	Image = "rbxassetid://5028857084",
	ImageTransparency = 0.3,
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(24,24,276,276),
	Size = UDim2.new(1, 30, 1, 30),
	Position = UDim2.new(0, -15, 0, -15),
	ZIndex = 9
}, hub)

-- top bar
local top = make("Frame", {
	Size = UDim2.new(1, 0, 0, 52),
	BackgroundColor3 = Color3.fromRGB(31, 37, 58),
	BorderSizePixel = 0,
	ZIndex = 11
}, hub)
round(top, 18)
gradient(top, Color3.fromRGB(58, 77, 160), Color3.fromRGB(130, 74, 210), 0)

local topMask = make("Frame", {
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 0, 1, 0),
	Size = UDim2.new(1, 0, 0, 18),
	BackgroundColor3 = Color3.fromRGB(31, 37, 58),
	BorderSizePixel = 0,
	ZIndex = 11
}, top)

local title = make("TextLabel", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 0),
	Size = UDim2.new(1, -120, 1, 0),
	Text = "🌈 Dance Hub Premium",
	TextXAlignment = Enum.TextXAlignment.Left,
	TextColor3 = Color3.fromRGB(255,255,255),
	Font = Enum.Font.GothamBold,
	TextSize = 20,
	ZIndex = 12
}, top)

local subtitle = make("TextLabel", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 28),
	Size = UDim2.new(1, -120, 0, 16),
	Text = "200+ slots • mobile fluide • favoris",
	TextXAlignment = Enum.TextXAlignment.Left,
	TextColor3 = Color3.fromRGB(220,225,255),
	Font = Enum.Font.Gotham,
	TextSize = 11,
	ZIndex = 12
}, top)

local closeBtn = make("TextButton", {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -10, 0.5, 0),
	Size = UDim2.new(0, 34, 0, 34),
	Text = "✕",
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	TextColor3 = Color3.fromRGB(255,255,255),
	BackgroundColor3 = Color3.fromRGB(208, 73, 73),
	AutoButtonColor = false,
	ZIndex = 12
}, top)
round(closeBtn, 12)

-- recherche
local searchBox = make("TextBox", {
	Position = UDim2.new(0, 12, 0, 64),
	Size = UDim2.new(1, -24, 0, 38),
	PlaceholderText = "🔎 Chercher une dance...",
	Text = "",
	ClearTextOnFocus = false,
	Font = Enum.Font.Gotham,
	TextSize = 15,
	TextColor3 = Color3.fromRGB(255,255,255),
	PlaceholderColor3 = Color3.fromRGB(180,190,220),
	BackgroundColor3 = Color3.fromRGB(32, 36, 50),
	ZIndex = 11
}, hub)
round(searchBox, 12)
stroke(searchBox, Color3.fromRGB(90, 110, 190), 1.2, 0.35)

-- boutons du haut
local buttonsRow = make("Frame", {
	Position = UDim2.new(0, 12, 0, 110),
	Size = UDim2.new(1, -24, 0, 40),
	BackgroundTransparency = 1,
	ZIndex = 11
}, hub)

local favFilterBtn = make("TextButton", {
	Size = UDim2.new(0.33, -4, 1, 0),
	Text = "⭐ Favoris",
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	TextColor3 = Color3.fromRGB(255,255,255),
	BackgroundColor3 = Color3.fromRGB(61, 69, 108),
	AutoButtonColor = false,
	ZIndex = 12
}, buttonsRow)
round(favFilterBtn, 12)

local allBtn = make("TextButton", {
	Position = UDim2.new(0.33, 2, 0, 0),
	Size = UDim2.new(0.33, -4, 1, 0),
	Text = "📂 Toutes",
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	TextColor3 = Color3.fromRGB(255,255,255),
	BackgroundColor3 = Color3.fromRGB(49, 57, 90),
	AutoButtonColor = false,
	ZIndex = 12
}, buttonsRow)
round(allBtn, 12)

local stopBtn = make("TextButton", {
	AnchorPoint = Vector2.new(1,0),
	Position = UDim2.new(1, 0, 0, 0),
	Size = UDim2.new(0.34, -2, 1, 0),
	Text = "🛑 Stop",
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	TextColor3 = Color3.fromRGB(255,255,255),
	BackgroundColor3 = Color3.fromRGB(155, 58, 58),
	AutoButtonColor = false,
	ZIndex = 12
}, buttonsRow)
round(stopBtn, 12)

-- compteur
local counterLabel = make("TextLabel", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 154),
	Size = UDim2.new(1, -28, 0, 16),
	Text = "0 résultat",
	TextXAlignment = Enum.TextXAlignment.Left,
	TextColor3 = Color3.fromRGB(190,200,235),
	Font = Enum.Font.Gotham,
	TextSize = 12,
	ZIndex = 11
}, hub)

-- scrolling list
local listHolder = make("Frame", {
	Position = UDim2.new(0, 12, 0, 176),
	Size = UDim2.new(1, -24, 1, -188),
	BackgroundColor3 = Color3.fromRGB(25, 28, 39),
	ZIndex = 11
}, hub)
round(listHolder, 14)
stroke(listHolder, Color3.fromRGB(70,85,140), 1.1, 0.45)

local scroll = make("ScrollingFrame", {
	Size = UDim2.new(1, 0, 1, 0),
	CanvasSize = UDim2.new(0, 0, 0, 0),
	ScrollBarThickness = 4,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	AutomaticCanvasSize = Enum.AutomaticSize.None,
	ScrollingDirection = Enum.ScrollingDirection.Y,
	ZIndex = 12
}, listHolder)

local listPad = make("UIPadding", {
	PaddingTop = UDim.new(0, 8),
	PaddingBottom = UDim.new(0, 8),
	PaddingLeft = UDim.new(0, 8),
	PaddingRight = UDim.new(0, 8),
}, scroll)

local layout = make("UIListLayout", {
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder
}, scroll)

-- =========================
-- STATE
-- =========================
local currentTrack = nil
local favoritesOnly = false
local rowRefs = {}

-- =========================
-- ANIMATION PLAYBACK
-- =========================
local function stopCurrent()
	if currentTrack then
		pcall(function()
			currentTrack:Stop(0.12)
			currentTrack:Destroy()
		end)
		currentTrack = nil
	end
end

local function playAnimation(animationId)
	local animator = getAnimator()
	if not animator then return end

	stopCurrent()

	local animation = Instance.new("Animation")
	animation.AnimationId = animationId

	local ok, track = pcall(function()
		return animator:LoadAnimation(animation)
	end)

	if ok and track then
		currentTrack = track
		currentTrack.Looped = true
		currentTrack:Play(0.15, 1, 1)
	end
end

-- =========================
-- ROW CREATION
-- =========================
local function createDanceRow(data, index)
	local row = make("Frame", {
		Name = "Row_" .. index,
		Size = UDim2.new(1, 0, 0, 56),
		BackgroundColor3 = Color3.fromRGB(33, 38, 55),
		LayoutOrder = index,
		ZIndex = 12
	}, scroll)
	round(row, 14)
	stroke(row, Color3.fromRGB(78, 92, 156), 1.1, 0.35)

	local icon = make("TextLabel", {
		Position = UDim2.new(0, 10, 0, 8),
		Size = UDim2.new(0, 40, 0, 40),
		Text = data.Icon or "🎵",
		TextSize = 22,
		Font = Enum.Font.GothamBold,
		TextColor3 = Color3.fromRGB(255,255,255),
		BackgroundColor3 = Color3.fromRGB(56, 65, 100),
		ZIndex = 13
	}, row)
	round(icon, 12)
	gradient(icon, Color3.fromRGB(84, 104, 220), Color3.fromRGB(172, 93, 255), 45)

	local name = make("TextLabel", {
		Position = UDim2.new(0, 58, 0, 7),
		Size = UDim2.new(1, -150, 0, 22),
		BackgroundTransparency = 1,
		Text = data.Name,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Color3.fromRGB(255,255,255),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		ZIndex = 13
	}, row)

	local idLabel = make("TextLabel", {
		Position = UDim2.new(0, 58, 0, 28),
		Size = UDim2.new(1, -150, 0, 16),
		BackgroundTransparency = 1,
		Text = data.AnimationId,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Color3.fromRGB(180,190,220),
		Font = Enum.Font.Gotham,
		TextSize = 10,
		ZIndex = 13
	}, row)

	local favBtn = make("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -58, 0.5, 0),
		Size = UDim2.new(0, 34, 0, 34),
		Text = data.Favorite and "★" or "☆",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = Color3.fromRGB(255,255,255),
		BackgroundColor3 = data.Favorite and Color3.fromRGB(204, 150, 54) or Color3.fromRGB(65, 72, 98),
		AutoButtonColor = false,
		ZIndex = 13
	}, row)
	round(favBtn, 10)

	local playBtn = make("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.new(0, 38, 0, 34),
		Text = "▶",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = Color3.fromRGB(255,255,255),
		BackgroundColor3 = Color3.fromRGB(75, 112, 214),
		AutoButtonColor = false,
		ZIndex = 13
	}, row)
	round(playBtn, 10)

	playBtn.MouseButton1Click:Connect(function()
		playAnimation(data.AnimationId)
	end)

	favBtn.MouseButton1Click:Connect(function()
		data.Favorite = not data.Favorite
		favBtn.Text = data.Favorite and "★" or "☆"
		favBtn.BackgroundColor3 = data.Favorite and Color3.fromRGB(204, 150, 54) or Color3.fromRGB(65, 72, 98)
	end)

	rowRefs[#rowRefs + 1] = {
		Data = data,
		Row = row,
		NameLabel = name
	}
end

for i, dance in ipairs(DANCES) do
	createDanceRow(dance, i)
end

local function refreshCanvas()
	task.wait()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)
refreshCanvas()

-- =========================
-- FILTER / SEARCH
-- =========================
local function applyFilters()
	local query = safeLower(searchBox.Text)
	local visibleCount = 0

	for _, item in ipairs(rowRefs) do
		local data = item.Data
		local okSearch = query == "" or string.find(safeLower(data.Name), query, 1, true)
		local okFav = (not favoritesOnly) or data.Favorite

		item.Row.Visible = okSearch and okFav
		if item.Row.Visible then
			visibleCount += 1
		end
	end

	counterLabel.Text = tostring(visibleCount) .. " résultat(s)"
	refreshCanvas()
end

searchBox:GetPropertyChangedSignal("Text"):Connect(applyFilters)

favFilterBtn.MouseButton1Click:Connect(function()
	favoritesOnly = true
	favFilterBtn.BackgroundColor3 = Color3.fromRGB(204, 150, 54)
	allBtn.BackgroundColor3 = Color3.fromRGB(49, 57, 90)
	applyFilters()
end)

allBtn.MouseButton1Click:Connect(function()
	favoritesOnly = false
	allBtn.BackgroundColor3 = Color3.fromRGB(75, 112, 214)
	favFilterBtn.BackgroundColor3 = Color3.fromRGB(61, 69, 108)
	applyFilters()
end)

stopBtn.MouseButton1Click:Connect(stopCurrent)

allBtn.BackgroundColor3 = Color3.fromRGB(75, 112, 214)
applyFilters()

-- =========================
-- OPEN / CLOSE + ANIMS
-- =========================
local opening = false

local function animateOpen()
	if opening then return end
	opening = true

	hub.Visible = true
	hub.Size = UDim2.new(0, 40, 0, 40)
	hub.BackgroundTransparency = 0.15
	hubGlow.ImageTransparency = 0.55

	local tween1 = TweenService:Create(hub, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = HUB_SIZE,
		BackgroundTransparency = 0
	})
	local tween2 = TweenService:Create(hubGlow, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		ImageTransparency = 0.3
	})

	tween1:Play()
	tween2:Play()
	tween1.Completed:Wait()
	opening = false
end

local function animateClose()
	local tween1 = TweenService:Create(hub, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 40, 0, 40),
		BackgroundTransparency = 0.2
	})
	local tween2 = TweenService:Create(hubGlow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		ImageTransparency = 0.65
	})

	tween1:Play()
	tween2:Play()
	tween1.Completed:Wait()
	hub.Visible = false
	hub.Size = HUB_SIZE
	hub.BackgroundTransparency = 0
	hubGlow.ImageTransparency = 0.3
end

openButton.MouseButton1Click:Connect(function()
	if hub.Visible then
		animateClose()
	else
		animateOpen()
	end
end)

closeBtn.MouseButton1Click:Connect(animateClose)

-- petit glow flottant
task.spawn(function()
	while gui.Parent do
		local up = TweenService:Create(openGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			ImageTransparency = 0.1
		})
		local down = TweenService:Create(openGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			ImageTransparency = 0.28
		})
		up:Play()
		up.Completed:Wait()
		down:Play()
		down.Completed:Wait()
	end
end)

-- =========================
-- MOBILE DRAG
-- =========================
local dragging = false
local dragStart = nil
local startPos = nil
local dragInput = nil

local function updateDrag(input)
	local delta = input.Position - dragStart
	hub.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = hub.Position
		dragInput = input

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

top.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		updateDrag(input)
	end
end)

-- meilleure fluidité mobile
scroll.ScrollingEnabled = true
scroll.ClipsDescendants = true
scroll.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable

print("Dance Hub Premium chargé.")
