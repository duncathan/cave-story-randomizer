local C = Class:extend()

function C:new(name, map, event, region)
  self.name = name
  self.map = map
  self.event = event
  self.region = region
end

function C:fill(item, items)
  local old = self.item
  self:setItem(item)
  if self:canAccess(items) then return true end
  self:setItem(old)
  return false
end

function C:canAccess(items)
  if not self.region:canAccess(items) then return false end
  if self.requirements == nil then return true end
  return self.requirements(self, items)
end

function C:hasItem()
  return self.item ~= nil
end

function C:setItem(item)
  item.placed = true
  self.item = item
end

function C:writeItem(tscFiles, item)
  item = item or self.item
  if item == nil then
    logError("No item at " .. self.name)
    return
  end
  if self.map == nil or self.event == nil or item.script == nil then return end
  tscFiles[self.map]:placeItemAtLocation(item, self)
end

return C