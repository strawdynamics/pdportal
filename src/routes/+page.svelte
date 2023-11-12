<script lang="ts">
	import Button from '$lib/components/form/Button.svelte'
	import TextInput from '$lib/components/form/TextInput.svelte'
	import Link from '$lib/components/text/Link.svelte'
	import { pdDeviceStore, supportsSerial } from '$lib/stores/pdDeviceStore'
	import { peerStore } from '$lib/stores/peerStore'

	const connect = async () => {
		await pdDeviceStore.connect()
		peerStore.initializePeer()
	}

	let remotePeerId = ''

	$: otherPeerIds = Object.keys($peerStore.peerConnections)
		.map((peerId) => {
			return `<strong>${peerId}</strong>`
		})
		.join(', ')

	const connectToRemotePeer = () => {
		peerStore.connect(remotePeerId)
		remotePeerId = ''
	}
</script>

{#if supportsSerial}
	<div class="flex flex-col gap-6 items-start">
		{#if $pdDeviceStore.device}
			<p>Connected to Playdate <strong>{$pdDeviceStore.serial}</strong></p>

			{#if $peerStore.isConnecting}
				<p>Connecting to peer server…</p>
			{:else if $peerStore.peerId}
				{#if Object.keys($peerStore.peerConnections).length > 0}
					<p>
						Connected to peer server. Your ID is <strong
							>{$peerStore.peerId}</strong
						>, connected to
						{@html otherPeerIds}.
					</p>
				{:else}
					<p>
						Connected to peer server. Your ID is <strong
							>{$peerStore.peerId}</strong
						>. Wait for someone to connect to you, or enter the ID you want to
						connect to:
					</p>

					<div class="flex gap-4">
						<TextInput
							bind:value={remotePeerId}
							ariaLabel="Remote peer ID"
							placeholder="1234"
							class="uppercase"
						/>

						<Button
							disabled={remotePeerId.length !== 4}
							on:click={connectToRemotePeer}>Connect</Button
						>
					</div>
				{/if}
			{/if}
		{:else}
			<p>
				To get started, connect a Playdate via USB. Make sure it's on, and
				running a <Link href="/about">pdportal-compatible app</Link>. Some apps
				may require you to be in a specific mode before connecting.
			</p>

			<Button on:click={connect}>Connect</Button>
		{/if}
	</div>
{:else}
	<p>
		Your browser doesn't support Web Serial. Can I Use provides an up-to-date
		list of <Link href="https://caniuse.com/web-serial" target="_blank"
			>browsers with Web Serial support</Link
		>.
	</p>
{/if}
