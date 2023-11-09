<script lang="ts">
	import { assertUsbSupported, requestConnectPlaydate } from 'pd-usb'
	import Button from '../form/Button.svelte'
	import { pdDevice } from '$lib/stores/pdDevice'

	let isSupported = true
	try {
		assertUsbSupported()
	} catch (err) {
		isSupported = false
	}

	const connect = async () => {
		try {
			$pdDevice = await requestConnectPlaydate()
			await $pdDevice.open()

			const serial = await $pdDevice.getSerial()
			console.log(`Connected to Playdate ${serial}`)

			$pdDevice.on('disconnect', () => {
				$pdDevice = null
			})

			$pdDevice.on('data', (theData) => {
				console.warn('pddata', new TextDecoder().decode(theData))
			})
		} catch (err) {
			console.warn('something has gone wrong')
			console.warn(err.message)
		}
	}
</script>

<div>
	<h1 class="font-bold">PlaydateSerialConnectorf</h1>

	{#if isSupported}
		{#if $pdDevice}
			<pre class="text-xs">{JSON.stringify($pdDevice, null, 2)}</pre>
		{:else}
			<Button on:click={connect}>Connect</Button>
		{/if}
	{:else}
		<p>No Web Serial support!</p>
	{/if}
</div>
