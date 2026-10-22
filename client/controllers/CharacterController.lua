local CharacterController = {}
CharacterController.__index = CharacterController

function CharacterController.new()
	local self = setmetatable({}, CharacterController)

	return self
end

function CharacterController:Destroy() end

return CharacterController
