<script lang="ts">
	import type { HTMLAttributeAnchorTarget } from 'svelte/elements'

	export let href: string
	export let target: HTMLAttributeAnchorTarget = '_self'
</script>

<a
	{href}
	target={target === '_self' ? null : target}
	on:click
	class="relative active:top-[1px] border-b-pd-yellow border-b-4 font-bold inline-block leading-[10px] hover:leading-[8px]"
	><slot /></a
>
