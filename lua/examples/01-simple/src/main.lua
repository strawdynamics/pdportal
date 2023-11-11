-- Copied during build, you wouldn't normally have to do that
import "./pdportal"

import "CoreLibs/graphics"

local PdPortal <const> = PdPortal
local timer <const> = playdate.timer
local graphics <const> = playdate.graphics

local connected = false

playdate.display.setRefreshRate(50)

function playdate.update()
	-- Required for serial keepalive
	timer.updateTimers()

	graphics.clear()

	playdate.graphics.drawTextAligned(
		connected and 'connected' or 'disconnected',
		200,
		120,
		kTextAlignment.center
	)

	playdate.drawFPS(10, 10)
end

pdpOnConnect = function()
	connected = true
	PdPortal.sendCommand(PdPortal.commands.log, 'connectEcho!')
end

pdpOnDisconnect = function()
	connected = false
end

pdpOnPeerOpen = function(peerId)
	PdPortal.sendCommand(PdPortal.commands.log, 'peerOpenEcho!', peerId)
end

pdpOnPeerClose = function()
	PdPortal.sendCommand(PdPortal.commands.log, 'peerCloseEcho!')
end

pdpOnPeerConnection = function(remotePeerId)
	PdPortal.sendCommand(PdPortal.commands.log, 'peerConnectionEcho!', remotePeerId)
end

pdpOnPeerConnOpen = function(remotePeerId)
	PdPortal.sendCommand(PdPortal.commands.log, 'peerConnOpenEcho!', remotePeerId)
end

pdpOnPeerConnClose = function(remotePeerId)
	PdPortal.sendCommand(PdPortal.commands.log, 'peerConnCloseEcho!', remotePeerId)
end

pdpOnPeerConnData = function(data)
	PdPortal.sendCommand(PdPortal.commands.log, 'peerConnDataEcho!', data)
end
