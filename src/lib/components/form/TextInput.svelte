<script lang="ts">
	export let label: string
	export let value: string

	let className = ''
	export { className as class }
</script>

<label>
	<p>{label}</p>

	<input type="text" class="border {className}" bind:value />
</label>
