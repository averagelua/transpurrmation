local ScreensContainerDirectory = "client.screens"

local CurrentScreen = nil
local ScreenManager = {}

function ScreenManager.hideScreen()
	if CurrentScreen then
		CurrentScreen:destroy()
		CurrentScreen = nil
	end
end

function ScreenManager.setScreen(ScreenName)
	print("Setting CurrentScreen to " .. ScreenName)
	if CurrentScreen then
		ScreenManager.hideScreen()
	end

	local ScreenModule = require(ScreensContainerDirectory .. "." .. ScreenName)
	CurrentScreen = ScreenModule.new()
end

function ScreenManager.init() end

return ScreenManager
