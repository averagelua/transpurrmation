local CharacterController = {}
CharacterController.__index = CharacterController

function CharacterController.new(CharacterData, CurrentWorld)
	local self = setmetatable({}, CharacterController)

	self.CharacterData = CharacterData
	self.CurrentWorld = CurrentWorld

	local characterWidth = CharacterData.image:getWidth()
	local characterHeight = CharacterData.image:getHeight()

	self.body = love.physics.newBody(CurrentWorld, CharacterData.position.x, CharacterData.position.y, "dynamic")
	self.body:setFixedRotation(true)

	self.shape = love.physics.newRectangleShape(characterWidth, characterHeight)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setRestitution(0)

	-- for ground detection
	self.footShape = love.physics.newRectangleShape(0, characterHeight / 2 + 2, characterWidth - 4, 4)
	self.footFixture = love.physics.newFixture(self.body, self.footShape, 1)
	self.footFixture:setRestitution(0)
	self.footFixture:setSensor(true)

	self.footFixture:setUserData("player_foot")

	self.groundContacts = 0
	self.lastJumpTime = 0

	local function beginContact(a, b, coll)
		if a:getUserData() == "player_foot" or b:getUserData() == "player_foot" then
			self.groundContacts = self.groundContacts + 1
		end
	end

	local function endContact(a, b, coll)
		if a:getUserData() == "player_foot" or b:getUserData() == "player_foot" then
			self.groundContacts = math.max(0, self.groundContacts - 1)
		end
	end

	CurrentWorld:setCallbacks(beginContact, endContact, nil, nil)

	return self
end

function CharacterController:Update(dt)
	local vx, vy = self.body:getLinearVelocity()

	if love.keyboard.isDown("right") then
		self.body:setLinearVelocity(50, vy)
	elseif love.keyboard.isDown("left") then
		self.body:setLinearVelocity(-50, vy)
	else
		self.body:setLinearVelocity(0, vy)
	end

	if love.keyboard.isDown("up") then
		if self.groundContacts > 0 and os.clock() - self.lastJumpTime > 0.3 then
			self.lastJumpTime = os.clock()
			self.body:applyLinearImpulse(0, -15)
		end
	end

	self.CharacterData.position.x = self.body:getX()
	self.CharacterData.position.y = self.body:getY()

	if self.CharacterData.position.y > love.graphics.getHeight() then
		print("Fell out of world...")
	end
end

function CharacterController:Destroy()
	for k, v in pairs(self) do
		self[k] = nil
	end
end

return CharacterController
