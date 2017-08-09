local edge = require("edge")

local qedge = {}

function qedge.make_edge()
	local qe = {}

	for i = 1, 4 do
		qe[i] = edge.new(qe, i)
	end

	qe[1].next = qe[1]
	qe[2].next = qe[4]
	qe[3].next = qe[3]
	qe[4].next = qe[2]

	return qe[1]
end

function qedge.splice(a, b)
	local alpha = a:onext():rot()
	local beta = b:onext():rot()

	a.next, b.next = b:onext(), a:onext()
	alpha.next, beta.next = beta:onext(), alpha:onext()
end

return qedge
