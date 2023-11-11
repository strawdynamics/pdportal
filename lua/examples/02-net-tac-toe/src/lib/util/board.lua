local geometry <const> = playdate.geometry

local indexPoints <const> = {
	geometry.point.new(128, 56),
	geometry.point.new(192, 56),
	geometry.point.new(256, 56),

	geometry.point.new(128, 120),
	geometry.point.new(192, 120),
	geometry.point.new(256, 120),

	geometry.point.new(128, 184),
	geometry.point.new(192, 184),
	geometry.point.new(256, 184),
}

function getIndexPoint(index)
	return indexPoints[index]
end
