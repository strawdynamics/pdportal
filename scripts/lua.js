function makeLuaStringHexPrefix(str) {
	const length = str.length;
	let hexString = '';

	if (length <= 40) {
		// Short strings
		hexString = '04' + (0x81 + length).toString(16);
	} else {
		// Long strings
		let size = length;
		hexString = '14'; // Prefix for long strings
		let bytes = [];

		// Process the length for long strings
		do {
			let byteVal = size & 0x7f; // Get the lower 7 bits
			size >>= 7; // Right shift by 7 to get the next set of bits
			bytes.push(byteVal);
		} while (size > 0);

		// Reverse the array since we need little endian
		bytes.reverse();

		// Add high bit for all but the last byte
		for (let i = 0; i < bytes.length; i++) {
			let byteVal = bytes[i];
			if (i < bytes.length - 1) {
				byteVal |= 0x80; // Add the high bit for continuation
			}
			hexString += byteVal.toString(16).padStart(2, '0');
		}
	}

	return hexString.toUpperCase();
}
