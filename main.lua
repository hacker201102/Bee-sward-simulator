-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Variables Fly
local flying = false
local speed = 60
local ascend = false
local descend = false
local moveVector = Vector3.zero

-- GUI
local PlayerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "FlyGuiV5"

-- Fonction pour créer un bouton
local function createButton(name, size, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Parent = screenGui
    btn.TouchTap:Connect(callback)
    return btn
end

-- Boutons Fly
createButton("Fly ON/OFF", UDim2.new(0,100,0,50), UDim2.new(0.8,0,0.7,0), function()
    flying = not flying
    humanoid.PlatformStand = flying
    print("Fly:", flying)
end)

createButton("UP", UDim2.new(0,60,0,60), UDim2.new(0.9,0,0.65,0), function() ascend = true end)
createButton("DOWN", UDim2.new(0,60,0,60), UDim2.new(0.9,0,0.75,0), function() descend = true end)

-- Vitesse + / -
createButton("+", UDim2.new(0,50,0,50), UDim2.new(0.05,0,0.05,0), function() speed += 10 print("Speed:", speed) end)
createButton("-", UDim2.new(0,50,0,50), UDim2.new(0.12,0,0.05,0), function() speed = math.max(10,speed-10) print("Speed:", speed) end)

-- Relâche boutons UP/DOWN
UserInputService.InputEnded:Connect(function(input, gp)
    if input.UserInputType == Enum.UserInputType.Touch then
        ascend = false
        descend = false
    end
end)

-- Joystick flottant simple
local joystickFrame = Instance.new("Frame")
joystickFrame.Size = UDim2.new(0,120,0,120)
joystickFrame.Position = UDim2.new(0.05,0,0.75,0)
joystickFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
joystickFrame.BackgroundTransparency = 0.5
joystickFrame.Parent = screenGui

local joystickKnob = Instance.new("Frame")
joystickKnob.Size = UDim2.new(0,50,0,50)
joystickKnob.Position = UDim2.new(0.5, -25, 0.5, -25)
joystickKnob.BackgroundColor3 = Color3.fromRGB(200,200,200)
joystickKnob.BackgroundTransparency = 0.3
joystickKnob.Parent = joystickFrame

local drag = false
local direction = Vector3.zero

joystickKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        drag = true
    end
end)

joystickKnob.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        drag = false
        joystickKnob.Position = UDim2.new(0.5, -25, 0.5, -25)
        direction = Vector3.zero
    end
end)

joystickKnob.InputChanged:Connect(function(input)
    if drag and input.UserInputType == Enum.UserInputType.Touch then
        local pos = Vector2.new(input.Position.X, input.Position.Y)
        local center = Vector2.new(joystickFrame.AbsolutePosition.X + joystickFrame.AbsoluteSize.X/2,
                                   joystickFrame.AbsolutePosition.Y + joystickFrame.AbsoluteSize.Y/2)
        local delta = pos - center
        local maxRadius = joystickFrame.AbsoluteSize.X/2
        if delta.Magnitude > maxRadius then
            delta = delta.Unit * maxRadius
        end
        joystickKnob.Position = UDim2.new(0, delta.X + joystickFrame.AbsoluteSize.X/2 - 25,
                                          0, delta.Y + joystickFrame.AbsoluteSize.Y/2 - 25)
        direction = Vector3.new(delta.X/maxRadius,0,delta.Y/maxRadius)
    end
end)

-- Fly loop
RunService.RenderStepped:Connect(function()
    if not flying then return end

    local cam = workspace.CurrentCamera
    local camForward = cam.CFrame.LookVector
    local camRight = cam.CFrame.RightVector

    -- Calcul direction du Fly selon joystick
    local move = (camForward*direction.Z + camRight*direction.X) * speed
    if ascend then move += Vector3.new(0,speed,0) end
    if descend then move -= Vector3.new(0,speed,0) end

    hrp.Velocity = move
end)
