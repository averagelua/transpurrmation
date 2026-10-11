local sock = require("libs.sock")

local currentMap
local clientCharacterNames = {}

local function loadClientCharacter(client) end

local function loadMapOnClient(client, mapName)
	local map = love.filesystem.load("server.maps." .. mapName .. ".lua")()
	client:send("loadMap", map)
end

local function loadMap(mapName)
	for _, client in ipairs(Server:getClients()) do
		loadMapOnClient(client, mapName)
	end
	currentMap = mapName
end

function love.load()
	Server = sock.newServer("*", 22122)

	Server:on("connect", function(data, client)
		print(client, "connected")
		if currentMap then
			loadMapOnClient(client, currentMap)

			-- debugging
			loadClientCharacter(client)
		end
	end)

	Server:on("disconnect", function(data, client)
		print(client, "disconnected")
	end)

	Server:on("selectName", function(data, client)
		print(data, client)
	end)

	print("Server setup complete")

	-- Test map load
	loadMap("map1")
end

function love.update()
	Server:update()
end
