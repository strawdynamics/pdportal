<script lang="ts">
	import PlaydateSerialConnector from '$lib/components/debug/PlaydateSerialConnector.svelte'
	import Button from '$lib/components/form/Button.svelte'
	import TextInput from '$lib/components/form/TextInput.svelte'
	import { pdDevice } from '$lib/stores/pdDevice'
	import { downloadBufferAsFile, hexStringToBuffer } from '$lib/util/buffer'
	import { getGlobalFunctionCallBytecode } from '$lib/util/luaBytecode'

	let functionName = 'someGlobal'
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

<div class="p-4">
	<div class="border p-4">
		<div>
			<TextInput label="Function name" bind:value={functionName} />
			<TextInput label="Payload" bind:value={payload} />
		</div>

		<pre
			class="w-[500px] max-w-full break-all whitespace-break-spaces text-xs">{bytecode}</pre>

		<Button on:click={download}>Download</Button>
		<Button on:click={evalPd}>Eval</Button>
	</div>

	<PlaydateSerialConnector />
</div>
