<script lang="ts">
	export let label: string | null = null
	export let ariaLabel: string | null = null
	export let value: string
	export let placeholder = ''

	let className = ''
	export { className as class }
</script>

<label>
	{#if label}
		<p>{label}</p>
	{/if}

	<input
		type="text"
		class="border rounded px-2 py-[1px] {className}"
		aria-label={ariaLabel}
		{placeholder}
		bind:value
	/>
</label>
