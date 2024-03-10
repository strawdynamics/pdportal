local graphics <const> = playdate.graphics

local PdPortal <const> = PdPortal
local PortalCommand <const> = PdPortal.PortalCommand

class('Example03PanicSign').extends(PdPortal)
local Example03PanicSign <const> = Example03PanicSign

local screenWidth <const>, screenHeight <const> = playdate.display.getSize()
local screenCenterX <const> = screenWidth * 0.5
local panicSpriteY <const> = math.floor(screenHeight * 0.333)

local topArrowImage = graphics.image.new("img/top-arrow")
local bottomArrowImage = graphics.image.new("img/bottom-arrow")

local colors <const> = {
	'red',
	'orange',
	'yellow',
	'green',
	'green2',
	'teal',
	'lightblue',
	'blue',
	'purple',
	'pink'
}

local colorIndices <const> = {}
for i, v in ipairs(colors) do
	colorIndices[v] = i
end

function Example03PanicSign:init()
	Example03PanicSign.super.init(self)

	playdate.display.setRefreshRate(50)
	graphics.setBackgroundColor(graphics.kColorBlack)

	local panicImage = graphics.image.new("img/panic-logo")
	self.panicSprite = graphics.sprite.new(panicImage)
	self.panicSprite:add()
	self.panicSprite:moveTo(screenCenterX, panicSpriteY)

	self.currentScreen = ''
	self.connected = false
	self.isUpdatingSign = false
	self.errorMessage = nil
	self.topColor = 'lightblue'
	self.bottomColor = 'blue'
	self.selectedSegment = 'top'
end

function Example03PanicSign:update()
	Example03PanicSign.super.update(self)

	graphics.clear()

	graphics.sprite.update()

	playdate.drawFPS(screenWidth - 15, screenHeight - 12)

	if not self.connected then
		self:_maybeEnterScreen('disconnected')
		self:_updateDisconnectedScreen()
	elseif self.errorMessage then
		self:_maybeEnterScreen('error')
		self:_updateErrorScreen()
	elseif self.isUpdatingSign then
		self:_maybeEnterScreen('updating')
		self:_updateUpdatingScreen()
	else
		self:_maybeEnterScreen('picker')
		self:_updatePickerScreen()
	end
end

function Example03PanicSign:_maybeEnterScreen(newScreen)
	if self.currentScreen ~= newScreen then
		self.currentScreen = newScreen
		self['_enter' .. newScreen:lower():gsub("^%l", newScreen.upper) .. 'Screen'](self)
	end
end

function Example03PanicSign:_enterDisconnectedScreen()
	graphics.pushContext()
	graphics.setImageDrawMode(graphics.kDrawModeFillWhite)
	self.disconnectedTextImage = graphics.imageWithText(
		graphics.getLocalizedText('disconnected.instructions'),
		screenWidth * 0.7, -- max width
		fonts.nicoClean16:getHeight() * 2 + 4, -- max height
		graphics.kColorClear, -- background
		4, -- leading
		'…', -- truncation
		kTextAlignment.center, -- text align
		fonts.nicoClean16 -- font
	)
	graphics.popContext()
end

function Example03PanicSign:_enterErrorScreen()
	graphics.pushContext()
	graphics.setImageDrawMode(graphics.kDrawModeFillWhite)
	self.errorMessageImage = graphics.imageWithText(
		'Error (Ⓐ to continue): ' .. self.errorMessage,
		screenWidth * 0.7, -- max width
		fonts.nicoClean16:getHeight() * 2 + 4, -- max height
		graphics.kColorClear, -- background
		4, -- leading
		'…', -- truncation
		kTextAlignment.center, -- text align
		fonts.nicoClean16 -- font
	)
	graphics.popContext()
end

function Example03PanicSign:_enterUpdatingScreen()
	--
end

function Example03PanicSign:_enterPickerScreen()
	graphics.pushContext()
	graphics.setImageDrawMode(graphics.kDrawModeFillWhite)
	self.pickerInstructionsImage = graphics.imageWithText(
		graphics.getLocalizedText('picker.instructions'),
		screenWidth * 0.7, -- max width
		fonts.nicoClean16:getHeight() * 2 + 4, -- max height
		graphics.kColorClear, -- background
		4, -- leading
		'…', -- truncation
		kTextAlignment.center, -- text align
		fonts.nicoClean16 -- font
	)
	graphics.popContext()
end

local disconnectedTextY = math.floor(screenHeight * 0.78)

function Example03PanicSign:_updateDisconnectedScreen()
	self.disconnectedTextImage:drawAnchored(screenCenterX, disconnectedTextY, 0.5, 0.5)
