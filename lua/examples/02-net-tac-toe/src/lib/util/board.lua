local geometry <const> = playdate.geometry

local indexPoints <const> = {
	geometry.point.new(134, 56),
	geometry.point.new(200, 56),
	geometry.point.new(260, 56),

	geometry.point.new(134, 120),
	geometry.point.new(200, 120),
	geometry.point.new(260, 120),

	geometry.point.new(134, 184),
	geometry.point.new(200, 184),
	geometry.point.new(260, 184),
}

function getIndexPoint(index)
	return indexPoints[index]:copy()
end
