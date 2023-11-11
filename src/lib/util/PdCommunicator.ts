import { pdDeviceStore } from '$lib/stores/pdDeviceStore'
import { peerStore } from '$lib/stores/peerStore'
import type { DataConnection } from 'peerjs'
import { getGlobalFunctionCallBytecode } from './luaBytecode'
import { splitBuffer } from './buffer'
import { CommandBuffer } from './CommandBuffer'

// Read data from the Playdate, send it on appropriately
// Take data from the peer store, send it to the Playdate
export class PdCommunicator {
	// https://en.wikipedia.org/wiki/C0_and_C1_control_codes#Field_separators
	// https://www.lammertbies.nl/comm/info/ascii-characters
	static readonly commandSeparator = String.fromCharCode(30) // RS (␞)
	static readonly argumentSeparator = String.fromCharCode(31) // US (␟)
	static readonly commands = Object.freeze({
		log: 'l',
		sendToPeerConn: 'p'
	})

	pdCommandBuffer = new CommandBuffer(PdCommunicator.commandSeparator)
	textDecoder = new TextDecoder()

	constructor() {
		peerStore.on('peerConnData', this.handleDataFromPeerConn)
		pdDeviceStore.on('data', this.handleDataFromPlaydate)
	}

	destroy() {
		peerStore.off('peerConnData', this.handleDataFromPeerConn)
		pdDeviceStore.off('data', this.handleDataFromPlaydate)
	}

	handleDataFromPlaydate = (data: Uint8Array) => {
		// \n, \r
		// \r\n
		if (
			(data.length === 1 && (data[0] === 10 || data[0] === 13)) ||
			(data.length === 2 && data[0] === 13 && data[1] === 10)
		) {
			return
		}

		// console.warn('Raw data from PD', new TextDecoder().decode(data))
		const completeCommandBuffers = this.pdCommandBuffer.append(data)

		completeCommandBuffers.forEach((commandBuffer) => {
			const args = splitBuffer(
				commandBuffer,
				PdCommunicator.argumentSeparator.charCodeAt(0)
			).map((arg) => {
				return this.textDecoder.decode(arg).trim()
			})
			const command = args[0]
			const restArgs = args.slice(1)

			switch (command) {
				case PdCommunicator.commands.log:
					console.log(restArgs)
					break

				default:
					console.error('[PdCommunicator] Unknown command', command)
					break
			}
		})
	}

	handleDataFromPeerConn = (conn: DataConnection, data: unknown) => {
		if (pdDeviceStore.device) {
			const bytecode = getGlobalFunctionCallBytecode(
				'pdpOnPeerConnData',
				JSON.stringify({
					peerConnId: conn.peer,
					payload: data
				})
			)
			pdDeviceStore.evalLuaPayload(bytecode)
		}
	}
}
