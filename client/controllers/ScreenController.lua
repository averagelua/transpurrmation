local ScreensContainerDirectory = "client.screens"
local ComponentsContainerDirectory = "client.ui-components"

local CurrentScreen = nil
local ScreenController = {}

function ScreenController.hideScreen()
	if CurrentScreen then
		CurrentScreen:destroy()
		CurrentScreen = nil
	end
end

function ScreenController.setScreen(ScreenName)
	print("Setting CurrentScreen to " .. ScreenName)
	if CurrentScreen then
		ScreenController.hideScreen()
	end

	local ScreenModule = require(ScreensContainerDirectory .. "." .. ScreenName)
	CurrentScreen = ScreenModule.new()
end

function ScreenController.createComponent(ComponentName)
	local ComponentModule = require(ComponentsContainerDirectory .. "." .. ComponentName)
	return ComponentModule.new()
end

function ScreenController.init() end

return ScreenController
