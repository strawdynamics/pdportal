import {
	assertUsbSupported,
	requestConnectPlaydate,
	type PlaydateDevice
} from 'pd-usb'
import {
	writable,
	type Unsubscriber,
	type Writable,
	type Subscriber,
	type Invalidator
} from 'svelte/store'

class PdDeviceStore {
	private writable: Writable<PlaydateDevice | null>

	subscribe: (
		this: void,
		run: Subscriber<PlaydateDevice | null>,
		invalidate?: Invalidator<PlaydateDevice | null>
	) => Unsubscriber

	constructor() {
		this.writable = writable(null)

		this.subscribe = this.writable.subscribe
	}

	async connect() {
		try {
			const device = await requestConnectPlaydate()
			this.writable.set(device)

			await device.open()

			const serial = await device.getSerial()
			console.log(`Connected to Playdate ${serial}`)

			device.on('disconnect', () => {
				this.writable.set(null)
			})

			device.on('data', (theData) => {
				console.warn('pddata', new TextDecoder().decode(theData))
			})
		} catch (err) {
			console.warn('something has gone wrong')
			console.warn(err.message)
		}
	}
}

export const supportsSerial = (() => {
	let out = true
	try {
		assertUsbSupported()
	} catch (_err) {
		out = false
	}
	return out
})()

export const pdDevice = new PdDeviceStore()
