class('Hand').extends()
local Hand <const> = Hand

local graphics <const> = playdate.graphics
local geometry <const> = playdate.geometry
local screenWidth, screenHeight = playdate.display.getSize()
local imageWithTextStroked <const> = imageWithTextStroked
local easings <const> = playdate.easingFunctions

local handImageTable = graphics.imagetable.new('img/hand')

function Hand:init(peerId, displayName)
	self.peerId = peerId
	self.displayName = displayName
	self._targetPos = geometry.point.new(
		screenWidth * 0.5,
		screenHeight + 64
	)
	self.pos = self._targetPos:copy()

	self._index = nil

	self._handSprite = graphics.sprite.new(handImageTable:getImage(1))
	self._handSprite:setZIndex(10)
	self._handSprite:moveTo(self._targetPos)
	self._handSprite:add()

	self:_initDisplayNameSprite()

	self._animator = graphics.animator.new(0, self._targetPos:copy(), self._targetPos:copy())
end

function Hand:update()
	local animPos = self._animator:currentValue()
	local x, y = animPos:unpack()
	self.pos.x = x
	self.pos.y = y
	self._handSprite:moveTo(x, y)
	self._displayNameSprite:moveTo(x + 2, y + 27)
end

function Hand:destroy()
	self._displayNameSprite:remove()
	self._handSprite:remove()
end

function Hand:getIndex()
	return self._index
end

function Hand:indexMoveUp()
	if not self._index then
		return
	end

	self._index -= 3
	if self._index < 1 then
		self._index += 9
	end

	self:setTargetIndex(self._index)
	return self._index
end

function Hand:indexMoveRight()
	if not self._index then
		return
	end

	if self._index % 3 == 0 then
		self._index -= 2
	else
		self._index += 1
	end

	self:setTargetIndex(self._index)
	return self._index
end

function Hand:indexMoveDown()
	if not self._index then
		return
	end

	self._index += 3
	if self._index > 9 then
		self._index -= 9
	end

	self:setTargetIndex(self._index)
	return self._index
end

function Hand:indexMoveLeft()
	if not self._index then
		return
	end

	self._index -= 1
	if self._index % 3 == 0 then
		self._index += 3
	end

	self:setTargetIndex(self._index)
	return self._index
end

function Hand:setTargetIndex(index)
	local indexPoint = getIndexPoint(index)
	indexPoint.x += 16
	indexPoint.y += 24
	self:setTarget(indexPoint)

	self._index = index
end

function Hand:setTarget(point)
	self._index = nil

	self._animator = graphics.animator.new(
		500,
		self.pos:copy(),
		point:copy(),
		easings.outBack
	)
	self._animator.s = 1.2
	self._targetPos.x = point.x
	self._targetPos.y = point.y
	self.pos.x = point.x
	self.pos.y = point.y
end

function Hand:_initDisplayNameSprite()
	local displayName = self.displayName

	graphics.pushContext()
	graphics.setFont(fonts.nicoPaint16)
	local displayNameImage = imageWithTextStroked(
		displayName,
		screenWidth,
		screenHeight,
		1,
		'…',
		kTextAlignment.center,
		2
	)
	graphics.popContext()

	self._displayNameSprite = graphics.sprite.new(displayNameImage)
	self._displayNameSprite:setCenter(0.5, 0)
	self._displayNameSprite:moveTo(self._targetPos)
	self._displayNameSprite:setZIndex(10)
	self._displayNameSprite:add()
end
