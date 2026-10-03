import {
  Alert,
  List,
  ListItem,
  ListItemText,
  Skeleton,
  Stack,
  Typography,
} from "@mui/material";
import { useGetArrivalsTodayPerPropertyQuery } from "./arrivalsApi";
import { formatOffsetTime } from "../../utils/formatOffsetTime";

export function ArrivalsList({ propertyId }: { propertyId: string }) {
  const { data, isLoading, error } = useGetArrivalsTodayPerPropertyQuery(propertyId, {
    skip: !propertyId,
  });

  if (!propertyId) {
    return (
      <Typography variant="body2" color="text.secondary">
        Select a property to see today&apos;s arrivals.
      </Typography>
    );
  }

  if (isLoading) return <Skeleton variant="rounded" height={120} />;
  if (error) return <Alert severity="error">Could not load arrivals.</Alert>;

  if (!data || data.length === 0) {
    return (
      <Typography variant="body2" color="text.secondary">
        No arrivals today.
      </Typography>
    );
  }

  return (
    <List dense disablePadding>
      {data.map((arrival) => (
        <ListItem key={arrival.id} disableGutters>
          <ListItemText
            primary={arrival.guestName}
            secondary={
              <Stack direction="row" spacing={1} component="span">
                <span>{formatOffsetTime(arrival.arrival)}</span>
                <span>&bull;</span>
                <span>{arrival.unit?.label ?? "No unit assigned"}</span>
              </Stack>
            }
          />
        </ListItem>
      ))}
    </List>
  );
}
