local graphics <const> = playdate.graphics

local PdPortal <const> = PdPortal
local PortalCommand <const> = PdPortal.PortalCommand

class('Example05Ping').extends(PdPortal)
local Example05Ping <const> = Example05Ping

function Example05Ping:init()
	-- If your subclass overrides the init method, make sure to call super!
	Example05Ping.super.init(self)

	playdate.display.setRefreshRate(50)

	self:_initOwnProps()
end

function Example05Ping:_initOwnProps()
	self.connected = false
	self.isPinging = false
	self.pingDuration = -1
	self.pingStart = -1
	self.peerId = nil
	self.remotePeerId = nil
end

function Example05Ping:update()
	-- If your subclass overrides the update method, make sure to call super!
	Example05Ping.super.update(self)

	graphics.clear()

	playdate.drawFPS(10, 225)

	if self.connected then
		if self.isPinging then
			graphics.drawTextAligned(
				'Pinging…',
				200,
				100,
				kTextAlignment.center
			)
		elseif self.peerId == nil then
			graphics.drawTextAligned(
				'Connecting to peer server…',
				200,
				100,
				kTextAlignment.center
			)
		elseif self.remotePeerId == nil then
			graphics.drawTextAligned(
				'Connected as ' .. self.peerId ..', waiting for remote peer…',
				200,
				100,
				kTextAlignment.center
			)
		elseif self.pingDuration > -1 then
			graphics.drawTextAligned(
				'Pong in ' .. self.pingDuration * 1000 ..'ms (Ⓐ ping again)',
				200,
				100,
				kTextAlignment.center
			)

			if playdate.buttonJustPressed(playdate.kButtonA) then
				self:beginPing()
			end
		else
			graphics.drawTextAligned(
				'Ⓐ to ping',
				200,
				100,
				kTextAlignment.center
			)

			if playdate.buttonJustPressed(playdate.kButtonA) then
				self:beginPing()
			end
		end
	else
		graphics.drawTextAligned(
			'Disconnected',
			200,
			100,
			kTextAlignment.center
		)
	end
end

function Example05Ping:beginPing()
	self.pingStart = playdate.getElapsedTime()
	self:sendToPeerConn(self.remotePeerId, 'ping')
end

function Example05Ping:onConnect(portalVersion)
	self.connected = true
	self:sendCommand(PortalCommand.InitializePeer)
end

function Example05Ping:onPeerOpen(peerId)
	self.peerId = peerId
end

function Example05Ping:onPeerConnection(remotePeerId)
	self.remotePeerId = remotePeerId
end

function Example05Ping:onPeerConnOpen(remotePeerId)
	self.remotePeerId = remotePeerId
end

function Example05Ping:onDisconnect()
	self:_initOwnProps()
end

function Example05Ping:onPeerConnData(remotePeerId, payload)
	-- Note double quotes below because of peerjs JSON encoding. Typically, you'd just send an actual JSON object instead of a string
	if payload == '"ping"' then
		self:sendToPeerConn(self.remotePeerId, 'pong')
	elseif payload == '"pong"' then
		self.isPinging = false
		self.pingDuration = playdate.getElapsedTime() - self.pingStart
	end
end
