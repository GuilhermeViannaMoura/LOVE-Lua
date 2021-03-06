local uf = require "uf"

local M = {}

local id = function (i, j)
  return i .. ":" .. j
end

local do_maze = function (map,_map)
  while #_map.walls > 0 do
    local w = math.random(1,#_map.walls)
    local i = _map.walls[w].i
    local j = _map.walls[w].j
    if i%2 == 0 then  -- check if horizontal or vertical wall
      if uf.union(_map.uf,id(i,j-1),id(i,j+1)) then
        map[i][j] = true
      else
        table.insert(_map.cycles,_map.walls[w])
      end
    else
      if uf.union(_map.uf,id(i-1,j),id(i+1,j)) then
        map[i][j] = true
      else
        table.insert(_map.cycles,_map.walls[w])
      end
    end
    table.remove(_map.walls,w)
  end
end

local do_doors = function (map)
  map[map.ny][2] = true
  map[1][map.nx-1] = true
end

local empty_space = function (map, _map, empty)
  local n = #_map.cycles * empty
  for k = 1, n do
    local w = math.random(1,#_map.cycles)
    local i = _map.cycles[w].i
    local j = _map.cycles[w].j
    map[i][j] = true
    table.remove(_map.cycles,w)
  end
  -- eliminate isolated corners
  for i = 3, map.ny-2, 2 do
    for j = 3, map.nx-2, 2 do
      if map[i-1][j] and map[i+1][j] and map[i][j-1] and map[i][j+1] then
        map[i][j] = true
      end
    end
  end
end

-- Create and return a new map
-- nx and ny represents the number of horizontal and vertical cells, respectively,
-- and must be odd numbers. Empty accounts for the amount of empty space. For 
-- empty=0.0, the returned map is a maze without cycles; for empty=1.0, the whole
-- domain is empty (without internal walls).
-- If doors are requested, they are placed at cells (2,ny) and (nx-1,1).
function M.create (nx, ny, doors, empty) -- dimensions must be odd numbers
  local map = {nx=nx, ny=ny} 
  local _map = {walls={}, cycles={}, uf=uf.create()}
  for i = 1, ny do
    map[i] = {} 
    for j = 1, nx do
      uf.addnode(_map.uf,id(i,j))
      if i%2==0 and j%2==0 then
        map[i][j] = true
        if i+1 ~= ny then
          table.insert(_map.walls,{i=i+1,j=j})
        end
        if j+1 ~= nx then
          table.insert(_map.walls,{i=i,j=j+1})
        end
      else
        map[i][j] = false
      end
    end
  end
  do_maze(map,_map)
  if doors then
    do_doors(map)
  end
  empty_space(map,_map,empty)
  return map
end

function M.draw (map)
  for i = 1, map.ny do
    for j = 1, map.nx do
      if not map[i][j] then
        love.graphics.setColor(0,0,0)
      else
        love.graphics.setColor(255,255,255)
      end
      love.graphics.rectangle("fill",(j-1),(i-1),1,1)
    end
  end
end

return M
