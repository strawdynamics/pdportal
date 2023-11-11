<script>
	import { pdDeviceStore } from '$lib/stores/pdDeviceStore'
	import { hexStringToBuffer, downloadBufferAsFile } from '$lib/util/buffer'
	import { getGlobalFunctionCallBytecode } from '$lib/util/luaBytecode'
	import Button from '../form/Button.svelte'
	import TextInput from '../form/TextInput.svelte'
	import Heading, { HeadingLevel } from '../text/Heading.svelte'

	let functionName = 'pdpEcho'
	let payload = 'Hello, cool world!'

	$: bytecode = getGlobalFunctionCallBytecode(functionName, payload)

	const download = () => {
		const buf = hexStringToBuffer(bytecode)
		downloadBufferAsFile(buf, `call_${functionName}.luac`)
	}

	const evalPd = async () => {
		if (!$pdDeviceStore.device) {
			alert('No device connected!')
			return
		}

		await pdDeviceStore.evalLuaPayload(bytecode)
	}
</script>

<section>
	<Heading level={HeadingLevel.H3}>Call global</Heading>

	<div>
		<TextInput label="Function name" bind:value={functionName} />
		<TextInput label="Payload" bind:value={payload} />
	</div>

	<pre
		class="w-[500px] max-w-full max-h-[200px] overflow-auto break-all whitespace-break-spaces text-xs">{bytecode}</pre>

	<Button on:click={download}>Download</Button>
	<Button on:click={evalPd}>Eval</Button>
</section>
