--- gameover gamestate
Gamestate.gameover = Gamestate.new()
local state = Gamestate.gameover

Gamestate.gameover.score = nil

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param enter (LUADOC TODO add enter description) 
-- @param last (LUADOC TODO add last description) 
-- @param sc (LUADOC TODO add sc description) 
-- @return (LUADOC TODO add return description) 
function state:enter(last, sc)
  getScreenMode()
  state.score = sc
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
end

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param draw (LUADOC TODO add draw description) 
-- @return (LUADOC TODO add return description) 
function state:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(fonts[",12"])
  love.graphics.printf("GAME OVER PLACEHOLDER", 0, screen_middley, screen_width, 'center')
  love.graphics.printf("Score: " .. state.score, 0, screen_middley+20, screen_width, 'center')
  love.graphics.printf("esc to exit and return to menu", 0, screen_middley+40, screen_width, 'center')
end

--- state (LUADOC TODO add resume)
-- state (LUADOC TODO add description)
-- @param keypressed (LUADOC TODO add keypressed description) 
-- @param key (LUADOC TODO add key description) 
-- @param unicode (LUADOC TODO add unicode description) 
-- @return (LUADOC TODO add return description) 
function state:keypressed(key, unicode)
  if key == "return" then
    Gamestate.switch(Gamestate.menu)
  elseif key == "escape" then
    love.event.push("quit")
  end
end
