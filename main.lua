-- game infos
game_id = "stealthman"
game_title = "StealthMan"
game_version = "00.01"

-- libraries
Gamestate = require "lib/gamestate"
require("lib/SECS")
require("lib/utils")
require("lib/dumper")
require("lib/json")
require("lib/simplegui")
require("lib/BTLua")
require("lib/mrpas")
require("lib/los")
require("lib/Astar_tengine")
require("lib/assetloader")

if images.icon then
  love.graphics.setIcon( images.icon )
end

--profiler = require "profiler"

function love.load()

  -- Set filesystem identity
  love.filesystem.setIdentity(game_id)

  love.graphics.setCaption(game_title)

  readScreenMode("configs.txt",images.icon)

  -- Set Random Seed
  math.randomseed(os.time());
  math.random()
  math.random()
  math.random()

  Gamestate.registerEvents()
  require ("states/intro")
  Gamestate.switch(Gamestate.intro)

end

