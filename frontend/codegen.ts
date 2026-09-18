import type { CodegenConfig } from "@graphql-codegen/cli";

/**
 * Generates TypeScript types from the running backend's GraphQL schema.
 * Start the backend first, then: npm run codegen
 *
 * End-to-end type safety is a house rule here: do not hand-write types that
 * the schema can generate for you.
 */
const config: CodegenConfig = {
  schema: "http://localhost:8080/graphql",
  documents: ["src/**/*.{ts,tsx}"],
  generates: {
    "src/gql/generated.ts": {
      plugins: ["typescript", "typescript-operations"],
      config: {
        scalars: { DateTime: "string" },
      },
    },
  },
};

export default config;
