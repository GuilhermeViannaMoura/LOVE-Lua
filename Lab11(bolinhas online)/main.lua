local bolas = {}
local iniciou = false
local mqtt = require "mqttLoveLibrary"
local id = '2010597'
local host = "test.mosquitto.org"
local canal = 'Lab11/2010597'
local njogadores = 1
local ninscritos = 0
local p = 0
local cont = 10
local rank = {}
local nfim = 0
local gera = false
local cont2 = true
local cont3 = 15
limita = true
function gera_bolas (n,seed)
  math.randomseed(seed)
  local w, h = love.graphics.getDimensions ()
  for i = 1, n do 
    local r = math.random (20,70)
    local x = math.random (r,w-r)
    local y = math.random (r+50,h-r)
    local cor = {0.8* math.random (), 0.8* math.random (), 0.8* math.random ()}
    local pontos = 70-(r-20)
    table.insert (bolas, {r=r, x=x, y=y, cor=cor,pontos=pontos })
  end 
end
function desenha_bolas ()
  for i, b in ipairs (bolas) do 
    love.graphics.setColor(b.cor [1] ,b.cor [2] ,b.cor [3]) 
    love.graphics.circle("fill",b.x,b.y,b.r)
  end 
end
function msg (m)
  if m:sub(1,6) == 'pronto' then
    ninscritos = ninscritos + 1
    if ninscritos == njogadores then
      math.randomseed(os.time())
      local s = math.random(1,1000)
      mqtt.sendMessage(string.format('inicia:%d',s),canal)
    end
  elseif m:sub(1,6) == 'inicia' then
    iniciou = true
    seed = m.match(m,'inicia:(%d*)')
  elseif m:sub(1,5) == 'mouse' then
    local jogador, x, y = m.match(m,'.-:(.-):(.-):(.+)')
    for i = #bolas , 1, -1 do 
      local d = math.sqrt ((x- bolas[i].x )^2+(tonumber(y)- bolas[i].y)^2)
        if d <= bolas [i].r then
          if jogador==id then
            p = p + bolas[i].pontos
          end
          table.remove(bolas,i)
        break 
        end
    end
  elseif m:sub(1,3) == 'fim' then
    nfim = nfim + 1
    --print(nfim)
    local player,points = m.match(m,'%a+:(%P*):(%d*)')
    --print(player)
    --print(points)
    rank[#rank + 1] = {id=player,pontos=points}
  end
end
function love.mousepressed(x,y)
  if iniciou then
    local msg = string.format('mouse:%s:%d:%d',id,x,y)
    mqtt.sendMessage(msg,canal)
  end
end
function rk(rank)
  table.sort(rank,function(a,b)
    return a.pontos > b.pontos
    end
  )
  for i = 1,njogadores do
    if i == 1 then
      love.graphics.print('id: '..rank[i].id,290,127)
      love.graphics.print('pontos: '..rank[i].pontos,400,127)
    elseif i == 2 then
      love.graphics.print('id: '..rank[i].id,80,223)
      love.graphics.print('pontos: '..rank[i].pontos,190,223)
    elseif i == 3 then
      love.graphics.print('id: '..rank[i].id,540,252)
      love.graphics.print('pontos: '..rank[i].pontos,650,252)
    end
  end
end
function love.load()
  mqtt.start(host,id,canal,msg)
  love.window.setMode (800 ,700)
  love.graphics.setBackgroundColor (1,1,1)
  mqtt.sendMessage("pronto",canal)
  fonte = love.graphics.newFont(25)
  fonte2 = love.graphics.newFont(50)
  txt = love.graphics.newText(fonte2)
  seg = love.graphics.newText(fonte2)
  reg = love.graphics.newText(fonte2)
  podio = love.graphics.newImage('podio.jpg')
end
function love.update(dt)
  mqtt.checkMessages()
  love.timer.sleep(0.02)
  if iniciou then
    cont = cont - dt
    cont3 = cont3 - dt
  end
end
function love.draw()
  local n = 70
  if cont >= 1 then
    love.graphics.setColor(0,0,0)
    local w, h = love.graphics.getDimensions ()
    reg:set(math.floor(cont))
    local ox = reg:getWidth()
    local oy = reg:getHeight()
    love.graphics.draw(reg, w/2, h/2,0,1,1,ox,oy)
  end
  if cont < 1 then
    if nfim >= njogadores then
      love.graphics.print('Fim de jogo!!!',10,5)
      love.graphics.push()
        love.graphics.setColor(1,1,1)
        love.graphics.draw(podio,-55,30,0,1,1)
      love.graphics.pop()
      love.graphics.setColor(0,0,0)
      rk(rank)
    elseif cont3 <= -10 then
      love.graphics.print('Carregando...',10,5)
      local msgf = string.format('fim:%s:%d',id,p)
      if limita then
        mqtt.sendMessage(msgf,canal)
        limita = false
      end
    elseif iniciou then
      if not gera then
        gera_bolas(n,seed)
        gera = true
      end
      desenha_bolas()
      love.graphics.setColor(0,0,0)
      txt:set('Pontos: '..p)
      seg:set('Tempo: '..math.floor(cont3+10)..'s')
      love.graphics.draw(txt, 5,2)
      love.graphics.draw(seg, 480,1)
    end
  end
end