local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local statsGui = gui:WaitForChild("CharacterStats")

local remote = ReplicatedStorage.Events:WaitForChild("UpdateCharacterStats")

local containers = {
	trust = statsGui:WaitForChild("TrustContainer"),
	friendship = statsGui:WaitForChild("FriendshipContainer"),
	respect = statsGui:WaitForChild("RespectContainer"),
	comfort = statsGui:WaitForChild("ComfortContainer")
}

remote.OnClientEvent:Connect(function(_, stats)
	for stat, container in pairs(containers) do
		local label = container:WaitForChild("LevelText")
		label.Text = math.floor(stats[stat] or 0) .. "/100"
	end
end)
