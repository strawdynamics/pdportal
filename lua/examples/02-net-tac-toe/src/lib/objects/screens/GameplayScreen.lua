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
	self._isX = nil
end

function GameplayScreen:update()
	self._boardLines:update()
	self._boardState:update()

	self._ownHand:update()
	self._otherHand:update()
end

function GameplayScreen:show()
	self._isShowing = true
	self._isOwnTurn = false

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

	-- TODO: nttGame.isSelfHost
	if true then
		timer.performAfterDelay(1500, function()
			-- Decide who starts first (i.e. who is x)
			-- TODO: self._isOwnTurn = math.random(1, 2) == 1
			self._isOwnTurn = true

			self:_setIsX(self._isOwnTurn)

			-- TODO: notify remote whether they're x

			self:_handleTurnStart()
		end)
	end

	timer.performAfterDelay(2000, function()
		self:_enableControls()
	end)
end

function GameplayScreen:_setIsX(isX)
	self._isX = isX
end

function GameplayScreen:_enableControls()
	if not self._isShowing then
		return
	end

	playdate.inputHandlers.push({
		upButtonDown = function()
			self:_handleUpPressed()
		end,
		rightButtonDown = function()
			self:_handleRightPressed()
		end,
		downButtonDown = function()
			self:_handleDownPressed()
		end,
		leftButtonDown = function()
			self:_handleLeftPressed()
		end,
		BButtonDown = function()
			self.game:_testSwitchScreen()
		end
	})
end

function GameplayScreen:_handleHandChangeIndex(oldIndex, newIndex, whichHand)
	if oldIndex then
		self._boardState:unsetCellHover(oldIndex)
	end

	local ownChanged = whichHand == self._ownHand
	if ownChanged then
		self._boardState:trySetCell(newIndex, self._isX and 4 or 5)
		-- TODO: Send new index over net
	else
		self._boardState:trySetCell(newIndex, self._isX and 5 or 4)
	end
end

function GameplayScreen:_handleUpPressed()
	if not self._isOwnTurn then
		return
	end

	local oldIndex = self._ownHand:getIndex()
	local newIndex = self._ownHand:indexMoveUp()

	self:_handleHandChangeIndex(oldIndex, newIndex, self._ownHand)
end

function GameplayScreen:_handleRightPressed()
	if not self._isOwnTurn then
		return
	end

	local oldIndex = self._ownHand:getIndex()
	local newIndex = self._ownHand:indexMoveRight()

	self:_handleHandChangeIndex(oldIndex, newIndex, self._ownHand)
end

function GameplayScreen:_handleDownPressed()
	if not self._isOwnTurn then
		return
	end

	local oldIndex = self._ownHand:getIndex()
	local newIndex = self._ownHand:indexMoveDown()

	self:_handleHandChangeIndex(oldIndex, newIndex, self._ownHand)
end

function GameplayScreen:_handleLeftPressed()
	if not self._isOwnTurn then
		return
	end

	local oldIndex = self._ownHand:getIndex()
	local newIndex = self._ownHand:indexMoveLeft()

	self:_handleHandChangeIndex(oldIndex, newIndex, self._ownHand)
end

function GameplayScreen:_handleTurnStart()
	self._isOwnTurn = true

	-- TODO: Cleanup (move other hand back to resting pos, probably other stuff)

	local targetIndex = self._boardState:getFirstEmptyCellIndex()
	self._ownHand:setTargetIndex(targetIndex)
	self:_handleHandChangeIndex(nil, targetIndex, self._ownHand)
end

function GameplayScreen:hide(hideCompleteCallback)
	self._isShowing = false

	PdPortal.sendCommand(PdPortal.commands.log, '[GameplayScreen] hide')

	self._boardState:destroy()
	self._boardLines:undraw()
	self._ownHand:destroy()
	self._otherHand:destroy()

	timer.performAfterDelay(900, hideCompleteCallback)

	playdate.inputHandlers.pop()
end
