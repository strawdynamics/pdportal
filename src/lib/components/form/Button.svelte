<script lang="ts">
	export let disabled = false

	let className = ''
	export { className as class }
</script>

<button
	on:click
	{disabled}
	class="py-0.5 px-4 bg-pd-yellow hover:bg-pd-yellow/80 rounded-md {className}"
	class:opacity-50={disabled}><slot /></button
>
