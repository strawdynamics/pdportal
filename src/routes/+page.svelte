<script lang="ts">
	import Button from '$lib/components/form/Button.svelte'
	import Link from '$lib/components/text/Link.svelte'
	import { pdDeviceStore, supportsSerial } from '$lib/stores/pdDeviceStore'

	const connect = async () => {
		pdDeviceStore.connect()
	}
</script>

{#if supportsSerial}
	{#if $pdDeviceStore.device}
		<p>Connected to Playdate <strong>{$pdDeviceStore.serial}</strong></p>
	{:else}
		<Button on:click={connect}>Connect</Button>
	{/if}
{:else}
	<p>
		Your browser doesn't support Web Serial. Can I Use provides an up-to-date
		list of <Link href="https://caniuse.com/web-serial" target="_blank"
			>browsers with Web Serial support</Link
		>.
	</p>
{/if}
