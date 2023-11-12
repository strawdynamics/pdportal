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

	self._handSprite = graphics.sprite.new(handImageTable:getImage(1))
	self._handSprite:moveTo(self._targetPos)
	self._handSprite:add()

	self:_initDisplayNameSprite()

	self._animator = graphics.animator.new(0, self._targetPos, self._targetPos)
end

function Hand:update()
	local animPos = self._animator:currentValue()
	local x, y = animPos:unpack()
	self._handSprite:moveTo(x, y)
	self._displayNameSprite:moveTo(x + 2, y + 27)
end

function Hand:destroy()
	self._displayNameSprite:remove()
	self._handSprite:remove()
end

function Hand:setTarget(point)
	self._animator = graphics.animator.new(
		360,
		self._targetPos,
		point,
		easings.outBack
	)
	self._animator.s = 1.2
	self.pos = point
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
	self._displayNameSprite:add()
end
