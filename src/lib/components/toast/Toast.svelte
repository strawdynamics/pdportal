<script lang="ts">
	import { toastStore, type Toast, ToastLevel } from '$lib/stores/toastStore'
	import { X } from 'lucide-svelte'
	import Heading, { HeadingLevel } from '$lib/components/text/Heading.svelte'
	import { fly } from 'svelte/transition'

	export let toast: Toast

	$: bgClass =
		toast.level === ToastLevel.Info ? 'bg-pd-yellow/80' : 'bg-red-500/80'
</script>

<li
	class="rounded-md w-[380px] max-w-full px-4 pt-2 pb-3 flex flex-col gap-1 {bgClass}"
	in:fly={{
		duration: 300,
		y: -20
	}}
	out:fly={{
		duration: 300,
		x: 300
	}}
>
	<div class="flex items-center justify-between">
		<Heading level={HeadingLevel.H4}>{toast.title}</Heading>

		<button on:click={() => toastStore.removeToast(toast.id)}>
			<X />
			<span class="sr-only">Dismiss</span>
		</button>
	</div>

	<p class="opacity-60">{toast.description}</p>
</li>
