local geometry = {}
local EPSILON = 1e-6

local abs = math.abs

function sq_mag(v)
	return v.x^2 + v.y^2
end

function area(a, b, c)
	return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
end

function ccw(a, b, c)
	return area(a, b, c) > 0
end

function geometry.right_of(p, e)
	return ccw(p, e:dest(), e:org())
end

function geometry.in_circle(a, b, c, d)
	return sq_mag(a) * area(b, c, d) - sq_mag(b) * area(a, c, d) + sq_mag(c) * area(a, b, d) - sq_mag(d) * area(a, b, c) > 0
end

function geometry.on_edge(p, e)
	local a = e:org()
	local b = e:dest()
	local m = (a.y - b.y) / (a.x - b.x)

	return abs(m * (p.x - a.x) - p.y) < EPSILON
end

return geometry
