package tech.likemagic.exercise.arrival;

import java.time.OffsetDateTime;
import java.util.UUID;
import tech.likemagic.exercise.unit.Unit;

public record Arrival(
    UUID id,
    String guestName,
    OffsetDateTime arrival,
    Unit unit,               // nullable — reservation.unit_id can be null
    ReservationStatus status
) {
}
