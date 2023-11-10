<script lang="ts">
	import Button from '../form/Button.svelte'
	import { pdDeviceStore, supportsSerial } from '$lib/stores/pdDeviceStore'

	const connect = async () => {
		pdDeviceStore.connect()
	}
</script>

<div>
	<h1 class="font-bold">PlaydateSerialConnectorf</h1>

	{#if supportsSerial}
		{#if $pdDeviceStore.device}
			<pre class="text-xs">{JSON.stringify($pdDeviceStore, null, 2)}</pre>
		{:else}
			<Button on:click={connect}>Connect</Button>
		{/if}
	{:else}
		<p>No Web Serial support!</p>
	{/if}
</div>
