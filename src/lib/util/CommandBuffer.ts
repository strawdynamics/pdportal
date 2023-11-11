import { splitBuffer } from './buffer'

export class CommandBuffer {
	private buffer: Uint8Array
	private separator: number

	constructor(separator: string = ';') {
		if (separator.length !== 1) {
			throw new Error('Separator must be a single character')
		}
		this.buffer = new Uint8Array(0)
		this.separator = separator.charCodeAt(0)
	}

	// Takes in a Uint8Array, appends it to the internal buffer, and returns an array of Uint8Arrays of complete commands
	append(data: Uint8Array): Uint8Array[] {
		this.buffer = Uint8Array.from([...this.buffer, ...data])

		// Find the last occurrence of the separator
		const lastIndex = this.lastIndexOfSeparator(this.buffer)
		if (lastIndex === -1) {
			return []
		}

		const completed = this.buffer.slice(0, lastIndex + 1)
		this.buffer = this.buffer.slice(lastIndex + 1)
		return splitBuffer(completed, this.separator)
	}

	private lastIndexOfSeparator(buffer: Uint8Array): number {
		for (let i = buffer.length - 1; i >= 0; i--) {
			if (buffer[i] === this.separator) {
				return i
			}
		}
		return -1
	}

	clear(): void {
		this.buffer = new Uint8Array(0)
	}
}
