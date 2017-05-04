Block = {
  layout = {},
  cellSize = 25, -- size, on screen, for each block.
  position = {x = 0 , y = 0},
}

-- constructor for this meta class.
function Block:new(o)
  o = o or {};
  setmetatable(o, self);
  self.__index = self;
 
  return o
end

function Block:setShape(shape)
  
  self.position = {x = 0 , y = 0};
  self.shape = shape;
  
  if shape == 'I' then
    self:fillInLayout(5);
    
    self.layout[1][3] = 1;
    self.layout[2][3] = 1;  
    self.layout[3][3] = 1;   
    self.layout[4][3] = 1;
  elseif shape == 'S' then
    self:fillInLayout(3);
    
    self.layout[1][3] = 1;
    self.layout[2][3] = 1;  
    self.layout[2][2] = 1;   
    self.layout[3][2] = 1;
  elseif shape == 'Z' then
    self:fillInLayout(3);
    
    self.layout[1][2] = 1;
    self.layout[2][2] = 1;  
    self.layout[2][3] = 1;   
    self.layout[3][3] = 1;  
  elseif shape == 'J' then
    self:fillInLayout(3);
    
    self.layout[1][2] = 1;
    self.layout[2][2] = 1;  
    self.layout[3][2] = 1;   
    self.layout[3][3] = 1;
  elseif shape == 'L' then
    self:fillInLayout(3);

    self.layout[1][2] = 1;
    self.layout[2][2] = 1;  
    self.layout[3][2] = 1;   
    self.layout[3][1] = 1;
  elseif shape == 'O' then
    self:fillInLayout(4);

    self.layout[2][3] = 1;
    self.layout[3][3] = 1;  
    self.layout[2][2] = 1;   
    self.layout[3][2] = 1;
  elseif shape == 'T' then
    self:fillInLayout(3);
  
    self.layout[1][2] = 1;
    self.layout[2][2] = 1;  
    self.layout[3][2] = 1;   
    self.layout[2][1] = 1;
  end
end

-- fills in the table, so it's not filled with nil.
function Block:fillInLayout(size)
  self.numBlocks = size;
  self.layout = {};

  for i=1, self.numBlocks do
    self.layout[i] = {}
    for j=1, self.numBlocks do
      self.layout[i][j] = 0;
    end  
  end
end

function Block:show()
  love.graphics.setColor(255, 255, 255, 255);

  for i=1, self.numBlocks do
    for j=1, self.numBlocks do
      if self.layout[i][j] == 1  then 
        love.graphics.rectangle(
          'fill', 
          i*self.cellSize + self.position.x * self.cellSize, 
          j*self.cellSize + self.position.y * self.cellSize, 
          self.cellSize, 
          self.cellSize
          );
      end
    end
  end
end

-- rotation, fwd dictates direction of rotation.
function Block:rotateShape(fwd)
  
-- for now, we use a classic transpose and reversal of the rows for the rotation.
  rMatrix = {};
  
    -- todo, for some reason, I can't add values below if I don't set them to 0 first? Will have to explore later.
    for i=1, self.numBlocks do
      rMatrix[i] = {}
        for j=1, self.numBlocks do
          rMatrix[i][j] = 0;
        end  
    end

    -- the actual rotation action, depending on direction.
    for i=1, self.numBlocks do
      for j=1, self.numBlocks do
          if(fwd) then
            rMatrix[i][j] = self.layout[self.numBlocks - j + 1][i];
          else 
            rMatrix[i][j] = self.layout[j][self.numBlocks - i+1];
          end
      end  
    end
  self.layout = rMatrix;
end

-- logic for moving the block.
function Block:move(xDirection, yDirection)
  
  self.position.x = self.position.x + xDirection;
  self.position.y = self.position.y + yDirection;
end

-- reset - handy for testing different block positions.
function Block:resetPosition()
  self.position.x = 0;
  self.position.y = 0;
end
