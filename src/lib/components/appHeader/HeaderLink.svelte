<script lang="ts">
	import type { HTMLAttributeAnchorTarget } from 'svelte/elements'

	export let href: string
	export let target: HTMLAttributeAnchorTarget = '_self'
</script>

<li>
	<a {href} target={target === '_self' ? null : target} class="p-1 block">
		<slot />
	</a>
</li>
