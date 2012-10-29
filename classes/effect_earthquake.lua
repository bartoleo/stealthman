--- EFFECT
--- draw text with fade

local effect_earthquake = SECS_class:new()

function effect_earthquake:init(pid, pintensityx,pintensityy, ptime)
  -- actor must have this properties and must have :update(dt) and :draw() methods
  self.interactive = true
  self.modal = false -- modal true : only this actor in update/draw, stops others actors after
  self.finished = false
  self.timing = "bef_graphics_rear"
  self.id = pid
  --
  self.frame = 0
  self.time = ptime
  self.intensityx = pintensityx
  self.intensityy = pintensityy
  --
end

function effect_earthquake:update(dt)
  self.frame = self.frame + 1

  if (self.frame >  self.time) then
    self.finished = true
    return false
  end
  
  return true
  
end

function effect_earthquake:draw()
  Gamestate.game:push_coord()
  love.graphics.translate( math.random()*self.intensityx,math.random()*self.intensityy )
end

return effect_earthquake