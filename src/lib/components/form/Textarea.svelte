<script lang="ts">
	export let label: string
	export let value: string
	export let placeholder = ''

	let className = ''
	export { className as class }
</script>

<label>
	<p>{label}</p>

	<textarea class="border {className}" {placeholder} bind:value />
</label>
