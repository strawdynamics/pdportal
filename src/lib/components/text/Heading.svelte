<script context="module" lang="ts">
	export enum HeadingLevel {
		H1,
		H2,
		H3,
		H4,
		H5,
		H6
	}

	const headingLevelTags = Object.freeze({
		[HeadingLevel.H1]: 'h1',
		[HeadingLevel.H2]: 'h2',
		[HeadingLevel.H3]: 'h3',
		[HeadingLevel.H4]: 'h4',
		[HeadingLevel.H5]: 'h5',
		[HeadingLevel.H6]: 'h6'
	})

	const headingLevelClasses = Object.freeze({
		[HeadingLevel.H1]: 'text-5xl font-bold font-display leading-relaxed',
		[HeadingLevel.H2]: 'text-4xl font-bold leading-relaxed',
		[HeadingLevel.H3]: 'text-2xl font-bold leading-relaxed',
		[HeadingLevel.H4]: 'text-xl font-bold font-display leading-relaxed',
		[HeadingLevel.H5]: 'h5',
		[HeadingLevel.H6]: 'h6'
	})
</script>

<script lang="ts">
	export let level: HeadingLevel

	let className = ''
	export { className as class }

	$: tag = headingLevelTags[level]
	$: classes = headingLevelClasses[level]
</script>

<svelte:element this={tag} class="{classes} {className}">
	<slot />
</svelte:element>
