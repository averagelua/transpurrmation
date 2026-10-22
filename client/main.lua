local FlexLove = require("libs.FlexLove")
local ScreenController = require("controllers.ScreenController")
local GameController = require("controllers.GameController")
local WorldController = require("controllers.WorldController")

function love.load()
	FlexLove.init()
	love.keyboard.setKeyRepeat(true) -- needed for text editing (arrows, backspace, etc.)
	love.window.setMode(960, 640)

	ScreenController.init()
	ScreenController.setScreen("MainMenu")
end

function love.update(dt)
	FlexLove.update(dt)
	GameController.update(dt)
	WorldController.update(dt)
end

function love.draw()
	FlexLove.draw()
	WorldController.draw()
end

function love.quit()
	GameController.disconnect()
end

-- Wire these hooks to enable responsive layout, text input, scrolling,
-- keyboard navigation, and touch. Each FlexLove.* function here mirrors
-- the corresponding love callback and is safe to call even if unused.
function love.resize()
	FlexLove.resize()
end
function love.textinput(text)
	FlexLove.textinput(text)
end
function love.keypressed(key, sc, rep)
	FlexLove.keypressed(key, sc, rep)
end
function love.wheelmoved(dx, dy)
	FlexLove.wheelmoved(dx, dy)
end
function love.touchpressed(id, x, y, dx, dy, p)
	FlexLove.touchpressed(id, x, y, dx, dy, p)
end
function love.touchmoved(id, x, y, dx, dy, p)
	FlexLove.touchmoved(id, x, y, dx, dy, p)
end
function love.touchreleased(id, x, y, dx, dy, p)
	FlexLove.touchreleased(id, x, y, dx, dy, p)
end
