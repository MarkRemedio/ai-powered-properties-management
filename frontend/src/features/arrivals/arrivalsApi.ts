import { gql } from "graphql-request";
import { api } from "../../api/api";
import type { Arrival } from "../../gql/generated";

const ArrivalsTodayPerPropertyDocument = gql`
  query ArrivalsTodayPerProperty($propertyId: ID!) {
    arrivalsTodayPerProperty(propertyId: $propertyId) {
      id
      guestName
      arrival
      status
      unit {
        id
        label
        floor
      }
    }
  }
`;

export const arrivalsApi = api.injectEndpoints({
  endpoints: (build) => ({
    getArrivalsTodayPerProperty: build.query<Arrival[], string>({
      query: (propertyId) => ({
        document: ArrivalsTodayPerPropertyDocument,
        variables: { propertyId },
      }),
      transformResponse: (res: { arrivalsTodayPerProperty: Arrival[] }) =>
        res.arrivalsTodayPerProperty,
      providesTags: ["Arrival"],
    }),
  }),
});

export const { useGetArrivalsTodayPerPropertyQuery } = arrivalsApi;
