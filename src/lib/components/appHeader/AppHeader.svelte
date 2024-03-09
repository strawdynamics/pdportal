<script lang="ts">
	import { BadgeInfo, Github, TerminalSquare } from 'lucide-svelte'

	import HeaderLink from './HeaderLink.svelte'
	import { pdDeviceStore } from '$lib/stores/pdDeviceStore'
	import { fly } from 'svelte/transition'
	import { version } from '$lib/version'
</script>

<header class="flex flex-row items-center justify-between">
	<div class="relative">
		<h1
			class="relative font-bold font-display text-4xl text-black hover:text-neutral-700 active:top-[1px]"
		>
			<img
				src="/logo.jpg"
				alt=""
				class="mb-0.5 mr-1 w-[70px] hidden sm:inline-block"
			/>
			<a href="/" class="inline-block -mt-1">pdportal</a>
			<span class="text-sm opacity-60">{version}</span>
		</h1>

		{#if $pdDeviceStore.device}
			<div
				class="absolute bottom-2 -right-4 rounded-full w-2 h-2 bg-pd-yellow"
				in:fly={{
					duration: 240,
					x: -12,
				}}
				out:fly={{
					duration: 300,
					x: -12,
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
