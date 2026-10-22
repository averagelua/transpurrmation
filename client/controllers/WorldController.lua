local sti = require("shared.libs.sti.init")
local CharacterController = require("controllers.CharacterController")

local WorldController = {}

love.physics.setMeter(32)

local currentMap = nil
local currentWorld = nil
local currentCharacterController = nil

function WorldController.destroyMap()
	if currentMap then
		currentMap:destroy()
		currentMap = nil
	end
end

function WorldController.addCharacter(CharacterData, IsSelf)
	assert(currentMap, "Attempted to addCharacter before currentMap exists.")

	local spriteLayer = currentMap.layers["Sprite Layer"]
	spriteLayer.sprites[CharacterData.id] = {
		name = CharacterData.name,
		image = love.graphics.newImage("assets/sprites/cat.png"),
		x = CharacterData.position.x,
		y = CharacterData.position.y,
		r = 0,
	}

	if IsSelf then
		currentCharacterController = CharacterController.new(CharacterData)
	end
end

function WorldController.loadMap(map)
	local windowWidth = love.graphics.getWidth()
	local windowHeight = love.graphics.getHeight()

	print(windowWidth, windowHeight)

	currentMap = sti(map, { "box2d" })
	currentWorld = love.physics.newWorld(0, 0)

	currentMap:box2d_init(currentWorld)

	currentMap:addCustomLayer("Sprite Layer", 4)

	currentMap:resize(windowWidth, windowHeight)

	local spriteLayer = currentMap.layers["Sprite Layer"]
	spriteLayer.sprites = {}

	function spriteLayer:draw()
		for _, sprite in pairs(self.sprites) do
			local x = math.floor(sprite.x)
			local y = math.floor(sprite.y)
			local r = sprite.r
			love.graphics.draw(sprite.image, x, y, r) -- draw sprite image
			love.graphics.print(sprite.name, x, y) -- draw character name
		end
	end
end

function WorldController.update(dt)
	if currentMap then
		currentMap:update(dt)
	end
end

function WorldController.draw()
	if currentMap then
		love.graphics.setColor(1, 1, 1)
		currentMap:draw()
	end
end

return WorldController
