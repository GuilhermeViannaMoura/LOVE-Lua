require = math
--VARIÁVEIS DISPARO
local mantemDirecao = true
local Tiro = {}
local atira = true
local delayTiro = 0.7
local tempoAteAtirar = delayTiro
local velocidadeDisparo = 1600
--VARIÁVEIS INIMIGOS
local delayInimigo = 1.5  --facil = 1.5/ medio = 1/ dificil = 0.8
local tempoCriarInimigo = delayInimigo
local Inimigos = {}
local jogo = true
local pontos = 0
local esperaTiro = 6
function love.load()                                              --LOAD
  love.window.setMode(1500,950,msaa)
  --love.graphics.setBackgroundColor(0.7,0.7,0.7) CINZA
  love.graphics.setBackgroundColor(0.3,0,0)
  love.window.setTitle('Projeto01')
  w , h = love.graphics.getDimensions()
  fonte = love.graphics.newFont('Skate Brand.otf',30)
  fonte2 = love.graphics.newFont('Skate Brand.otf',150)
  ptxt = love.graphics.newText(fonte)
  final = love.graphics.newText(fonte2,'FIM DE JOGO')
  numPontos = love.graphics.newText(fonte)
  reviver = love.graphics.newText(fonte,"Pressione 'space' para reviver!")
  --SONS DO JOGO
  musicaFim = love.audio.newSource('musicas/QuickRevivePerk.mp3','stream')
  musicaJogo = love.audio.newSource('musicas/Panic Attack BO1.mp3','stream')
  somTiro = love.audio.newSource('musicas/Tiro.mp3','static')
  musicaFim:setVolume(0.1)
  musicaJogo:setVolume(0.1)
  somTiro:setVolume(0.1)
  musicaJogo:play()
  musicaJogo:setLooping(true)
  --CRIA SOLDADO
  imgSold1 = love.graphics.newImage('imagens/soldado.png')
  ox = imgSold1:getWidth()/2
  oy = imgSold1:getHeight()/2
  Sold1 = { posX = w/2,
            posY = h/2,
            velocidade = 300
          }
  --CRIA TIRO
  imgTiro = love.graphics.newImage('imagens/projetil.png')
  --CRIA INIMIGO
  imgInimigo = love.graphics.newImage('imagens/inimigo3.png')
  --CRIA BACKGROUND
  imgFundo = love.graphics.newImage('imagens/grass map.jpg')
end
function dispara2 (dt) 
  tempoAteAtirar = tempoAteAtirar - dt
  if tempoAteAtirar < 0 then
    atira = true
  end
  if love.mouse.isDown(1) and atira then
    novoTiro = {x = Sold1.posX, y = Sold1.posY, img = imgTiro, roty = math.sin(angulo)*velocidadeDisparo,
      rotx = math.cos(angulo)*velocidadeDisparo}
    table.insert(Tiro,novoTiro)
    somTiro:stop()
    somTiro:play()
    atira = false
    tempoAteAtirar = delayTiro
  end
  local i = 1
  while i <= #Tiro do
    Tiro[i].y = Tiro[i].y + Tiro[i].roty * dt
    Tiro[i].x = Tiro[i].x + Tiro[i].rotx * dt
    if (Tiro[i].y < 0 or Tiro[i].x < 0) or (Tiro[i].y > h or Tiro[i].x > w) then
      table.remove(Tiro,i)
    else
      i = i + 1
    end
  end
end
function dispara (dt)
  tempoAteAtirar = tempoAteAtirar - dt
  if tempoAteAtirar < 0 then
    mantemDirecao = true
    atira = true
  end
  if love.mouse.isDown(1) and atira then
    novoTiro = {x = Sold1.posX, y = Sold1.posY, img = imgTiro, roty = math.sin(angulo)*velocidadeDisparo,
      rotx = math.cos(angulo)*velocidadeDisparo}
    table.insert(Tiro,novoTiro)
    somTiro:stop()
    somTiro:play()
    atira = false
    tempoAteAtirar = delayTiro
  end
  for i, tiro in ipairs(Tiro) do --MOVIMENTO DO TIRO
    if mantemDirecao then
      tiro.roty = math.sin(angulo)*velocidadeDisparo
      tiro.rotx = math.cos(angulo)*velocidadeDisparo
      mantemDirecao = false
    end
    tiro.y = tiro.y + tiro.roty * dt
    tiro.x = tiro.x + tiro.rotx * dt
    if tiro.y < 0 or tiro.x < 0 then
      table.remove(Tiro, i)
    end
    if tiro.y > h or tiro.x > w then
      table.remove(Tiro, i)
    end
  end
end
function inimigo (dt)
  math.randomseed(os.time())
  tempoCriarInimigo = tempoCriarInimigo - dt
  if pontos > 30 then
    delayInimigo = 0.7
  elseif pontos > 20 then
    delayInimigo = 0.8
  elseif pontos > 10 then
    delayInimigo = 1
  end
  if tempoCriarInimigo < 0 then
    tempoCriarInimigo = delayInimigo
    sorteiaLado = math.random(1,4)
    if sorteiaLado == 1 then
      x1 = -10
      y1 = math.random(60,h-60)
    elseif sorteiaLado == 2 then
      x1 = math.random(60,w-60)
      y1 = h+10
    elseif sorteiaLado == 3 then
      x1 = w+10
      y1 = math.random(60,h-60)
    elseif sorteiaLado == 4 then
      x1 = math.random(60,w-60)
      y1 = -10
    end
    novoInimigo = {x = x1, y = y1, img = imgInimigo}
    angulo2 = (math.atan2(novoInimigo.x-Sold1.posX,novoInimigo.y-Sold1.posY)*-1) + 3*math.pi/2
    novoInimigo.rot = angulo2
    table.insert(Inimigos, novoInimigo)
  end
  --MOVIMENTAÇÃO INIMIGO COM PERSEGUISSÃO
  for i, inimigo in ipairs(Inimigos) do
    if inimigo.y < Sold1.posY then
      inimigo.y = inimigo.y + (100 * dt)
    end
    if inimigo.y > Sold1.posY then
      inimigo.y = inimigo.y - (100 * dt)
    end
    if inimigo.x < Sold1.posX then
      inimigo.x = inimigo.x + (100 * dt)
    end
    if inimigo.x > Sold1.posX then
      inimigo.x = inimigo.x - (100 * dt)
    end
    angulo2 = (math.atan2(inimigo.x-Sold1.posX,inimigo.y-Sold1.posY)*-1) + 3*math.pi/2
    inimigo.rot = angulo2
  end
