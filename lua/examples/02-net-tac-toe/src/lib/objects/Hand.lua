class('Hand').extends()
local Hand <const> = Hand

local graphics <const> = playdate.graphics

local handImageTable <const> = graphics.imagetable.new('img/hand-table')

function Hand:init(peerId, displayName)
	self.peerId = peerId
	self.displayName = displayName

	self._buildDisplayNameImage()
end

function Hand:_buildDisplayNameImage()
	local displayName = self.displayName

	graphics.pushContext()
	graphics.setFont(fonts.nicoPaint16)
	local dnWidth, dnHeight = graphics.getTextSize(displayName)
	local displayNameImage = graphics.image.new(dnWidth + 4, dnHeight + 4)
	graphics.pushContext(displayNameImage)
	drawTextAlignedStroked(displayName, 2, 2, kTextAlignment.left, 2, graphics.kDrawModeFillWhite)
	graphics.popContext()
	graphics.popContext()

	self.displayNameImage = displayNameImage
end
