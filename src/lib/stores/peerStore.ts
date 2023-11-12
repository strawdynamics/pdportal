import Peer, { PeerError } from 'peerjs'
import type { DataConnection } from 'peerjs'
import {
	writable,
	type Unsubscriber,
	type Writable,
	type Subscriber,
	type Invalidator,
	get
} from 'svelte/store'
import { ToastLevel, toastStore } from './toastStore'
import { EventEmitter } from '$lib/util/EventEmitter'
import { leftPad } from '$lib/util/string'

interface PeerStoreData {
	peerId: string | null
	isConnecting: boolean
	peerConnections: Record<string, DataConnection>
}

class PeerStore extends EventEmitter {
	private writable: Writable<PeerStoreData>

	private peer: Peer | null

	subscribe: (
		this: void,
		run: Subscriber<PeerStoreData>,
		invalidate?: Invalidator<PeerStoreData>
	) => Unsubscriber

	constructor() {
		super()

		this.writable = writable({
			peerId: null,
			isConnecting: false,
			peerConnections: {}
		})

		this.subscribe = this.writable.subscribe
		this.peer = null
	}

	initializePeer() {
		const peerId = this.getRandomPeerId()
		console.log(`[PeerStore] Attempting to connect as ${peerId}`)
		this.peer = new Peer(peerId)

		this.setIsConnecting(true)

		this.peer.on('open', this.handlePeerOpen)
		this.peer.on('close', this.handlePeerClose)
		this.peer.on('connection', this.handlePeerConnection)
		this.peer.on('error', this.handlePeerError)
	}

	destroyPeer() {
		this.peer?.destroy()
		// TODO: Other cleanup
	}

	connect(otherPeerId: string) {
		if (!this.peer) {
			throw new Error("Can't connect to another peer before we have our own!")
		}

		const conn = this.peer.connect(otherPeerId.toUpperCase())
		// https://peerjs.com/docs/#dataconnection-on-open
		conn.on('open', () => {
			this.handlePeerConnOpen(conn)
		})
	}

	async send(otherPeerId: string, data: unknown) {
		otherPeerId = otherPeerId.toUpperCase()
		const conn = get(this.writable).peerConnections[otherPeerId]

		if (!conn) {
			throw new Error(`Can't send data to unknown peer ${otherPeerId}`)
		}

		await conn.send(data)
		return true
	}

	private getRandomPeerId() {
		return leftPad(Math.floor(Math.random() * 10000).toString(), '0', 4)
	}

	private setIsConnecting(val: boolean) {
		this.writable.update((state) => {
			state.isConnecting = val
			return state
		})
	}

	private handlePeerOpen = (peerId: string) => {
		this.writable.update((state) => {
			state.isConnecting = false
			state.peerId = peerId
			return state
		})
		this.emit('peerOpen', peerId)
	}

	// https://peerjs.com/docs/#peeron-close
	private handlePeerClose = () => {
		this.peer = null
		this.writable.update((state) => {
			state.isConnecting = false
			state.peerId = null
			return state
		})
		this.emit('peerClose')
	}

	// Called after a remote peer opens a connection to us
	// https://peerjs.com/docs/#peeron-connection
	private handlePeerConnection = (conn: DataConnection) => {
		this.addPeerConn(conn)
		this.emit('peerConnection', conn)
	}

	// https://peerjs.com/docs/#peeron-error
	private handlePeerError = (err: PeerError<string>) => {
		if (err.type === 'unavailable-id') {
			this.initializePeer()
		} else {
			toastStore.addToast(
				'Error connecting to peer server',
				`${err.message} - ${err.type}`,
				ToastLevel.Warning
			)
		}
	}

	// Called after we finish opening connection to a remote peer
	private handlePeerConnOpen(conn: DataConnection) {
		this.addPeerConn(conn)
		this.emit('peerConnOpen', conn)
	}

	private handlePeerConnClose(conn: DataConnection) {
		this.removePeerConn(conn)
		this.emit('peerConnClose', conn)
	}

	private handlePeerConnError(
		conn: DataConnection,
		err: PeerError<
			| 'not-open-yet'
			| 'message-too-big'
			| 'negotiation-failed'
			| 'connection-closed'
		>
	) {
		toastStore.addToast(
			`Peer conn error ${err.type}`,
			err.message,
			ToastLevel.Warning
		)

		this.removePeerConn(conn)
	}

	private handlePeerConnData(conn: DataConnection, data: unknown) {
		this.emit('peerConnData', conn, data)
	}

	private addPeerConn(conn: DataConnection) {
		this.writable.update((state) => {
			state.peerConnections[conn.peer] = conn
			return state
		})

		conn.on('close', () => {
			this.handlePeerConnClose(conn)
		})
		conn.on('error', (err) => {
			this.handlePeerConnError(conn, err)
		})
		conn.on('data', (data) => {
			this.handlePeerConnData(conn, data)
		})
	}

	private removePeerConn(conn: DataConnection) {
		this.writable.update((state) => {
			delete state.peerConnections[conn.peer]
			return state
		})
	}
}

export const peerStore = new PeerStore()
