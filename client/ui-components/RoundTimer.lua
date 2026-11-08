local FlexLove = require("libs.FlexLove")
local Color = FlexLove.Color

local RoundTimer = {}
RoundTimer.__index = RoundTimer

function RoundTimer.new()
	local self = setmetatable({}, RoundTimer)

	self.container = FlexLove.new({
		x = "25%",
		y = "0%",
		z = 1000,
		width = "50%",
		height = "25%",
		scaleCorners = 3,
		text = "Round time: xx:xx",
		textColor = Color.new(0, 0, 0, 1),
		textSize = 50,
		textAlign = "center",
	})

	return self
end

function RoundTimer:SetTime(time)
	self.container.text = ("Round Time Left: %.2d:%.2d"):format(math.floor(time / 60), time % 60)
end

function RoundTimer:Destroy()
	self.container:destroy()
	for k in pairs(self) do
		self[k] = nil
	end
end

return RoundTimer
