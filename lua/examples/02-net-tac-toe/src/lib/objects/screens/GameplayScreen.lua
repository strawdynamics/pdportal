class('GameplayScreen').extends()
local GameplayScreen <const> = GameplayScreen

local graphics <const> = playdate.graphics
local fonts <const> = fonts
local drawTextAlignedStroked <const> = drawTextAlignedStroked
local screenWidth, screenHeight = playdate.display.getSize()

function GameplayScreen:init(nttGame)
	self.game = nttGame
end

function GameplayScreen:update()
	--
end

function GameplayScreen:show()
	self._boardState = BoardState()
end

function GameplayScreen:hide(hideCompleteCallback)
	--
end
