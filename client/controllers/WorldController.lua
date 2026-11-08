local sti = require("shared.libs.sti.init")
local CharacterController = require("controllers.CharacterController")

local WorldController = {}
WorldController.currentCharacterController = nil

local currentMap = nil
local currentWorld = nil

function WorldController.destroyMap()
	if currentMap then
		-- currentMap:destroy()
		currentMap = nil
	end
	if currentWorld then
		-- currentWorld:destroy()
		currentWorld = nil
	end
end

function WorldController.destroySelfCharacter()
	if WorldController.currentCharacterController then
		WorldController.currentCharacterController:Destroy()
		WorldController.currentCharacterController = nil
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
		WorldController.currentCharacterController = CharacterController.new(CharacterData, currentWorld)
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

			if sprite.CharacterData.hasFish then
				-- TODO: draw fish if character has
			end

			love.graphics.draw(sprite.CharacterData.image, x, y, r, 3, 3) -- draw sprite image
			love.graphics.print({ { 0, 0, 0 }, sprite.CharacterData.name }, x, y - 25) -- draw character name
		end
	end
end

function WorldController.destroyCharacter(characterId)
	if not currentMap then
		return
	end
	if
		WorldController.currentCharacterController
		and characterId == WorldController.currentCharacterController.CharacterData.id
	then
		WorldController.destroySelfCharacter()
	end
	currentMap.layers["Sprite Layer"].sprites[characterId] = nil
end

function WorldController.setHasFish(characterId)
	if not currentMap then
		return
	end
	currentMap.layers["Sprite Layer"].sprites[characterId].CharacterData.hasFish = true
end

function WorldController.updateCharacterPosition(characterId, newPosition)
	if not currentMap then
		return
	end
	currentMap.layers["Sprite Layer"].sprites[characterId].CharacterData.position = newPosition
end

function WorldController.roundEnded()
	WorldController.destroySelfCharacter()
	WorldController.destroyMap()
end

function WorldController.update(dt)
	if currentMap then
		currentMap:update(dt)
	end
	if currentWorld then
		currentWorld:update(dt)
	end
	if WorldController.currentCharacterController then
		WorldController.currentCharacterController:Update(dt)
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
