local pillar = {}

pillar.x = 0
pillar.y = 0
pillar.width = 32
pillar.height = 96
pillar.dead = false
pillar.sprite = love.graphics.newImage('assets/sprites/pillar/normal/1.png')

function pillar:update()
	local c_players = playerColliding(self)
	if #c_players > 0 then
		pillar.dead = true
		if currentSong() ~= 'boss_winning' then
			changeMusic('boss_winning', 'ogg', false)
		end
	end
end

function pillar:draw()
	love.graphics.draw(self.sprite, self.x, self.y)
end

return pillar