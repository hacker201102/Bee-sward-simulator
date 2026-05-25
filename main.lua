local tool = script.Parent
local handle = tool:WaitForChild("Handle")

tool.Equipped:Connect(function()
	handle.Transparency = 0
end)

tool.Unequipped:Connect(function()
	handle.Transparency = 1
end)