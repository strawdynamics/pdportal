import {
	assertUsbSupported,
	requestConnectPlaydate,
	type PlaydateDevice,
} from 'pd-usb'
import {
	writable,
	type Unsubscriber,
	type Writable,
	type Subscriber,
	type Invalidator,
} from 'svelte/store'
import { ToastLevel, toastStore } from './toastStore'
import { EventEmitter } from '$lib/util/EventEmitter'
import { PlaydateCommand } from '$lib/util/PdCommunicator'

interface PdDeviceStoreData {
	device: PlaydateDevice | null
	serial: string | null
}

class PdDeviceStore extends EventEmitter {
	static readonly playdateArgumentSeparator = '~,~'

	public device: PlaydateDevice | null = null
	private writable: Writable<PdDeviceStoreData>

	subscribe: (
		this: void,
		run: Subscriber<PdDeviceStoreData>,
		invalidate?: Invalidator<PdDeviceStoreData>,
	) => Unsubscriber

	constructor() {
		super()

		this.writable = writable({
			device: null,
			serial: null,
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

	async sendCommand(command: PlaydateCommand, ...args: string[]) {
		if (!this.device) {
			throw new Error('No Playdate connected to send command to!')
		}

		const cmdParts: [PlaydateCommand | string] = [command]
		args.forEach((arg) => {
			cmdParts.push(arg)
		})

		const cmd = `msg ${cmdParts.join(
			PdDeviceStore.playdateArgumentSeparator,
		)}\n`
		await this.device.serial.writeAscii(cmd)
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
			await this.device.serial.writeAscii('echo off\n')

			const serial = await this.device.getSerial()

			this.pollSerialLoop()

			await this.sendCommand(PlaydateCommand.OnConnect)

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
				ToastLevel.Warning,
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
