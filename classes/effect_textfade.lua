--- EFFECT
--- draw text with fade

local effect_textfade = SECS_class:new()

function effect_textfade:init(pid, ptext, px, py, pdx, pdy, pfont, pcolor, pfadetimein, ptime, pfadetimeout,plimit,palign,pbordercolor,pcolorfill,pmargin)
  -- actor must have this properties and must have :update(dt) and :draw() methods
  self.interactive = true
  self.modal = false -- modal true : only this actor in update/draw, stops others actors after
  self.finished = false
  self.timing = "aftergui"
  self.id = pid
  --
  self.text = ptext
  self.ox = px
  self.oy = py
  self.x = px
  self.y = py
  self.dx = pdx
  self.dy = pdy
  self.font = pfont
  self.color = pcolor
  self.fadetimein = pfadetimein
  self.time = ptime
  self.fadetimeout = pfadetimeout
  self.totaltime = pfadetimein+ptime+pfadetimeout
  self.frame = 0
  self.limit = plimit
  self.align = palign
  self.bordercolor = pbordercolor
  self.colorfill = pcolorfill
  self.margin = pmargin
  self.borderx = self.x
  self.lines = 1
  --
  if self.margin == nil then
    self.margin = 0
  end 
  self.width = self.font:getWidth(self.text)
  if self.limit ~= nil then
    self.width, self.lines = self.font:getWrap(self.text, self.limit)
	if self.align=="" then
	  self.width = self.limit
	  self.borderx = self.x
	elseif self.align=="center" then
	  self.borderx = self.x+(self.limit-self.width)/2
	elseif self.align=="right" then
	  self.borderx = self.x+self.limit-self.width
	elseif self.align=="left" then
	  self.borderx = self.x-self.margin
	end
  end 
  self.height = self.font:getHeight()
  self.width = self.width + self.margin*2
  self.height = self.height + self.margin*2
end

function effect_textfade:update(dt)
  self.frame = self.frame + 1

  if (self.frame >  self.totaltime) then
    self.finished = true
    return false
  end

  if self.x ~= self.dx then
    self.x = self.ox+((self.dx-self.ox)*self.frame)/self.totaltime
  end
  if self.y ~= self.dy then
    self.y = self.oy+((self.dy-self.oy)*self.frame)/self.totaltime
  end
  
  return true
  
end

function effect_textfade:draw()
  love.graphics.setFont(self.font)
  local alpha = 255
  local r,g,b
  if self.frame <= self.fadetimein then
    alpha = (255*self.frame)/self.fadetimein
  elseif self.frame <= self.fadetimein+self.time then
    alpha = 255
  else 
    alpha = 255*(self.fadetimein-self.time-self.frame)/self.fadetimeout
  end
  if self.colorfill ~= nil then
    r,g,b = unpack(self.colorfill)
	love.graphics.setColor(r,g,b,alpha)
    love.graphics.rectangle("fill",self.borderx-self.margin,self.y-self.margin,self.width,self.height)
  end
  if self.bordercolor ~= nil then
    r,g,b = unpack(self.bordercolor)
	love.graphics.setColor(r,g,b,alpha)
    love.graphics.rectangle("line",self.borderx-self.margin,self.y-self.margin,self.width,self.height)
  end
  r,g,b = unpack(self.color)
  love.graphics.setColor(r,g,b,alpha)
  if self.limit and self.align then
    love.graphics.printf(self.text,self.x,self.y,self.limit,self.align)
  else
    love.graphics.print(self.text,self.x,self.y)
  end
end

return effect_textfade