import { pdDeviceStore } from '$lib/stores/pdDeviceStore'
import { peerStore } from '$lib/stores/peerStore'
import type { DataConnection } from 'peerjs'
import { splitBuffer } from './buffer'
import { CommandBuffer } from './CommandBuffer'

/**
 * Things the Playdate can tell pdportal to do.
 */
export enum PortalCommand {
	/**
	 * Log the given arguments to the browser console
	 */
	Log = 'l',
	/**
	 * Keepalive command, automatically sent by the Lua side of pdportal
	 */
	Keepalive = 'k',
	/**
	 * Takes two strings, the destination peer ID, and a JSON string. Sends the
	 * JSON to that peer.
	 */
	SendToPeerConn = 'p',
	/**
	 * Takes one string, the peer ID to close the connection to.
	 */
	ClosePeerConn = 'cpc',
}

/**
 * Things pdportal can tell the Playdate to do.
 */
export enum PlaydateCommand {
	OnConnect = 'oc',
	OnPeerConnData = 'opcd',
	OnPeerOpen = 'opo',
	OnPeerClose = 'opc',
	OnPeerConnection = 'opconn',
	OnPeerConnOpen = 'opco',
	OnPeerConnClose = 'opcc',
	Keepalive = 'k',
}

// Read data from the Playdate, send it on appropriately
// Take data from the peer store, send it to the Playdate
export class PdCommunicator {
	// https://en.wikipedia.org/wiki/C0_and_C1_control_codes#Field_separators
	// https://www.lammertbies.nl/comm/info/ascii-characters
	static readonly portalCommandSeparator = String.fromCharCode(30) // RS (␞)
	static readonly portalArgumentSeparator = String.fromCharCode(31) // US (␟)

	pdCommandBuffer = new CommandBuffer(PdCommunicator.portalCommandSeparator)
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
				PdCommunicator.portalArgumentSeparator.charCodeAt(0),
			).map((arg) => {
				return this.textDecoder.decode(arg).trim()
			})
			const command = args[0]
			const restArgs = args.slice(1)

			// console.log('[PDCommunicator] executing command', command, restArgs)

			switch (command) {
				case PortalCommand.Log:
					console.log(restArgs)
					break
				case PortalCommand.Keepalive:
					this.handleKeepaliveCommand()
					break
				case PortalCommand.SendToPeerConn:
					this.handleSendToPeerConnCommand(restArgs as [string, string])
					break
				case PortalCommand.ClosePeerConn:
					this.handleClosePeerConnCommand(restArgs as [string])
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
			await pdDeviceStore.sendCommand(
				PlaydateCommand.OnPeerConnData,
				conn.peer,
				JSON.stringify(data),
			)
		}
	}

	handlePeerOpen = async (peerId: string) => {
		if (pdDeviceStore.device) {
			await pdDeviceStore.sendCommand(PlaydateCommand.OnPeerOpen, peerId)
		}
	}

	handlePeerClose = async () => {
		if (pdDeviceStore.device) {
			await pdDeviceStore.sendCommand(PlaydateCommand.OnPeerClose)
		}
	}

	handlePeerConnection = async (conn: DataConnection) => {
		if (pdDeviceStore.device) {
			await pdDeviceStore.sendCommand(
				PlaydateCommand.OnPeerConnection,
				conn.peer,
			)
		}
	}

	handlePeerConnOpen = async (conn: DataConnection) => {
		if (pdDeviceStore.device) {
			await pdDeviceStore.sendCommand(PlaydateCommand.OnPeerConnOpen, conn.peer)
		}
	}

	handlePeerConnClose = async (conn: DataConnection) => {
		if (pdDeviceStore.device) {
			await pdDeviceStore.sendCommand(
				PlaydateCommand.OnPeerConnClose,
				conn.peer,
			)
		}
	}

	private handleKeepaliveCommand() {
		pdDeviceStore.sendCommand(PlaydateCommand.Keepalive)
	}

	private async handleSendToPeerConnCommand([destPeerId, jsonString]: [
		string,
		string,
	]) {
		const outJson = JSON.parse(jsonString)
		await peerStore.send(destPeerId, outJson)
	}

	private async handleClosePeerConnCommand([closePeerId]: [string]) {
		console.log(
			'[PdCommunicator] Closing peer conn (requested by Playdate)',
			closePeerId,
		)
		peerStore.close(closePeerId)
	}
}
