local collisions = {}

local function colliding(p,b,type,exte)
	local x = true
	local y = true
	local ext = 0
	if b.intangible then return false end
	
	if not type or type == 1 then
		x = p.x < (b.x+b.width) and
        b.x < (p.x+p.width)
	end
	
	if not type or type == 2 then
		y = p.y < (b.y+b.height) and
        b.y < (p.y+p.height)
	end
	
	return x and y
end

local function slopeY(p,b)
	local x = b.width / (p.x - b.x)
	local height = (b.ly + b.ry) / x
	if b.ly > b.ry then height = -height end
	local y = math.min(b.y+b.height, math.max(b.y, b.y + height))
	
	return y
end

local function return_x_collision_depth(p,b)
	local y1,y2
	if p.x+(p.width/2) > b.x+(b.width/2) then
		y1 = p.x
		y2 = b.x+b.width
	elseif p.x+(p.width/2) <= b.x+(b.width/2) then
		y1 = p.x+p.width
		y2 = b.x
	end
  return y1-y2
end

local function return_y_collision_depth(p,b)
	local y1,y2
	if p.y+(p.height/2) > b.y+(b.height/2) then
		y1 = p.y
		y2 = b.y+b.height
	elseif p.y+(p.height/2) <= b.y+(b.height/2) then
		y1 = p.y+p.height
		y2 = b.y
	end
  return y1-y2
end

local function tile_x_collision(p)
	local coltype = 0
	for _,x in pairs(map.tiles) do
    for _,b in pairs(x) do
    	if colliding(p,b)
    	and b.type ~= "slope" 
    	and (not p.sloping or p.sloping and b.y < p.y)
    	then
    		local depth = return_x_collision_depth(p,b)
    		p.x = p.x - depth
    		p.mom.x = 0
    		coltype = 1
    	end
    end
	end

	return coltype
end

local function y_col(p,b)
	local collision_type = 0
	if colliding(p,b) then
		if b.type ~= "slope" 
		and not b.intangible 
		and not p.sloping then
			depth = return_y_collision_depth(p,b)
			if depth >= 0 then
				p.ac.y = 0
				p.mom.y = GLOBAL_GRAVITY
				p.grounded = true
				collision_type = 1
			else
				collision_type = 2
			end
			p.y = p.y - depth
		elseif not b.intangible and b.type == "slope" then
			local slopeY = slopeY(p,b)
			if p.y+p.height >= slopeY then
				p.sloping = b
				p.ac.y = 0
				p.mom.y = GLOBAL_GRAVITY
				collision_type = 0
				p.grounded = true
			end
		end
	end
	
	return collision_type
end

local function tile_y_collision(p)
	local wasgrounded = p.grounded
	local wassloping = p.sloping
	p.grounded = false
	p.sloping = nil
	
	local coltype = 0
	
	for _,x in pairs(map.tiles) do
		for _,y in pairs(x) do
			coltype = y_col(p,y)
		end
	end

	if p.sloping then
		local highestSlopeY
		
		for _,slope in pairs(map.slopes) do
			if slope.type == "slope"
			and colliding(p,slope)
			and (highestSlopeY == nil
			or highestSlopeY > slopeY(p,slope))
			then
				highestSlopeY = slopeY(p,slope)
			end
		end
		
		if highestSlopeY ~= nil then
			p.y = highestSlopeY-p.height
		end
	end
	return coltype
end

function collisions.tile(p,t)
	local func = tile_y_collision
	if not t then
		func = tile_x_collision
	end

	return func(p)
end

return collisions