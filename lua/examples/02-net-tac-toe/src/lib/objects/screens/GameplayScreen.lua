class('GameplayScreen').extends()
local GameplayScreen <const> = GameplayScreen

local graphics <const> = playdate.graphics
local geometry <const> = playdate.geometry
local fonts <const> = fonts
local drawTextAlignedStroked <const> = drawTextAlignedStroked
local screenWidth, screenHeight = playdate.display.getSize()
local timer <const> = playdate.timer

local ownHandRestPoint <const> = geometry.point.new(
	40,
	screenHeight * 0.7
)
local otherHandRestPoint <const> = geometry.point.new(
	screenWidth - 40,
	screenHeight * 0.7
)

function GameplayScreen:init(nttGame)
	self.game = nttGame

	self._isShowing = false
end

function GameplayScreen:update()
	self._boardLines:update()
	self._boardState:update()

	self._ownHand:update()
	self._otherHand:update()
end

function GameplayScreen:show()
	self._isShowing = true

	PdPortal.sendCommand(PdPortal.commands.log, '[GameplayScreen] show')
	self._boardState = BoardState()
	self._boardLines = BoardLines()

	self._ownHand = Hand('1234', graphics.getLocalizedText('gameplay.you'))
	self._otherHand = Hand('5678', '5678')

	timer.performAfterDelay(300, function()
		self._ownHand:setTarget(ownHandRestPoint)
	end)
	timer.performAfterDelay(600, function()
		self._otherHand:setTarget(otherHandRestPoint)
	end)

	timer.performAfterDelay(2000, function()
		self:_enableControls()
	end)
end

function GameplayScreen:_enableControls()
	if not self._isShowing then
		return
	end

	playdate.inputHandlers.push({
		AButtonDown = function()
			print('handledfromgps')
			self.game:_testSwitchScreen()
		end
	})
end

function GameplayScreen:hide(hideCompleteCallback)
	self._isShowing = false

	PdPortal.sendCommand(PdPortal.commands.log, '[GameplayScreen] hide')

	self._boardLines:undraw()
	self._ownHand:destroy()
	self._otherHand:destroy()

	timer.performAfterDelay(900, hideCompleteCallback)

	playdate.inputHandlers.pop()
end
