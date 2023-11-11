import 'CoreLibs/object'

class("PdPortal").extends()
local PdPortal <const> = PdPortal

local jsonEncode <const> = json.encode

PdPortal.commands = {
	log = 'l',
	sendToPeerConn = 'p',
}

local commandSeparator <const> = string.char(30) -- RS (␞)
local argumentSeparator <const> = string.char(31) -- US (␟)

PdPortal.sendCommand = function(cmdName, ...)
	local cmd = {cmdName}

	for i = 1, select('#', ...) do
		local arg = select(i, ...)
		table.insert(cmd, argumentSeparator)
		table.insert(cmd, arg)
	end

	table.insert(cmd, commandSeparator)

	print(table.concat(cmd, ''))
end

PdPortal.sendToPeerConn = function(peerConnId, payload)
	local jsonPayload = jsonEncode(payload)
	self:sendCommand(PdPortal.commands.sendToPeerConn, peerConnId, jsonPayload)
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
