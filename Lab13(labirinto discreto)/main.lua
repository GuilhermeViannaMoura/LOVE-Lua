map = require ('map')
local M
local nx = 21
local ny = 21
local x = 2
local y = ny
local i = math.ceil(y)
local j = math.ceil(x)
local r = 0.5
local t0 = os.time()
local jogo = true
local fim = false
local tf = false
function love.keypressed(key)
  if jogo == true then
    if key == 'up' then
      if M[i-1][j]==true then
        i = i - 1
      end
    elseif key == 'down' then
      if M[i+1][j]==true then
        i = i + 1
      end
    elseif key == 'right' then
      if M[i][j+1]==true then
        j = j + 1
      end
    elseif key == 'left' then
      if M[i][j-1]==true then
        j = j - 1
      end
    end
  end
end
function love.load()
  math.random(3)
  M = map.create(nx,ny,true,0.0)
  love.window.setMode(600,600)
  love.graphics.setBackgroundColor(1,1,1)
  fonte = love.graphics.newFont(25)
  tempo = love.graphics.newText(fonte)
end
function love.update()
  if i == 1 and j == nx-1 then
    jogo = false
    fim = true
  end
  end
function love.draw()
  local w,h = love.graphics.getDimensions()
  local D = 500
  if jogo == true then
    love.graphics.push()
    love.graphics.translate((w-D)/2,(h-D)/2)
    love.graphics.scale(D/nx,D/ny)
    love.graphics.setColor(0,0,0)
    map.draw(M)
    love.graphics.setColor(1,0,0)
    love.graphics.circle('fill',j-0.5,i-0.5,r)
    love.graphics.pop()
  elseif fim == true then
    if not tf then
      tf = os.time()
    end
    tempo:set('Labirinto concluido em '..tostring(math.floor(tf-t0))..' segundos')
    ox = tempo:getWidth() - 220
    oy = tempo:getHeight()
    love.graphics.setColor(0,0,0)
    love.graphics.draw(tempo,w/2,h/2,0,1,1,ox,oy)
  end
end