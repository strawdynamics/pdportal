-- Copied during build, you wouldn't normally have to do that
import "./pdportal"

import "CoreLibs/animator"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

import "lib/util/board"
import "lib/util/text"

import "lib/objects/board/BoardCell"
import "lib/objects/board/BoardLines"
import "lib/objects/board/BoardState"

import "lib/objects/screens/GameplayScreen"
import "lib/objects/screens/SetupScreen"

import "lib/objects/Hand"
import "lib/objects/NttGame"

local PdPortal <const> = PdPortal

local nttGame <const> = NttGame()

playdate.display.setRefreshRate(50)

playdate.update = function()
	nttGame:update()
end
