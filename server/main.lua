--[[
-- Server design --

Need to store:
RoundTime = How much round time is left
CurrentMapData = Data for the current map of the round
- StartLocation = The current map's start location (x,y)
- FishLocation = The current map's fish location (x,y)
ShamanObjects = The current round's shaman objects
ClientCharacterNames = Client -> string dict
  - Saves the selected name of a client
ClientCharacterData = Client -> CharacterData dict
  - CharacterData includes: name, isShaman, hasFish, position (x,y)

Game loop:
While there are no players, wait
Select a map at random
Find the location of the starting point and the fish from map data
Instruct clients to create the map
For each currently playing player (players that selected their name), create a server character for them
- Of all the players, randomly select 1 to be the shaman, this reflects in their data
- Inform that player of their character so that they can create the client version
- Inform all players of the other players so that they can create visuals for them as well
  - When informing a client of a character thats not theirs, the name must be sent as well
Start round timer countdown
Every time round timer decrements by 1, update clients with new round timer information to visually display
When roud timer reaches 0, roud ends (go to round end proceedure)

When receiving a packet requesting a movement, update the position of that player's character and replicate it to other clients
When a new player connects
- Send them the current map to load it
- Send them all the players and begin replicating to them as well
- Do not give them their own character yet
When a player selects their name
- Save their name in a map client -> name on the server
When a player disconnects or dies
- Send to all players to destroy that player's character
- Remove them from the characters
- If the current characters (alive) are 0, end the round (go to round end proceedure)

-- TODO:

When receiving a shaman command to place an object
- Check that the client actually owns the shaman
- register the placed object in a list on the server
- Inform all clients of the placed object for them to create
When a player reports having touched the fish
- Check their distance to the fish, if its less than a reasonable threshold, give them the fish
- toggle the 'hasFish' property in their CharacterData
- replicate this change to all clients (including this player) to visually add a fish to their back
When a player reports having touched the home
- Check their distance to home, if it is not within a reasonable threshold, return
- Check if they have fish, if they dont, return
- Destroy their character
- Send a chat message announcing that '[their-selected-username] just collected the fish!' with a special server color

Types of Shaman objects:
Plank (Anchored)
Box (Light)
Anvil (Heavy)
Balloon (Floats)

---

When receiving a packet to send a chat message
- Perform filtering on the message content
- Forward the name of the client and the message content to the other players to be visually displayed

When the round ends:
Inform clients of "round end" (this will cause them to delete all characters, objects, and map)
Clear the current server shaman objects and character list
Begin the gameloop cycle again

]]

local sock = require("shared.libs.sock")
local tableutil = require("shared.libs.tableutil")

local MAPS_DIRECTORY = "maps"
local ROUND_LENGTH = 120 -- 2 minutes

local RoundTime = 0
local LastReplicatedRoundTime = nil
local RoundIsOngoing = false
local CurrentMapData = nil
local CurrentSpawnLocation = nil
local CurrentGoalLocation = nil
local ShamanObjects = {}
local ClientCharacterNames = {}
local ClientCharacterData = {}

-- Informs Client to create CurrentMapData locally
local function SendMaptoClient(Client)
	Client:send("loadMap", CurrentMapData)
end

local function DestroyCharacter(Client)
	if ClientCharacterData[Client] then
		Server:sendToAllBut(Client, "destroyCharacter", ClientCharacterData[Client].id)
		ClientCharacterData[Client] = nil
	end
	ClientCharacterNames[Client] = nil
end

local function EndRound()
	-- TODO: End the round
	Server:sendToAll("roundEnd")

	RoundIsOngoing = false

	RoundTime = 0
	LastReplicatedRoundTime = nil

	CurrentMapData = nil
	CurrentSpawnLocation = nil
	CurrentGoalLocation = nil

	-- TODO: Replace with appropriate cleaning mechanism
	for _, Object in ShamanObjects do
		Object:Destroy()
	end
	ShamanObjects = {}
end

