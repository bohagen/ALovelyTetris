menu = {}

-- could probably have done some pseudo inheritance for both menu and game.lua, but for now, this solution is just quicker.

function menu.update(dt)
end

function menu.draw()
  love.graphics.draw(menuGfx, 0,0);
end

function menu.onLoad()
  menuGfx = love.graphics.newImage("png/menu.png")
end

function menu.keyUp(key)
    if key == 'return' then
    loadGame();
  end
end

return menu;