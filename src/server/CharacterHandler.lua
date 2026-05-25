local ChatService = game:GetService("Chat")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local EmotionsHandler = require(script.Parent.EmotionsHandler)

local UpdateCharacterStats = ReplicatedStorage.Events.UpdateCharacterStats

local CharacterHandler = {}
CharacterHandler.__index = CharacterHandler

function CharacterHandler.new(model, name, personality, gender, openRouterClient, decals)
	local self = setmetatable({}, CharacterHandler)

	self.model = model
	self.name = name
	self.personality = personality
	self.gender = gender

	self.client = openRouterClient
	self.decals = decals

	self.emotions = EmotionsHandler.new(model, decals)

	self.history = {
		{
			role = "system",
			content = self:_buildSystemPrompt()
		}
	}

	return self
end

function CharacterHandler:Chat(message)
	local head = self.model:FindFirstChild("Head")
	if not head then return end

	ChatService:Chat(head, message, Enum.ChatColor.White)
end

function CharacterHandler:_summarizeHistory()
	local summary = self.client:PostMessage({
		{
			role = "system",
			content = "Summarize this conversation in 2-3 sentences."
		},
		table.unpack(self.history)
	})

	self.history = {
		{ role = "system", content = self:_buildSystemPrompt() },
		{ role = "assistant", content = "Context: " .. (summary or "") }
	}
end

function CharacterHandler:SendMessage(player, playerMessage)

	if #self.history > 10 then
		self:_summarizeHistory()
	end

	table.insert(self.history, {
		role = "user",
		content = playerMessage
	})

	local response = self.client:PostMessage(self.history)
	if not response then return end

	local parsed = HttpService:JSONDecode(response)
	table.insert(self.history, {
		role = "assistant",
		content = parsed.message
	})

	self.emotions:Process(parsed)

	UpdateCharacterStats:FireClient(
		player,
		self.name,
		self.emotions:GetStats()
	)

	self:Chat(parsed.message)

	return parsed
end

function CharacterHandler:_buildSystemPrompt()
	return string.format([[
    You are %s, a %s NPC in a game.
    Gender: %s
    
    Stay in character.
    
    Return ONLY JSON:
    {
      "message": "",
      "emotions": {
        "happiness": 0-100,
        "anger": 0-100,
        "fear": 0-100,
        "trust": 0-100,
        "surprise": 0-100
      },
      "mood": "",
      "action": ""
    }
]], self.name, self.personality, self.gender)
end

return CharacterHandler
