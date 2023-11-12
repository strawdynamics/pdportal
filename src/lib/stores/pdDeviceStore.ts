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
import { EventEmitter } from '$lib/util/EventEmitter'
import { stringToByteArray } from '$lib/util/string'
import { hexStringToBuffer } from '$lib/util/buffer'
import { getGlobalFunctionCallBytecode } from '$lib/util/luaBytecode'

interface PdDeviceStoreData {
	device: PlaydateDevice | null
	serial: string | null
}

class PdDeviceStore extends EventEmitter {
	public device: PlaydateDevice | null = null
	private writable: Writable<PdDeviceStoreData>

	subscribe: (
		this: void,
		run: Subscriber<PdDeviceStoreData>,
		invalidate?: Invalidator<PdDeviceStoreData>
	) => Unsubscriber

	constructor() {
		super()

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

	async evalLuaPayload(payload: string) {
		if (!this.device) {
			throw new Error('No Playdate connected to eval against!')
		}
		const arrayPayload = hexStringToBuffer(payload)

		const cmd = `eval ${arrayPayload.byteLength}\n`
		const data = new Uint8Array(cmd.length + arrayPayload.byteLength)
		data.set(stringToByteArray(cmd), 0)
		data.set(new Uint8Array(arrayPayload), cmd.length)
		await this.device.serial.write(data)
	}

	private async pollSerialLoop() {
		while (this.device && this.device.port.readable) {
			try {
				const bytes = await this.device.serial.readBytes()
				this.emit('data', bytes)
			} catch (err) {
				console.error('[PdDeviceStore] Error in serial loop', err)
			}
		}
	}

	async connect() {
		try {
			this.device = await requestConnectPlaydate()
			await this.device.open()
			const serial = await this.device.getSerial()

			this.pollSerialLoop()

			await this.evalLuaPayload(getGlobalFunctionCallBytecode('_pdpOnConnect'))
			await this.evalLuaPayload(getGlobalFunctionCallBytecode('pdpOnConnect'))

			this.writable.update((state) => {
				state.device = this.device
				state.serial = serial
				return state
			})

			this.device.on('disconnect', () => {
				this.device = null
				this.emit('disconnect')
				this.resetWritable()
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
