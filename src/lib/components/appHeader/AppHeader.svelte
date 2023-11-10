<script lang="ts">
	import { BadgeInfo, Github, TerminalSquare } from 'lucide-svelte'

	import HeaderLink from './HeaderLink.svelte'
	import Heading, { HeadingLevel } from '../text/Heading.svelte'
</script>

<header class="flex flex-row items-center justify-between">
	<Heading level={HeadingLevel.H1} class="h-[50px] leading-[50px]">
		<a href="/">pdportal</a>
	</Heading>

	<nav>
		<ul class="flex gap-4 text-neutral-700">
			<HeaderLink href="/just-dev-things">
				<TerminalSquare />
				<span class="sr-only">Dev tools</span>
			</HeaderLink>

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
