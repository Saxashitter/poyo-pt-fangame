local state = {}

local focused_x
local chars
local cur_sel
local camera

local function loadCharacters(path)
	local path = path or 'assets/characters/'
	local folders = love.filesystem.getDirectoryItems(path)
	
	for _,folder in ipairs(folders) do
		local css_exists = love.filesystem.getInfo(path..folder..'/css')
		
		if css_exists then
			local data = json.decode(love.filesystem.read(path..folder..'/css/data.json'))
			data.image = love.graphics.newImage(path..folder..'/css/art.png')
			data.path = path..folder
			
			data.image:setFilter('nearest')
			
			table.insert(chars, data)
		end
	end
end

function state:enter()
	focused_x = lovesize.getWidth()/2
	chars = {}
	cur_sel = 1
	
	loadCharacters()
	loadCharacters(game_name..'/mods/characters/')

	camera = Camera(focused_x)
	
	changeMusic('choose_your_dumbass', 'ogg', true)
end

local function change_selection(num)
	local length = #chars
	
	if (cur_sel+num <= length and cur_sel+num >= 1) then
		cur_sel = cur_sel + num
	end
	focused_x = (lovesize.getWidth()/2) + (lovesize.getWidth() * (cur_sel-1))
end

function state:update()
	local left = (controls.inputs['left'] == 1)
	local right = (controls.inputs['right'] == 1)
	local accept = (controls.inputs['jump'] == 1)
	
	if left then
		change_selection(-1)
	elseif right then
		change_selection(1)
	end
	
	if accept then
		global.character = {}
		global.character[1] = chars[cur_sel].path
		gamestate.switch(states['play_state'])
	end
	
	camera.x = camera.x + round((focused_x - camera.x) / 4, 40)
end

function img_scale( image, newHeight )
    local currentWidth, currentHeight = image:getDimensions()
    return ( newHeight / currentHeight )
end

function state:draw()
	love.graphics.printf(chars[cur_sel].name or "Nil", 0-lovesize.getWidth()/2, 4, lovesize.getWidth(), "center", 0, 2)
	
	camera:attach()
		for i,char in ipairs(chars) do
			local x = lovesize.getWidth()/2
			local y = lovesize.getHeight()/2
			
			x = x + (lovesize.getWidth()*(i-1))
			
			local scale = img_scale(char.image, lovesize.getHeight()*0.75)
			love.graphics.draw(
				char.image,
				x,
				y,
				0,
				scale,
				nil,
				char.image:getWidth()/2,
				char.image:getHeight()/2
			)
		end
	camera:detach()
end
return state