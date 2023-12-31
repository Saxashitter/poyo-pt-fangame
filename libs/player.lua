local players = {}
-- functions for player
local function keyHandler(p)
    for input, key in pairs(p.rawkeys) do
    		if controls.inputs[key] ~= nil then
      		p.keys[input] = (controls.inputs[key])
      	end
    end
end

local updatePlayer = function(p,dt)
		if p.rawkeys then
  	  keyHandler(p)
  	end
    p:update(dt)
end

function playerColliding(obj)
	local c_players = {}
	
	for _,p in ipairs(players) do
		if p.x < obj.x+obj.width
		and obj.x < p.x+p.width
		and p.y < obj.y+obj.height
		and obj.y < p.y+p.height then
			table.insert(c_players, p)
		end
	end
	
	return c_players
end

-- players table

function players.initPlayer(char, x, y, keys)
		local char = char or "poyo"
		
		local player = modsReq(char)
		player.rawkeys = keys
		player.keys = {}
	  for input, key in ipairs(player.rawkeys) do
	      player.keys[input] = 0
	  end
		player:init(x,y)

		table.insert(players, player)
end

function players:update(dt)
    for _, p in ipairs(self) do
        updatePlayer(p,dt)
    end
end

function players:draw()
    for _, p in ipairs(self) do
    		p:draw()
    end
end

return players
