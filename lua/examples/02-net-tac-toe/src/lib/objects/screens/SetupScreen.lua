class('SetupScreen').extends()
local SetupScreen <const> = SetupScreen

local graphics <const> = playdate.graphics
local fonts <const> = fonts
local fontFamilies <const> = fontFamilies
local drawTextAlignedStroked <const> = drawTextAlignedStroked
local screenWidth, screenHeight = playdate.display.getSize()
local PdPortal <const> = PdPortal

graphics.pushContext()
graphics.setFont(fonts.pinzelan48)
local titleString = graphics.getLocalizedText('setup.title')
local titleImage = imageWithTextStroked(
	titleString,
	screenWidth,
	screenHeight,
	1,
	'…',
	kTextAlignment.center,
	3
)
graphics.popContext()

function SetupScreen:init(nttGame)
	self.game = nttGame
end

function SetupScreen:update()
	titleImage:drawAnchored(screenWidth * 0.5, 60, 0.5, 0.5)

	local setupText = graphics.getLocalizedText('setup.disconnected')
	if self.game.isSerialConnected then
		if self.game.isPeerOpen then
			setupText = table.concat({
				graphics.getLocalizedText('setup.peerOpenPrefix'),
				self.game.peerId,
				graphics.getLocalizedText('setup.peerOpenSuffix'),
			}, '')
		else
			setupText = graphics.getLocalizedText('setup.serialConnected')
		end
	end

	if self._lastSetupText ~= setupText then
		self._lastSetupText = setupText

		graphics.pushContext()
		graphics.setFontFamily(fontFamilies.nico)
		self._setupTextImage = imageWithTextStroked(
			setupText,
			screenWidth * 0.7,
			screenHeight,
			8,
			'…',
			kTextAlignment.center,
			2
		)
		graphics.popContext()
	end

	self._setupTextImage:drawAnchored(screenWidth * 0.5, 120, 0.5, 0)
end

function SetupScreen:show()
	self._lastSetupText = ''
	PdPortal.sendCommand(PdPortal.commands.log, '[SetupScreen] show')
end

function SetupScreen:hide(hideCompleteCallback)
	PdPortal.sendCommand(PdPortal.commands.log, '[SetupScreen] hide')
	hideCompleteCallback()
end
