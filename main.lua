-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variables Fly
local flying = false
local speed = 50
local direction = Vector3.new(0,0,0)

-- GUI
local PlayerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyHub"
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Parent = screenGui

local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
end

-- Bouton Toggle Fly
createButton("Toggle Fly (N)", 10, function()
    flying = not flying
    print("Fly :", flying and "ON" or "OFF")
end)

-- Bouton augmenter vitesse
createButton("Speed +10", 50, function()
    speed = speed + 10
    print("Vitesse Fly :", speed)
end)

-- Bouton diminuer vitesse
createButton("Speed -10", 90, function()
    speed = math.max(10, speed - 10)
    print("Vitesse Fly :", speed)
end)

-- Fermer menu
createButton("Fermer Menu", 130, function()
    screenGui:Destroy()
end)

-- Détection touches pour mouvement
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then direction = Vector3.new(0,0,-1) end
    if input.KeyCode == Enum.KeyCode.S then direction = Vector3.new(0,0,1) end
    if input.KeyCode == Enum.KeyCode.A then direction = Vector3.new(-1,0,0) end
    if input.KeyCode == Enum.KeyCode.D then direction = Vector3.new(1,0,0) end
    if input.KeyCode == Enum.KeyCode.N then
        flying = not flying
        print("Fly :", flying and "ON" or "OFF")
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or
       input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
        direction = Vector3.new(0,0,0)
    end
end)

-- Fly loop
RunService.Stepped:Connect(function()
    if flying then
        hrp.Velocity = direction * speed
        humanoid.PlatformStand = true
    else
        humanoid.PlatformStand = false
    end
end)

print("Fly Hub chargé ! Utilise W/A/S/D pour bouger et N pour toggle.")
