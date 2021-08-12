local function leitura ()
  local T = {}
  local f = io.open('brasileirao-2017.txt','r')
  if not f then
    error('Não foi possível abrir o arquivo')
  end
  for line in f:lines() do
    local a, pa, pb, b = line:match('%s*(%D-)%s+(%d+)%s+-%s+(%d+)%s+(%D-)%s*$')
    if a and pa and pb and b then
      --io.write("'",a,"'",pa,"x",pb,"'",b,"'\n")
      if not T[a] then
        T[a] = {p=0,v=0,s=0,g=0}
      end
      if not T[b] then
        T[b] = {p=0,v=0,s=0,g=0}
      end
      if tonumber(pa) > tonumber(pb) then
        T[a].p = T[a].p + 3
        --print(T[a].p)
        T[a].v = T[a].v + 1
        --print(T[a].v)
        local saldo = pa - pb
        T[a].s = T[a].s + saldo
        T[b].s = T[b].s - saldo
        --print(T[a].s)
        T[a].g = T[a].g + pa
        T[b].g = T[b].g + pb
        --print(T[a].g)
      end
      if tonumber(pb) > tonumber(pa) then
        T[b].p = T[b].p + 3
        --print(T[b].p)
        T[b].v = T[b].v + 1
        local saldo = pb - pa
        T[b].s = T[b].s + saldo
        T[a].s = T[a].s - saldo
        T[b].g = T[b].g + pb
        T[a].g = T[a].g + pa
      end
      if tonumber(pa) == tonumber(pb) then
        T[a].p = T[a].p + 1
        T[b].p = T[b].p + 1
        T[a].g = T[a].g + pa
        T[b].g = T[b].g + pb
      end
    end
  end
  f:close()
  return T
end
local T = leitura()
tab = {}
for k,v in pairs(T) do
  tab[#tab+1] = {nome = k, p = v.p, v = v.v, s = v.s, g = v.g}
end
  table.sort(tab, function (a,b)
      if a.p > b.p then
        return true
      elseif a.p < b.p then
        return false
      else
        if a.v > b.v then
          return true
        elseif a.v < b.v then
          return false
        else
          if a.s > b.s then
            return true
          elseif a.s < b.s then
            return false
          else
            return a.g > b.g
          end
        end
      end
    end
  )
function love.load()
 love.window.setMode(700,700)
 love.window.setTitle('Brasileirão-2017')
 love.graphics.setBackgroundColor(1,1,1)
 fonte1 = love.graphics.newFont(26)
 fonte2 = love.graphics.newFont(13)
 fonte3 = love.graphics.newFont(17)
end
function love.draw()
 love.graphics.setColor(0,0,0.6)
 love.graphics.setFont(fonte1)
 love.graphics.print("Clube          P    V    S    G",50,20)
 love.graphics.line(45,20,45,650)
 love.graphics.line(190,20,190,650)
 love.graphics.line(240,20,240,650)
 love.graphics.line(290,20,290,650)
 love.graphics.line(340,20,340,650)
 love.graphics.line(390,20,390,650)
 love.graphics.line(45,650,390,650)
 love.graphics.line(45,624,390,624)
 love.graphics.line(45,594,390,594)
 love.graphics.line(45,564,390,564)
 love.graphics.line(45,534,390,534)
 love.graphics.line(45,504,390,504)
 love.graphics.line(45,474,390,474)
 love.graphics.line(45,444,390,444)
 love.graphics.line(45,414,390,414)
 love.graphics.line(45,384,390,384)
 love.graphics.line(45,354,390,354)
 love.graphics.line(45,324,390,324)
 love.graphics.line(45,294,390,294)
 love.graphics.line(45,264,390,264)
 love.graphics.line(45,234,390,234)
 love.graphics.line(45,204,390,204)
 love.graphics.line(45,174,390,174)
 love.graphics.line(45,144,390,144)
 love.graphics.line(45,114,390,114)
 love.graphics.line(45,84,390,84)
 love.graphics.line(45,54,390,54)
 love.graphics.line(45,20,390,20)
 for i = 1,20 do
  love.graphics.setColor(0,0,0)
  love.graphics.setFont(fonte3)
  love.graphics.print(i,17,28+i*30)
  love.graphics.print(tab[i].nome,50,28+i*30) -- x = 82
  love.graphics.print(tab[i].p,200,28+i*30)
  love.graphics.print(tab[i].v,250,28+i*30)
  love.graphics.print(tab[i].s,300,28+i*30)
  love.graphics.print(tab[i].g,350,28+i*30)
end
end