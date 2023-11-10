import { stringToHex } from './string'

export const getBytecodePrefix = (str: string) => {
	const length = str.length
	// LUAI_MAXSHORTLEN https://www.lua.org/source/5.4/llimits.h.html
	const hexPrefix = length <= 40 ? '04' : '14'
	const bytes = []

	// Size includes null terminator
	// (Actually 0x81? That's a question for another day/person)
	let size = length + 1
	// Encode size using only the least-significant 7 bits of each byte
	do {
		bytes.unshift(size & 0x7f) // Push bytes in reverse order
		size >>= 7
	} while (size > 0)

	// Set MSB of the final byte
	// https://www.lua.org/source/5.4/ldump.c.html#dumpSize
	bytes[bytes.length - 1] |= 0x80

	const hexLength = bytes
		.map((byte) => {
			return byte.toString(16).padStart(2, '0')
		})
		.join('')

	return hexPrefix + hexLength.toUpperCase()
}

// See scripts/gf1.lua, which is literally just `globalfunc('h')`
const globalFunctionCallPre =
	'1B4C7561540019930D0A1A0A040404785600000040B9430189406766312E6C75618080000102854F0000000900000083800000420002014400010182'
const globalFunctionCallPost = '8101000080850100000000808081855F454E56'

export const getGlobalFunctionCallBytecode = (
	functionName: string,
	stringArg: string
) => {
	return [
		globalFunctionCallPre,
		getBytecodePrefix(functionName),
		stringToHex(functionName),
		getBytecodePrefix(stringArg),
		stringToHex(stringArg),
		globalFunctionCallPost
	].join('')
}
