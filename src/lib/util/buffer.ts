export const hexStringToBuffer = (hexString: string) => {
	if (hexString.length % 2 !== 0) {
		throw new Error('hexString must have an even number of digits')
	}
	const typedArray = new Uint8Array(
		hexString.match(/[\da-f]{2}/gi)!.map(function (h) {
			return parseInt(h, 16)
		})
	)

	return typedArray.buffer
}

export const downloadBufferAsFile = (
	buffer: ArrayBufferLike,
	filename: string
) => {
	const blob = new Blob([buffer], { type: 'application/octet-stream' })
	const url = URL.createObjectURL(blob)
	const a = document.createElement('a')
	a.href = url
	a.download = filename || 'download.bin'
	a.click()
	URL.revokeObjectURL(url)
}

export const splitBuffer = (
	buffer: Uint8Array,
	separator: number
): Uint8Array[] => {
	let start = 0
	const out: Uint8Array[] = []

	for (let i = 0; i < buffer.length; i++) {
		if (buffer[i] === separator) {
			if (i > start) {
				out.push(buffer.slice(start, i))
			}
			start = i + 1
		}
	}

	if (start < buffer.length) {
		out.push(buffer.slice(start, buffer.length))
	}

	return out
}
