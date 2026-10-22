local GameController = require("controllers.GameController")
local FlexLove = require("libs.FlexLove")
local Color = FlexLove.Color

local MainMenu = {}
MainMenu.__index = MainMenu

function MainMenu.new()
	local self = setmetatable({}, MainMenu)

	self.window = FlexLove.new({
		x = "0%",
		y = "0%",
		z = 1000,
		width = "100%",
		height = "100%",
		scaleCorners = 3,
		positioning = "flex",
		flexDirection = "vertical",
		justifyContent = "center",
		alignItems = "center",
		gap = 10,
	})

	-- Header
	FlexLove.new({
		parent = self.window,
		text = "Transpurrmation",
		textAlign = "center",
		textSize = 50,
		width = "100%",
		textColor = Color.new(1, 1, 1, 1),
		margin = { bottom = 10 },
	})

	-- Play button
	FlexLove.new({
		parent = self.window,
		text = "Play",
		textAlign = "center",
		backgroundColor = Color.new(145 / 255, 246 / 255, 255 / 255, 1),
		textColor = Color.new(0, 0, 0, 1),
		width = "25%",
		height = "5%",
		textSize = 25,
		onEvent = function(element, event)
			if event.type == "click" then
				GameController.start()
			end
		end,
	})

	-- Settings button
	-- FlexLove.new({
	-- 	parent = self.window,
	-- 	text = "Settings",
	-- 	textAlign = "center",
	-- 	backgroundColor = Color.new(145 / 255, 246 / 255, 255 / 255, 1),
	-- 	textColor = Color.new(0, 0, 0, 1),
	-- 	width = "25%",
	-- 	height = "5%",
	-- 	textSize = 25,
	-- })

	return self
end

function MainMenu:destroy()
	self.window:destroy()
	for k in pairs(self) do
		self[k] = nil
	end
end

return MainMenu
