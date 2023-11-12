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
		keepalive: 'k',
		sendToPeerConn: 'p'
	})

	pdCommandBuffer = new CommandBuffer(PdCommunicator.commandSeparator)
	textDecoder = new TextDecoder()

	constructor() {
		pdDeviceStore.on('data', this.handleDataFromPlaydate)
		pdDeviceStore.on('disconnect', this.handlePlaydateDisconnect)

		peerStore.on('peerOpen', this.handlePeerOpen)
		peerStore.on('peerClose', this.handlePeerClose)
		peerStore.on('peerConnData', this.handleDataFromPeerConn)
		peerStore.on('peerConnection', this.handlePeerConnection)
		peerStore.on('peerConnOpen', this.handlePeerConnOpen)
		peerStore.on('peerConnClose', this.handlePeerConnClose)
	}

	destroy() {
		pdDeviceStore.off('data', this.handleDataFromPlaydate)
		pdDeviceStore.off('disconnect', this.handlePlaydateDisconnect)

		peerStore.off('peerOpen', this.handlePeerOpen)
		peerStore.off('peerClose', this.handlePeerClose)
		peerStore.off('peerConnData', this.handleDataFromPeerConn)
		peerStore.off('peerConnection', this.handlePeerConnection)
		peerStore.off('peerConnOpen', this.handlePeerConnOpen)
		peerStore.off('peerConnClose', this.handlePeerConnClose)
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

			// console.log('[PDCommunicator] executing command', command, restArgs)

			switch (command) {
				case PdCommunicator.commands.log:
					console.log(restArgs)
					break
				case PdCommunicator.commands.keepalive:
					this.handleKeepaliveCommand()
					break
				case PdCommunicator.commands.sendToPeerConn:
					this.handleSendToPeerConnCommand(restArgs as [string, string])
					break
				default:
					console.error('[PdCommunicator] Unknown command', command)
					break
			}
		})
	}

	// Automatically disconnect peer when Playdate connection lost
	handlePlaydateDisconnect = () => {
		peerStore.destroyPeer()
	}

	handleDataFromPeerConn = async (conn: DataConnection, data: unknown) => {
		if (pdDeviceStore.device) {
			const bytecode = getGlobalFunctionCallBytecode(
				'pdpOnPeerConnData',
				JSON.stringify({
					peerConnId: conn.peer,
					payload: data
				})
			)
			await pdDeviceStore.evalLuaPayload(bytecode)
		}
	}

	handlePeerOpen = async (peerId: string) => {
		if (pdDeviceStore.device) {
			const bytecode = getGlobalFunctionCallBytecode('pdpOnPeerOpen', peerId)
			await pdDeviceStore.evalLuaPayload(bytecode)
		}
	}

	handlePeerClose = async () => {
		if (pdDeviceStore.device) {
			const bytecode = getGlobalFunctionCallBytecode('pdpOnPeerOpen', '')
			await pdDeviceStore.evalLuaPayload(bytecode)
		}
	}

	handlePeerConnection = async (conn: DataConnection) => {
		if (pdDeviceStore.device) {
			const bytecode = getGlobalFunctionCallBytecode(
				'pdpOnPeerConnection',
				conn.peer
			)
			await pdDeviceStore.evalLuaPayload(bytecode)
		}
	}

	handlePeerConnOpen = async (conn: DataConnection) => {
		if (pdDeviceStore.device) {
			const bytecode = getGlobalFunctionCallBytecode(
				'pdpOnPeerConnOpen',
				conn.peer
			)
			await pdDeviceStore.evalLuaPayload(bytecode)
		}
	}

	handlePeerConnClose = async (conn: DataConnection) => {
		if (pdDeviceStore.device) {
			const bytecode = getGlobalFunctionCallBytecode(
				'pdpOnPeerConnClose',
				conn.peer
			)
			await pdDeviceStore.evalLuaPayload(bytecode)
		}
	}

	private handleKeepaliveCommand() {
		pdDeviceStore.evalLuaPayload(getGlobalFunctionCallBytecode('_pdpKeepalive'))
	}

	private async handleSendToPeerConnCommand(args: [string, string]) {
		const destPeerId = args[0]
		const jsonString = args[1]
		const outJson = JSON.parse(jsonString)
		await peerStore.send(destPeerId, outJson)
	}
}
