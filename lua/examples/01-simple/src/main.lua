-- Copied during build, you wouldn't normally have to do that
import "./pdportal"

import "CoreLibs/graphics"

local graphics <const> = playdate.graphics

local PdPortal <const> = PdPortal
local PortalCommand <const> = PdPortal.PortalCommand

class('Example01SimplePortal').extends(PdPortal)
local Example01SimplePortal <const> = Example01SimplePortal

local connected = false

playdate.display.setRefreshRate(50)

local portalInstance = Example01SimplePortal()

function playdate.update()
	-- Required for serial keepalive
	portalInstance:update()

	graphics.clear()

	playdate.graphics.drawTextAligned(
		connected and 'connected' or 'disconnected',
		200,
		120,
		kTextAlignment.center
	)

	playdate.drawFPS(10, 10)
end

function Example01SimplePortal:init()
	-- If your subclass overrides the init method, make sure to call super!
	Example01SimplePortal.super.init(self)
end

function Example01SimplePortal:onConnect()
	connected = true
	self:log('connectEcho!', 'second arg!')
end

function Example01SimplePortal:onDisconnect()
	connected = false
end

function Example01SimplePortal:onPeerOpen(peerId)
	self:log('peerOpenEcho!', peerId)
end

function Example01SimplePortal:onPeerClose()
	self:log('peerCloseEcho!')
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
