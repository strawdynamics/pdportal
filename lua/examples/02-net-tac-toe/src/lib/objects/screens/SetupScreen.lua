class('SetupScreen').extends()
local SetupScreen <const> = SetupScreen

local graphics <const> = playdate.graphics
local fonts <const> = fonts
local fontFamilies <const> = fontFamilies
local drawTextAlignedStroked <const> = drawTextAlignedStroked
local screenWidth, screenHeight = playdate.display.getSize()
local PdPortal <const> = PdPortal
local easings <const> = playdate.easingFunctions
local timer <const> = playdate.timer

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
	titleImage:drawAnchored(screenWidth * 0.5, 50 + self._titleTextAnimator:currentValue(), 0.5, 0)

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

	self._setupTextImage:drawAnchored(screenWidth * 0.5, 140 + self._setupTextAnimator:currentValue(), 0.5, 0)
end

function SetupScreen:show()
	self._lastSetupText = ''
	PdPortal.sendCommand(PdPortal.commands.log, '[SetupScreen] show')

	self._titleTextAnimator = graphics.animator.new(
		700,
		-150,
		0,
		easings.outBack
	)
	self._titleTextAnimator.s = 1.3

	self._setupTextAnimator = graphics.animator.new(
		600,
		150,
		0,
		easings.outBack,
		240
	)
	self._setupTextAnimator.s = 1.1

	self:_enableControls()
end

function SetupScreen:_enableControls()
	playdate.inputHandlers.push({
		AButtonDown = function()
			self.game:_testSwitchScreen()
		end
	})
end

function SetupScreen:hide(hideCompleteCallback)
	PdPortal.sendCommand(PdPortal.commands.log, '[SetupScreen] hide')

	self._titleTextAnimator = graphics.animator.new(
		400,
		0,
		-150,
		easings.inBack,
		150
	)
	self._titleTextAnimator.s = 1.3

	self._setupTextAnimator = graphics.animator.new(
		400,
		0,
		150,
		easings.inBack
	)
	self._setupTextAnimator.s = 1.1

	playdate.inputHandlers.pop()

	timer.performAfterDelay(900, hideCompleteCallback)
end
