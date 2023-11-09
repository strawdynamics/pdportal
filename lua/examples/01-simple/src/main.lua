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

function veryveryveryveryveryveryveryveryveryveryLongNameGlobal(stringArg)
	print('helo from vvvvvvLongNameGlobal', stringArg)
end
