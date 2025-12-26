-- Fly MOBILE
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local flying = false
local speed = 50
local moveUp = false
local moveDown = false

-- Bouton Fly
ContextActionService:BindAction("ToggleFly", function(_, state)
    if state == Enum.UserInputState.Begin then
        flying = not flying
        humanoid.PlatformStand = flying
        print("Fly:", flying)
    end
end, true)

ContextActionService:SetTitle("ToggleFly", "FLY")
ContextActionService:SetPosition("ToggleFly", UDim2.new(0.8,0,0.6,0))

-- Monter
ContextActionService:BindAction("FlyUp", function(_, state)
    moveUp = state == Enum.UserInputState.Begin
end, true)

ContextActionService:SetTitle("FlyUp", "↑")
ContextActionService:SetPosition("FlyUp", UDim2.new(0.9,0,0.45,0))

-- Descendre
ContextActionService:BindAction("FlyDown", function(_, state)
    moveDown = state == Enum.UserInputState.Begin
end, true)

ContextActionService:SetTitle("FlyDown", "↓")
ContextActionService:SetPosition("FlyDown", UDim2.new(0.9,0,0.55,0))

-- Mouvement
RunService.RenderStepped:Connect(function()
    if not flying then return end

    local cam = workspace.CurrentCamera
    local direction = cam.CFrame.LookVector * speed

    if moveUp then
        direction += Vector3.new(0, speed, 0)
    end
    if moveDown then
        direction -= Vector3.new(0, speed, 0)
    end

    hrp.Velocity = direction
end)
