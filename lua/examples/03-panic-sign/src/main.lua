-- Copied during build, you wouldn't normally have to do that
import './pdportal'

import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

import './lib/util/text'
import './Example03PanicSign'

local app = Example03PanicSign()

function playdate.update()
	app:update()
end
