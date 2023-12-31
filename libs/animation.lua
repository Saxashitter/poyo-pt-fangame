local animation = {}
animation.manager = {}

local function getAllAnims(path)
	local var = {}
	local folders = love.filesystem.getDirectoryItems(path)
	for _,folder in ipairs(folders) do
		local files = love.filesystem.getDirectoryItems(path..'/'..folder)
		table.sort(files)

		for _,file in ipairs(files) do
			if not var[folder] then
				var[folder] = {}
			end

			local image = love.graphics.newImage(path..'/'..folder..'/'..file)
			table.insert(var[folder], image)
		end
	end
	
	return var
end

function animation:newObject(object, path, anim, fps)
	local savedanims = getAllAnims(path)
	self.manager[object] = {
		anims = savedanims,
		
		fps = fps or 24,
		frame = 1,
		name = anim or "idle",
		
		time = 0,
		speed = 1,
	}
end

function animation:update(dt)
	for obj,data in pairs(self.manager) do
		data.time = data.time + (dt*data.speed)
		
		if data.time > 1/data.fps then
			data.frame = data.frame+1
			data.time = 0
			
			if not data.anims[data.name][data.frame] then
				data.frame = 1
			end
		end
	end
end

function animation:changeAnimation(obj, name, fps)
	local anim = self.manager[obj]
	if not anim then return end
	if anim.name == name then return end

	anim.frame = 1
	anim.time = 0
	anim.fps = fps or 1
	anim.name = name or "idle"
	anim.speed = 1
end

return animation