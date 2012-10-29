--- gradient
--- draw gradient

local gradient = SECS_class:new()

function gradient:init(pfromcolor,ptocolor)
 --
  self.fromcolor = pfromcolor
  self.tocolor = ptocolor
  
  local _imagedata = love.image.newImageData(1,2)
  _imagedata:setPixel(0,0, unpack(self.tocolor))
  _imagedata:setPixel(0,1, unpack(self.fromcolor))
  self.image = love.graphics.newImage(_imagedata)
  self.image:setFilter('linear', 'linear')

end

return gradient