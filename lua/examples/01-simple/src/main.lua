-- Copied during build, you wouldn't normally have to do that
import "./pdportal"

local PdPortal <const> = PdPortal

playdate.display.setRefreshRate(50)

function playdate.update()
	playdate.drawFPS(10, 10)
end
