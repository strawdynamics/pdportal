<script>
	import { pdDeviceStore } from '$lib/stores/pdDeviceStore'
	import { hexStringToBuffer, downloadBufferAsFile } from '$lib/util/buffer'
	import { getGlobalFunctionCallBytecode } from '$lib/util/luaBytecode'
	import Button from '../form/Button.svelte'
	import TextInput from '../form/TextInput.svelte'
	import Heading, { HeadingLevel } from '../text/Heading.svelte'

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
