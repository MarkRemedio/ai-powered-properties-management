import React from "react";
import ReactDOM from "react-dom/client";
import { Provider } from "react-redux";
import { CssBaseline, ThemeProvider, createTheme } from "@mui/material";
import { store } from "./api/store";
import App from "./App";

const theme = createTheme({
  palette: {
    primary: { main: "#0000dc" },   // LIKE MAGIC blue
    secondary: { main: "#914bd7" }, // LIKE MAGIC violet
  },
});

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <Provider store={store}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <App />
      </ThemeProvider>
    </Provider>
  </React.StrictMode>
);
