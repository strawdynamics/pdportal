<script>
	import '../app.css'

	import AppHeader from '$lib/components/appHeader/AppHeader.svelte'
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
		href="https://fonts.googleapis.com/css?family=Josefin+Sans:700"
	/>
</svelte:head>

<main class="max-w-2xl p-6 text-lg">
	<div class="mb-10">
		<AppHeader />
	</div>

	<slot />
</main>
