--- player

local player = SECS_class:new()

function player:init(pWorld)
  --- common properties for Player, NPC, Enemies...
  self.name = "player"
  self.type = "player"
  self.id = "player"
  self.x = 0
  self.y = 0
  self.finished = false
  
  --- specific properties for player
end

function player:enterlevel(pWorld, pPlayerX,pPlayerY)
  
  self.x = pPlayerX
  self.y = pPlayerY

end


function player:update(dt)
  if GAME.inputenabled then    
	  if love.keyboard.isDown("right") then
		  -- right
	  elseif love.keyboard.isDown("left") then
		  -- left
	  elseif  love.keyboard.isDown("up") then
		  -- up
    elseif  love.keyboard.isDown("down") then
      -- up
    end
  end
    
  return true
  
end

function player:draw()
  
end

function player:keypressed(key, unicode)
  if key == " " then
  end
end

return player