class('GameplayScreen').extends()
local GameplayScreen <const> = GameplayScreen

local graphics <const> = playdate.graphics
local geometry <const> = playdate.geometry
local fonts <const> = fonts
local drawTextAlignedStroked <const> = drawTextAlignedStroked
local screenWidth, screenHeight = playdate.display.getSize()
local timer <const> = playdate.timer
local BoardStates <const> = BoardStates

local ownHandRestPoint <const> = geometry.point.new(
	40,
	screenHeight * 0.7
)
local otherHandRestPoint <const> = geometry.point.new(
	screenWidth - 40,
	screenHeight * 0.7
)

local MatchEvent <const> = {
	Start = 's',
	HandMoved = 'm',
	Placed = 'p',
}

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

	self._ownHand = Hand(
		self.game.peerId,
		graphics.getLocalizedText('gameplay.you')
	)
	self._otherHand = Hand(self.game.remotePeerId, self.game.remotePeerId)

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

			self:_sendToPeer({e = MatchEvent.Start, isHostX = self._isOwnTurn})

			if self._isOwnTurn then
				self:_handleTurnStart()
			end
		end)
	end

	timer.performAfterDelay(2000, function()
		self:_enableControls()
	end)
end

function GameplayScreen:_sendToPeer(payload)
	PdPortal.sendToPeerConn(self.game.remotePeerId, payload)
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
		AButtonDown = function()
			self:_handleAPressed()
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
		self._boardState:trySetCell(
			newIndex,
			self._isX and BoardStates.HoverX or BoardStates.HoverO
		)

		self:_sendToPeer({
			e = MatchEvent.HandMoved,
			oldIndex = oldIndex,
			newIndex = newIndex
		})
	else
		self._boardState:trySetCell(
			newIndex,
			self._isX and BoardStates.HoverO or BoardStates.HoverX
		)
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

function GameplayScreen:_handleAPressed()
	local index = self._ownHand:getIndex()

	if not self._isOwnTurn or index == nil then
		return
	end

	local ownState = self._isX and BoardStates.X or BoardStates.O

	local didSet = self._boardState:trySetCell(index, ownState)

	if didSet then
		self:_sendToPeer({
			e = MatchEvent.Placed,
			index = index,
		})

		local didWin = self._boardState:checkWinState(ownState)

		if didWin then
			-- TODO: Handle win condition
			-- TODO: Handle draw condition? Second return from checkWinState?
		else
			self:_handleTurnEnd()
		end
	end
end

function GameplayScreen:_handleTurnStart()
	self._isOwnTurn = true

	self._otherHand:setTarget(otherHandRestPoint)

	local targetIndex = self._boardState:getFirstEmptyCellIndex()
	self._ownHand:setTargetIndex(targetIndex)
	self:_handleHandChangeIndex(nil, targetIndex, self._ownHand)
end

function GameplayScreen:_handleTurnEnd()
	self._isOwnTurn = false
	self._ownHand:setTarget(ownHandRestPoint)
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

function GameplayScreen:_resetBoard()
	self._boardState:reset()
end

function GameplayScreen:_handleMatchStart(matchStartData)
	self:_resetBoard()

	local isSelfX = not matchStartData.isHostX

	self:_setIsX(isSelfX)

	if isSelfX then
		self:_handleTurnStart()
	end
end

function GameplayScreen:_handleHandMoved(handMovedData)
	local oldIndex = handMovedData.oldIndex
	local newIndex = handMovedData.newIndex
	self._otherHand:setTargetIndex()
	self:_handleHandChangeIndex(oldIndex, newIndex, self._otherHand)
end

function GameplayScreen:_handlePlace(placeData)
	local otherState = self._isX and BoardStates.O or BoardStates.X

	self._boardState:setCell(placeData.index, otherState)

	local didLose = self._boardState:checkWinState(otherState)

	if didLose then
		-- TODO: Handle lose condition
		-- TODO: Handle draw condition? Second return from checkWinState?
	else
		self:_handleTurnStart()
	end
end
