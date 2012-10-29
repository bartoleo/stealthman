--- pause gamestate
Gamestate.pause = Gamestate.new()
local state = Gamestate.pause
local _pre = nil

Gamestate.pause.screenshot = nil
Gamestate.pause.blur_vertical = nil
Gamestate.pause.blur_horizontal = nil
Gamestate.pause.blurred = false

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param enter (LUADOC TODO add enter description) 
-- @param pre (LUADOC TODO add pre description) 
-- @return (LUADOC TODO add return description) 
function state:enter(pre, action, ...)

  getScreenMode()
 
  _pre = pre

  local _image = love.graphics.newScreenshot( )
  local w, h = _image:getWidth(), _image:getHeight()                    
  
  Gamestate.pause.screenshot = love.graphics.newImage(_image)
  
  if canvas_supported and pixeleffect_supported then
    state.blurred = false
	state.blur_vertical = love.graphics.newPixelEffect(love.filesystem.read("shaders/blur_h.frag"))
	state.blur_vertical:send("rt_h", h)
	
	state.blur_horizontal = love.graphics.newPixelEffect(love.filesystem.read("shaders/blur_v.frag"))
	state.blur_horizontal:send("rt_w", w)

	love.graphics.setPixelEffect()
		
  end
  
  -- TOO SLOW
--[[
  local x,y
  local r,g,b,a 
  local r1,g1,b1,a1 
  local r2,g2,b2,a2 
  local r3,g3,b3,a3 
  for x=1, w-2 do 
    for y=1, h-2 do 
	  r,g,b,a = _image:getPixel(x,y)
	  r1,g1,b1,a1 = _image:getPixel(x+1,y)
	  r2,g2,b2,a2 = _image:getPixel(x,y+1)
	  r3,g3,b3,a3 = _image:getPixel(x+1,y+1)
  	  _image:setPixel(x,y,(r+r1+r2+r3)/4,(g+g1+g2+g3)/4,(b+b1+b2+b3)/4,(a+a1+a2+a3)/4)
	end
  end
  for x=1, w-2 do 
    for y=1, h-2 do 
      r,g,b,a = _image:getPixel(x,y)
      r1,g1,b1,a1 = _image:getPixel(x+1,y)
      r2,g2,b2,a2 = _image:getPixel(x,y+1)
      r3,g3,b3,a3 = _image:getPixel(x+1,y+1)
      _image:setPixel(x,y,(r+r1+r2+r3)/4,(g+g1+g2+g3)/4,(b+b1+b2+b3)/4,(a+a1+a2+a3)/4)
    end
  end
  ]]--
  
  love.graphics.setBackgroundColor(0, 0, 0)
end

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param leave (LUADOC TODO add leave description) 
-- @return (LUADOC TODO add return description) 
function state:leave()
  state.blur = nil
end

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param update (LUADOC TODO add update description) 
-- @param dt (LUADOC TODO add dt description) 
-- @return (LUADOC TODO add return description) 
function state:update(dt)
end

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param draw (LUADOC TODO add draw description) 
-- @return (LUADOC TODO add return description) 
function state:draw()
   
  if canvas_supported and pixeleffect_supported and state.blurred == false then
  
	local canvas1 = love.graphics.newCanvas()
	local canvas2 = love.graphics.newCanvas()
    
	love.graphics.setColor(255, 255, 255, 255)
	r, g, b, a = love.graphics.getBackgroundColor( )
    love.graphics.setCanvas(canvas1)
    love.graphics.setBackgroundColor(r,g,b,a )
	love.graphics.clear()
	love.graphics.setPixelEffect(blur_vertical)
	love.graphics.draw(Gamestate.pause.screenshot, 0, 0)
	r, g, b, a = love.graphics.getBackgroundColor( )
    love.graphics.setCanvas(canvas2)
    love.graphics.setBackgroundColor(r,g,b,a )
	love.graphics.clear()
    love.graphics.setPixelEffect(blur_horizontal)
	love.graphics.draw(canvas1, 0, 0)

	--[[r, g, b, a = love.graphics.getBackgroundColor( )
    love.graphics.setCanvas(canvas1)
    love.graphics.setBackgroundColor(r,g,b,a )
	love.graphics.clear()
	love.graphics.setPixelEffect(blur_vertical)
	love.graphics.draw(canvas2, 0, 0)
	r, g, b, a = love.graphics.getBackgroundColor( )
    love.graphics.setCanvas(canvas1)
    love.graphics.setBackgroundColor(r,g,b,a )
	love.graphics.clear()
    love.graphics.setPixelEffect(blur_horizontal)
	love.graphics.draw(canvas1, 0, 0)]]--

	Gamestate.pause.screenshot = canvas2
	love.graphics.setCanvas()
	love.graphics.setPixelEffect()	
	
	state.blurred = true
	
  end

  love.graphics.setColor(255, 255, 255, 60)  
  love.graphics.draw(Gamestate.pause.screenshot,0,0)
  
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(fonts[",20"])
  love.graphics.print(game_title, 20, 40, -0.3)
  
  love.graphics.printf("PAUSE", 0, screen_middley, screen_width, 'center')
  love.graphics.printf("p or ESC to resume", 0, screen_middley+20, screen_width, 'center')
end

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param keypressed (LUADOC TODO add keypressed description) 
-- @param key (LUADOC TODO add key description) 
-- @param unicode (LUADOC TODO add unicode description) 
-- @return (LUADOC TODO add return description) 
function state:keypressed(key, unicode)
  if (key == "p" or key == "escape" ) then
    Gamestate.switch(_pre)
	_pre = nil
  end
end

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param mousepressed (LUADOC TODO add mousepressed description) 
-- @param x (LUADOC TODO add x description) 
-- @param y (LUADOC TODO add y description) 
-- @param button (LUADOC TODO add button description) 
-- @return (LUADOC TODO add return description) 
function state:mousepressed(x, y, button)
  if button == "l" then
    Gamestate.switch(_pre, "from_pause")
	_pre = nil
  end
end

