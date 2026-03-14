-- ESP Script (Roblox Lua)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Configuration
local ESP_CONFIG = {
    BoxESP = true,
    NameESP = true,
    HealthESP = true,
    TeamCheck = false,
    BoxColor = Color3.fromRGB(255, 0, 0),
    FriendColor = Color3.fromRGB(0, 255, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    MaxDistance = 1000,
}

-- Stockage des drawings
local espObjects = {}

-- Fonctions utilitaires
local function createDrawing(type, props)
    local obj = Drawing.new(type)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function getCharacterParts(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    local head = character:FindFirstChild("Head")
    return rootPart, humanoid, head
end

local function worldToViewport(position)
    local screenPos, onScreen = camera:WorldToViewportPoint(position)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen, screenPos.Z
end

local function getBoxBounds(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    local pos = rootPart.Position
    local topPos, topOnScreen = worldToViewport(pos + Vector3.new(0, 3, 0))
    local botPos, botOnScreen = worldToViewport(pos + Vector3.new(0, -3, 0))

    if not topOnScreen and not botOnScreen then return nil end

    local height = math.abs(topPos.Y - botPos.Y)
    local width = height * 0.6

    return {
        X = botPos.X - width / 2,
        Y = topPos.Y,
        Width = width,
        Height = height,
    }
end

-- Création des éléments ESP pour un joueur
local function createESP(player)
    local obj = {
        Box = createDrawing("Square", {
            Visible = false, Thickness = 1.5,
            Color = ESP_CONFIG.BoxColor, Filled = false
        }),
        Name = createDrawing("Text", {
            Visible = false, Size = 14, Center = true,
            Color = ESP_CONFIG.TextColor, Outline = true
        }),
        HealthBar = createDrawing("Square", {
            Visible = false, Thickness = 1,
            Color = Color3.fromRGB(0, 255, 0), Filled = true
        }),
        HealthBarBg = createDrawing("Square", {
            Visible = false, Thickness = 1,
            Color = Color3.fromRGB(50, 50, 50), Filled = true
        }),
    }
    espObjects[player] = obj
end

-- Suppression des éléments ESP
local function removeESP(player)
    if espObjects[player] then
        for _, drawing in pairs(espObjects[player]) do
            drawing:Remove()
        end
        espObjects[player] = nil
    end
end

-- Mise à jour de l'ESP
local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player == localPlayer then continue end

        local obj = espObjects[player]
        if not obj then continue end

        local character = player.Character
        if not character then
            for _, d in pairs(obj) do d.Visible = false end
            continue
        end

        local rootPart, humanoid, head = getCharacterParts(character)
        if not rootPart or not humanoid or humanoid.Health <= 0 then
            for _, d in pairs(obj) do d.Visible = false end
            continue
        end

        -- Vérification de la distance
        local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
        if distance > ESP_CONFIG.MaxDistance then
            for _, d in pairs(obj) do d.Visible = false end
            continue
        end

        -- Vérification d'équipe
        local color = ESP_CONFIG.BoxColor
        if ESP_CONFIG.TeamCheck and player.Team == localPlayer.Team then
            color = ESP_CONFIG.FriendColor
        end

        local bounds = getBoxBounds(character)
        if not bounds then
            for _, d in pairs(obj) do d.Visible = false end
            continue
        end

        -- Box ESP
        if ESP_CONFIG.BoxESP then
            obj.Box.Visible = true
            obj.Box.Color = color
            obj.Box.Position = Vector2.new(bounds.X, bounds.Y)
            obj.Box.Size = Vector2.new(bounds.Width, bounds.Height)
        end

        -- Name ESP
        if ESP_CONFIG.NameESP then
            obj.Name.Visible = true
            obj.Name.Text = player.Name .. " [" .. math.floor(distance) .. "m]"
            obj.Name.Position = Vector2.new(bounds.X + bounds.Width / 2, bounds.Y - 18)
        end

        -- Health Bar
        if ESP_CONFIG.HealthESP then
            local healthPct = humanoid.Health / humanoid.MaxHealth
            local barX = bounds.X - 6
            local barHeight = bounds.Height

            obj.HealthBarBg.Visible = true
            obj.HealthBarBg.Position = Vector2.new(barX - 1, bounds.Y - 1)
            obj.HealthBarBg.Size = Vector2.new(4, barHeight + 2)

            obj.HealthBar.Visible = true
            obj.HealthBar.Color = Color3.fromRGB(
                255 * (1 - healthPct), 255 * healthPct, 0
            )
            obj.HealthBar.Position = Vector2.new(barX, bounds.Y + barHeight * (1 - healthPct))
            obj.HealthBar.Size = Vector2.new(3, barHeight * healthPct)
        end
    end
end

-- Initialisation
for _, player in pairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if not espObjects[player] then createESP(player) end
    end)
    createESP(player)
end)

Players.PlayerRemoving:Connect(removeESP)

-- Boucle principale
RunService.RenderStepped:Connect(updateESP)

print("ESP chargé avec succès !")
