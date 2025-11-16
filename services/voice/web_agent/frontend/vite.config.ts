import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5176,
    host: true, // Allow external connections
  },
  // Build configuration - base path for assets when served from backend
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
  },
})