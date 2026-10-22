local sock = require("shared.libs.sock")
local ScreenController = require("controllers.ScreenController")
local CharacterController = require("controllers.CharacterController")
local WorldController = require("controllers.WorldController")

local GameController = {}

function GameController.selectName(Name)
	print("selectName: " .. Name)

	Client:send("selectUsername", Name)

	ScreenController.hideScreen()
end

function GameController.start()
	-- Establish client/server connection
	Client = sock.newClient("localhost", 22122)

	Client:on("connect", function(data)
		print("Client connected to the server.")
	end)

	Client:on("loadMap", function(data)
		WorldController.loadMap(data)
	end)

	Client:on("createSelf", function(CharacterData)
		WorldController.addCharacter(CharacterData, true)
	end)

	Client:on("createCharacter", function(CharacterData)
		WorldController.addCharacter(CharacterData)
	end)

	Client:on("roundTimer", function(RoundTime) end)

	Client:on("updatePosition", function(CharacterId, Position) end)

	Client:on("destroyCharacter", function(CharacterId) end)

	Client:on("roundEnded", function() end)

	Client:connect()

	ScreenController.setScreen("SelectName")
end

function GameController.update(dt)
	if Client then
		Client:update()
	end
end

function GameController.disconnect()
	if Client then
		Client:disconnectNow()
		Client = nil
	end
end

return GameController
