class('GameplayScreen').extends()
local GameplayScreen <const> = GameplayScreen

local graphics <const> = playdate.graphics
local fonts <const> = fonts
local drawTextAlignedStroked <const> = drawTextAlignedStroked
local screenWidth, screenHeight = playdate.display.getSize()
local timer <const> = playdate.timer

function GameplayScreen:init(nttGame)
	self.game = nttGame
end

function GameplayScreen:update()
	self._boardLines:update()
end

function GameplayScreen:show()
	PdPortal.sendCommand(PdPortal.commands.log, '[GameplayScreen] show')
	self._boardState = BoardState()
	self._boardLines = BoardLines()
end

function GameplayScreen:hide(hideCompleteCallback)
	PdPortal.sendCommand(PdPortal.commands.log, '[GameplayScreen] hide')

	self._boardLines:undraw()

	timer.performAfterDelay(900, hideCompleteCallback)
end