end

local errorTextY = math.floor(screenHeight * 0.78)
function Example03PanicSign:_updateErrorScreen()
	self.errorMessageImage:drawAnchored(screenCenterX, errorTextY, 0.5, 0.5)

	if playdate.buttonJustPressed(playdate.kButtonA) then
		self.errorMessage = nil
	end
end

local updatingTextY = math.floor(screenHeight * 0.78)
function Example03PanicSign:_updateUpdatingScreen()
	graphics.pushContext()
	graphics.setImageDrawMode(graphics.kDrawModeFillWhite)
	graphics.setFont(fonts.nicoPaint16)
	graphics.drawTextAligned(
		graphics.getLocalizedText('updating.description'),
		screenCenterX,
		updatingTextY,
		kTextAlignment.center
	)
	graphics.popContext()
end

local pickerInstructionsY = math.floor(screenHeight * 0.78)

local topPickerX = math.floor(screenWidth * 0.18)
local topPickerY = math.floor(screenHeight * 0.18)

local topArrowX = math.floor(screenWidth * 0.30)
local topArrowY = math.floor(screenHeight * 0.14)

local bottomPickerX = math.floor(screenWidth * 0.80)
local bottomPickerY = math.floor(screenHeight * 0.43)

local bottomArrowX = math.floor(screenWidth * 0.68)
local bottomArrowY = math.floor(screenHeight * 0.55)

function Example03PanicSign:_updatePickerScreen()
	self.pickerInstructionsImage:drawAnchored(screenCenterX, pickerInstructionsY, 0.5, 0.5)

	-- Draw swoopy arrows pointing to sign
	topArrowImage:drawAnchored(topArrowX, topArrowY, 0.5, 0.5)
	bottomArrowImage:drawAnchored(bottomArrowX, bottomArrowY, 0.5, 0.5)

	graphics.pushContext()
	graphics.setImageDrawMode(graphics.kDrawModeFillWhite)
	graphics.setFont(fonts.nicoPaint16)
	-- Draw selected colors
	graphics.drawTextAligned(
		graphics.getLocalizedText('colors.' .. self.topColor),
		topPickerX,
		topPickerY,
		kTextAlignment.center
	)
	graphics.drawTextAligned(
		graphics.getLocalizedText('colors.' .. self.bottomColor),
		bottomPickerX,
		bottomPickerY,
		kTextAlignment.center
	)

	-- Draw up/down arrows
	graphics.setFont(fonts.nicoClean16)
	graphics.drawTextAligned(
		'⬆️',
		self.selectedSegment == 'top' and topPickerX or bottomPickerX,
		(self.selectedSegment == 'top' and topPickerY or bottomPickerY) - 20,
		kTextAlignment.center
	)
	graphics.drawTextAligned(
		'⬇️',
		self.selectedSegment == 'top' and topPickerX or bottomPickerX,
		(self.selectedSegment == 'top' and topPickerY or bottomPickerY) + 20,
		kTextAlignment.center
	)
	graphics.popContext()

	if playdate.buttonJustPressed(playdate.kButtonLeft) or playdate.buttonJustPressed(playdate.kButtonRight) then
		self.selectedSegment = self.selectedSegment == 'top' and 'bottom' or 'top'
	end
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		self:_changeColor('up')
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		self:_changeColor('down')
	end

	if playdate.buttonJustPressed(playdate.kButtonA) then
		self:_updateSign()
	end
end

function Example03PanicSign:_changeColor(direction)
	local currentColor = self.selectedSegment == 'top' and self.topColor or self.bottomColor
	local currentIndex = colorIndices[currentColor]
	local newIndex = direction == 'up' and currentIndex + 1 or currentIndex - 1

	if newIndex < 1 then
		newIndex = #colors
	elseif newIndex > #colors then
		newIndex = 1
	end

	if self.selectedSegment == 'top' then
		self.topColor = colors[newIndex]
	else
		self.bottomColor = colors[newIndex]
	end
end

function Example03PanicSign:_updateSign()
	self.isUpdatingSign = true

	local url = 'https://signserver.panic.com/set/' .. self.topColor .. '/' .. self.bottomColor

	self:fetch(
		url,
		{},
		function (responseText, responseDetails)
			self.isUpdatingSign = false

			if responseText ~= 'Done.\n' then
				self.errorMessage = responseText
			end
		end,
		function (errorDetails)
			self.isUpdatingSign = false
			self.errorMessage = errorDetails.message
		end
	)
end

function Example03PanicSign:onConnect(portalVersion)
	self.connected = true
end

function Example03PanicSign:onDisconnect()
	self.connected = false
end
