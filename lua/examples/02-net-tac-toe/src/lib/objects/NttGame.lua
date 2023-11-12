class('NttGame').extends()
local NttGame <const> = NttGame

local timer <const> = playdate.timer
local graphics <const> = playdate.graphics
local display <const> = playdate.display
local json <const> = json
local PdPortal <const> = PdPortal
local screenWidth, screenHeight = playdate.display.getSize()

function NttGame:init()
	self.isSerialConnected = false
	self._wasSerialConnected = false

	self.isPeerOpen = false
	self._wasPeerOpen = false

	self.isLocalHost = false

	self:_initBackgroundDrawing()

	self._setupScreen = SetupScreen(self)
	self._gameplayScreen = GameplayScreen(self)

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

	if self.remotePeerId then
		self:handlePeerConnClose(self.remotePeerId)
	end
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

-- Remote peer connected to us, we are host
function  NttGame:handlePeerConnection(remotePeerId)
	self.isLocalHost = true
	self:_handlePeerConn(remotePeerId)
end

-- We connected to remote peer, they are host
function NttGame:handlePeerConnOpen(remotePeerId)
	self.isLocalHost = false
	self:_handlePeerConn(remotePeerId)
end

function NttGame:_handlePeerConn(remotePeerId)
	if self.remotePeerId ~= nil then
		PdPortal.sendCommand(
			PdPortal.commands.log,
			'[NttGame] Only 2 players supported!'
		)
		return
	end

	self.remotePeerId = remotePeerId

	self._currentScreen:hide(function ()
		self._currentScreen = self._gameplayScreen
		self._gameplayScreen:show()
	end)
end

function NttGame:handlePeerConnClose(remotePeerId)
	if remotePeerId ~= self.remotePeerId then
		return
	end

	self.remotePeerId = nil

	self:_showSetupScreen()
end

function NttGame:_showSetupScreen()
	if self._currentScreen == self._setupScreen then
		return
	end

	self._currentScreen:hide(function ()
		self._currentScreen = self._setupScreen
		self._setupScreen:show()
	end)
end

function NttGame:_testSwitchScreen()
	self._currentScreen:hide(function ()
		if self._currentScreen == self._setupScreen then
			self._currentScreen = self._gameplayScreen
			self._gameplayScreen:show()
		else
			self._currentScreen = self._setupScreen
			self._setupScreen:show()
		end
	end)
end

function NttGame:handlePeerConnData(data)
	local decodedData = json.decode(data)
	local peerConnId = data.peerConnId
	local payload = data.payload
	PdPortal.sendCommand(PdPortal.commands.log, 'TODO: NttGame:handlePeerConnData!', peerConnId, payload)
end

function NttGame:_updateBasics()
	-- Required for serial keepalive
	timer.updateTimers()

	graphics.sprite.update()

	playdate.drawFPS(screenWidth - 18, screenHeight - 15)
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
