local graphics <const> = playdate.graphics

local PdPortal <const> = PdPortal
local PortalCommand <const> = PdPortal.PortalCommand

class('Example04Fetch').extends(PdPortal)
local Example04Fetch <const> = Example04Fetch

function Example04Fetch:init()
	-- If your subclass overrides the init method, make sure to call super!
	Example04Fetch.super.init(self)

	playdate.display.setRefreshRate(50)

	self:_initOwnProps()
end

function Example04Fetch:_initOwnProps()
	self.objectId = '-1'
	self.connected = false
	self.isSendingRequest = false
	self.responseString = nil
	self.portalVersion = nil
end

function Example04Fetch:update()
	-- If your subclass overrides the update method, make sure to call super!
	Example04Fetch.super.update(self)

	graphics.clear()

	playdate.drawFPS(10, 225)

	if self.connected then
		if self.isSendingRequest then
			graphics.drawTextAligned(
				'Fetching…',
				200,
				100,
				kTextAlignment.center
			)
		elseif self.responseString then
			graphics.drawTextInRect(
				'(Ⓐ continue) ' .. self.responseString,
				10,
				10,
				380,
				220,
				0,
				'…',
				kTextAlignment.center
			)

			if playdate.buttonJustPressed(playdate.kButtonA) then
				self.responseString = nil
			end
		else
			self:_updateReady()
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

function Example04Fetch:_updateReady()

	graphics.drawTextAligned('Ⓐ POST expecting success', 200, 120, kTextAlignment.center)
	graphics.drawTextAligned('Ⓑ POST invalid body', 200, 140, kTextAlignment.center)
	graphics.drawTextAligned('⬆️ GET expecting success/404 if no post first', 200, 160, kTextAlignment.center)

	if playdate.buttonJustPressed(playdate.kButtonA) then
		self:_createObject(json.encode({
			name = '04-fetch',
			data = {
				hello = 'from pdportal ' .. self.portalVersion
			}
		}))
	elseif playdate.buttonJustPressed(playdate.kButtonB) then
		self:_createObject('{invalidJson}')
	elseif playdate.buttonJustPressed(playdate.kButtonUp) then
		self:_getObject()
	end
end

function Example04Fetch:_getObject()
	self.isSendingRequest = true

	self:fetch(
		'https://api.restful-api.dev/objects/' .. self.objectId,
		{},
		function (responseText, responseDetails)
			self.isSendingRequest = false
			self.responseString = responseText
		end,
		function (errorDetails)
			self:_handleError(errorDetails.message)
		end
	)
end

function Example04Fetch:_createObject(body)
	self.isSendingRequest = true

	self:fetch(
		'https://api.restful-api.dev/objects',
		{
			body = body,
			method = 'POST',
			headers = {
				['Content-Type'] = 'application/json'
			},
		},
		function (responseText, responseDetails)
			self.isSendingRequest = false

			local responseJson = json.decode(responseText)

			-- FIXME: Currently messed up because of `msg` character limit. Waiting for response from Panic
			if responseDetails.status == 200 then
				self.responseString = responseText
				self.objectId = responseJson.id
			else
				self:_handleError(responseText)
			end
		end,
		function (errorDetails)
			self:_handleError(errorDetails.message)
		end
	)
end

function Example04Fetch:_handleError(errorMessage)
	self.isSendingRequest = false
	self.responseString = 'Error: ' .. errorMessage
	self.objectId = '-1'
end

function Example04Fetch:onConnect(portalVersion)
	self.connected = true
	self.portalVersion = portalVersion
	self:log('connectEcho!', portalVersion)
end

function Example04Fetch:onDisconnect()
	self:_initOwnProps()
end
