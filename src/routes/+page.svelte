<script>
	import { downloadBufferAsFile, hexStringToBuffer } from '$lib/buffer';
	import { getGlobalFunctionCallBytecode } from '$lib/luaBytecode';

	let firsttest = getGlobalFunctionCallBytecode('globalfunc', 'h');

	const download = () => {
		const buf = hexStringToBuffer(firsttest);
		downloadBufferAsFile(buf, 'maybe.luac');
	};
</script>

<pre>{firsttest}</pre>
<button on:click={download}>Download</button>
