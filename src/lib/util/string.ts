export const stringToHex = (str: string) => {
	return str
		.split('')
		.map((char) => {
			return char.charCodeAt(0).toString(16).padStart(2, '0');
		})
		.join('');
};
