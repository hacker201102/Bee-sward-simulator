-- Script pour faire danser ton personnage

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Créer l'animation
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://507771019" -- Dance Animation

-- Vérifier ou créer un Animator
local animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
    animator = Instance.new("Animator")
    animator.Parent = humanoid
end

-- Charger et jouer l'animation
local track = animator:LoadAnimation(animation)
track:Play()

-- Optionnel : arrêter après 10 secondes
-- task.wait(10)
-- track:Stop()
