import { gql } from "graphql-request";
import { api } from "../../api/api";

/**
 * WORKED EXAMPLE of an RTK Query GraphQL endpoint.
 * Copy this shape for your own query.
 */

export type Property = {
  id: string;
  code: string;
  name: string;
  timezone: string;
};

const PropertiesDocument = gql`
  query Properties {
    properties {
      id
      code
      name
      timezone
    }
  }
`;

export const propertiesApi = api.injectEndpoints({
  endpoints: (build) => ({
    getProperties: build.query<Property[], void>({
      query: () => ({ document: PropertiesDocument }),
      transformResponse: (res: { properties: Property[] }) => res.properties,
      providesTags: ["Property"],
    }),
  }),
});

export const { useGetPropertiesQuery } = propertiesApi;
