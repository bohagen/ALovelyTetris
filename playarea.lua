playarea = {
  layout = {},
  width = 10, -- official size
  height = 22, -- official size
  cellSize = 25, -- size, on screen, for each block.
  position = {x = 0, y = 0},
  realArea = true; -- used to differentiate between the actual playing area, and those just used for testing.
}

-- constructor
function playarea:new(o)
  o = o or {};
  setmetatable(o, self);
  self.__index = self;
  return o
end

-- intial playarea. empty.
function playarea:initiatePlayArea()
  self.layout = {};
  position = {x = 0, y = 0};
  -- initiate play area.
  for i=1, self.width do
    self.layout[i] = {};
    for j=1, self.height do
      self.layout[i][j] = 0
    end
  end  
end

-- draw the play area. 
function playarea:show()
  for i=1, self.width do
    for j=1, self.height do
      if(self.layout[i][j] == 1 ) then 
        love.graphics.setColor(255, 255, 255, 255);
      else
        love.graphics.setColor(64, 64, 64, 255);
      end

      love.graphics.rectangle(
        'fill', 
        i*self.cellSize + position.x, 
        j*self.cellSize + position.y, 
        self.cellSize, 
        self.cellSize
      );
      
      love.graphics.setColor(128, 128, 128, 255);
      love.graphics.rectangle('line', 
        position.x + self.cellSize, 
        position.y + self.cellSize, 
        position.x+ self.width*self.cellSize+1, 
        position.y+ self.height*self.cellSize+1)
    end
  end
 end

-- check if the tetromino is out of bounds when rotated.
function playarea:OutOfRotationBounds(b)
  xPos = b.position.x;
  yPos = b.position.y;

  numBlocks = b.numBlocks;

  for i = 1, numBlocks do
    for j = 1, numBlocks do
      blockVal = b.layout[i][j];
      if(blockVal == 1 ) then
        if xPos + i < 1 or xPos + i > self.width then
          return true;
        end
        if self.layout[xPos + i][yPos + j] == 1  then
          return true;
        end
        if yPos + j > self.height then
          return true;
        end
      end
    end
  end

  return false;
end

-- make sure the tetromino doesn't move out of the play area, OR doesn't collide with 
function playarea:OutOfHorizontalBounds(b)

  xPos = b.position.x;
  yPos = b.position.y;

  numBlocks = b.numBlocks;

  for i = 1, numBlocks do
    for j = 1, numBlocks do
      blockVal = b.layout[i][j];
      if(blockVal == 1 ) then
        if xPos + i < 1 or xPos + i > self.width then
          return true;
        end
        if self.layout[xPos + i][yPos + j] == 1  then
          return true;
        end
      end
    end
  end

  return false;
end

-- check if the block has hit the bottom line, or any blocks in the world.
function playarea:VerticalBounds(b)
  xPos = b.position.x;
  yPos = b.position.y;

  numBlocks = b.numBlocks;

  for i = 1, numBlocks do
    for j = 1, numBlocks do
      blockVal = b.layout[i][j];
      if(blockVal == 1 ) then
        -- upon moving the block down, let's also just check for score! 
        if self.layout[xPos + i][yPos + j] == 1  then
          -- as below, let's just move the block up one spot.
          b.position.y = b.position.y - 1;
          self:solidify(b);
          return true;
        end
        if yPos + j > self.height then
          -- let's just move the block up one spot.
          b.position.y = b.position.y - 1;
          self:solidify(b);
          return true;
        end
      end
    end
  end
  return false;
end

-- whatever happens when the tetromino hits the bottom / the world.
function playarea:solidify(b)

  -- insert the block into the play area.
  xPos = b.position.x;
  yPos = b.position.y;

  blayout = b.layout;

  for i = 1, b.numBlocks do
    for j = 1, b.numBlocks do
      blockVal = blayout[i][j];
      if(blockVal == 1 ) then
        self.layout[i + xPos][j + yPos] = blockVal;
      end
    end
  end
  
  -- check for lines
  self:checkForLines();
end

-- a simple check if a line is complete.
function playarea:checkForLines()
  for j = 1, self.height do 
    numHits = 0;
    for i = 1, self.width do
      if self.layout[i][j] == 0 then
        break;
      else
        numHits = numHits+1;
      end
      if numHits == self.width then
        self:removeLine(j);
      end
    end
  end
end

-- do we need to remove a line?
function playarea:removeLine(lineNum)
  -- essentially, we don't care about actually deleting the current line
  -- we just copy it over with the next one, 
  -- and repeat this step for each line above it.
  currentLine = lineNum;
  
  while currentLine > 0 do
    for i = 1, self.width do
      self.layout[i][currentLine] = self.layout[i][currentLine - 1] or 0;
    end
    currentLine = currentLine - 1;
  end
  
  if(self.realArea) then
    game.increaseScore(10);
  end
end

-- check if a block can actually spawn - otherwise, game over.
function playarea:canSpawn(b)
  
  xPos = b.position.x;
  yPos = b.position.y;
  
  for i = 1, b.numBlocks do
    for j = 1, b.numBlocks do
      blockVal = b.layout[i][j];
      if(blockVal == 1 ) then -- if there's a piece here then
        if self.layout[xPos + i][yPos + j] == 1  then -- ...checks if it overlaps with the play area.
          return false;
        end
      end
    end
  end
  return true;
end
