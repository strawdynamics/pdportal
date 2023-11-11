<script>
	import { toastStore, ToastLevel } from '$lib/stores/toastStore'
	import Button from '../form/Button.svelte'
	import Heading, { HeadingLevel } from '../text/Heading.svelte'
</script>

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
