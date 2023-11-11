class('SetupScreen').extends()
local SetupScreen <const> = SetupScreen

local graphics <const> = playdate.graphics
local fonts <const> = fonts
local drawTextAlignedStroked <const> = drawTextAlignedStroked
local screenWidth, screenHeight = playdate.display.getSize()

graphics.pushContext()
graphics.setFont(fonts.pinzelan48)
local titleString = graphics.getLocalizedText('setup.title')
local titleWidth, titleHeight = graphics.getTextSize(titleString)
local titleImage = graphics.image.new(titleWidth + 6, titleHeight + 6)
graphics.pushContext(titleImage)
drawTextAlignedStroked(titleString, 3, 3, kTextAlignment.left, 3, graphics.kDrawModeFillWhite)
graphics.popContext()
graphics.popContext()

function SetupScreen:init(nttGame)
	self.game = nttGame
end

function SetupScreen:update()
	titleImage:drawAnchored(screenWidth * 0.5, 40, 0.5, 0.5)
end

function SetupScreen:show()
	--
end

function SetupScreen:hide(hideCompleteCallback)
	--
end
