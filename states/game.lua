
--- game gamestate
Gamestate.game = Gamestate.new()
local state = Gamestate.game

-- constant

-- GAME environment
GAME={}
GAME.inputenabled = false
GAME.counter = 0
GAME.world = nil
GAME.player = nil
GAME.objects = {}
GAME.level = {}
GAME.shaders = false

GAME.tileSize = 32
GAME.tileQuads = {}

GAME.canvas = nil
GAME.pixeleffect = nil

GAME.effects = {}

GAME.numobjects = 0
GAME.numeffects = 0
GAME.push_coord_num = 0

function state:enter(pre, action, level,  ...)

  getScreenMode()
  
  -- disable input
  GAME.inputenabled = false
   
  -- logic
  if action=="INIT" then
    -- init game
    GAME.prev_level_name = nil
    
    --profiler.start("prova")
    
    -- proto tiles
    GAME.tileSize = 32
    GAME.tileQuads[0] = love.graphics.newQuad(5 * GAME.tileSize, 0 * GAME.tileSize, GAME.tileSize, GAME.tileSize, images.dungeon:getWidth(), images.dungeon:getHeight())
   
    GAME.counter = 0
    GAME.player = _G.classes.player:new(GAME.world)
    
    state:loadlevel("001")

    love.graphics.setBackgroundColor(unpack(GAME.level.background_color_rgb))
    
    if canvas_supported and pixeleffect_supported then
      GAME.pixeleffect = love.graphics.newPixelEffect(love.filesystem.read("shaders/crt.frag"))
      local a1 = {500,400}
      local a2 = {800,600}
      local a3 = {500,400}
      GAME.pixeleffect:send("inputSize", a1)
      GAME.pixeleffect:send("outputSize", a2)
      GAME.pixeleffect:send("textureSize", a3)
      GAME.canvas = love.graphics.newCanvas( )
    end 
  end 
  
  -- enable input
  GAME.inputenabled = true

end

function state:leave()
  --profiler.stop()
  collectgarbage("restart")
end

function state:update(dt) 
  
  -- get rid off of long 'pauses'
  -- from https://love2d.org/forums/viewtopic.php?f=4&t=8740
  dt = math.min(dt, 0.07)
  lastdt = dt
  
  GAME.counter = GAME.counter + 1
  GAME.numeffects = 0

  -- effects (explosions, movement, animations...)
  local _bremove = false
  for _, vv in pairs(GAME.effects) do
   for _, v in pairs(vv) do
    if not v.finished then
      -- if effects pretends no-interactive
      if v.interactive == false then
        GAME.inputenabled = false
      end
      if v:update(dt) == false then
        _bremove = true
      elseif v.modal then
        break
      end
    GAME.numeffects=GAME.numeffects+1
    end
   end
  end
  -- remove 'finished' effects
  if _bremove then
   for _, vv in pairs(GAME.effects) do
    for i = #vv, 1, -1 do
    if vv[i].finished == true then
        table.remove(vv, i)
    end
    end
   end
  end
  
  -- world update
  GAME.numobjects = 0
  
  -- objects update (including player)
  _bremove = false
  for _, vv in pairs(GAME.objects) do
    if not vv.finished then
      if vv:update(dt) == false then
      _bremove = true
    end
    GAME.numobjects=GAME.numobjects+1
  end
  end 
  
  -- remove 'finished' ebjects
  if _bremove then
   for i = #GAME.objects, 1, -1 do
    if GAME.objects[i].finished == true then
      table.remove(GAME.objects, i)
    end
   end
  end
  
  -- level update
  if GAME.level.update then
    GAME.level.update(dt)
  end

end

function state:draw()

  love.graphics.setBackgroundColor(unpack(GAME.level.background_color_rgb))

  if GAME.shaders then
    local r, g, b, a = love.graphics.getBackgroundColor( )
    love.graphics.setCanvas(GAME.canvas)
    love.graphics.setBackgroundColor(r,g,b,a )
  love.graphics.clear()
  end

  -- GAME
  state:effects_draw("aft_graphics_rear")
  
  state:effects_draw("bef_player")

  love.graphics.setColor(255, 255, 255, 255) 
  -- objects draw (including player)
  for _, vv in pairs(GAME.objects) do
    vv:draw()
  end 
  
  state:effects_draw("aft_player")
  
  state:effects_draw("bef_graphics_front")  
  if GAME.graphics then
    state:graphics_draw(GAME.level.graphics_front)
    GAME.level.draw_front()
  end
  state:effects_draw("aft_graphics_front")

  state:pop_coord("all")
  
  --- GUI
  state:effects_draw("bef_gui")
  -- FPS
  local fps = love.timer.getFPS( )
  love.graphics.setFont(fonts[",11"])
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("fps:"..fps.." effects:"..GAME.numeffects.." objects:"..GAME.numobjects, 2, screen_height-13)
  ---
  state:effects_draw("aft_gui")


  if GAME.shaders then  
  
    love.graphics.setCanvas()

    love.graphics.setPixelEffect(GAME.pixeleffect)
    -- draw scaled canvas to screen
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(GAME.canvas, 0,0)
    love.graphics.setPixelEffect()
  end 
  
