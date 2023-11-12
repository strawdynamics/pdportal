<script lang="ts">
	import { peerStore } from '$lib/stores/peerStore'
	import { ToastLevel, toastStore } from '$lib/stores/toastStore'
	import { onDestroy, onMount } from 'svelte'
	import Button from '../form/Button.svelte'
	import TextInput from '../form/TextInput.svelte'
	import Textarea from '../form/Textarea.svelte'
	import Heading, { HeadingLevel } from '../text/Heading.svelte'
	import type { DataConnection } from 'peerjs'

	let peerToConnectToId = ''

	let destPeerId = ''
	let outString = '{}'

	interface InMessage {
		conn: DataConnection
		data: unknown
	}

	let inMessages: InMessage[] = []

	const handlePeerConnData = (conn: DataConnection, data: unknown) => {
		inMessages.unshift({
			conn,
			data
		})
		inMessages = inMessages
	}

	onMount(() => {
		peerStore.on('peerConnData', handlePeerConnData)
	})

	onDestroy(() => {
		peerStore.off('peerConnData', handlePeerConnData)
	})

	const initPeer = () => {
		peerStore.initializePeer()
	}

	const connectToPeer = () => {
		peerStore.connect(peerToConnectToId)
	}

	const sendOut = async () => {
		try {
			const outJson = JSON.parse(outString)
			await peerStore.send(destPeerId, outJson)
		} catch (err) {
			let errorMessage = 'Unknown error'
			if (err instanceof Error) {
				errorMessage = err.message
			}
			toastStore.addToast(
				'Error sending data',
				errorMessage,
				ToastLevel.Warning
			)
			return
		}
	}
</script>

<section>
	<Heading level={HeadingLevel.H3}>P2P</Heading>

	{#if $peerStore.peerId}
		<p>
			Connected to peer server. Your ID is <strong>{$peerStore.peerId}</strong>.
			Wait for someone to connect to you, or enter the ID you want to connect
			to:
		</p>

		<TextInput
			label="Other peer ID"
			bind:value={peerToConnectToId}
			placeholder="1234"
			class="uppercase"
		/>
		<Button disabled={peerToConnectToId.length !== 4} on:click={connectToPeer}
			>Connect</Button
		>

		<div class="border">
			<Heading level={HeadingLevel.H4}>Peers</Heading>
			<ul>
				{#each Object.keys($peerStore.peerConnections) as pcId}
					<li>{pcId}</li>
				{/each}
			</ul>
		</div>

		<div class="border flex gap-4">
			<div class="border flex flex-col">
				<TextInput
					label="Dest peer ID"
					bind:value={destPeerId}
					class="uppercase"
				/>
				<Textarea label="Out" bind:value={outString} />
				<Button disabled={destPeerId.length !== 4} on:click={sendOut}
					>Send</Button
				>
			</div>

			<div class="border grow max-h-[300px] overflow-auto">
				<p>In</p>

				<ol class="text-xs">
					{#each inMessages as inMessage}
						<li>{inMessage.conn.peer}: {JSON.stringify(inMessage.data)}</li>
					{/each}
				</ol>
			</div>
		</div>
	{:else}
		<Button on:click={initPeer}>Init peer</Button>
	{/if}
</section>
