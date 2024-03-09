<script>
	import { pdDeviceStore } from '$lib/stores/pdDeviceStore'
	import Button from '../form/Button.svelte'
	import Heading, { HeadingLevel } from '../text/Heading.svelte'

	const connectDevice = async () => {
		pdDeviceStore.connect()
	}

	let msg = ''

	const sendMsg = async () => {
		const cmd = `msg ${msg}`
		console.warn('sending command', cmd)
		pdDeviceStore.device?.serial.writeAscii(cmd)
	}
</script>

<section>
	<Heading level={HeadingLevel.H3}>Device info</Heading>

	{#if $pdDeviceStore.device}
		<pre class="text-xs h-[200px] overflow-auto">{JSON.stringify(
				$pdDeviceStore,
				null,
				2,
			)}</pre>

		<form on:submit|preventDefault={sendMsg}>
			<input type="text" bind:value={msg} />
			<Button>Send</Button>
		</form>
	{:else}
		<p>No device connected</p>

		<Button on:click={connectDevice}>Connect</Button>
	{/if}
</section>
