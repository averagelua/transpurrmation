local sti = require("libs.sti")
local CharacterController = require("client.controllers.CharacterController")

local WorldController = {}

local currentWorld

function WorldController.loadMap(map)
	-- Destroy character on a new world
	CharacterController.destroyCharacter()

	-- Destroy current world
	if currentWorld then
		currentWorld:destroy()
	end

	love.physics.setMeter(32)

	map = sti(map, { "box2d" })

	world = love.physics.newWorld(0, 0)

	currentWorld = world
	return {
		map = map,
		world = world,
	}
end

return WorldController
