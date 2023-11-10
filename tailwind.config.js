/** @type {import('tailwindcss').Config} */
export default {
	content: ['./src/**/*.{html,js,svelte,ts}'],
	theme: {
		fontFamily: {
			sans: ['Inconsolata', 'monospace', 'sans-serif'],
			display: ['Red Hat Display', 'sans-serif']
		},
		extend: {
			colors: {
				pd: {
					yellow: '#ffc500'
				}
			}
		}
	},
	plugins: []
}
