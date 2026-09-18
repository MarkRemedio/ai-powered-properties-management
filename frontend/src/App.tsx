import { useState } from "react";
import { Box, Container, Divider, Paper, Stack, Typography } from "@mui/material";
import { PropertyPicker } from "./features/properties/PropertyPicker";

export default function App() {
  const [propertyId, setPropertyId] = useState("");

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Stack spacing={3}>
        <Box>
          <Typography variant="h4" fontWeight={700}>
            Backoffice
          </Typography>
          <Typography variant="body2" color="text.secondary">
            LIKE MAGIC full stack exercise
          </Typography>
        </Box>

        <Paper variant="outlined" sx={{ p: 2 }}>
          <Typography variant="overline" color="text.secondary">
            Worked example
          </Typography>
          <Box sx={{ mt: 1 }}>
            <PropertyPicker value={propertyId} onChange={setPropertyId} />
          </Box>
        </Paper>

        <Divider />

        <Paper variant="outlined" sx={{ p: 2 }}>
          <Typography variant="overline" color="text.secondary">
            Your task
          </Typography>
          <Typography variant="body2" sx={{ mt: 1 }}>
            Render today&apos;s arrivals for the selected property here: guest name,
            arrival time and the label of the assigned unit. Handle loading and
            error states however you think is reasonable.
          </Typography>
        </Paper>
      </Stack>
    </Container>
  );
}
