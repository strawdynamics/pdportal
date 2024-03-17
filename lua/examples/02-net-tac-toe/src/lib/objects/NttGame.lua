class('NttGame').extends('PdPortal')
local NttGame <const> = NttGame

local timer <const> = playdate.timer
local graphics <const> = playdate.graphics
local display <const> = playdate.display
local json <const> = json
local PdPortal <const> = PdPortal
local screenWidth, screenHeight = playdate.display.getSize()

function NttGame:init()
	NttGame.super.init(self)

	self.isSerialConnected = false
	self._wasSerialConnected = false

	self.isPeerOpen = false
	self._wasPeerOpen = false

	self.peerId = nil
	self.remotePeerId = nil
	self.isSelfHost = false

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
	NttGame.super.update(self)

	self:_updateBasics()
	self:_updateConnectionState()

	self._currentScreen:update()
end

function NttGame:onConnect()
	self.isSerialConnected = true
	self:sendCommand(PdPortal.PortalCommand.InitializePeer)
end

function NttGame:onDisconnect()
	self.isSerialConnected = false
	self:onPeerClose()

	if self.remotePeerId then
		self:onPeerConnClose(self.remotePeerId)
	end
end

function NttGame:onPeerOpen(peerId)
	self.peerId = peerId
	self.isPeerOpen = true
end

-- This doesn't matter during gameplay, only matchmaking
function NttGame:onPeerClose()
	self.peerId = nil
	self.isPeerOpen = false
end

-- Remote peer connected to us, we are host
function  NttGame:onPeerConnection(remotePeerId)
	self.isSelfHost = true
	self:_onPeerConn(remotePeerId)
end

-- We connected to remote peer, they are host
function NttGame:onPeerConnOpen(remotePeerId)
	self.isSelfHost = false
	self:_onPeerConn(remotePeerId)
end

function NttGame:_onPeerConn(remotePeerId)
	if self.remotePeerId ~= nil then
		self:log('[NttGame] Only 2 players supported!')

		self:sendCommand(
			PdPortal.PortalCommand.ClosePeerConn,
			remotePeerId
		)
		return
	end

	self.remotePeerId = remotePeerId

	self._currentScreen:hide(function ()
		self._currentScreen = self._gameplayScreen
		self._gameplayScreen:show()
	end)
end

function NttGame:onPeerConnClose(remotePeerId)
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

function NttGame:onPeerConnData(peerConnId, stringData)
	local payload = json.decode(stringData)

	if peerConnId ~= self.remotePeerId then
		return
	end

	self._gameplayScreen:handlePeerData(payload)
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
