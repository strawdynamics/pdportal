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

pdpOnPeerConnData = function(data)
	PdPortal.sendCommand(PdPortal.commands.log, 'peerConnDataEcho!', data)
	-- data string is a JSON object of shape:
	-- { peerConnId, payload }
	-- https://peerjs.com/docs/#dataconnection-on-data
end
