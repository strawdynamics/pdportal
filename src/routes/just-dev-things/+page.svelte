<script lang="ts">
	import Button from '$lib/components/form/Button.svelte'
	import TextInput from '$lib/components/form/TextInput.svelte'
	import Heading, { HeadingLevel } from '$lib/components/text/Heading.svelte'
	import ToastList from '$lib/components/toast/ToastList.svelte'
	import { pdDeviceStore } from '$lib/stores/pdDeviceStore'
	import { ToastLevel, toastStore } from '$lib/stores/toastStore'
	import { downloadBufferAsFile, hexStringToBuffer } from '$lib/util/buffer'
	import { getGlobalFunctionCallBytecode } from '$lib/util/luaBytecode'
	import { onMount } from 'svelte'

	let functionName = 'global1'
	let payload = 'hey'

	$: bytecode = getGlobalFunctionCallBytecode(functionName, payload)

	const download = () => {
		const buf = hexStringToBuffer(bytecode)
		downloadBufferAsFile(buf, 'maybe.luac')
	}

	const evalPd = () => {
		console.warn('epd', hexStringToBuffer(bytecode))
		if (!$pdDeviceStore.device) {
			alert('No device connected!')
			return
		}

		$pdDeviceStore.device.evalLuaPayload(hexStringToBuffer(bytecode), 500)
	}
</script>

<Heading level={HeadingLevel.H2}>Dev tools</Heading>

<section>
	<Heading level={HeadingLevel.H3}>Call global</Heading>

	<div>
		<TextInput label="Function name" bind:value={functionName} />
		<TextInput label="Payload" bind:value={payload} />
	</div>

	<pre
		class="w-[500px] max-w-full break-all whitespace-break-spaces text-xs">{bytecode}</pre>

	<Button on:click={download}>Download</Button>
	<Button on:click={evalPd}>Eval</Button>
</section>

<section>
	<Heading level={HeadingLevel.H3}>Toasts</Heading>

	<Button
		on:click={() => {
			toastStore.addToast(
				'Greetings, toasters',
				'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
				ToastLevel.Info
			)
		}}>Info toast</Button
	>
	<Button
		on:click={() => {
			toastStore.addToast(
				'Oh no, Mr. Bill!',
				'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
				ToastLevel.Warning
			)
		}}>Warning toast</Button
	>
</section>

<section>
	<Heading level={HeadingLevel.H3}>Device info</Heading>

	{#if $pdDeviceStore.device}
		<pre class="text-xs h-[200px] overflow-auto">{JSON.stringify(
				$pdDeviceStore,
				null,
				2
			)}</pre>
	{:else}
		No device connected
	{/if}
</section>
