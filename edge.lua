local edge = {}
edge.__index = edge

function edge.new(qedge, index)
	local e = {}

	e.qedge = qedge
	e.index = index
	e.next = nil
	e.origin = nil

	return setmetatable(e, edge)
end

function edge:rot()
	return self.qedge[self.index % 4 + 1]
end

function edge:onext()
	return self.next
end

function edge:sym()
	return self:rot():rot()
end

function edge:inv_rot()
	return self:rot():sym()
end

function edge:oprev()
	return self:rot():onext():rot()
end

function edge:lprev()
	return self:onext():sym()
end

function edge:rprev()
	return self:sym():onext()
end

function edge:dprev()
	return self:inv_rot():onext():inv_rot()
end

function edge:lnext()
	return self:inv_rot():onext():rot()
end

function edge:rnext()
	return self:rot():onext():inv_rot()
end

function edge:dnext()
	return self:sym():onext():sym()
end

function edge:org()
	return self.origin
end

function edge:dest()
	return self:sym():org()
end

function edge:set_endpoints(a, b)
	self.origin = a
	self:sym().origin = b
end

function edge:neighbors()
	return {self:onext(), self:oprev(), self:dnext(), self:dprev()}
end

return edge
