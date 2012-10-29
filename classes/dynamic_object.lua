--- dynamic_object

local dynamic_object = SECS_class:new()

function dynamic_object:init(pWorld,pname,pid,px,py,pwidth,pheight,pimage,pfunupdate,pfundraw,pphysicstype,pphysicsmass,pphysicsfixedrotation,pphysicsinertia,pphysicslineardamping,pfunbegincontact,pfunendcontact)
  --- common properties for dynamic_object, NPC, Enemies...
  self.name = self.name
  self.type = "dynamic_object"
  self.id = self.id
  self.x = px
  self.y = py
  self.finished = false
  
  --- specific properties for dynamic_object
  self.width = pwidth
  self.height = pheight
  self.visible = true
  
  self.touch_player = 0 -- 0 not touching, 1 just touched, 2 touching
  
  self.r = 0

  self.vertices = {-self.width/2, -self.height/2,
  	               self.width/2, -self.height/2,
  	               self.width/2, self.height/2,
  	               -self.width/2, self.height/2,}
  
  self.funupdate = pfunupdate
  self.fundraw = pfundraw

  self.funbegincontact = pfunbegincontact
  self.funendcontact = pfunendcontact
  
  self.image = pimage
  
  self.physicstype = pphysicstype
  self.physicsmass = pphysicsmass
  self.physicsfixedrotation = pphysicsfixedrotation
  self.physicsinertia = pphysicsinertia
  self.physicslineardamping = pphysicslineardamping
  if self.physicstype then
    self.body=love.physics.newBody(pWorld, self.x, self.y, self.physicstype)
	if self.physicsmass then
      self.body:setMass(self.physicsmass)
	end
	if self.physicsfixedrotation then
      self.body:setFixedRotation( self.physicsfixedrotation )
	end
	if self.physicsinertia then
      self.body:setInertia( self.physicsinertia )
	end 
	if self.physicslineardamping then
      self.body:setLinearDamping( self.physicslineardamping )
	end
    self.shape=love.physics.newPolygonShape(unpack(self.vertices))
    self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
    self.fixture:setUserData( {tipo="dynamic_object",value=self,custombegincontact=self.funbegincontact,customendcontact=self.funendcontact} )
	--self.fixture:setCategory(1,2,3,4,5,6)
    --self.fixture:setMask(1)
	self.fixture:setFilterData(1,65535,0)

  end	
end

function dynamic_object:update(dt)

  if self.funupdate then
    self.funupdate(self,dt)
  end

  if self.touch_player == 1 then
    self.touch_player = 2
  end

  if self.physicstype then
    self.x,self.y = self.body:getPosition()
	self.r = self.body:getAngle()
  end
  
  return true
  
end

function dynamic_object:draw(physics,graphics)
  
  if (graphics) then
    if self.visible then
      if self.fundraw then
  	    self.fundraw(self,physics,graphics)
	  else
	    love.graphics.setColor(255,255, 255, 255)
  	    if self.physicstype then
  	      love.graphics.draw(self.image, self.x, self.y, self.r, 1,1,self.width/2, self.height/2)
	    else
          love.graphics.draw(self.image, self.x, self.y)
	    end
	  end
	end
  end
  
  if physics and self.physicstype then
    love.graphics.setColor(0,0, 255, 255)
    love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()))
  end
end

return dynamic_object