local state = {}

objects = {}
local focusedplayer = 1

function state:enter()
	focusedplayer = 1
	local keys = {
		['left'] = 'left',
		['right'] = 'right',
		['jump'] = 'jump',
		['run'] = 'run'
	}
	camera = Camera(PLAYER_SPAWN[1],PLAYER_SPAWN[2])
	camera:zoom(2)
	maploader:loadMap('export')
	players.initPlayer(global.character[1], PLAYER_SPAWN[1],PLAYER_SPAWN[2],keys)
	local keys2 = {
		['left'] = 'left2',
		['right'] = 'right2',
		['jump'] = 'jump2',
		['run'] = 'run2'
	}
	--players.initPlayer(PLAYER_SPAWN[1],PLAYER_SPAWN[2],keys2)
end

function state:update(dt)
	players:update()
	
	for _,obj in pairs(objects) do
		obj:update(dt)
	end
	
	animation:update(dt)
	local p = players[focusedplayer]
	
	if not p then return end
	camera.x = p.x
	camera.y = p.y
end

function state:draw()
	camera:attach()
		maploader:draw()
		
		for _,obj in pairs(objects) do
			obj:draw()
		end
		
		players:draw()
	camera:detach()
end

return state