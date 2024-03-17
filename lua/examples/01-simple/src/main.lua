-- Copied during build, you wouldn't normally have to do that
import "./pdportal"

import "CoreLibs/graphics"

local graphics <const> = playdate.graphics

local PdPortal <const> = PdPortal
local PortalCommand <const> = PdPortal.PortalCommand

class('Example01SimplePortal').extends(PdPortal)
local Example01SimplePortal <const> = Example01SimplePortal

playdate.display.setRefreshRate(50)

function Example01SimplePortal:init()
	-- If your subclass overrides the init method, make sure to call super!
	Example01SimplePortal.super.init(self)

	self.connected = false
	self.peerId = nil
	self.updatingPeer = false
end

local portalInstance = Example01SimplePortal()

playdate.update = function()
	-- Required for serial keepalive
	portalInstance:update()
end

function Example01SimplePortal:update()
	-- If your subclass overrides the update method, make sure to call super!
	Example01SimplePortal.super.update(self)

	graphics.clear()

	graphics.drawTextAligned(
		self.connected and 'Connected' or 'Disconnected',
		200,
		120,
		kTextAlignment.center
	)

	playdate.drawFPS(10, 10)

	if self.connected then
		local peerText = self.peerId and 'Ⓐ Destroy peer ' .. self.peerId or 'Ⓐ Initialize peer'
		if self.updatingPeer then
			peerText = 'Updating peer…'
		end

		graphics.drawTextAligned(peerText, 200, 140, kTextAlignment.center)

		if not self.updatingPeer and playdate.buttonJustPressed(playdate.kButtonA) then
			self.updatingPeer = true

			if self.peerId == nil then
				self:sendCommand(PortalCommand.InitializePeer)
			else
				self:sendCommand(PortalCommand.DestroyPeer)
			end
		end
	end
end

function Example01SimplePortal:onConnect(portalVersion)
	self.connected = true
	self:log('connectEcho!', portalVersion)
end

function Example01SimplePortal:onDisconnect()
	self.connected = false
	self.peerId = nil
	self.updatingPeer = false
end

function Example01SimplePortal:onPeerOpen(peerId)
	self:log('peerOpenEcho!', peerId)
	self.updatingPeer = false
	self.peerId = peerId
end

function Example01SimplePortal:onPeerClose()
	self:log('peerCloseEcho!')
	self.updatingPeer = false
	self.peerId = nil
end

function Example01SimplePortal:onPeerConnection(remotePeerId)
	self:log('peerConnectionEcho!', remotePeerId)
end

function Example01SimplePortal:onPeerConnOpen(remotePeerId)
	self:log('peerConnOpenEcho!', remotePeerId)
end

function Example01SimplePortal:onPeerConnClose(remotePeerId)
	self:log('peerConnCloseEcho!', remotePeerId)
end

function Example01SimplePortal:onPeerConnData(remotePeerId, payload)
	self:log('peerConnDataEcho!', remotePeerId, payload)
end
