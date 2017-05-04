

function love.load()
  -- for debugging.
  if arg and arg[#arg] == "-debug" then require("mobdebug").start() end
  
  game = require "game";
  menu = require "menu";
  scoreScreen = require "scoreScreen";
  
  font48 = love.graphics.setNewFont("/font/upheavtt.ttf", 48);
  font24 = love.graphics.setNewFont("/font/upheavtt.ttf", 24);
  font80 = love.graphics.setNewFont("/font/upheavtt.ttf", 80);
 
  loadMenu();
 
end

function loadGame()
  -- load the game
  game.onLoad();
  
  -- set up callbacks
  love.keyreleased = game.keyUp;
  love.draw = game.draw;
  love.update = game.update;
end

function loadScore()
  -- load the scorescreen
  scoreScreen.onLoad();
  
  -- set up callbacks
  love.keyreleased = scoreScreen.keyUp;
  love.draw = scoreScreen.draw;
  love.update = scoreScreen.update;
end

function loadMenu()
  -- load the game
  menu.onLoad();
  
  -- set up callbacks
  love.keyreleased = menu.keyUp;
  love.draw = menu.draw;
  love.update = menu.update;
end




