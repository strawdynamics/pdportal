-- Copied during build, you wouldn't normally have to do that
import './pdportal'

import 'CoreLibs/graphics'

import 'Example05Ping'

local app = Example05Ping()

playdate.update = function()
	app:update()
end
