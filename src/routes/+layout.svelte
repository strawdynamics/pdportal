<script>
	import '../app.css'

	import { onMount } from 'svelte'
	import AppHeader from '$lib/components/appHeader/AppHeader.svelte'
	import ToastList from '$lib/components/toast/ToastList.svelte'

	onMount(() => {
		console.log(
			'%c Welcome, explorer! Try running `localStorage.enableDevTools = true` and refreshing.',
			'font-size: 18px; font-weight: bold; font-family: sans-serif'
		)
	})
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

<main class="max-w-2xl p-6 text-lg text-neutral-700">
	<div class="mb-8">
		<AppHeader />
	</div>

	<slot />
</main>

<div class="fixed top-0 right-0">
	<ToastList />
</div>
