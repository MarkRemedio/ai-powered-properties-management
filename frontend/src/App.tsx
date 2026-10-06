import { useState } from "react";
import { Box, Container, Divider, Paper, Stack, Typography } from "@mui/material";
import { PropertyPicker } from "./features/properties/PropertyPicker";
import { ArrivalsList } from "./features/arrivals/ArrivalsList";

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
          <Box sx={{ mt: 1 }}>
            <ArrivalsList propertyId={propertyId} />
          </Box>
        </Paper>
      </Stack>
    </Container>
  );
}
