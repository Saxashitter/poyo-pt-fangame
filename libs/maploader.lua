local maploader = {}

local function addTile(v)
	if not map then return end
	local data = v.data
		
	for num,i in pairs(data) do
		if i and map.tilesets[i] then
			local newtile = {}
			
			local x = num
			local y = 0
			
			local vars = map.tilesets[i].properties
			
			while x > map.width/map.tilewidth do
				x = x - map.width/map.tilewidth
				y = y+1
			end
			if map.tilesets[i].image == "poyo_spawn.png" then
				PLAYER_SPAWN = {v.x + (x*map.tilewidth), v.y + (y*map.tilewidth)}
			elseif map.tilesets[i].image == "pillar_spawn.png" then
				local pillar = require('libs.pillar')
				
				pillar.x = v.x + (x*map.tilewidth)
				pillar.y = v.y + (y*map.tileheight) + 32 - pillar.height
				
				table.insert(objects, pillar)
			else
				newtile.x = v.x + (x * map.tilewidth)
				newtile.y = v.y + (y * map.tileheight)
				newtile.width = map.tilewidth
				newtile.height = map.tileheight
				
				local image = map.tilesets[i].image
				newtile.graphic = love.graphics.newImage('assets/maps/tiles/'..map.tilesets[i].image)
			
				if not (vars and vars.slope) then
					newtile.type = "tile"
				else
					newtile.type = "slope"
					newtile.ly = vars.ly
					newtile.ry = vars.ry
					
					table.insert(map.slopes, newtile)
				end
				newtile.type2 = "tile2"
	
				if not map.tiles[v.y+y] then
					map.tiles[v.y+y] = {}
				end
				map.tiles[v.y+y][v.x+x] = newtile
			end
		end
	end
end

local function addCollision(v)
	if not map then return end
	for _,obj in pairs(v.objects) do
		local x = obj.x+v.offsetx
		local y = obj.y+v.offsety
		local vars = {}
		
		for _,var in pairs(obj.properties) do
			local name = var.name
			local type = var.type
			local value
			
			if type == "Boolean" then
				value = (var.value == "true")
			else
				value = tonumber(var.value)
			end
			
			vars[name] = value
		end
		
		local t = {}
		if not vars.slope then
			t.x = x
			t.y = y
			t.width = obj.width
			t.height = obj.height
			t.type = "block"
			t.type2 = "block"
		else
			t.x = x
			t.y = y
			t.ly = vars.lefty
			t.ry = vars.righty
			t.width = obj.width
			t.height = obj.height
			t.type = "slope"
			t.type2 = "block"
		end
		table.insert(map.blocks, t)
	end
end

function maploader:loadMap(name)
	local rawmap = require('assets.maps.'..name)
	map = {}
	
	map.width = rawmap.width * rawmap.tilewidth
	map.height = rawmap.height * rawmap.tileheight
	
	map.tilewidth = rawmap.tilewidth
	map.tileheight = rawmap.tileheight
	
	map.raw_tiles = rawmap.layers
	map.tilesets = rawmap.tilesets
	
	map.tiles = {}
	map.blocks = {}
	map.slopes = {} -- exists to help code runtime
	
	local vars = rawmap.properties
	
	if vars and vars.music then
		changeMusic(vars.music, 'ogg')
	end
	
	for _,v in pairs(map.raw_tiles) do
		if v.type == "tilelayer" then
			addTile(v)
		elseif v.type == "objectgroup" then
			addCollision(v)
		end
	end
	
	map.raw_tiles = nil
end

local function drawTile(width,height)
	for _,i in pairs(map.tiles) do
		for _,tile in pairs(i) do
			if tile.x < camera.x+width
			and tile.y < camera.y+height
			and tile.x+tile.width > camera.x-width
			and tile.y+tile.height > camera.y-height then
				love.graphics.draw(tile.graphic, tile.x, tile.y)
			end
		end
	end
end

function maploader:draw(drawtype)
	local width = lovesize.getWidth()
	local height = lovesize.getHeight()
	drawTile(width/camera.scale,height/camera.scale)
end

function maploader:TileAtPos(rawx,rawy)
	local x = math.floor(rawx/map.tilewidth)
	local y = math.floor(rawy/map.tileheight)

	if not map.tiles[y] then return false end
	if not map.tiles[y][x] then return false end
	return map.tiles[y][x]
end
return maploader