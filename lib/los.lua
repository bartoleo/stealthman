--[[
porting from
PlayTechs: Programming for fun 
Dabbling and babbling
http://playtechs.blogspot.com/2007/03/raytracing-on-grid.html

Bresenham line-drawing algorithm
c only integer version

original:

void raytrace(int x0, int y0, int x1, int y1){
    int dx = abs(x1 - x0);
    int dy = abs(y1 - y0);
    int x = x0;
    int y = y0;
    int n = 1 + dx + dy;
    int x_inc = (x1 > x0) ? 1 : -1;
    int y_inc = (y1 > y0) ? 1 : -1;
    int error = dx - dy;
    dx *= 2;
    dy *= 2;
    for (; n > 0; --n)
    {
    visit(x, y);
      if (error > 0)
       {
         x += x_inc;
         error -= dy;
       }
    else
      {
       y += y_inc;
       error += dx;
    }
}
}
--]]

function los(m,x0,y0,x1,y1) 
  local dx = math.abs(x1 - x0)
  local dy = math.abs(y1 - y0)
  local x = x0
  local y = y0
  local n = 1 + dx + dy
  local x_inc = 1
  if x1 < x0 then
    x_inc = -1
  end 
  local y_inc = 1
  if y1 < y0 then
    y_inc = -1
  end 
  local error = dx - dy
  dx = dx*2
  dy = dy*2
  while n>0 do
    if m[x][y].transparent==false then
		
		  -- draw debug (remove it to use in projects)
		  love.graphics.setColor(255,0,0,100)
		  love.graphics.rectangle("line", x*10, y*10,10,10)
		  -- end draw debug
    
      return false
    end 
	  
	  -- draw debug (remove it to use in projects)
	  love.graphics.setColor(0,255,0,100)
	  love.graphics.rectangle("line", x*10, y*10,10,10)
	  -- end draw debug
	  
    if error > 0 then
         x = x + x_inc
         error = error-dy
    else
       y = y + y_inc;
       error = error + dx
    end
    n = n - 1
  end
  return true
end 