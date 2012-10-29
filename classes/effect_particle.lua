--- EFFECT
--- draw text with fade

local effect_particle = SECS_class:new()

function effect_particle:init(pid,x,y,ptime,pimage,pbuffersize,w)
  -- actor must have this properties and must have :update(dt) and :draw() methods
  self.interactive = true
  self.modal = false -- modal true : only this actor in update/draw, stops others actors after
  self.finished = false
  self.timing = "aft_graphics_rear"
  self.id = pid
  --
  self.frame = 0
  self.time = ptime
  self.x = x
  self.y = y
  --
  self.ps = love.graphics.newParticleSystem( pimage,pbuffersize)
  if w.colors then
    self.ps:setColors(unpack(w.colors));
  end
  if w.direction then
    self.ps:setDirection(unpack(w.direction));
  end
  if w.emissionrate then
    self.ps:setEmissionRate(unpack(w.emissionrate));
  end
  if w.gravity then
    self.ps:setGravity(unpack(w.gravity));
  end
  if w.setlifetime then
    self.ps:setLifetime(unpack(w.setlifetime));
  end
  if w.particlelife then
    self.ps:setParticleLife(unpack(w.particlelife));
  end
  if w.radialacceleration then
    self.ps:setRadialAcceleration(unpack(w.radialacceleration));
  end
  if w.rotation then
    self.ps:setRotation(unpack(w.rotation));
  end
  if w.sizes then
    self.ps:setSizes(unpack(w.sizes));
  end
  if w.speed then 
    self.ps:setSpeed(unpack(w.speed));
  end
  if w.spin then
    self.ps:setSpin(unpack(w.spin));
  end
  if w.spread then
    self.ps:setSpread(unpack(w.spread));
  end
  if w.tangentialacceleration then
    self.ps:setTangentialAcceleration(unpack(w.tangentialacceleration));
  end
  -----------------------
  --current particles [0]
  self.ps:start( )
end

function effect_particle:update(dt)
  self.frame = self.frame + 1

  if (self.time and self.frame >  self.time) then
    self.finished = true
	self.ps:stop( )
	self.ps = nil
    return false
  end
  
  self.ps:update(dt)
  
  return true
  
end

function effect_particle:draw()
  if (self.ps) then
    love.graphics.draw(self.ps,self.x,self.y)
  end
end

return effect_particle