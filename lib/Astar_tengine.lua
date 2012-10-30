-- TE4 - T-Engine 4
-- Copyright (C) 2009, 2010 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org


--- The default heuristic for A*, tries to come close to the straight path
function heuristicCloserPath(sx, sy, cx, cy, tx, ty)
	local dx1 = cx - tx
	local dy1 = cy - ty
	local dx2 = sx - tx
	local dy2 = sy - ty
	return math.abs(dx1*dy2 - dx2*dy1)
end

function core_fov_distance(x1,y1,x2,y2)
  local dx,dy = x2-x1,y2-y1
  return math.sqrt(dx*dx+dy*dy)
end

--- The a simple heuristic for A*, using distance
function heuristicDistance(sx, sy, cx, cy, tx, ty)
	return core_fov_distance(cx, cy, tx, ty)
end


function createPath(came_from, cur)
	if not came_from[cur] then return end
	local rpath, path = {}, {}
	while came_from[cur] do
		local x, y = toDouble(cur)
		rpath[#rpath+1] = {x=x,y=y}
		cur = came_from[cur]
	end
	for i = #rpath, 1, -1 do path[#path+1] = rpath[i] end
	return path
end

function toSingle(x, y)
	return x + y * (MAP_WIDTH+1)
end
function toDouble(c)
	local y = math.floor(c / (MAP_WIDTH+1))
	return c - y * (MAP_WIDTH+1), y
end


--- Compute path from sx/sy to tx/ty
-- @param sx the start coord
-- @param sy the start coord
-- @param tx the end coord
-- @param ty the end coord
-- @param use_has_seen if true the astar wont consider non-has_seen grids
-- @return either nil if no path or a list of nodes in the form { {x=...,y=...}, {x=...,y=...}, ..., {x=tx,y=ty}}
function calc(sx, sy, tx, ty, use_has_seen, heuristic)
	--local heur = heuristic or heuristicCloserPath
	local heur = heuristic or heuristicDistance
	local w, h = (MAP_WIDTH+1), (MAP_HEIGHT+1)
	local start = toSingle(sx, sy)
	local stop = toSingle(tx, ty)
	local open = {[start]=true}
	local closed = {}
	local g_score = {[start] = 0}
	local h_score = {[start] = heur( sx, sy, sx, sy, tx, ty)}
	local f_score = {[start] = heur( sx, sy, sx, sy, tx, ty)}
	local came_from = {}

	local cache = false --LB:self.map._fovcache.path_caches[self.actor:getPathString()]
	local checkPos
	--if cache then
	--	checkPos = function(node, nx, ny)
	--		local nnode = toSingle(nx, ny)
	--		if not closed[nnode] and self.map:isBound(nx, ny) and ((use_has_seen and not self.map.has_seens(nx, ny)) or not cache:get(nx, ny)) then
	--			local tent_g_score = g_score[node] + 1 -- we can adjust hre for difficult passable terrain
	--			local tent_is_better = false
	--			if not open[nnode] then open[nnode] = true; tent_is_better = true
	--			elseif tent_g_score < g_score[nnode] then tent_is_better = true
	--			end
  --
	--			if tent_is_better then
	--				came_from[nnode] = node
	--				g_score[nnode] = tent_g_score
	--				h_score[nnode] = heur(self, sx, sy, tx, ty, nx, ny)
	--				f_score[nnode] = g_score[nnode] + h_score[nnode]
	--			end
	--		end
	--	end
	--else
		checkPos = function(node, nx, ny)
			local nnode = toSingle(nx, ny)
			if not closed[nnode] and map[nx][ny].transparent then
				local tent_g_score = g_score[node] + 1 -- we can adjust hre for difficult passable terrain
				local tent_is_better = false
				if not open[nnode] then open[nnode] = true; tent_is_better = true
				elseif tent_g_score < g_score[nnode] then tent_is_better = true
				end

				if tent_is_better then
					came_from[nnode] = node
					g_score[nnode] = tent_g_score
					h_score[nnode] = heur( sx, sy, tx, ty, nx, ny)
					f_score[nnode] = g_score[nnode] + h_score[nnode]
				end
			end
		end
	--end

	while next(open) do
		-- Find lowest of f_score
		local node, lowest = nil, 999999999999999
		for n, _ in pairs(open) do
			if f_score[n] < lowest then node = n; lowest = f_score[n] end
		end

		if node == stop then return createPath(came_from, stop) end

		open[node] = nil
		closed[node] = true
		local x, y = toDouble(node)

		-- Check sides
		if x<MAP_WIDTH then
		  checkPos(node, x + 1, y)
		end
		if x>0 then
		  checkPos(node, x - 1, y)
		end
		if y<MAP_HEIGHT then
		  checkPos(node, x, y + 1)
		end
		if y>0 then
		  checkPos(node, x, y - 1)
		end
		if x<MAP_WIDTH and y<MAP_HEIGHT then
		  checkPos(node, x + 1, y + 1)
		end
		if x<MAP_WIDTH and y>0 then
		  checkPos(node, x + 1, y - 1)
		end
		if x>0 and y<MAP_HEIGHT then
		  checkPos(node, x - 1, y + 1)
		end
		if x>0 and y>0 then
			checkPos(node, x - 1, y - 1)
	  end
	end
end


