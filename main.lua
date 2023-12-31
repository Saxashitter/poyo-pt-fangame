states = {}
global = {}

game_name = "Poyo Game"

debug = true

isMobile = (love._os == 'Android' or love._os == "iOS")

controls = require 'libs.controls'
require 'libs.helpers'
players = require 'libs.player'
json = require 'libs.json'
Binocles = require 'libs.Binocles'
collisions = require 'libs.collision_manager'
maploader = require 'libs.maploader'
Camera = require 'libs.camera'
mlib = require 'libs.mlib'
animation = require 'libs.animation'

local function requireAllStates()
	local dir = "states"
	local entities = love.filesystem.getDirectoryItems(dir)

	for k, ents in ipairs(entities) do
		trim = string.gsub(ents, ".lua", "")
		
		states[trim] = require("states."..trim)
	end
end

function love.load()
	GLOBAL_GRAVITY = 0.5
	PLAYER_SPAWN = {0,0}

	--requireAllLibs()
	
	gamestate = require 'libs.gamestate'
	lovesize = require 'libs.lovesize'

	lovesize.set(960, 540)

	if debug then
		Binocles()
	end

	controls:init()
	requireAllStates()
	
	if not love.filesystem.exists(game_name..'/mods') then
		love.filesystem.createDirectory(game_name..'/mods/characters')
		love.filesystem.createDirectory(game_name..'/mods/maps')
	end

	gamestate.switch(states["select_character"])

	if debug then
		Binocles:watch("slopery",function() return chars end)
		Binocles:setPosition(10 ,1);
	end
end

function love.resize(width, height)
    lovesize.resize(width, height)
end

function love.update(dt)
	musicUpdate()
	controls:update()
	if debug then Binocles:update() end
	
	gamestate.update(dt)
end

function love.draw()
	--love.graphics.print(math.floor(1/love.timer.getDelta()))
	
	-- love.graphics.print(tostring(tile and tile.slope))
	local x = x or 0
	local y = y or 0
	
	
	lovesize.begin()
		gamestate.draw()
	lovesize.finish()
	if debug then Binocles:draw() end
	controls:draw()
end