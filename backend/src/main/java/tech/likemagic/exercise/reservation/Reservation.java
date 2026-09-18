package tech.likemagic.exercise.reservation;

import java.time.OffsetDateTime;
import java.util.UUID;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("reservation")
public record Reservation(
        @Id UUID id,
        @Column("property_id") UUID propertyId,
        @Column("guest_name") String guestName,
        OffsetDateTime arrival,
        OffsetDateTime departure,
        @Column("unit_id") UUID unitId,     // nullable: not every reservation has a unit yet
        String status                        // CONFIRMED | IN_HOUSE | CHECKED_OUT | CANCELLED | NO_SHOW
) {}
