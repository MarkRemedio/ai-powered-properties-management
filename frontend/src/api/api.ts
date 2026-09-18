import { createApi } from "@reduxjs/toolkit/query/react";
import { graphqlRequestBaseQuery } from "@rtk-query/graphql-request-base-query";

/**
 * RTK Query over GraphQL. Vite proxies /graphql to the backend on :8080,
 * so there is no CORS configuration to worry about.
 */
export const api = createApi({
  reducerPath: "api",
  baseQuery: graphqlRequestBaseQuery({ url: "/graphql" }),
  tagTypes: ["Property", "Arrival"],
  endpoints: () => ({}),
});
