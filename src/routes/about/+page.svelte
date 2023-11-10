<script lang="ts">
	import Link from '$lib/components/text/Link.svelte'
</script>

<div class="flex flex-col gap-6">
	<p>
		A magic portal for <Link href="https://play.date" target="_blank"
			>Playdate</Link
		> that enables online multiplayer using Web Serial and WebRTC.
	</p>

	<p>
		I'll be honest, there's not much to play yet! If you're interested in trying
		out the technology, grab <Link
			href="https://paulstraw.itch.io/net-tac-toe"
			target="_blank">Net-tac-toe on itch</Link
		>. It's… well, it's tic-tac-toe. But over the internet! With another
		Playdate!
	</p>

	<p>
		The technology behind pdportal is app agnostic, and should be capable of
		powering relatively complex Playdate multiplayer experiences. In theory,
		it's possible to create a fast-paced game with client-side prediction and
		"server" (another Playdate) reconciliation. See Gabriel Gambetta's excellent <Link
			href="https://www.gabrielgambetta.com/client-server-game-architecture.html"
			target="_blank">Fast-Paced Multiplayer</Link
		> series for an introduction to these topics.
	</p>

	<div>
		<p>
			© 2023 <Link href="https://paulstraw.com" target="_blank">Paul Straw</Link
			>
		</p>

		<p>
			Freely available under the <Link
				href="https://github.com/strawdynamics/pdportal/blob/main/LICENSE"
				target="_blank">MIT license</Link
			>
		</p>
	</div>
</div>
