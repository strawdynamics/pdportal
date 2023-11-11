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
