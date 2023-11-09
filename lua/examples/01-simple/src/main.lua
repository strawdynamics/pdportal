-- Copied during build, you wouldn't normally have to do that
import "./pdportal"

function playdate.update()
	playdate.drawFPS(10, 10)
end

function global1(stringArg)
	print('helo from global1', stringArg)
end

function global2(stringArg)
	print('helo from global2', stringArg)
end

-- NOTE: This doesn't work (presumably when > 40 chars, since that's when the string bytecode change happens). Don't use super long function names.
function veryveryveryveryveryveryveryveryveryveryLongNameGlobal(stringArg)
	print('helo from vvvvvvLongNameGlobal', stringArg)
end
