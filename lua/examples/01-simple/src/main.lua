-- Copied during build, you wouldn't normally have to do that
import "./pdportal"

local PdPortal <const> = PdPortal

function playdate.update()
	playdate.drawFPS(10, 10)
end

function global1(stringArg)
	PdPortal.sendCommand(PdPortal.commands.log, 'Hey global 1', stringArg)
end

function global2(stringArg)
	PdPortal.sendCommand(PdPortal.commands.log, "It's global 2!", stringArg)
end

-- NOTE: This doesn't work (presumably when > 40 chars, since that's when the string bytecode change happens). Don't use super long function names.
function veryveryveryveryveryveryveryveryveryveryLongNameGlobal(stringArg)
	PdPortal.sendCommand(
		PdPortal.commands.log,
		'helo from vvvvvvLongNameGlobal',
		stringArg
	)
end
