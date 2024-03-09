<script lang="ts">
	import PeerDebugger from '$lib/components/dev/PeerDebugger.svelte'
	import DeviceInfo from '$lib/components/dev/DeviceInfo.svelte'
	import Heading, { HeadingLevel } from '$lib/components/text/Heading.svelte'
	import Toasts from '$lib/components/dev/Toasts.svelte'
</script>

<Heading level={HeadingLevel.H2}>Dev tools</Heading>

<div class="flex flex-col gap-8">
	<PeerDebugger />

	<DeviceInfo />

	<Toasts />
</div>
