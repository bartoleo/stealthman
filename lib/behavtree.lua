--- behavtree
behavtree = {}
function behavtree:new(...)
   local _o = {}
   _o.name=""
   _o.tree=nil
   _o.object=nil
   _o.lastaction=nil
   _o.laststatus=nil
   _o.activenode=nil
   _o.initialized=false
   setmetatable(_o, self)
   self.__index = self
   _o:init(...)
   return _o
end
--------------- UTILS -------------------
local function inheritsFrom( baseClass )
    local new_class = {}
    local class_mt = { __index = new_class }

    function new_class:create()
        local newinst = {}
        setmetatable( newinst, class_mt )
        return newinst
    end

    if baseClass then
        setmetatable( new_class, { __index = baseClass } )
    end
    return new_class
end
--
local function shuffle(t)
  -- see: http://en.wikipedia.org/wiki/Fisher-Yates_shuffle
  local n = #t
 
  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
 
  return t
end
--------------- NODE --------------------
btnode = {}
function btnode:new(...)
   local _o = {}
   _o.status="ready"
   setmetatable(_o, self)
   self.__index = self
   _o:init(...)
   return _o
end
--------------- SEQUENCE ----------------
btsequence = inheritsFrom(btnode)
function btsequence:init(pchilds)
  self.childs = pchilds
  if self.childs and #self.childs == 0 then
    self.childs={self.childs}
  end
end
function btsequence:run(pbehavtree)
  print("btsequence:run")
  local _s
  local _a
  for i=1,#self.childs do
    print("btsequence:run "..i)
     _s,_a = self.childs[i]:run(pbehavtree)
     if _s==false or _s=="running" or _a then
        return _s,_a
     end
  end
  return _s,_a
end
--------------- SELECTOR ----------------
btselector = inheritsFrom(btnode)
function btselector:init(pchilds)
  self.childs = pchilds
  if self.childs and #self.childs == 0 then
    self.childs={self.childs}
  end
end
function btselector:run(pbehavtree)
  print("btselector:run")
  local _s
  local _a
  for i=1,#self.childs do
     _s,_a = self.childs[i]:run(pbehavtree)
     if _s=="running" or _a then
        return _s,_a
     end
  end
  return _s,_a
end
--------------- RANDOMSELECTOR ----------------
btrandomselector = inheritsFrom(btnode)
function btrandomselector:init(pchilds)
  self.childs = pchilds
  if self.childs and #self.childs == 0 then
    self.childs={self.childs}
  end
end
function btrandomselector:run(pbehavtree)
  print("btrandomselector:run")
  local _s
  local _a
  shuffle(self.childs)
  for i=1,#self.childs do
     _s,_a = self.childs[i]:run(pbehavtree)
     if _s=="running" or _a then
        return _s,_a
     end
  end
  return _s,_a
end
--------------- CONDITION ----------------
btcondition = inheritsFrom(btnode)
function btcondition:init(pcondition,pchilds)
  self.childs = pchilds
  self.condition = pcondition
  if self.childs and #self.childs == 0 then
    self.childs={self.childs}
  end
end
function btcondition:run(pbehavtree)
  print("btcondition:run "..type(self.condition))
  local _s
  local _a
  if type(self.condition) == "function" then
    _s,_a = self.condition(pbehavtree.object,pbehavtree)
  elseif type(self.condition) == "string" then
    _s,_a = loadstring(self.condition)()
  end 
  print("btcondition:run result ")
  print(_s)
  if _s==true or _s=="running" or _a then
    for i=1,#self.childs do
       _s,_a = self.childs[i]:run(pbehavtree)
       if _s=="running" or _a then
          return _s,_a
       end
    end
  end
  return _s,_a
end
--------------- ACTION ----------------
btaction = inheritsFrom(btnode)
function btaction:init(paction,pchilds)
  self.childs = pchilds
  self.action = paction
  if self.childs and #self.childs == 0 then
    self.childs={self.childs}
  end
end
function btaction:run(pbehavtree)
  print("btaction:run")
  local _s
  local _a
  if type(self.action) == "function" then
    _s,_a = self.action(pbehavtree.object,pbehavtree)
  elseif type(self.action) == "string" then
    _s,_a = loadstring(self.action)()
  end 
  if self.childs then
    if _s==true or _s=="running" or _a  then
      for i=1,#self.childs do
         _s,_a = self.childs[i]:run(pbehavtree)
         if _s=="running" or _a then
            return _s,_a
         end
      end
    end
  end
  return _s,_a
end
--------------- BEHAVTREE ----------------
function behavtree:init(pname,pobject,ptree)
  print("behavtree:init")
  self.name=pname
  self.object=pobject
  self.tree=ptree
  if self.tree==nil then
    self.tree = {}
    self.tree=btrandomselector:new({
          btcondition:new(function() return math.random()*10<5 end, 
            btcondition:new("print('prova') return math.random()*10<5", 
              btaction:new(function() return true,{"ACTION",{}} end)
            )
          ),
          btcondition:new("print('prova2') return math.random()*10<5", 
            btaction:new(function() return true,{"ACTION2",{}} end)
          ),
          btcondition:new("print('prova3') return math.random()*10<5", 
            btaction:new(function() return true,{"ACTION3",{}} end)
          )}
       )
  end
  if #self.tree==0 then
    self.tree={self.tree}
  end
  self.initialized=false
  self:initialize()
end

function behavtree:run()
  print("behavtree:run "..self.name)
  if (self.initialized==false) then
    self:initialize()
  end
  self.lastaction = nil
  self.laststatus = nil
  local _s
  local _a
  for i=1,#self.tree do
    print(i.."/"..#self.tree)
     _s,_a = self.tree[i]:run(self)
  end
  self.lastaction = _s
  self.laststatus = _a
  print(_s)
  print(_a)
  return self.lastaction,self.laststatus
end

function behavtree:initialize()
  for i=1,#self.tree do
    self:setParentChilds(self.tree[i],nil)
  end  
end

function behavtree:initialize(pnode,pparent)
  if pnode then
    pnode.parent =pparent
    if pnode.childs then
      for i=1,#pnode.childs do
        behavtree:setParentChilds(pnode.childs[i],pnode)
      end
    end
  end
end