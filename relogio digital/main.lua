function love.load()
  love.window.setMode(500,300)
  love.window.setTitle('Relógio Digital')
  love.graphics.setBackgroundColor(0.3,0.4,0.4)
  local digit = love.graphics.newFont('DS-DIGII.ttf',140)
  local digit2 = love.graphics.newFont('DS-DIGII.ttf',50)
  hora = love.graphics.newText(digit) 
  data = love.graphics.newText(digit2)
  dia_semana = love.graphics.newText(digit2)
end
function love.draw()
  tab = os.date('*t')
  local w , h = love.graphics.getDimensions()
  local ox = hora:getWidth()/2
  local oy = hora:getHeight()/2
  hora:set(tab.hour..':'..tab.min..':'..tab.sec)
  love.graphics.setColor(0.0,0.0,0.0)
  love.graphics.draw(hora,w/2,h/3,0.0,1.0,1.5,ox,oy)
  data:set(tab.day..'/'..tab.month)
  local oxd = data:getWidth()/2
  local oxy = data:getHeight()/2
  love.graphics.draw(data,w/4,3*h/4,0.0,1.0,1.5,oxd,oxy)
  if tab.wday == 1 then
    ds = 'Dom'
  elseif tab.wday == 2 then
    ds = 'Seg'
  elseif tab.wday == 3 then
    ds = 'Ter'
  elseif tab.wday == 4 then
    ds = 'Qua'
  elseif tab.wday == 5 then
    ds = 'Qui'
  elseif tab.wday == 6 then
    ds = 'Sex'
  elseif tab.wday == 7 then
    ds = 'Sab'
  end
  dia_semana:set(ds)
  local oxs = dia_semana:getWidth()/2
  local oys = dia_semana:getHeight()/2
  love.graphics.draw(dia_semana,3*w/4,3*h/4,0.0,1.0,1.5,oxs,oxy)
end