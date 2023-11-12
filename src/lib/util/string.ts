export const stringToHex = (str: string) => {
	return str
		.split('')
		.map((char) => {
			return char.charCodeAt(0).toString(16).padStart(2, '0')
		})
		.join('')
}

export const stringToByteArray = (str: string) => {
	const bytes = new Uint8Array(str.length)
	for (let i = 0; i < str.length; i++) {
		bytes[i] = str.charCodeAt(i)
	}
	return bytes
}

// I will never not laugh
export const leftPad = (str: string, padChar: string, targetLen: number) => {
	if (padChar.length > 1) {
		throw new Error('padChar must be single character')
	}

	const strLen = str.length
	if (strLen >= targetLen) {
		return str
	}

	const padding = padChar.repeat(targetLen - strLen)
	return padding + str
}