end

function state:keypressed(key, unicode)

  if GAME.inputenabled then  
    GAME.player:keypressed(key, unicode)
  end

  if key == "rctrl" then
    debug.debug()
  elseif key == "p" then
    Gamestate.switch(Gamestate.pause)
  elseif key == "escape" then
    if GAME.world then
      GAME.world:destroy()
    end
    GAME.world = nil
    if (GAME.level and GAME.level.exitlevel) then
    GAME.level.exitlevel()
    GAME.level = nil
  end
    Gamestate.switch(Gamestate.menu)
  end
end

function state:mousepressed(x, y, button)
end

function state:mousereleased(x, y, button)
end


function state:loadlevel(pLevel,pPlayerX,pPlayerY)
  
    -- previous level
  GAME.prev_levelname = nil
  if (GAME.level and GAME.level.name) then
    GAME.prev_levelname = GAME.level.name..""
  end
  if (GAME.level and GAME.level.exitlevel) then
    GAME.level.exitlevel()
  end
   
  GAME.level = nil
  GAME.level = {}
  state:graphics_clear()
  GAME.effects = {}
  GAME.objects = {}
  state:objects_add(GAME.player)
  
  --collectgarbage("collect")
  
  GAME.level.playerx = pPlayerX
  GAME.level.playery = pPlayerY
  

  --- load level as lua chunk
  _G.state=state
  chunk = love.filesystem.load( "levels/level_"..pLevel..".lua") 
  local _ = chunk()
  _G.state=nil

  GAME.player:enterlevel(GAME.level.playerx,GAME.level.playery)
  
  state:effects_add("aft_gui",classes.effect_textfade:new("_levelname",GAME.level.name, 50, 10, 50, 10, fonts[",14"], {0,0,0}, 30, 30, 30,screen_width-100,"center",{0,0,0},{255,255,255},3))

end

function state:effects_draw(ptiming)
  if GAME.effects[ptiming] then
    for _, v in pairs(GAME.effects[ptiming]) do
      if not v.finished then
        v:draw() 
        if v.modal then
          break
        end
      end
    end
  end 
end

function state:effects_add(ptiming,pobject)
  local _timing = ptiming
  if pobject.id == nil then
    pobject.id = generateId("eff")
  end
  if _timing == nil then
    _timing = pobject.timing
  end
  if GAME.effects[_timing] == nil then
    GAME.effects[_timing]={}
  end
  table.insert(GAME.effects[_timing],pobject)
end

function state:getEffectById(pId)
  for _, vv in pairs(GAME.effects) do
   for _, v in pairs(vv) do
     if v.id == pId then
     return v
     end
   end
  end
  return nil
end

function state:objects_add(pobject)
  if pobject.id == nil then
    pobject.id = generateId(pobject.type)
  end
  if GAME.objects[pobject.id] == nil then
    GAME.objects[pobject.id] = pobject
  end
  return pobject.id
end

function state:getObjectById(pid)
  return GAME.objects[pid]
end

function state:getObjectByName(pname)
  for _, vv in pairs(GAME.objects) do
    if vv.name == pname then
    return vv
  end
  end
  return nil
end

function state:getObjectsByAttribute(pattr,pvalue)
  local _r = {}
  local _n = 0
  for _, vv in pairs(GAME.objects) do
    if vv[pattr] == pvalue then
    table.insert(_r,vv)
    _n = _n + 1
  end
  end
  return _n, _r
end

function state:graphics_clear()
  GAME.level.graphics_rear = {}
  GAME.level.graphics_front = {}
end

function state:graphics_draw(ptable)
  --- graphics layer
  love.graphics.setColor(255, 255, 255, 255)
  local v, vt,va
  local gdq=love.graphics.drawq
  local gd=love.graphics.draw
  local gsc=love.graphics.setColor
  local gsf=love.graphics.setFont
  local gp=love.graphics.print
  local slg = ptable
  for i=1,# slg do
    v = slg[i]
    vt = v.t
  va = v.a
    if (vt=="drawq") then
    gdq(unpack(va))
    --gdq(va[1],va[2],va[3],va[4])
  elseif (vt=="draw") then
    gd(unpack(va))
  elseif (vt=="setColor") then
    gsc(unpack(va))
  elseif (vt=="print") then
    gp(unpack(va))
  elseif (vt=="setFont") then
    gsf(unpack(va))
  end
  end
end

function state:graphics_add(ptable,pgraphics)
  if pgraphics.id == nil then
    pgraphics.id = generateId("graph")
  end
  table.insert(ptable,pgraphics)
  return pgraphics.id
end

function state:push_coord()
  love.graphics.push()
  GAME.push_coord_num = GAME.push_coord_num + 1
end

function state:pop_coord(ptype)
  if (ptype=="all") then
    for _ = 1, GAME.push_coord_num, 1 do
    love.graphics.pop()
  end
  GAME.push_coord_num = 0
  else
    love.graphics.pop()
    GAME.push_coord_num = GAME.push_coord_num - 1
  end
end