import { FormControl, InputLabel, MenuItem, Select, Alert, Skeleton } from "@mui/material";
import { useGetPropertiesQuery } from "./propertiesApi";

/**
 * WORKED EXAMPLE: fetches from GraphQL via RTK Query and renders with MUI,
 * including the loading and error states.
 *
 * This is your reference for the frontend half of the exercise.
 */
export function PropertyPicker({
  value,
  onChange,
}: {
  value: string;
  onChange: (propertyId: string) => void;
}) {
  const { data, isLoading, error } = useGetPropertiesQuery();

  if (isLoading) return <Skeleton variant="rounded" height={56} />;
  if (error) return <Alert severity="error">Could not load properties.</Alert>;

  return (
    <FormControl fullWidth size="small">
      <InputLabel id="property-label">Property</InputLabel>
      <Select
        labelId="property-label"
        label="Property"
        value={value}
        onChange={(e) => onChange(e.target.value)}
      >
        {(data ?? []).map((p) => (
          <MenuItem key={p.id} value={p.id}>
            {p.name} ({p.timezone})
          </MenuItem>
        ))}
      </Select>
    </FormControl>
  );
}
