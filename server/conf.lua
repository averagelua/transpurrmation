-- Disables various visual modules unneeded for the server runtime
function love.conf(t)
	t.graphics = nil
	t.audio = nil
	t.sound = nil
end
