--[[
MRPAS
Copyright (c) 2010 Dominik Marczuk
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * The name of Dominik Marczuk may not be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY DOMINIK MARCZUK ``AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL DOMINIK MARCZUK BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]

--[[ Love2d - Lua - Porting of Restrictive Precise Angle Shadowcasting by Mingo http://umbrarumregnum.110mb.com/download/mrpas --]]

function computeQuadrant(m,playerX,playerY,maxRadius,lightWalls,dx,dy)

      local lMAP_HEIGHT = table.maxn(m[0])
      local lMAP_WIDTH = table.maxn(m)

      local startAngle = {}
      local endAngle = {}
      --octant: vertical edge:
      
        local iteration = 1
        local done = false
        local totalObstacles = 0
        local obstaclesInLastLine = 0
        local minAngle = 0.0
        local x = 0
        local y = 0
        --do while there are unblocked slopes left and the algo is within the map's boundaries
        --scan progressive lines/columns from the PC outwards
        y = playerY + dy
        if (y < 0 or y >= lMAP_HEIGHT) then
          done = true
        end
        while (done==false) do
          --process cells in the line
          slopesPerCell = 1.0 / (iteration + 1)
          halfSlopes = slopesPerCell * 0.5
          processedCell = math.ceil(minAngle / slopesPerCell)
          minx = math.max(0, playerX - iteration)
          maxx = math.min(lMAP_WIDTH - 1, playerX + iteration)
          done = true
          x = playerX + (processedCell * dx)
          while (x >= minx and x <= maxx) do
            c = x + (y * lMAP_WIDTH);
            --calculate slopes per cell
            visible = true
            startSlope = processedCell * slopesPerCell
            centreSlope = startSlope + halfSlopes
            endSlope = startSlope + slopesPerCell
            if (obstaclesInLastLine > 0 and m[x][y].fov == false) then
              idx = 0
              while (visible and idx < obstaclesInLastLine) do
                if ( m[x][y].transparent == true) then
                  if (centreSlope > startAngle[idx] and centreSlope < endAngle[idx]) then
                    visible = false
                  end
                else 
                  if (startSlope >= startAngle[idx] and endSlope <= endAngle[idx]) then
                    visible = false
                  end
                end
                if (visible and (m[x][y-dy].fov== false or m[x][y-dy].transparent==false) and (x - dx >= 0 and x - dx < lMAP_WIDTH and (m[x-dx][y-dy].fov == false or m[x-dx][y-dy].transparent==false))) then
                  visible = false
                end
                idx=idx+1
              end
            end
            if (visible) then
              m[x][y].fov = true
              done = false
              --if the cell is opaque, block the adjacent slopes
              if (m[x][y].transparent==false) then
                if (minAngle >= startSlope) then
                  minAngle = endSlope
                else 
                  startAngle[totalObstacles] = startSlope
                  endAngle[totalObstacles] = endSlope
                  totalObstacles = totalObstacles +1
                end
                if (lightWalls==false) then
                  m[x][y].fov = false
                end
              end
            end
            processedCell=processedCell+1
            x =x+ dx
          end
          if (iteration == maxRadius) then
            done = true
          end
          iteration =iteration + 1
          obstaclesInLastLine = totalObstacles
          y = y + dy
          if (y < 0 or y >= lMAP_HEIGHT) then
            done = true
          end
          if (minAngle == 1.0) then
            done = true
          end
        end
      
      --octant: horizontal edge
      
        local iteration = 1 --iteration of the algo for this octant
        local done = false
        local totalObstacles = 0
        local obstaclesInLastLine = 0
        local minAngle = 0.0
        local x = 0
        local y = 0;
        --do while there are unblocked slopes left and the algo is within the map's boundaries
        --scan progressive lines/columns from the PC outwards
        x = playerX + dx --the outer slope's coordinates (first processed line)
        if (x < 0 or x >= lMAP_WIDTH) then
          done = true
        end
        while (done==false) do
          --process cells in the line
          slopesPerCell = 1.0 / (iteration + 1)
          halfSlopes = slopesPerCell * 0.5
          processedCell = math.ceil(minAngle / slopesPerCell)
          miny = math.max(0, playerY - iteration)
          maxy = math.min(lMAP_HEIGHT - 1, playerY + iteration)
          done = true
          y = playerY + (processedCell * dy)
          while (y >= miny and y <= maxy) do
            c = x + (y * lMAP_WIDTH)
            --calculate slopes per cell
            visible = true
            startSlope = (processedCell * slopesPerCell)
            centreSlope = startSlope + halfSlopes
            endSlope = startSlope + slopesPerCell
            if (obstaclesInLastLine > 0 and m[x][y].fov == false) then
              idx = 0
              while (visible and idx < obstaclesInLastLine) do
                if (m[x][y].transparent == true) then
                  if (centreSlope > startAngle[idx] and centreSlope < endAngle[idx]) then
                    visible = false
                  end
                else 
                  if (startSlope >= startAngle[idx] and endSlope <= endAngle[idx]) then
                    visible = false
                  end
                end
                if (visible and (m[x-dx][y].fov == false or m[x-dx][y].transparent==false) and (y - dy >= 0 and y - dy < lMAP_HEIGHT and (m[x-dx][y-dy].fov == false or m[x-dx][y-dy].transparent==false))) then
                  visible = false
                end
                idx=idx+1
              end
            end
            if (visible) then
              m[x][y].fov = true
              done = false
              --if the cell is opaque, block the adjacent slopes
              if (m[x][y].transparent==false) then
                if (minAngle >= startSlope) then
                  minAngle = endSlope
                else 
                  startAngle[totalObstacles] = startSlope
                  endAngle[totalObstacles] = endSlope
                  totalObstacles = totalObstacles + 1
                end
                if (lightWalls==false) then
                  m[x][y].fov = false
                end
              end
            end
            processedCell = processedCell+1
            y = y + dy
          end
          if (iteration == maxRadius) then
            done = true
          end
          iteration=iteration+1
          obstaclesInLastLine = totalObstacles
          x = x + dx
          if (x < 0 or x >= lMAP_WIDTH) then
            done = true
          end
          if (minAngle == 1.0) then
            done = true
          end
        end

end

function computeFOV(m,playerX,playerY,maxRadius,lightWalls)

      local lMAP_HEIGHT = table.maxn(m[0])
      local lMAP_WIDTH = table.maxn(m)

      --first, zero the FOV map
		   for j=0, lMAP_WIDTH, 1 do
				for k=0, lMAP_HEIGHT, 1 do
					if m[j][k].fov then
					  m[j][k].viewed = true
					end
					m[j][k].fov = false
				end
			end
	    --set PC's position as visible
      m[playerX][playerY].fov = true
      --compute the 4 quadrants of the map
      computeQuadrant(m, playerX, playerY, maxRadius, lightWalls, 1, 1)
      computeQuadrant(m, playerX, playerY, maxRadius, lightWalls, 1, -1)
      computeQuadrant(m, playerX, playerY, maxRadius, lightWalls, -1, 1)
      computeQuadrant(m, playerX, playerY, maxRadius, lightWalls, -1, -1)
end
