local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local noclip = false

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

RunService.Stepped:Connect(function()
    if noclip and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.N then
        noclip = not noclip
        print("NoClip :", noclip and "ON" or "OFF")
    end
end)
