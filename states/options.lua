--- options gamestate
Gamestate.options = Gamestate.new()
local state = Gamestate.options
local _pre = nil;

state.simplegui = nil

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param enter (LUADOC TODO add enter description) 
-- @param pre (LUADOC TODO add pre description) 
-- @return (LUADOC TODO add return description) 
function state:enter(pre, action,pre2, ...)
  love.graphics.setBackgroundColor(64, 64, 64)
  
  _pre = pre
  if (pre2~=nil) then
    _pre = pre2
  end
  
  getScreenMode()

  state:setGui()

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
    love.graphics.print(game_title, 20, 40, -0.3)
	love.graphics.setFont(fonts[",10"])
	love.graphics.printf("resolution:".._G.screen_width.."x".._G.screen_height.." "..truefalse(_G.screen_fullscreen,"fullscreen","windowed"), 0, screen_height-95, screen_width, 'right')
	love.graphics.printf("vsyinc:"..truefalse(_G.screen_vsync,"yes","no"), 0, screen_height-85, screen_width, 'right')
	love.graphics.printf("fsaa-buffers:".._G.screen_fsaa, 0, screen_height-75, screen_width, 'right')
	love.graphics.printf("canvas_support:"..truefalse(_G.canvas_supported,"yes","no"), 0, screen_height-65, screen_width, 'right')
	love.graphics.printf("pixeleffect_support:"..truefalse(_G.pixeleffect_supported,"yes","no"), 0, screen_height-55, screen_width, 'right')
	love.graphics.printf("npot_support:"..truefalse(_G.npot_supported,"yes","no"), 0, screen_height-45, screen_width, 'right')
	love.graphics.printf("subtractive_support:"..truefalse(_G.subtractive_supported,"yes","no"), 0, screen_height-35, screen_width, 'right')
    love.graphics.setFont(fonts[",20"])
    love.graphics.printf("v."..game_version, 0, screen_height-20, screen_width, 'right')

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
  if key == "escape" then
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
	elseif pname=="apply" then
      state:apply()
      state:setGui()
	end
  end
end

function state:apply()
  local _res = split(state.simplegui:getElementByName("resolution").value,"x")
end

function state:setGui()
  if state.simplegui==nil then
    state.simplegui = _G.simplegui:new(state.simplegui_event)
  end
  state.simplegui:clear()
  state.simplegui.divisor=7
  state.simplegui:setlayout("down",32,screen_middley-90,screen_width-32,screen_height-100,fonts[",30"],{r=255,g=255,b=255,a=255},{r=255,g=255,b=0,a=255})
  local _modes=love.graphics.getModes()
  table.sort(_modes, function(a, b) return a.width*a.height < b.width*b.height end)  
  local _values={}
  local _value=_G.screen_width.."x".._G.screen_height
  local _val
  local _found=false
  for i,v in ipairs(_modes) do
    _val=v.width.."x"..v.height
    table.insert(_values,_val)
    table.insert(_values,_val)
    if _value==_val then
      _found=true
    end
  end
  if _found==false then
    table.insert(_values,_val)
    table.insert(_values,_val)
  end
  state.simplegui:addelement("resolution","hcombo",{label="Resolution:",value=_value,values=_values})
  state.simplegui:addelement("fullscreen","checkbox",{label="Fullscreen:",value=_G.screen_fullscreen,valuechecked=true,valueunchecked=false})
  state.simplegui:addelement("vsync","checkbox",{label="VSync:",value=_G.screen_vsync,valuechecked=true,valueunchecked=false})
  state.simplegui:addelement("volume","hcombo",{label="Volume:",value=100,values={0,"0%",10,"10%",20,"20%",30,"30%",40,"40%",50,"50%",60,"60%",70,"70%",80,"80%",90,"90%",100,"100%"}})
  state.simplegui:addelement("apply","button",{text="Apply"})
  state.simplegui:addelement("sep1","separator",{height=10})
  state.simplegui:addelement("exit","button",{text="Exit"})
end