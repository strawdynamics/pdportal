<script lang="ts">
	import { toastStore } from '$lib/stores/toastStore'
	import Toast from './Toast.svelte'
</script>

<ol class="flex flex-col gap-2 p-2">
	{#each $toastStore.toasts as toast (toast.id)}
		<Toast {toast} />
	{/each}
</ol>
