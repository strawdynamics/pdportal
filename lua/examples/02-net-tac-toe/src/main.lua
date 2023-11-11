-- Copied during build, you wouldn't normally have to do that
import "./pdportal"

import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

import "lib/util/board"
import "lib/util/text"

import "lib/objects/board/BoardCell"
import "lib/objects/board/BoardLines"
import "lib/objects/board/BoardState"

import "lib/objects/screens/GameplayScreen"
import "lib/objects/screens/SetupScreen"

import "lib/objects/Hand"
import "lib/objects/NttGame"

local PdPortal <const> = PdPortal

local nttGame <const> = NttGame()

local connected = false

playdate.display.setRefreshRate(50)

function playdate.update()
	nttGame:update()
end

pdpOnConnect = function()
	nttGame.isSerialConnected = true
end

pdpOnDisconnect = function()
	nttGame.isSerialConnected = false
end

pdpOnPeerOpen = function(peerId)
	-- Peer connection established, remote peer connection possible.
	-- https://peerjs.com/docs/#peeron-open
	nttGame.isPeerOpen = true
end

pdpOnPeerClose = function()
	-- Peer connection destroyed, remote peer connection no longer possible.
	-- https://peerjs.com/docs/#peeron-close
	nttGame.isPeerOpen = false
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
