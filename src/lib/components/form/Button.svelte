<script lang="ts">
	let className = ''
	export { className as class }
</script>

<button on:click class="border p-2 {className}"><slot /></button>
