local sti = require("shared.libs.sti.init")
local CharacterController = require("controllers.CharacterController")

local WorldController = {}

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

	CharacterData.image = love.graphics.newImage("assets/sprites/cat.png")

	local spriteLayer = currentMap.layers["Sprite Layer"]
	spriteLayer.sprites[CharacterData.id] = {
		CharacterData = CharacterData,
		r = 0,
	}

	if IsSelf then
		currentCharacterController = CharacterController.new(CharacterData, currentWorld)
	end
end

function WorldController.loadMap(map)
	currentMap = sti(map, { "box2d" })

	local windowWidth = love.graphics.getWidth()
	local windowHeight = love.graphics.getHeight()

	print(windowWidth, windowHeight)
	currentMap:resize(windowWidth, windowHeight)

	currentWorld = love.physics.newWorld(0, 100)
	currentMap:box2d_init(currentWorld)

	currentMap:addCustomLayer("Sprite Layer", 4)
	local spriteLayer = currentMap.layers["Sprite Layer"]
	spriteLayer.sprites = {}

	function spriteLayer:draw()
		for _, sprite in pairs(self.sprites) do
			local x = math.floor(sprite.CharacterData.position.x) - sprite.CharacterData.image:getWidth() / 2
			local y = math.floor(sprite.CharacterData.position.y) - sprite.CharacterData.image:getHeight() * 2
			local r = sprite.r
			love.graphics.draw(sprite.CharacterData.image, x, y, r, 3, 3) -- draw sprite image
			love.graphics.print({ { 0, 0, 0 }, sprite.CharacterData.name }, x, y - 25) -- draw character name
		end
	end
end

function WorldController.updateCharacterPosition(characterId, newPosition) end

function WorldController.update(dt)
	if currentMap then
		currentMap:update(dt)
	end
	if currentWorld then
		currentWorld:update(dt)
	end
	if currentCharacterController then
		currentCharacterController:Update(dt)
	end
end

function WorldController.draw()
	if currentMap then
		love.graphics.setColor(1, 1, 1)
		currentMap:draw()
		-- currentMap:box2d_draw()
	end
end

return WorldController
