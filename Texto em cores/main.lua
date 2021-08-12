function textoColorido(texto)
  local tab = {}
  local Cores = { 
    red = {1.0, 0.0, 0.0},
    green = {0.0, 1.0, 0.0}, 
    blue = {0.0, 0.0, 1.0}, 
    yellow = {1.0, 1.0, 0.0}, 
    magenta = {1.0, 0.0, 1.0}, 
    cyan = {0.0, 1.0, 1.0},
    gray= {0.5, 0.5, 0.5},
    white= {1.0, 1.0, 1.0},
  }
  texto = string.gsub(texto,'([^<]*)<:(.-):(.-):>*',function(txtpreto,cor,txtcolorido)
 tab[#tab+1]={0.0,0.0,0.0}
 tab[#tab+1]=txtpreto 
 tab[#tab+1]=Cores[cor]
 tab[#tab+1]=txtcolorido
  return ""
end
)
tab[#tab+1]={0.0,0.0,0.0}
tab[#tab+1]=texto
  return tab
end
function love.load()
  love.window.setMode(1900,400)
  love.graphics.setBackgroundColor(1.0,1.0,1.0)
  font=love.graphics.newFont(20)
end
function love.draw()
  local t = "Texto todo em preto. Texto em preto, <:blue:depois em azul:>. Texto em preto, <:green: verde:>, <:yellow:amarelo:> e depois novamente preto. <:gray:Texto em cinza:> e depois em preto. <:red:Texto em vermelho:>, <:blue:seguido de azul:>."
  love.graphics.setFont(font)
  love.graphics.print(textoColorido(t),10,200)
end