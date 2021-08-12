function love.load()
  love.window.setMode(400,400)
  love.window.setTitle('Relógio Analógico')
  love.graphics.setBackgroundColor(1.0,1.0,1.0)
  fonte = love.graphics.newFont('BebasNeue-Regular.ttf',50)
  fonte2 = love.graphics.newFont('BebasNeue-Regular.ttf',25)
  data = love.graphics.newText(fonte)
  texto = love.graphics.newText(fonte2)
end
function numrlg()
  
  for i=1,12 do
    tab = {'1','2','3','4','5','6','7','8','9','10','11','12'}
    love.graphics.push()
      love.graphics.translate(200, 200)
      texto:set(tab[i])
      ox= texto:getWidth()/2
      oy = texto:getHeight()/2
      love.graphics.rotate(i * 2 * math.pi / 12)
      love.graphics.draw(texto,0,-85,0.0,1.0,1.0,ox,oy)
    love.graphics.pop()
  end
end
function love.draw()
  local tab = os.date('*t')
  data:set(tab.day..'/'..tab.month..'/'..tab.year)
  local oy = data:getHeight()/2
  local ox = data:getWidth()/2
  numrlg()
  love.graphics.push()
    love.graphics.translate(200,200)
    love.graphics.setColor(0.0,0.0,0.0)
    love.graphics.draw(data,0.0,-150,0.0,1.0,1.0,ox,oy)
    love.graphics.setLineWidth(2.0)
    love.graphics.circle('line',0,0,100)
    --Ponteiro Segundo
    love.graphics.setColor(0.7,0.0,0.0)
    love.graphics.setLineWidth(1.0)
    local rs = tab.sec * math.rad(6)
    love.graphics.push()
      love.graphics.rotate(rs)
      love.graphics.line(0.0,0.0,0.0,-70)
    love.graphics.pop()
    --Ponteiro Hora
    love.graphics.setColor(0.0,0.0,0.0)
    love.graphics.setLineWidth(4.0)
    local rh = tab.hour * math.rad(30)
    love.graphics.push()
      love.graphics.rotate(rh)
      love.graphics.line(0.0,0.0,0.0,-40)
    love.graphics.pop()
    --Ponteiro Minuto
    love.graphics.setLineWidth(1.6)
    local rm = tab.min * math.rad(6)
    love.graphics.push()
      love.graphics.rotate(rm)
      love.graphics.line(0.0,0.0,0.0,-60)
    love.graphics.pop()
  love.graphics.pop()
end