local function UpdatePosition(Client, Position)
	if
		ClientCharacterData[Client] == nil
		or type(Position) ~= "table"
		or type(Position.x) ~= "number"
		or type(Position.y) ~= "number"
	then
		return
	end

	-- TODO: Add check here for when the character falls out of bounds and destroy their character

	local NewPosition = { x = Position.x, y = Position.y }
	ClientCharacterData[Client].position = NewPosition
	Server:sendToAllBut(Client, "updatePosition", {
		id = ClientCharacterData[Client].id,
		position = NewPosition,
	})
end

local function SelectUsername(Client, Username)
	if ClientCharacterNames[Client] ~= nil or type(Username) ~= "string" then
		return
	end
	ClientCharacterNames[Client] = Username
end

local function SendMessage(Client, Message)
	if type(Message) ~= "string" then
		return
	end

	local Username = ClientCharacterNames[Client]
	if Username == nil then
		return
	end

	-- TODO: filter 'Message' content

	Server:sendToAll("createMessage", {
		username = Username,
		content = Message,
	})
end

function love.load()
	Server = sock.newServer("*", 22122)

	Server:on("connect", function(data, client)
		print(client, "connected")
		if CurrentMapData then
			SendMaptoClient(client)
		end
		for _, CharacterData in ClientCharacterData do
			client:send("createCharacter", CharacterData)
		end
	end)

	Server:on("disconnect", function(data, client)
		print(client, "disconnected")
		DestroyCharacter(client)
	end)

	Server:on("updatePosition", function(data, client)
		UpdatePosition(client, data)
	end)

	Server:on("selectUsername", function(data, client)
		SelectUsername(client, data)
	end)

	Server:on("sendMessage", function(data, client)
		SendMessage(client, data)
	end)
end

local function StartRound()
	-- TODO: Begin round
	-- Select random map
	local AvailableMaps = love.filesystem.getDirectoryItems(MAPS_DIRECTORY)
	local SelectedMap = AvailableMaps[math.random(1, #AvailableMaps)]:gsub(".lua", "")

	-- Find start and goal locations
	local MapData = require(MAPS_DIRECTORY .. "/" .. SelectedMap)

	for _, Layer in ipairs(MapData.layers) do
		if Layer.type == "objectgroup" and Layer.name == "items" then
			for _, Object in Layer.objects do
				if Object.properties["spawn"] then
					CurrentSpawnLocation = { x = Object.x, y = Object.y }
				elseif Object.properties["goal"] then
					CurrentGoalLocation = { x = Object.x, y = Object.y }
				end
			end
		end
	end

	if not CurrentSpawnLocation or not CurrentGoalLocation then
		print(("Map %s doesn't have both spawn and goal objects."):format(SelectedMap))

		CurrentSpawnLocation = nil
		CurrentGoalLocation = nil

		return
	end

	-- Inform clients to load map
	Server:sendToAll("loadMap", MapData)

	-- Select shaman and load characters
	local CharacterId = 0 -- unique character identifier
	local SelectedShaman = tableutil.RandomKey(ClientCharacterNames)

	for Client, Username in ClientCharacterNames do
		local NewCharacterData = {
			id = CharacterId,
			name = Username,
			isShaman = Client == SelectedShaman,
			hasFish = false,
			position = CurrentSpawnLocation,
		}
		ClientCharacterData[Client] = NewCharacterData
		CharacterId = CharacterId + 1

		Client:send("createSelf", NewCharacterData)
		Server:sendToAllBut(Client, "createCharacter", NewCharacterData)
	end

	CurrentMapData = MapData
	RoundIsOngoing = true
	RoundTime = ROUND_LENGTH
end

function love.update(deltaTime)
	if RoundIsOngoing then
		-- Check round state
		RoundTime = RoundTime - deltaTime
		local RoundTimeCeil = math.ceil(RoundTime)
		if RoundTimeCeil ~= LastReplicatedRoundTime then
			-- TODO: Replicate RoundTimeCeil
			LastReplicatedRoundTime = RoundTimeCeil
			Server:sendToAll("roundTimer", LastReplicatedRoundTime)
		end

		-- If time runs out or all players die, end the round.
		if RoundTimeCeil <= 0 or next(ClientCharacterData) == nil then
			EndRound()
		end
	else
		if #ClientCharacterNames > 0 or not RoundIsOngoing then -- debugging condition
			StartRound()
		end
	end
	Server:update()
end
