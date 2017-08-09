local geometry = require("geometry")
local qedge = require("qedge")

local subdivision = {}
subdivision.__index = subdivision

function subdivision.new(a, b, c, d)
	local sd = {}

	sd.corners = {a, b, c}
	sd.starting_edge = init(a, b, c)

	return setmetatable(sd, subdivision)
end

function init(a, b, c)
	local ea = qedge.make_edge()
	local eb = qedge.make_edge()
	local ec = qedge.make_edge()

	qedge.splice(ea:sym(), eb)
	qedge.splice(eb:sym(), ec)
	qedge.splice(ec:sym(), ea)

	ea:set_endpoints(a, b)
	eb:set_endpoints(b, c)
	ec:set_endpoints(c, a)

	return ea
end

function connect(a, b)
	local e = qedge.make_edge()

	e:set_endpoints(a:dest(), b:org())
	qedge.splice(e, a:lnext())
	qedge.splice(e:sym(), b)

	return e
end

function delete_edge(e)
	qedge.splice(e, e:oprev())
	qedge.splice(e:sym(), e:sym():oprev())
end

function swap(e)
	local a = e:oprev()
	local b = e:sym():oprev()

	qedge.splice(e, a)
	qedge.splice(e:sym(), b)
	qedge.splice(e, a:lnext())
	qedge.splice(e:sym(), b:lnext())
	e:set_endpoints(a:dest(), b:dest())
end

function subdivision:locate(x)
	local e = self.starting_edge

	while true do
		if x == e:org() or x == e:dest() then
			return e
		elseif geometry.right_of(x, e) then
			e = e:sym()
		elseif not geometry.right_of(x, e:onext()) then
			e = e:onext()
		elseif not geometry.right_of(x, e:dprev()) then
			e = e:dprev()
		else
			return e
		end
	end
end

function subdivision:insert_site(x)
	local e = self:locate(x)

	if x == e:org() or x == e:dest() then
		return
	elseif geometry.on_edge(x, e) then
		local t = e:oprev()

		delete_edge(e)
		e = t
	end

	local base = qedge.make_edge()
	local first = e:org()

	base:set_endpoints(first, x)
	qedge.splice(base, e)

	repeat
		base = connect(e, base:sym())
		e = base:oprev()
	until e:dest() == first

	e = base:oprev()

	while true do
		local t = e:oprev()

		if geometry.right_of(t:dest(), e) and geometry.in_circle(e:org(), t:dest(), e:dest(), x) then
			swap(e)
			e = t
		elseif e:org() == first then
			return e
		else
			e = e:onext():lprev()
		end
	end
end

function subdivision:edges()
	local visited = {}
	local stack = {}
	local edges = {}

	visited[self.starting_edge] = true
	table.insert(stack, self.starting_edge)

	while #stack > 0 do
		local e = table.remove(stack)

		table.insert(edges, e)

		for _, neighbor in pairs(e:neighbors()) do
			if not visited[neighbor] then
				visited[neighbor] = true
				table.insert(stack, neighbor)
			end
		end		 
	end

	return edges
end

return subdivision
