<script lang="ts">
	import '../app.css'

	import { onDestroy, onMount } from 'svelte'
	import AppHeader from '$lib/components/appHeader/AppHeader.svelte'
	import ToastList from '$lib/components/toast/ToastList.svelte'
	import { PdCommunicator } from '$lib/util/PdCommunicator'
	import { peerStore } from '$lib/stores/peerStore'

	let communicator: PdCommunicator | null = null

	if (localStorage.enableDevTools) {
		console.log('Dev tools enabled, visit `/just-dev-things`')
	} else {
		console.log(
			'%c Welcome, explorer! Try running `localStorage.enableDevTools = true` and refreshing.',
			'font-size: 18px; font-weight: bold; font-family: sans-serif',
		)
	}

	onMount(() => {
		communicator = new PdCommunicator()
	})

	onDestroy(() => {
		communicator?.destroy()
	})

	const handleBeforeUnload = () => {
		peerStore.destroyPeer()
	}
</script>

<svelte:head>
	<link
		rel="stylesheet"
		type="text/css"
		href="https://fonts.googleapis.com/css?family=Inconsolata:500,700"
	/>
	<link
		rel="stylesheet"
		type="text/css"
		href="https://fonts.googleapis.com/css?family=Red+Hat+Display:700"
	/>
</svelte:head>

<svelte:window on:beforeunload={handleBeforeUnload} />

<main class="max-w-2xl p-6 text-lg text-neutral-700">
	<div class="mb-8">
		<AppHeader />
	</div>

	<slot />
</main>

<div class="fixed top-0 right-0">
	<ToastList />
</div>
