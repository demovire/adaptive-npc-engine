local EmotionsHandler = {}
EmotionsHandler.__index = EmotionsHandler

function EmotionsHandler.new(model, decals)
	local self = setmetatable({}, EmotionsHandler)

	self.model = model
	self.decals = decals

	self.stats = {
		trust = 50,
		friendship = 50,
		respect = 50,
		comfort = 50
	}

	return self
end

function EmotionsHandler:GetDominantEmotion(emotions)
	local highest = -math.huge
	local dominant = "neutral"

	for emotion, value in pairs(emotions) do
		if value > highest then
			highest = value
			dominant = emotion
		end
	end

	return dominant
end

function EmotionsHandler:UpdateFace(mood)
	local head = self.model:FindFirstChild("Head")
	if not head then return end

	local face = head:FindFirstChild("face")
	if not face then return end

	face.Texture = self.decals[mood] or self.decals.neutral
end

function EmotionsHandler:UpdateStats(emotions)
	self.stats.trust += (emotions.trust - 50) * 0.1
	self.stats.friendship += (emotions.happiness - 50) * 0.1
	self.stats.respect += (50 - emotions.anger) * 0.05
	self.stats.comfort += (50 - emotions.fear) * 0.05

	for k, v in pairs(self.stats) do
		self.stats[k] = math.clamp(v, 0, 100)
	end
end

function EmotionsHandler:Process(parsed)
	local dominant = self:GetDominantEmotion(parsed.emotions)

	self:UpdateFace(dominant)
	self:UpdateStats(parsed.emotions)
end

function EmotionsHandler:GetStats()
	return self.stats
end

return EmotionsHandler
