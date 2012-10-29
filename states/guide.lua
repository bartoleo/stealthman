--- guide gamestate
Gamestate.guide = Gamestate.new()
local state = Gamestate.guide
local _pre = nil;
state.simplegui = nil

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param enter (LUADOC TODO add enter description) 
-- @param pre (LUADOC TODO add pre description) 
-- @return (LUADOC TODO add return description) 
function state:enter(pre, action,pre2, ...)

  getScreenMode()
  
  _pre = pre
  if (pre2~=nil) then
    _pre = pre2
  end
  
  if state.simplegui==nil then
    state.simplegui = _G.simplegui:new(state.simplegui_event)
  end
  state.simplegui:clear()
  state.simplegui:setlayout("down",32,screen_height-40,screen_width-32,40,fonts[",30"],{r=255,g=255,b=255,a=255},{r=255,g=255,b=0,a=255})
  state.simplegui:addelement("exit","button",{text="Exit"})
 
  love.graphics.setBackgroundColor(64, 64, 64)
end

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param leave (LUADOC TODO add leave description) 
-- @return (LUADOC TODO add return description) 
function state:leave()
end

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param update (LUADOC TODO add update description) 
-- @param dt (LUADOC TODO add dt description) 
-- @return (LUADOC TODO add return description) 
function state:update(dt)
  state.simplegui:update(dt)
end

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param draw (LUADOC TODO add draw description) 
-- @return (LUADOC TODO add return description) 
function state:draw()
 
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(fonts[",20"])
  
  love.graphics.setFont(fonts["fonts/keys.ttf,40"])
  love.graphics.print("z", 20, 20)
  love.graphics.print("x", 20, 60)
  love.graphics.print("w", 20, 100)
  love.graphics.print("y", 20, 140)
  love.graphics.print("k", 20, 180)
  love.graphics.print("P", 20, 220)
  love.graphics.print("^", 20, 260)
  love.graphics.setFont(fonts[",25"])
  love.graphics.print("move left", 63, 27)
  love.graphics.print("move right", 63, 67)
  love.graphics.print("jump or climb up ladder", 63, 107)
  love.graphics.print("climb down ladder", 63, 147)
  love.graphics.print("sword", 93, 187)
  love.graphics.print("pause", 63, 227)
  love.graphics.print("exit", 93, 267)
  love.graphics.print("others: 1 show/hide physics shapes, 2 show/hide graphics", 20, 300)
  love.graphics.print("3/4 change room, 5 apply crt shader, 6 test, 7 svg level", 20, 340)
  love.graphics.print("8 zoom on player", 20, 380)
  --[[
  for i = 0 ,15 do
    for j=0,15 do
	  if (j+i*16 < 128) then
	   print (j+i*16)
	    love.graphics.setFont(fonts["fonts/keys.ttf,25"])
	    love.graphics.print(string.char(j+i*16), j*40,i*45)
	    love.graphics.setFont(fonts[",16"])
	    love.graphics.print(string.char(j+i*16), j*40,i*45+25)
	  end
	end
  end
  ]]-- 
  
  
  love.graphics.setFont(fonts[",20"])
  
  state.simplegui:draw()

end

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param keypressed (LUADOC TODO add keypressed description) 
-- @param key (LUADOC TODO add key description) 
-- @param unicode (LUADOC TODO add unicode description) 
-- @return (LUADOC TODO add return description) 
function state:keypressed(key, unicode)
  state.simplegui:keypressed(key, code)
  if (key == "escape" ) then
    Gamestate.switch(Gamestate.transition,_pre,"FADE",0.3,"",state)
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
end

function state.simplegui_event(pname,pevent) 
  if pevent=="click" then
    if pname=="exit" then
      Gamestate.switch(Gamestate.transition,_pre,"FADE",0.3,"",state)
	  _pre = nil
	end
  end
end