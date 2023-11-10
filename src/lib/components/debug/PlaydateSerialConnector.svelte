<script lang="ts">
	import Button from '../form/Button.svelte'
	import { pdDevice, supportsSerial } from '$lib/stores/pdDevice'

	const connect = async () => {
		pdDevice.connect()
	}
</script>

<div>
	<h1 class="font-bold">PlaydateSerialConnectorf</h1>

	{#if supportsSerial}
		{#if $pdDevice}
			<pre class="text-xs">{JSON.stringify($pdDevice, null, 2)}</pre>
		{:else}
			<Button on:click={connect}>Connect</Button>
		{/if}
	{:else}
		<p>No Web Serial support!</p>
	{/if}
</div>
