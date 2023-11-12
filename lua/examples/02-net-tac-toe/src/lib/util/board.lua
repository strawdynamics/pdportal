local geometry <const> = playdate.geometry

local indexPoints <const> = {
	geometry.point.new(140, 56),
	geometry.point.new(204, 56),
	geometry.point.new(268, 56),

	geometry.point.new(140, 120),
	geometry.point.new(204, 120),
	geometry.point.new(268, 120),

	geometry.point.new(140, 184),
	geometry.point.new(204, 184),
	geometry.point.new(268, 184),
}

function getIndexPoint(index)
	return indexPoints[index]
end
