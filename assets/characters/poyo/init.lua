local character = {}

local function movementHandler(p)
  local k = p.keys
  local key_left = math.min((k and k.left) or 0, 1)
  local key_down = math.min((k and k.down) or 0, 1)
  local key_up = math.min((k and k.up) or 0, 1)
  local key_right = math.min((k and k.right) or 0, 1)
  local key_run = math.min((k and k.run) or 0, 1)

  local key_jump_buffer = ((k and k.jump) or 0) == 1

  -- lua is being dumb, i cant use and 1 or 0

  local move = -key_left + key_right
  speed = p.mspeed * math.abs(move)
  
  if key_run == 1 then speed = speed*2 end

  -- ight bitch time to move

  p.ac.x = 0.45 * move
  if math.abs(p.mom.x) > speed then
      p.ac.x = 0
  end
  
  -- now jump fatass
  if key_jump_buffer and p.grounded then
  	p.mom.y = -6
  	p.grounded = false
	end

  -- GRAVITYYYYYYYY
  if not p.grounded then
      if p.mom.y >= 0 then
          p.ac.y = GLOBAL_GRAVITY
      else
          p.ac.y = GLOBAL_GRAVITY / 2
      end
  else
  	if p.mom.x > 0 then p.dir = 1
  	elseif p.mom.x < 0 then p.dir = -1
  	end
  end

  local value, clamped = lerp_clamp(p.mom.x + p.ac.x, 0.25, speed)
  p.mom.x = value
  p.mom.y = p.mom.y + p.ac.y
  
  p.x = p.x + p.mom.x
  collisions.tile(p)

  p.y = p.y + p.mom.y
  collisions.tile(p,1)
end

function character:init(x,y)
	local width = 32
  local height = 64

  local x = x or 0
  local y = y-(height/2) or 0

  self.x = x
  self.y = y

  self.width = width
  self.height = height

  self.ac = {x = 0, y = 0}
  self.mom = {x = 0, y = 0}

  self.dec = 0.25

  self.dir = 1
  self.mspeed = 4
  self.jumped = false

  self.grounded = true
  
  animation:newObject(self, 'assets/characters/poyo/sprites')
  
  self.sprite = love.graphics.newImage('assets/characters/poyo/sprites/idle/1.png')
  self.sprite:setFilter('nearest')
end

function character:update(dt)
	movementHandler(self)
end

function character:draw()
	local width = self.sprite:getWidth()
	local height = self.sprite:getHeight()
	love.graphics.draw(self.sprite, self.x+(self.width/2), self.y+self.height, 0, self.dir, 1, width/2, height)
end

return character