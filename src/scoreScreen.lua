scoreScreen = {}

-- could probably have done some pseudo inheritance for both menu and game.lua, but for now, this solution is just quicker.

function scoreScreen.update(dt)
end

-- manually positioned - could be improved by taking screen.width into account.
function scoreScreen.draw()
  love.graphics.setFont(font48);
  love.graphics.print("Game Over", 85, 30);
  love.graphics.print("Final Score ", 50, 200);
  love.graphics.print(game.score, 50, 250);
  
  love.graphics.setFont(font24);
  love.graphics.print("Press Return to continue", 50, 500);
end

function scoreScreen.onLoad()

end

function scoreScreen.keyUp(key)
  if key == 'return' then
    loadMenu();
  end
 end

return scoreScreen;