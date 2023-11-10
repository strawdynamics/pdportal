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
import { ToastLevel, toastStore } from './toastStore'

interface PdDeviceStoreData {
	device: PlaydateDevice | null
	serial: string | null
}

class PdDeviceStore {
	private writable: Writable<PdDeviceStoreData>

	subscribe: (
		this: void,
		run: Subscriber<PdDeviceStoreData>,
		invalidate?: Invalidator<PdDeviceStoreData>
	) => Unsubscriber

	constructor() {
		this.writable = writable({
			device: null,
			serial: null
		})

		this.subscribe = this.writable.subscribe
	}

	private resetWritable() {
		this.writable.update((state) => {
			state.device = null
			state.serial = null
			return state
		})
	}

	async connect() {
		try {
			const device = await requestConnectPlaydate()
			await device.open()
			const serial = await device.getSerial()

			this.writable.update((state) => {
				state.device = device
				state.serial = serial
				return state
			})

			device.on('disconnect', () => {
				this.resetWritable()
			})

			device.on('data', (theData) => {
				console.warn('pddata', new TextDecoder().decode(theData))
			})
		} catch (err: unknown) {
			this.resetWritable()

			let errorMessage = 'Unknown error'
			if (err instanceof Error) {
				errorMessage = err.message
			}
			toastStore.addToast(
				'Error connecting to Playdate',
				errorMessage,
				ToastLevel.Warning
			)
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

export const pdDeviceStore = new PdDeviceStore()
