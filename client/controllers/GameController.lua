local sock = require("libs.sock")
local ScreenController = require("client.controllers.ScreenController")
local CharacterController = require("client.controllers.CharacterController")
local WorldController = require("client.controllers.WorldController")

local GameController = {}

function GameController.selectName(Name)
	print("selectName: " .. Name)

	Client:send("selectName", Name)

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

	Client:connect()

	ScreenController.setScreen("SelectName")
end

function GameController.update()
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
