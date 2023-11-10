<script lang="ts">
	import { BadgeInfo, Github, TerminalSquare } from 'lucide-svelte'

	import HeaderLink from './HeaderLink.svelte'
	import { pdDeviceStore } from '$lib/stores/pdDeviceStore'
	import { fly } from 'svelte/transition'
</script>

<header class="flex flex-row items-center justify-between">
	<div class="flex flex-row items-center gap-3">
		<h1 class="font-bold font-display text-5xl text-black">
			<a href="/" class="block -mt-1">pdportal</a>
		</h1>

		{#if $pdDeviceStore.device}
			<div
				class="rounded-full w-2 h-2 bg-pd-yellow"
				in:fly={{
					duration: 240,
					x: -12
				}}
				out:fly={{
					duration: 300,
					x: -12
				}}
			/>
		{/if}
	</div>

	<nav>
		<ul class="flex gap-4">
			{#if localStorage.enableDevTools}
				<HeaderLink href="/just-dev-things">
					<TerminalSquare />
					<span class="sr-only">Dev tools</span>
				</HeaderLink>
			{/if}

			<HeaderLink href="/about">
				<BadgeInfo />
				<span class="sr-only">About</span>
			</HeaderLink>

			<HeaderLink
				href="https://github.com/strawdynamics/pdportal"
				target="_blank"
			>
				<Github />
				<span class="sr-only">GitHub</span>
			</HeaderLink>
		</ul>
	</nav>
</header>
