local graphics <const> = playdate.graphics

fonts = {
	nicoPaint16 = graphics.font.new('fonts/nico/nico-paint-16'),
	pinzelan48 = graphics.font.new('fonts/pinzelan/pinzelan-48'),
}

local function strokeOffsets(radius)
	local offsets = {}
	for x = -radius, radius do
		for y = -radius, radius do
			if x * x + y * y <= radius * radius then
				table.insert(offsets, { x, y })
			end
		end
	end
	return offsets
end

function drawTextAlignedStroked(text, x, y, alignment, stroke, strokeColor)
	local offsets = strokeOffsets(stroke)

	if strokeColor == nil then
		strokeColor = graphics.kDrawModeFillWhite
	end

	graphics.pushContext()
	graphics.setImageDrawMode(strokeColor)
	for _, o in pairs(offsets) do
		graphics.drawTextAligned(text, x + o[1], y + o[2], alignment)
	end
	graphics.popContext()

	graphics.drawTextAligned(text, x, y, alignment)
end
