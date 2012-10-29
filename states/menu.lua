--- menu gamestate
Gamestate.menu = Gamestate.new()
local state = Gamestate.menu

state.simplegui = nil

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param enter (LUADOC TODO add enter description) 
-- @param pre (LUADOC TODO add pre description) 
-- @return (LUADOC TODO add return description) 
function state:enter(pre, action, ...)
  love.graphics.setBackgroundColor(64, 64, 64)

  getScreenMode()

  if state.simplegui==nil then
    state.simplegui = _G.simplegui:new(state.simplegui_event)
  end
  state.simplegui:clear()
  state.simplegui.divisor=7
  state.simplegui:setlayout("down",32,screen_middley-85,screen_width-32,screen_height-100,fonts[",30"],{r=255,g=255,b=255,a=255},{r=255,g=255,b=0,a=255})
  state.simplegui:addelement("game","button",{text="New Game"})
  state.simplegui:addelement("continue","button",{text="Continue",enabled=false})
  state.simplegui:addelement("sep1","separator",{height=10})
  state.simplegui:addelement("options","button",{text="Options"})
  state.simplegui:addelement("guide","button",{text="How to play"})
  state.simplegui:addelement("bht","button",{text="bht"})
  --state.bht=behavtree:new("prova",state,nil)
  state.bht=BTLua.TreeWalker:new("prova",state,
                             BTLua.RandomSelector:new(
                               BTLua.Action:new(function() local a = math.random()*10 print("nodo1 "..a.." <5") return a<5 end),
                               BTLua.Action:new(function(b,o,p,p2) local a = math.random()*10 print("nodo2 "..a.." <5 ") print(b) print(o) print(p) print(p2) return a<5 end,"argument","argument2"),
                               BTLua.Action:new('local a = math.random()*10 print("nodo3.a "..a.." <5") coroutine.yield() print("nodo3.b "..a.." <5") return a<5')
                           ))
  state.simplegui:addelement("sep2","separator",{height=10})
  state.simplegui:addelement("quit","button",{text="Quit"})
  
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
    love.graphics.setFont(fonts[",20"])
    love.graphics.printf("v."..game_version, 0, screen_height-20, screen_width, 'right')

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
    love.event.push('quit')
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
    if pname=="game" then
      Gamestate.switch(Gamestate.transition,Gamestate.game,"FADE",0.3,"INIT","base",state)
    elseif pname=="continue" then
      --todo
    elseif pname=="options" then
      Gamestate.switch(Gamestate.transition,Gamestate.options,"FADE",0.3,"",state)
    elseif pname=="guide" then
      Gamestate.switch(Gamestate.transition,Gamestate.guide,"FADE",0.3,"",state)
    elseif pname=="bht" then
      --state.bht:run()
      print("TICK----------------------------")
      state.bht:Tick()
      print(truefalseother(state.bht.logic.last_status,"TRUE","FALSE",state.bht.logic.last_status))
    elseif pname=="quit" then
	    love.event.push('quit')
	end
  end
end