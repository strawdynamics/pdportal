class('BoardCell').extends()
local BoardCell <const> = BoardCell

local geometry <const> = playdate.geometry
local graphics <const> = playdate.graphics
local fonts <const> = fonts

local getIndexPoint <const> = getIndexPoint

local function makeCharImage(char, graphicsPre, graphicsPost)
	local charImage = graphics.image.new(60, 60)

	graphics.pushContext(charImage)
	graphics.setFont(fonts.pinzelan48)

	graphicsPre()

	graphics.drawTextAligned(char, 30, 0, kTextAlignment.center)

	if graphicsPost then
		graphicsPost(charImage)
	end

	graphics.popContext()

	return charImage
end

local function postFadedCharImage(charImage)
	-- https://devforum.play.date/t/drawing-faded-text-more-sustainably/7477/2
	graphics.setStencilImage(charImage)
	graphics.setPattern({0x0, 0x22, 0x0, 0x88, 0x0, 0x22, 0x0, 0x88})
	graphics.fillRect(0, 0, 60, 60)
end

-- Prebuild images: empty, x, o, hoverX, hoverO
local emptyImage <const> = makeCharImage(' ', function() end)
local xImage <const> = makeCharImage('x', function()
	graphics.setImageDrawMode(graphics.kDrawModeFillBlack)
end)
local oImage <const> = makeCharImage('o', function()
	graphics.setImageDrawMode(graphics.kDrawModeFillBlack)
end)
local hoverXImage <const> = makeCharImage('x', function()
	graphics.setImageDrawMode(graphics.kDrawModeFillWhite)
end, postFadedCharImage)
local hoverOImage <const> = makeCharImage('o', function()
	graphics.setImageDrawMode(graphics.kDrawModeFillWhite)
end, postFadedCharImage)

local stateImages = {
	emptyImage,
	xImage,
	oImage,
	hoverXImage,
	hoverOImage,
}

-- 1 empty, 2 x, 3 o, 4 hoverX, 5 hoverO
function BoardCell:init(index)
	self._index = index
	self.state = 1
	self._point = getIndexPoint(self._index):offsetBy(
		math.random(-1, 1),
		math.random(-1, 1)
	)

	self._sprite = graphics.sprite.new(self:_getImage())
	self._sprite:moveTo(self._point)
	self._sprite:add()
end

function BoardCell:destroy()
	self._sprite:remove()
end

function BoardCell:setState(newState)
	self.state = newState
end

function BoardCell:_getImage()
	return stateImages[self.state]
end

function BoardCell:update()
	local x, y = self._point:unpack()

	self._sprite:setImage(self:_getImage())
end
