import typography from '@tailwindcss/typography';
import containerQueries from '@tailwindcss/container-queries';

/** @type {import('tailwindcss').Config} */
export default {
	darkMode: 'class',
	content: ['./src/**/*.{html,js,svelte,ts}'],
	theme: {
		extend: {
			fontFamily: {
				sans: ['Hanken Grotesk', 'system-ui', '-apple-system', 'sans-serif'],
				primary: ['Hanken Grotesk', 'system-ui', '-apple-system', 'sans-serif']
			},
			colors: {
				gray: {
					50: 'var(--color-gray-50, #f9f9f9)',
					100: 'var(--color-gray-100, #ececec)',
					200: 'var(--color-gray-200, #e3e3e3)',
					300: 'var(--color-gray-300, #cdcdcd)',
					400: 'var(--color-gray-400, #b4b4b4)',
					500: 'var(--color-gray-500, #9b9b9b)',
					600: 'var(--color-gray-600, #676767)',
					700: 'var(--color-gray-700, #4e4e4e)',
					800: 'var(--color-gray-800, #333)',
					850: 'var(--color-gray-850, #262626)',
					900: 'var(--color-gray-900, #171717)',
					950: 'var(--color-gray-950, #0d0d0d)'
				},
				eveo: {
					primary: '#ff0000',
					secondary: '#e2001b'
				}
			},
			typography: {
				DEFAULT: {
					css: {
						pre: false,
						code: false,
						'pre code': false,
						'code::before': false,
						'code::after': false
					}
				}
			},
			padding: {
				'safe-bottom': 'env(safe-area-inset-bottom)'
			},
			transitionProperty: {
				width: 'width'
			},
			keyframes: {
				'hud-glow': {
					'0%, 100%': {
						boxShadow: '0 0 20px #ff0000, 0 0 40px #ff0000, inset 0 0 20px rgba(255, 0, 0, 0.1)',
						borderColor: '#ff0000'
					},
					'50%': {
						boxShadow: '0 0 30px #e2001b, 0 0 60px #e2001b, inset 0 0 30px rgba(226, 0, 27, 0.2)',
						borderColor: '#e2001b'
					}
				},
				'border-flow': {
					'0%': { strokeDashoffset: '0' },
					'100%': { strokeDashoffset: '1000' }
				}
			},
			animation: {
				'hud-glow': 'hud-glow 3s ease-in-out infinite',
				'border-flow': 'border-flow 20s linear infinite'
			}
		}
	},
	plugins: [typography, containerQueries]
};
