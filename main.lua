-- LocalScript à placer dans StarterPlayerScripts ou StarterGui

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Création de l'interface graphique
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Bouton pour ouvrir/fermer le menu
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 150, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "📍 Téléporter"
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

local UICorner0 = Instance.new("UICorner")
UICorner0.CornerRadius = UDim.new(0, 8)
UICorner0.Parent = ToggleButton

-- Fenêtre principale du menu
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Size = UDim2.new(0, 250, 0, 350)
MenuFrame.Position = UDim2.new(0, 170, 0.5, -175)
MenuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MenuFrame.BorderSizePixel = 0
MenuFrame.Visible = false
MenuFrame.Parent = ScreenGui

local UICorner1 = Instance.new("UICorner")
UICorner1.CornerRadius = UDim.new(0, 10)
UICorner1.Parent = MenuFrame

-- Titre du menu (sert aussi de poignée de drag)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "🎯 Choisir un joueur"
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MenuFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 10)
UICorner2.Parent = Title

-- Icône de déplacement dans le titre
local DragIcon = Instance.new("TextLabel")
DragIcon.Size = UDim2.new(0, 30, 1, 0)
DragIcon.Position = UDim2.new(1, -35, 0, 0)
DragIcon.BackgroundTransparency = 1
DragIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
DragIcon.Text = "⠿"
DragIcon.TextSize = 20
DragIcon.Font = Enum.Font.GothamBold
DragIcon.Parent = Title

-- Zone scrollable pour la liste des joueurs
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -55)
ScrollFrame.Position = UDim2.new(0, 5, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 215)
ScrollFrame.Parent = MenuFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 5)
ListLayout.Parent = ScrollFrame

-- ============================================
-- SYSTÈME DE DRAG (déplacement du menu)
-- ============================================
local dragging = false
local dragStartPos = nil
local frameStartPos = nil

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
		input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStartPos = input.Position
		frameStartPos = MenuFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
		input.UserInputType == Enum.UserInputType.Touch) then

		local delta = input.Position - dragStartPos

		-- Calcul de la nouvelle position
		local newX = frameStartPos.X.Offset + delta.X
		local newY = frameStartPos.Y.Offset + delta.Y

		-- Limites de l'écran pour ne pas sortir
		local screenSize = ScreenGui.AbsoluteSize
		local frameSize = MenuFrame.AbsoluteSize

		newX = math.clamp(newX, 0, screenSize.X - frameSize.X)
		newY = math.clamp(newY, 0, screenSize.Y - frameSize.Y)

		MenuFrame.Position = UDim2.new(
			frameStartPos.X.Scale, newX,
			frameStartPos.Y.Scale, newY
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
		input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- ============================================
-- TÉLÉPORTATION
-- ============================================
local function teleportToPlayer(targetPlayer)
	local character = LocalPlayer.Character
	local targetCharacter = targetPlayer.Character

	if not character or not targetCharacter then
		warn("Personnage introuvable !")
		return
	end

	local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	if targetRootPart and rootPart then
		local offset = Vector3.new(3, 0, 0)
		rootPart.CFrame = targetRootPart.CFrame + offset
		print("Téléporté vers " .. targetPlayer.Name)
	end
end

-- Fonction pour créer un bouton joueur
local function createPlayerButton(player)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 45)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = "👤 " .. player.Name
	btn.TextSize = 14
	btn.Font = Enum.Font.Gotham
	btn.Parent = ScrollFrame

	local UICornerBtn = Instance.new("UICorner")
	UICornerBtn.CornerRadius = UDim.new(0, 6)
	UICornerBtn.Parent = btn

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end)

	btn.MouseButton1Click:Connect(function()
		teleportToPlayer(player)
		MenuFrame.Visible = false
	end)

	return btn
end

-- Fonction pour rafraîchir la liste des joueurs
local function refreshPlayerList()
	for _, child in pairs(ScrollFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			createPlayerButton(player)
		end
	end

	ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
end

-- Ouvrir/fermer le menu
ToggleButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = not MenuFrame.Visible
	if MenuFrame.Visible then
		refreshPlayerList()
	end
end)

Players.PlayerAdded:Connect(function()
	if MenuFrame.Visible then refreshPlayerList() end
end)
Players.PlayerRemoving:Connect(function()
	if MenuFrame.Visible then refreshPlayerList() end
end)
