<script lang="ts">
	import Button from '$lib/components/form/Button.svelte'
	import Link from '$lib/components/text/Link.svelte'
	import { pdDevice, supportsSerial } from '$lib/stores/pdDevice'

	const connect = async () => {
		pdDevice.connect()
	}
</script>

{#if supportsSerial}
	<p>supported</p>

	{#if $pdDevice}
		<p>Connected!</p>
	{:else}
		<Button on:click={connect}>Connect</Button>
	{/if}
{:else}
	<p>
		Your browser doesn't support Web Serial. Can I Use provides an up to date
		list of <Link href="https://caniuse.com/web-serial" target="_blank"
			>browsers with Web Serial support</Link
		>.
	</p>
{/if}
