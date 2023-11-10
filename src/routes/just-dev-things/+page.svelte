<script lang="ts">
	import PlaydateSerialConnector from '$lib/components/debug/PlaydateSerialConnector.svelte'
	import Button from '$lib/components/form/Button.svelte'
	import TextInput from '$lib/components/form/TextInput.svelte'
	import Heading, { HeadingLevel } from '$lib/components/text/Heading.svelte'
	import { pdDevice } from '$lib/stores/pdDevice'
	import { downloadBufferAsFile, hexStringToBuffer } from '$lib/util/buffer'
	import { getGlobalFunctionCallBytecode } from '$lib/util/luaBytecode'

	let functionName = 'global1'
	let payload = 'hey'

	$: bytecode = getGlobalFunctionCallBytecode(functionName, payload)

	const download = () => {
		const buf = hexStringToBuffer(bytecode)
		downloadBufferAsFile(buf, 'maybe.luac')
	}

	const evalPd = () => {
		console.warn('epd', hexStringToBuffer(bytecode))
		if (!$pdDevice) {
			alert('No device connected!')
			return
		}

		$pdDevice.evalLuaPayload(hexStringToBuffer(bytecode), 500)
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

<PlaydateSerialConnector />