end
function checaColisao(x1,y1,w1,h1,x2,y2,w2,h2)
  if x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1 then
    return true
  else
    return false
  end
end
function colisao()
  wi = imgInimigo:getWidth()*0.45
  hi = imgInimigo:getHeight()*0.45
  wt = imgTiro:getWidth()*0.7
  ht = imgTiro:getHeight()*0.7
  ws = imgSold1:getWidth()*0.4
  hs = imgSold1:getHeight()*0.4
  for i, inimigo in ipairs(Inimigos) do
    for j, tiro in ipairs(Tiro) do
      if checaColisao(inimigo.x,inimigo.y,wi,hi,tiro.x,tiro.y,wt,ht) then
        table.remove(Tiro, j)
        table.remove(Inimigos, i)
        pontos = pontos + 1
      end
    end
    if checaColisao(inimigo.x,inimigo.y,wi,hi,Sold1.posX,Sold1.posY,ws,hs) then
      table.remove(Inimigos,i)
      jogo = false
      Sold1.posX = w/2
      Sold1.posY = h/2
      musicaJogo:stop()
    end
  end
end
function soldado (dt)
  if love.keyboard.isDown('d') then
    if Sold1.posX < (w - ox + 15) then
      Sold1.posX = Sold1.posX + Sold1.velocidade * dt
    end
  end
  if love.keyboard.isDown('a') then
    if Sold1.posX > (ox - 20) then
      Sold1.posX = Sold1.posX - Sold1.velocidade * dt
    end
  end
  if love.keyboard.isDown('s') then
    if Sold1.posY < (h-oy) then
      Sold1.posY = Sold1.posY + Sold1.velocidade * dt
    end
  end
  if love.keyboard.isDown('w') then
    if Sold1.posY > (oy) then
      Sold1.posY = Sold1.posY - Sold1.velocidade * dt
    end
  end  
end
function love.keypressed(key)
  if key == 'space' and not jogo then
    musicaFim:stop()
    musicaJogo:play()
    Inimigos = {}
    pontos = 0
    delayInimigo = 1.5
    jogo = true
  end
end
function love.update(dt)                                         --UPDATE
  if jogo then
  --MOVIMENTO SOLDADO
  soldado(dt)
  mouseX = love.mouse.getX() - w/2
  mouseY = love.mouse.getY() - h/2
  --ACHA ANGULO ENTRE SOLDADO E MOUSE
  mX = love.mouse.getX()
  mY = love.mouse.getY()
  angulo = (math.atan2(mX-Sold1.posX,mY-Sold1.posY) * -1) + math.pi/2 --soldado/mouse
  --MOVIMENTO TIRO
  dispara(dt)
  --dispara2(dt)
  --MOVIMENTO INIMIGO
  inimigo(dt)
  --CHECA COLISAO
  colisao()
  end
end
function love.draw()                                             --DRAW
  if jogo then
    --DESENHA IMAGEM FUNDO
    oxbg = imgFundo:getWidth()/2
    oybg = imgFundo:getHeight()/2
    love.graphics.draw(imgFundo,w/2,h/2,0,1,1,oxbg,oybg)
    --DESENHA SOLDADO
    love.graphics.draw(imgSold1, Sold1.posX, Sold1.posY, angulo, 0.4, 0.4, ox, oy)
    love.graphics.setColor(1,0,0)
    love.graphics.line(Sold1.posX,Sold1.posY,mX,mY)
    love.graphics.setColor(1,1,1)
    --DESENHA TIROS
    for i, tiro in ipairs(Tiro) do
      love.graphics.draw(tiro.img, tiro.x, tiro.y, 0, 0.6, 0.6, imgTiro:getWidth()/2, imgTiro:getHeight())
    end
    --DESENHA INIMIGOS
    oxi = imgInimigo:getWidth()/2
    oyi = imgInimigo:getHeight()/2
    for i, inimigo in ipairs(Inimigos) do
      love.graphics.draw(inimigo.img, inimigo.x, inimigo.y, inimigo.rot, 0.45, 0.45, oxi, oyi)
    end
    numPontos:set('Pontos: '..pontos)
    love.graphics.draw(numPontos,10,10)
  else
    musicaFim:play()
    ptxt:set('Sua pontuação\n            '..pontos)
    oxp = ptxt:getWidth()/2
    oyp = ptxt:getHeight()/2
    oxf = final:getWidth()/2
    oyf = final:getHeight()/2
    oxr = reviver:getWidth()/2
    oyr = reviver:getHeight()/2
    love.graphics.draw(ptxt,w/2,h/2,0,1,1,oxp,oyp)
    love.graphics.draw(final,w/2,h/2-200,0,1,1,oxf,oyf)
    love.graphics.draw(reviver,w/2,h/2+100,0,1,1,oxr,oyr)
  end
end