local graphics <const> = playdate.graphics

fonts = {
	nicoClean16 = graphics.font.new('fonts/nico/nico-clean-16'),
	nicoBold16 = graphics.font.new('fonts/nico/nico-bold-16'),
	nicoPaint16 = graphics.font.new('fonts/nico/nico-paint-16'),
	pinzelan48 = graphics.font.new('fonts/pinzelan/pinzelan-48'),
}

fontFamilies = {
	nico = graphics.font.newFamily({
		[graphics.font.kVariantNormal] = 'fonts/nico/nico-clean-16',
		[graphics.font.kVariantBold] = 'fonts/nico/nico-bold-16',
		[graphics.font.kVariantItalic] = 'fonts/nico/nico-paint-16',
	})
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

function imageWithTextStroked(
	text,
	maxWidth,
	maxHeight,
	leadingAdjustment,
	truncationString,
	alignment,
	stroke,
	strokeColor
)
	if text == nil then
		text = 'nil'
	end

	if strokeColor == nil then
		strokeColor = graphics.kDrawModeFillWhite
	end

	local foregroundImage, textWasTruncated = graphics.imageWithText(
		text,
		maxWidth,
		maxHeight,
		graphics.kColorClear,
		leadingAdjustment,
		truncationString,
		alignment
	)

	graphics.pushContext()
	graphics.setImageDrawMode(strokeColor)
	local strokeImage = graphics.imageWithText(
		text,
		maxWidth,
		maxHeight,
		graphics.kColorClear,
		leadingAdjustment,
		truncationString,
		alignment
	)
	graphics.popContext()

	local outImageWidth, outImageHeight = foregroundImage:getSize()
	outImageWidth += stroke * 2
	outImageHeight += stroke * 2
	local outImage = graphics.image.new(outImageWidth, outImageHeight)

	graphics.pushContext(outImage)
	local offsets = strokeOffsets(stroke)
	for _, o in pairs(offsets) do
		strokeImage:draw(stroke + o[1], stroke + o[2])
	end

	foregroundImage:draw(stroke, stroke)
	graphics.popContext()


	return outImage, textWasTruncated
end
