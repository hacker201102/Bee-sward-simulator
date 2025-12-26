-- Fly Mobile avancé
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local flying = false
local speed = 60
local ascend = false
local descend = false

-- Toggle Fly
local function toggleFly()
    flying = not flying
    humanoid.PlatformStand = flying
    print("Fly:", flying)
end

-- Création des boutons pour mobile
local function createButton(name, pos, callback)
    local screenGui = player:WaitForChild("PlayerGui"):FindFirstChild("FlyGui") or Instance.new("ScreenGui", player.PlayerGui)
    screenGui.Name = "FlyGui"

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = screenGui

    btn.TouchTap:Connect(callback)
end

-- Boutons Fly
createButton("Fly ON/OFF", UDim2.new(0.8,0,0.8,0), toggleFly)
createButton("UP", UDim2.new(0.9,0,0.7,0), function() ascend = true end)
createButton("DOWN", UDim2.new(0.9,0,0.85,0), function() descend = true end)

UserInputService.InputEnded:Connect(function(input, gp)
    if input.UserInputType == Enum.UserInputType.Touch then
        ascend = false
        descend = false
    end
end)

-- Fly loop
RunService.RenderStepped:Connect(function()
    if not flying then return end

    local cam = workspace.CurrentCamera
    local moveDir = Vector3.zero

    -- Joystick / caméra direction
    local joystick = Vector3.new(0,0,0)
    if UserInputService.TouchEnabled then
        local camForward = cam.CFrame.LookVector
        local camRight = cam.CFrame.RightVector
        local move = player:GetMouse().Hit.Position - hrp.Position
        move = Vector3.new(move.X,0,move.Z).Unit
        moveDir = move
    else
        moveDir = cam.CFrame.LookVector
    end

    local velocity = moveDir * speed
    if ascend then velocity += Vector3.new(0, speed, 0) end
    if descend then velocity -= Vector3.new(0, speed, 0) end

    hrp.Velocity = velocity
end)

