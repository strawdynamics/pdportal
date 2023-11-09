import 'CoreLibs/object'

class("PdPortal").extends()
local PdPortal <const> = PdPortal

local jsonEncode <const> = json.encode

function PdPortal:sendToPeerConn(peerConnId, payload)
	local jsonPayload = jsonEncode(payload)
	print('') -- TODO: ASCII control char to indicate end of message?
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- These functions should be implemented by each app, and will be called by the
-- pdportal web app automatically.

pdpOnConnect = function(arg)
	-- Called by pdportal web app after serial connection established.
	-- TODO: How does PD know when serial disconnects?
end

pdpOnPeerServerOpen = function(peerId)
	-- Peer server connection established, remote peer connection possible.
	-- https://peerjs.com/docs/#peeron-open
end

pdpOnPeerServerConnection = function(connectionInfo)
	-- A remote peer has conneted via the peer server.
	-- { connectionStuff??? }
	-- https://peerjs.com/docs/#peeron-connection
end

pdpOnPeerConnOpen = function(peerConnId)
	-- Peer connection is usable
	-- https://peerjs.com/docs/#dataconnection-on-open
end

pdpOnPeerConnClose = function(peerConnId)
	-- Peer connection has been closed
	-- https://peerjs.com/docs/#dataconnection-on-close
end

pdpOnPeerConnData = function(data)
	-- data string is a JSON object of shape:
	-- { peerConnId, payload }
	-- https://peerjs.com/docs/#dataconnection-on-data
end
