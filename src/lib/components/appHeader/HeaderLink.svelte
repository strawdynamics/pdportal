<script lang="ts">
	import { page } from '$app/stores'
	import type { HTMLAttributeAnchorTarget } from 'svelte/elements'

	export let href: string
	export let target: HTMLAttributeAnchorTarget = '_self'
</script>

<li>
	<a
		{href}
		target={target === '_self' ? null : target}
		class="p-1 block rounded-full relative active:top-[1px]"
		class:bg-pd-yellow={$page.url.pathname === href}
		class:text-black={$page.url.pathname === href}
	>
		<slot />
	</a>
</li>
