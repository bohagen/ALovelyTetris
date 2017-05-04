-- could probably have done some pseudo inheritance for both menu and game.lua, but for now, this solution is just quicker.
local game = {
  lengthOfStep = 0.75;-- length of each ingame step, in seconds.
  score = 0;--game score.
  currentTime = 0;
}

-- include these. 
-- meta classes
require('playarea');
require('Block');
-- other modules.
difficultyModule = require('blockSpawner');

function game.onLoad()
    -- settings vars
  game.score = 0;
  
  -- game objects.
  difficultyModule.blocks = difficultyModule.buildBlocks();
  
  -- play area.
  playA = playarea:new();
  playA:initiatePlayArea();
  
  -- finally, let's spawn a block.
  game.spawnNewBlock();
end

function game.draw()
  playA:show();
  currentBlock:show();
  
  -- some GUI
  love.graphics.setFont(font24);
  love.graphics.print("SCORE", 300, 25);
  love.graphics.print(game.score, 300, 50);
  
  love.graphics.print("WORST", 300, 75);
  love.graphics.print(worstShape, 300, 100);
  
  love.graphics.print("BEST", 300, 125);
  love.graphics.print(bestShape, 300, 150);
end

-- player input.
function game.keyUp(key)
  if key == 'left' then
    game.blockMove(currentBlock, -1)
  end
  if key == 'right' then
    game.blockMove(currentBlock, 1)
  end
  if key == 'up' then
    game.blockRotate(currentBlock) 
  end
  if key == 'down' then
    game.blockFall(currentBlock);
  end
  if key == 'z' or key == 'space' or key == ' ' then
    game.blockDrop(currentBlock);
  end
  
end

-- General time loop, used to control gravity.
function game.update(dt)
  game.currentTime = game.currentTime + dt;
  if(game.currentTime > game.lengthOfStep) then
    game.currentTime = 0;
    game.step();
  end
end

function game.step()
  game.blockFall(currentBlock); 
end

-- This is called when the player presses left or right, or called by game.blockFall. 
function game.blockMove(b, xDirection)
  b:move(xDirection, 0);
  if(playA:OutOfHorizontalBounds(b)) then 
    b:move(-xDirection, 0);
  end
end

-- move the tetromino downwards.
function game.blockFall(b)
  b:move(0, 1);
  -- doing a simple vertical bounds check to see if we're actually trying to move the block an element. 
  -- If so, let's move it back up, and paste it into the playarea
  if playA:VerticalBounds(b) then
      game.spawnNewBlock();
  end
  
end

function game.blockRotate(b)
    b:rotateShape(true);
  
  if playA:OutOfRotationBounds(b) then
    b:rotateShape(false);
    return false;
  else
    currentTime = 0;
  end
end

-- drop a block to the bottom of the field.
 function game.blockDrop(b)
  repeat 
    b:move(0, 1);
    inbounds = playA:VerticalBounds(b) 
  until inbounds;
  
  -- spawn new.
  game.spawnNewBlock();
 end
 
 -- spawns new. 
 function game.spawnNewBlock()
   
  -- get the shape.
  shapes = difficultyModule.findNext(playA); -- slooow.
  worstShape = shapes[1].shape;
  bestShape = shapes[7].shape;
   
   -- new block
  currentBlock = Block:new();
  currentBlock:setShape(worstShape);
   
  if(not playA:canSpawn(currentBlock)) then
    game.gameOver();
    -- game over!
  end

end

function game.increaseScore(addedScore)
  game.score = game.score + addedScore;
end

-- pretty self-explanatory. Called when the player can not put down anymore blocks.
function game.gameOver()
  loadScore();
end


return game;
