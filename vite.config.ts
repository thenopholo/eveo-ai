import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

import { viteStaticCopy } from 'vite-plugin-static-copy';

export default defineConfig({
	plugins: [
		sveltekit(),
		viteStaticCopy({
			targets: [
				{
					src: 'node_modules/onnxruntime-web/dist/*.jsep.*',

					dest: 'wasm'
				}
			]
		})
	],
	resolve: {
		alias: {
			'y-protocols/awareness': 'y-protocols/dist/awareness.cjs',
			'y-protocols/sync': 'y-protocols/dist/sync.cjs'
		}
	},
	optimizeDeps: {
		include: ['yjs'],
		exclude: ['@huggingface/transformers', 'y-protocols', 'y-prosemirror']
	},
	ssr: {
		noExternal: ['y-protocols', 'yjs', 'y-prosemirror'],
		external: ['@huggingface/transformers', 'pyodide']
	},
	define: {
		APP_VERSION: JSON.stringify(process.env.npm_package_version),
		APP_BUILD_HASH: JSON.stringify(process.env.APP_BUILD_HASH || 'dev-build')
	},
	build: {
		sourcemap: true
	},
	worker: {
		format: 'es'
	},
	esbuild: {
		pure: process.env.ENV === 'dev' ? [] : ['console.log', 'console.debug', 'console.error']
	}
});
