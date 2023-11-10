<script lang="ts">
	let className = ''
	export { className as class }
</script>

<button
	on:click
	class="py-0.5 px-4 bg-pd-yellow hover:bg-pd-yellow/80 rounded-md {className}"
	><slot /></button
>
