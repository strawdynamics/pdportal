-- Copied during build, you wouldn't normally have to do that
import "./pdportal"

local PdPortal <const> = PdPortal

playdate.display.setRefreshRate(50)

function playdate.update()
	playdate.drawFPS(10, 10)
end

pdpOnConnect = function(arg)
	PdPortal.sendCommand(PdPortal.commands.log, 'connectEcho!', arg)
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
