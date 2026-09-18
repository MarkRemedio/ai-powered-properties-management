import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    // Proxy so the browser talks to the same origin and there is no CORS setup to do.
    proxy: {
      "/graphql": "http://localhost:8080",
    },
  },
});
