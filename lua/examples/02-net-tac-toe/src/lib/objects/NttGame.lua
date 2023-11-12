class('NttGame').extends()
local NttGame <const> = NttGame

local timer <const> = playdate.timer
local graphics <const> = playdate.graphics
local display <const> = playdate.display

function NttGame:init()
	self.isSerialConnected = false
	self._wasSerialConnected = false

	self.isPeerOpen = false
	self._wasPeerOpen = false

	self:_initBackgroundDrawing()

	self._setupScreen = SetupScreen(self)

	self._currentScreen = self._setupScreen
	self._setupScreen:show()
end

function NttGame:_initBackgroundDrawing()
	graphics.sprite.setBackgroundDrawingCallback(function(x, y, w, h)
		graphics.pushContext()
		graphics.setPattern({0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA})
		graphics.fillRect(0, 0, display.getSize())
		graphics.popContext()
	end)
end

function NttGame:update()
	self:_updateBasics()
	self:_updateConnectionState()

	self._currentScreen:update()
end

function NttGame:handleSerialConnect()
	self.isSerialConnected = true
end

function NttGame:handleSerialDisconnect()
	self.isSerialConnected = false
	self:handlePeerClose()
end

function NttGame:handlePeerOpen(peerId)
	self.peerId = peerId
	self.isPeerOpen = true
end

-- This doesn't matter during gameplay, only matchmaking
function NttGame:handlePeerClose()
	self.peerId = nil
	self.isPeerOpen = false
end

function NttGame:_handleScreenHideComplete()
	--
end

function NttGame:_updateBasics()
	-- Required for serial keepalive
	timer.updateTimers()

	graphics.sprite.update()

	playdate.graphics.drawTextAligned(
		connected and 'connected' or 'disconnected',
		10,
		30,
		kTextAlignment.left
	)

	playdate.drawFPS(10, 10)
end

function NttGame:_updateConnectionState()
	if self.isSerialConnected and not self._wasSerialConnected then
		self._wasSerialConnected = true
		-- handle serial connected
	elseif not self.isSerialConnected and self._wasSerialConnected then
		self._wasSerialConnected = false
		-- handle serial disconnected
	end

	if self.isPeerOpen and not self._wasPeerOpen then
		self._wasPeerOpen = true
		-- handle peer opened
	elseif not self.isPeerOpen and self._wasPeerOpen then
		self._wasPeerOpen = false
		-- handle peer closed
	end
end
