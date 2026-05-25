local HttpService = game:GetService("HttpService")

local OpenRouterClient = {}
OpenRouterClient.__index = OpenRouterClient

function OpenRouterClient.new(model)
	local self = setmetatable({}, OpenRouterClient)

	self.model = model
	self.apiKey = HttpService:GetSecret("openrouter_api_key")
	self.url = "https://openrouter.ai/api/v1/chat/completions"

	return self
end

function OpenRouterClient:PostMessage(messages)
	local body = HttpService:JSONEncode({
		model = self.model,
		messages = messages
	})

	local success, response = pcall(function()
		return HttpService:RequestAsync({
			Url = self.url,
			Method = "POST",
			Headers = {
				["Authorization"] = "Bearer " .. self.apiKey,
				["Content-Type"] = "application/json"
			},
			Body = body
		})
	end)

	if not success or not response.Success then
		warn("OpenRouter request failed")
		return nil
	end

	local decoded = HttpService:JSONDecode(response.Body)
	return decoded.choices[1].message.content
end

return OpenRouterClient
