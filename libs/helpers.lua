local music = nil
local musname
local loop_music = false

function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

function lerp_clamp(value, sub, num)
    local fixedval = value

    if -num > fixedval then
        fixedval = fixedval + math.abs(sub)
        if fixedval > -num then
            fixedval = -num
        end
    end

    if fixedval > num then
        fixedval = fixedval - math.abs(sub)
        if fixedval < num then
            fixedval = num
        end
    end

    return fixedval, (fixedval == value)
end

function musicUpdate(dt)
	if (music and loop_music) then
		if not music:isPlaying() then
			music:play()
		end
	end
end

function changeMusic(song, ext, loop)
	if not (song and ext) then return end
	if song == music then return end

	if music then
		music:stop()
	end

	music = love.audio.newSource("assets/music/"..song..'.'..ext, 'stream')
	musname = song
	music:play()
	
	loop_music = (loop)
end

function currentSong()
	return musname
end

function modsReq(path)
	if not path then return end
	if not love.filesystem.exists(path)
	and not love.filesystem.exists(path..'.lua') then
		local path = string.gsub(path, "/", ".")
		return require('assets'..path)
	end

	if love.filesystem.isFile(path..'.lua') then
		return love.filesystem.load(path..'.lua')()
	else
		return love.filesystem.load(path..'/init.lua')()
	end
end
function jsonVarsToTable(table)
	if not table then return end

	local vars

	for _,var in ipairs(table) do
		local value = var.value
		if var.type == "Integer"
		or var.type == "Float" then
			value = tonumber(var.value)
		end
		
		if not vars then vars = {} end
		
		vars[var.name] = value
	end

	return vars
end