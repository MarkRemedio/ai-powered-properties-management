/**
 * Formats the wall-clock time embedded in a Java `OffsetDateTime` string (e.g.
 * "2026-09-22T14:30:00+02:00") without converting it to the browser's local
 * timezone, since the backend's offset already represents the correct local time.
 */
export function formatOffsetTime(offsetDateTime: string): string {
  const match = offsetDateTime.match(/^(\d{4}-\d{2}-\d{2})T(\d{2}:\d{2}:\d{2})/);
  if (!match) return new Date(offsetDateTime).toLocaleTimeString();

  const [, datePart, timePart] = match;
  return new Date(`${datePart}T${timePart}Z`).toLocaleTimeString([], { timeZone: "UTC" });
}
