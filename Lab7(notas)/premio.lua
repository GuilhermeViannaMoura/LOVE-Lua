function le_conteudo(nomearq)
  local arq = io.open(nomearq,'r')
  if not arq then
    print('Não foi possível abrir o arquivo: ',nomearq)
    return nil
  end
  local tab = {}
  local p = '%s*(.-)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s*$'
  while true do
    local linha = arq:read('*l')
    if not linha then
      break
    end
    local nomepessoa,n1,n2,n3,n4,n5 = linha:match(p)
    --print(nomepessoa)
    if not (nomepessoa and n1 and n2 and n3 and n4 and n5) then
      break
    end
    tab[#tab+1] = { nome = nomepessoa , 
                    notas = {
                    tonumber(n1),
                    tonumber(n2),
                    tonumber(n3),
                    tonumber(n4),
                    tonumber(n5)
                    }
                  }
  end
  for i= 1,#tab do table.sort(tab[i].notas,function(a,b)
      return a>b
    end
  )
    local media = 
      (tab[i].notas[1]+
      tab[i].notas[2]+
      tab[i].notas[3])/3
      tab[i].media = media
  end
  table.sort(tab,function(a,b)
        return a.media > b.media
      end
    )
  t={}
  for i= 1,4 do
    t[#t + 1] = {n = tab[i].nome, m = tab[i].media}
  end
  table.sort(t,function(a,b)
        return a.n < b.n
      end
    )
  local arqnew = io.open("premiados.txt","w")
if not arqnew then 
  print ("Nao foi possivel abrir arquivo : arqnew") 
  return nil 
end
for i = 1,4 do 
  arqnew:write(string.format("%-25s%4.1f\n",t[i].n , 
      t[i].m))
  end
  arq:close()
  arqnew:close()
return
end
print('Digite o nome do arquivo: ')
local notas = io.read('*l')
le_conteudo(notas)