local GameController = require("client.controllers.GameController")
local FlexLove = require("libs.FlexLove")
local Color = FlexLove.Color

local SelectName = {}
SelectName.__index = SelectName

function SelectName.new()
	local self = setmetatable({}, SelectName)

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
		text = "Select your name:",
		textAlign = "center",
		textSize = 35,
		width = "100%",
		textColor = Color.new(1, 1, 1, 1),
		margin = { bottom = 10 },
	})

	-- Name input
	local NameInput = FlexLove.new({
		editable = true,
		parent = self.window,
		text = "",
		textAlign = "center-left",
		textSize = "md",
		width = "30%",
		backgroundColor = Color.new(1, 1, 1, 1),
		textColor = Color.new(0, 0, 0, 1),
		onEnter = SubmitName,
	})

	function SubmitName()
		GameController.selectName(NameInput.text)
	end

	-- Submit button
	FlexLove.new({
		parent = self.window,
		text = "Submit",
		textAlign = "center",
		backgroundColor = Color.new(1, 1, 1, 1),
		textColor = Color.new(0, 0, 0, 1),
		width = "10%",
		height = "3%",
		textSize = 15,
		onEvent = function(element, event)
			if event.type == "click" then
				SubmitName()
			end
		end,
	})

	return self
end

function SelectName:destroy()
	self.window:destroy()
	for k in pairs(self) do
		self[k] = nil
	end
end

return SelectName
