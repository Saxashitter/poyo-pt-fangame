local lovepad = nil
local controls = {}

function controls:makekey(index, key, key2)
	if not isMobile and key then
		self.buttons[index] = key
	elseif isMobile and key2 then
		self.buttons[index] = key2
	end
	self.inputs[index] = 0
end

function controls:init()
	self.buttons = {}
	self.inputs = {}
	if isMobile then
		lovepad = require 'libs.lovepad'
		lovepad:setGamePad()
	end
	
	self:makekey('left', 'a', 'Left')
	self:makekey('down', 's', 'Down')
	self:makekey('up', 'w', 'Up')
	self:makekey('right', 'd', 'Right')
	
	self:makekey('jump', 'space', 'A')
	self:makekey('run', 'lshift', 'B')

	self:makekey('left2', 'left')
	self:makekey('right2', 'right')
	self:makekey('jump2', 'up')
	self:makekey('run2', 'l')
end

function controls:update()
	if isMobile then
		lovepad:update()
	
		for _,key in pairs(self.buttons) do
			self.inputs[_] = lovepad:isDown(key) and self.inputs[_]+1 or 0
		end
	else
		for _,key in pairs(self.buttons) do
			self.inputs[_] = love.keyboard.isDown(key) and self.inputs[_]+1 or 0
		end
	end
end

function controls:draw()
	if isMobile then
		lovepad:draw()
	end
end

return controls