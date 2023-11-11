class('Hand').extends()
local Hand <const> = Hand

local graphics <const> = playdate.graphics

local handImageTable <const> = graphics.imagetable.new('img/hand-table')

function Hand:init(peerId)
	self.peerId = peerId

	self._buildPeerIdImage()
end

function Hand:_buildPeerIdImage()
	local peerId = self.peerId

	graphics.pushContext()
	graphics.setFont(fonts.nicoPaint16)
	local pidWidth, pidHeight = graphics.getTextSize(peerId)
	local peerIdImage = graphics.image.new(pidWidth + 4, pidHeight + 4)
	graphics.pushContext(peerIdImage)
	drawTextAlignedStroked(peerId, 2, 2, kTextAlignment.left, 2, graphics.kDrawModeFillWhite)
	graphics.popContext()
	graphics.popContext()

	self.peerIdImage = peerIdImage
end
