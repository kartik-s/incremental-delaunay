# incremental-delaunay

This is a pretty straightforward implementation of the incremental algorithm described in "Primitives for the Manipulation of General Subdivisions and the Computation of Voronoi Diagrams".
 
Here's a quick example usage using Love2D:
```lua
local subdivision = require("subdivision")

local point = {}

point.__index = point

function point.new(x, y)
	return setmetatable({x = x, y = y}, point)
end

function point.__eq(a, b)
	return a.x == b.x and a.y == b.y
end

local triangulation = subdivision.new(point.new(100, 100), point.new(100, 500), point.new(500, 500))

function love.mousepressed(x, y)
	triangulation:insert_site(point.new(x, y))
end

function love.draw()
	for _, edge in pairs(triangulation:edges()) do
		love.graphics.line(edge:org().x, edge:org().y, edge:dest().x, edge:dest().y)
	end
end
```

