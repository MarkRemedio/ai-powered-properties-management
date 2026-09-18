package tech.likemagic.exercise.unit;

import java.util.UUID;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("unit")
public record Unit(
        @Id UUID id,
        @Column("property_id") UUID propertyId,
        String label,
        Integer floor
) {}
