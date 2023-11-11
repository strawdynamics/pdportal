-- These functions should be implemented/overridden by each app, and will be
-- called by the pdportal web app as appropriate.

pdpOnConnect = function(arg)
	-- Called by pdportal web app after serial connection established.
end

pdpOnPeerOpen = function(peerId)
	-- Peer connection established, remote peer connection possible.
	-- https://peerjs.com/docs/#peeron-open
end

pdpOnPeerClose = function()
	-- Peer connection destroyed, remote peer connection no longer possible.
	-- https://peerjs.com/docs/#peeron-close
end

pdpOnPeerConnection = function(remotePeerId)
	-- A remote peer has connected to us via the peer server.
	-- https://peerjs.com/docs/#peeron-connection
end

pdpOnPeerConnOpen = function(remotePeerId)
	-- We've connected to a remote peer via the peer server.
	-- https://peerjs.com/docs/#dataconnection-on-open
end

pdpOnPeerConnClose = function(remotePeerId)
	-- Connection to a remote peer has been lost.
	-- https://peerjs.com/docs/#dataconnection-on-close
end

pdpOnPeerConnData = function(data)
	-- data string is a JSON object of shape:
	-- { peerConnId, payload }
	-- https://peerjs.com/docs/#dataconnection-on-data
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Don't change these functions unless you know what you're doing!

pdpEcho = function(arg)
	PdPortal.sendCommand(PdPortal.commands.log, 'pdpEcho', arg)
end

_pdpOnConnect = function()
	-- TODO: How does PD know when serial disconnects? Some kind of keepalive pong with the browser, I guess.
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- The PdPortal class can be used to communicate from the Playdate back to the
-- browser (and other Playdates)

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
