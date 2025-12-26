-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Variables Fly
local flying = false
local speed = 60
local ascend = false
local descend = false
local moveDirection = Vector3.zero

-- GUI
local PlayerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.Parent = PlayerGui

-- Création d’un bouton simple
local function createButton(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = screenGui
    btn.TouchTap:Connect(callback)
end

-- Boutons Fly
createButton("Fly ON/OFF", UDim2.new(0.8,0,0.8,0), function()
    flying = not flying
    humanoid.PlatformStand = flying
    print("Fly:", flying)
end)

createButton("UP", UDim2.new(0.9,0,0.7,0), function() ascend = true end)
createButton("DOWN", UDim2.new(0.9,0,0.85,0), function() descend = true end)

UserInputService.InputEnded:Connect(function(input, gp)
    if input.UserInputType == Enum.UserInputType.Touch then
        ascend = false
        descend = false
    end
end)

-- Calcul direction selon la caméra / joystick
RunService.RenderStepped:Connect(function()
    if not flying then return end

    local cam = workspace.CurrentCamera
    local dir = Vector3.zero

    if UserInputService.TouchEnabled then
        -- direction caméra
        local camForward = cam.CFrame.LookVector
        dir = camForward
    else
        dir = cam.CFrame.LookVector
    end

    local velocity = dir * speed
    if ascend then velocity += Vector3.new(0,speed,0) end
    if descend then velocity -= Vector3.new(0,speed,0) end

    hrp.Velocity = velocity
end)
