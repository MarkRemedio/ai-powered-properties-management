package tech.likemagic.exercise.property;

import java.util.UUID;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@Table("property")
public record Property(
        @Id UUID id,
        String code,
        String name,
        String timezone
) {}
