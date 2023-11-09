<script lang="ts">
	import {
		assertUsbSupported,
		requestConnectPlaydate
	} from '$lib/3p/pd-usb/src/index'
	import Button from '../form/Button.svelte'
	import { pdDevice } from '$lib/stores/pdDevice'

	let isSupported = true
	try {
		assertUsbSupported()
	} catch (err) {
		isSupported = false
	}

	const connect = async () => {
		console.warn('whatnow')
		try {
			console.warn('ok0')
			$pdDevice = await requestConnectPlaydate()
			console.warn('ok0.5')
			await $pdDevice.open()
			console.warn('ok1')

			const serial = await $pdDevice.getSerial()
			console.log(`Connected to Playdate ${serial}`)
			console.warn('ok2')

			$pdDevice.on('disconnect', () => {
				$pdDevice = null
			})

			$pdDevice.on('data', (theData) => {
				console.warn('pddata', theData)
			})

			// const consoleData = await runPayload(device);
			// document.getElementById('data');
			// data.innerHTML += "<b>results:</b>";
			// data.innerHTML += consoleData.join('</br>');
			// console.log(consoleData);
		} catch (err) {
			console.warn('something has gone wrong')
			console.warn(err.message)
			// document.getElementById('serial').innerHTML = 'Error connecting to Playdate, try again';
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
