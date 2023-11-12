class('BoardLines').extends()
local BoardLines <const> = BoardLines

local geometry <const> = playdate.geometry
local graphics <const> = playdate.graphics
local screenWidth, screenHeight = playdate.display.getSize()

local gridLinesVImageTable = graphics.imagetable.new('img/grid-lines-v')
local gridLinesHImageTable = graphics.imagetable.new('img/grid-lines-h')

-- leftV, rightV, topH, bottomH
local lineAnchors <const> = {
	geometry.point.new(158, 10),
	geometry.point.new(222, 10),
	geometry.point.new(85, 80),
	geometry.point.new(85, 140),
}

function BoardLines:init()
	local vSize = gridLinesVImageTable:getSize()
	local hSize = gridLinesHImageTable:getSize()

	self._image = graphics.image.new(screenWidth, screenHeight)
	self._sprite = graphics.sprite.new(self._image)
	self._sprite:setCenter(0, 0)
	self._sprite:moveTo(0, 0)
	self._sprite:add()

	self._lines = {
		{
			image = gridLinesVImageTable:getImage(
				math.random(1, vSize)
			),
			anchor = lineAnchors[1]:offsetBy(math.random(-3, 3), math.random(-3, 3)),
			dir = 'v',
		},
		{
			image = gridLinesVImageTable:getImage(
				math.random(1, vSize)
			),
			anchor = lineAnchors[2]:offsetBy(math.random(-3, 3), math.random(-3, 3)),
			dir = 'v',
		},
		{
			image = gridLinesHImageTable:getImage(
				math.random(1, hSize)
			),
			anchor = lineAnchors[3]:offsetBy(math.random(-3, 3), math.random(-3, 3)),
			dir = 'h',
		},
		{
			image = gridLinesHImageTable:getImage(
				math.random(1, hSize)
			),
			anchor = lineAnchors[4]:offsetBy(math.random(-3, 3), math.random(-3, 3)),
			dir = 'h',
		},
	}

	self._drawingLinesIn = true
	self._currentLineIndex = 1
	self._currentLineProgress = 0
end

function BoardLines:undraw()
	self._drawingLinesOut = true
	self._outProgress = 0
end

function BoardLines:update()
	if self._drawingLinesIn then
		self:_updateLinesIn()
	end

	if self._drawingLinesOut then
		self:_updateLinesOut()
	end
end

function BoardLines:_updateLinesOut()
	self._outProgress += 0.05
	local progress = self._outProgress

	graphics.pushContext(self._image)
	graphics.setColor(graphics.kColorClear)
	graphics.fillRect(
		(1 - progress) * screenWidth,
		0,
		progress * screenWidth,
		screenHeight
	)
	graphics.popContext()

	if progress >= 1 then
		self._sprite:remove()

		self._drawingLinesOut = false
	end
end

function BoardLines:_updateLinesIn()
	self._currentLineProgress += 0.12

	local progress = self._currentLineProgress
	local line = self._lines[self._currentLineIndex]

	graphics.pushContext(self._image)

	if line.dir == 'v' then
		graphics.setClipRect(0, 0, screenWidth, screenHeight * progress)
	else
		graphics.setClipRect(0, 0, screenWidth * progress, screenHeight)
	end

	line.image:draw(line.anchor)
	graphics.popContext()

	if self._currentLineProgress >= 1 then
		self._currentLineIndex += 1
		self._currentLineProgress = -0.6

		if self._currentLineIndex > #self._lines then
			self._drawingLinesIn = false
		end
	end
end
