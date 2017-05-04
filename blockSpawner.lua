--[[
  Addendum, the method used in this algorithm is not terribly efficent, and at 
  this point, it has just occured to me that a similar result could be achieved 
  using a simpler method (for v2). By counting the gap in each line, and finding
  out what's underneath each gap (and also what's above), it becomes a relatively 
  straight forward matter of excluding or including a large numbers of pieces.
  
  A 4 block wide gap? Don't spawn any 'I' blocks. 
  a 3 block wide gap? Remove the J, L, and T blocks from play.
  
  And so on..
  
  However, it's also important to note that I probably would not have made this 
  realisation had it not been for v1 of this game, as it is with any experimentation.
  
  Another approach to finding the best block could also involve building a 
  3 dimensional graph involving every possible move with each block, the third 
  dimension representing rotation. This could potentially also catch all
  the examples where the player builds an "overpass", restricting the efficiency of
  the algorithm.
 --]]

blockSpawner = {
  blocks = {},
}

-- this is just for 'timekeeping' in lack of a better word
blockHelper = {
  initialX = 0,
  finalX = 0,
  currentPosition = 0,
  currentOrientation = 1;
}

-- every component
function blockSpawner.buildBlocks()
  blocks = {};
  
  blocks[1] = Block:new();
  blocks[1]:setShape('I');
  blocks[2] = Block:new();
  blocks[2]:setShape('S');
  blocks[3] = Block:new();
  blocks[3]:setShape('Z');
  blocks[4] = Block:new();
  blocks[4]:setShape('O');
  blocks[5] = Block:new();
  blocks[5]:setShape('J');
  blocks[6] = Block:new();
  blocks[6]:setShape('L');
  blocks[7] = Block:new();
  blocks[7]:setShape('T');

  return blocks;
end

-- algorithm is relatively straight forward
-- try every possible position by dropping by down every piece in the play area
-- pieces that are more likely to increase total height of the entire thing are 
-- more likely to be chosen, unless of course they can be used to clear lines.
function blockSpawner.findNext(currentplayarea)
  
  -- make a new play area for testing on. Make sure to mark it as such.
  testArea = playarea:new();
  testArea.realArea = false;
  
  for i=1, 7 do-- maaagic numbers.
    
    b = blockSpawner.blocks[i];
    b.score = 0;
    b.numPlacements = 0;
    allPositionsTested = false;
    blockSpawner.setUpBlockHelper(b, testArea.width);
    
    repeat 
      -- reset the playing area to look like the current.
      testArea.layout = blockSpawner.deepcopy(currentplayarea.layout);
      
      if(not testArea:OutOfHorizontalBounds(b)) then
        -- let's drop a block.
        blockSpawner.dropBlock(b);
        
        -- add the block to the current score.
        b.score = b.score + blockSpawner.calculateScore(testArea);
        b.numPlacements = b.numPlacements + 1;
      end
      
      -- Check how far along we are testing this particular piece.
      allPositionsTested = blockSpawner.isAllPositionsTested();
      
      -- we basically keep this up until every permutation of any tetronimo is tested.
      if not allPositionsTested then
        b:resetPosition();
        blockSpawner.selectNextPosition(b);
      end
   
    until allPositionsTested;
    -- take the average, as the O block can be placed more often.
    b.score = b.score / b.numPlacements;
  end
  blockSpawner.sortScores();
  
  return blocks;
end


-- Set the block helper. Worth noting that it actually extends over the play area on purpose.
function blockSpawner.setUpBlockHelper(b, width)
    blockHelper.initialX = 1 - b.numBlocks;
    blockHelper.finalX = b.numBlocks + width - 1;
    blockHelper.currentOrientation = 1;
    blockHelper.currentPosition = blockHelper.initialX;
    
    b.position.x = blockHelper.currentPosition;
end


function blockSpawner.isAllPositionsTested()
  return blockHelper.currentPosition == blockHelper.finalX and blockHelper.currentOrientation == 4
end

-- duplicate code, I'll have to point it back to the one in game.lua
function blockSpawner.dropBlock(b)
        repeat 
        b:move(0, 1);
        inbounds = testArea:VerticalBounds(b) 
      until inbounds;
end

-- sets the next starting position for the block that is being tested.
function blockSpawner.selectNextPosition(b)
  if blockHelper.currentOrientation == 4 then
    blockHelper.currentPosition = blockHelper.currentPosition + 1;
    blockHelper.currentOrientation = 1;
  else 
    blockHelper.currentOrientation = blockHelper.currentOrientation + 1;
    b:rotateShape(true);
  end
  
  b.position.x = blockHelper.currentPosition;
end

function blockSpawner.sortScores()
    table.sort(blocks, function(a,b) return a.score>b.score end)
end

function blockSpawner.calculateScore(playArea)
-- in reverse order, count the number of blocks. 
-- The higher we go up, the higher the score of each block
-- bottom line is 1.1, next is 1.2, 1.3 etc.
-- why? We want to pick the block that gives the highest potential to put something up top
-- At the same time, if the player positions a block so it removes a line, the score will be drastically reduced. 
  score = 0;
  
  for i = 1, playArea.width do
    for j = 1, playArea.height do
      col = playArea.width - i+1;
      row = playArea.height - j+1; 
      
      if playArea.layout[col][row] == 1  then
        score = score + (1 + (j/5));
      end
    end
  end
  
  return score;
end

-- courtesy of http://lua-users.org/wiki/CopyTable
-- in retrospect, a simpler method could just as easily have been used copying the tables.
-- alas still learning the language, at this point in time.
function blockSpawner.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[blockSpawner.deepcopy(orig_key)] = blockSpawner.deepcopy(orig_value)
        end
        setmetatable(copy, blockSpawner.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return blockSpawner;
