function love.load()
  love.window.setMode(700,700,{msaa=16})
  love.window.setTitle('Relógio Analógico')
  love.graphics.setBackgroundColor(1.0,1.0,1.0)
  fonte = love.graphics.newFont('BebasNeue-Regular.ttf',50)
  fonte2 = love.graphics.newFont('BebasNeue-Regular.ttf',25)
  data = love.graphics.newText(fonte)
  texto = love.graphics.newText(fonte2)
  relogio = love.graphics.newImage('clockface.png')
  ponteiros = love.graphics.newImage('clockhands.png')
  ponteiro_hora = love.graphics.newQuad(40,80,71,176,ponteiros:getDimensions())
  ponteiro_minuto = love.graphics.newQuad(109,15,43,241,ponteiros:getDimensions())
  ponteiro_segundo = love.graphics.newQuad(160,7,30,357,ponteiros:getDimensions())
end
function desenha_relogio()
  local sx = 500 / relogio:getWidth()
  local sy = 500 / relogio:getHeight()
  love.graphics.setColor(1.0,1.0,1.0)
  love.graphics.draw(relogio,100,100,0,sx,sy)
end
function desenha_ponteiro_segundo()
  local _,_,w,h = ponteiro_segundo:getViewport()
  local sx = 30 / w 
  local sy = 300 / h
  love.graphics.setColor(1.0,1.0,1.0)
  love.graphics.draw(ponteiros,ponteiro_segundo,0.0,0.0,0.0,sx,sy,w/2,235)
end
function desenha_ponteiro_hora()
  local _,_,w,h = ponteiro_hora:getViewport()
  local sx = 40 / w
  local sy = 100 / h
  love.graphics.setColor(1.0,1.0,1.0)
  love.graphics.draw(ponteiros,ponteiro_hora,0.0,0.0,0.0,sx,sy,w/2,160)
end
function desenha_ponteiro_minuto()
  local _,_,w,h = ponteiro_minuto:getViewport()
  local sx = 30 / w 
  local sy = 150 / h
  love.graphics.setColor(1.0,1.0,1.0)
  love.graphics.draw(ponteiros,ponteiro_minuto,0.0,0.0,0.0,sx,sy,w/2,231)
end
function love.draw()
  desenha_relogio()
  local tab = os.date('*t')
  data:set(tab.day..'/'..tab.month..'/'..tab.year)
  local oy = data:getHeight()/2
  local ox = data:getWidth()/2
  love.graphics.push()
    love.graphics.translate(350,350)
    love.graphics.setColor(0.0,0.0,0.0)
    love.graphics.draw(data,0.0,-300,0.0,1.0,1.0,ox,oy)
    --Ponteiro Hora
    local rh = tab.hour * math.rad(30)
    love.graphics.push()
      love.graphics.rotate(rh)
      desenha_ponteiro_hora()
    love.graphics.pop()
    --Ponteiro Minuto
    local rm = tab.min * math.rad(6)
    love.graphics.push()
      love.graphics.rotate(rm)
      desenha_ponteiro_minuto()
    love.graphics.pop()
    --Ponteiro Segundo
    love.graphics.setColor(0.7,0.0,0.0)
    local rs = tab.sec * math.rad(6)
    love.graphics.push()
      love.graphics.rotate(rs)
      desenha_ponteiro_segundo()
    love.graphics.pop()
  love.graphics.pop()
end
