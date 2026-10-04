package tech.likemagic.exercise.property;

import jakarta.validation.constraints.NotBlank;

public record PropertyCreateInput(
        @NotBlank(message = "code must not be blank") String code,
        @NotBlank(message = "name must not be blank") String name,
        @NotBlank(message = "timezone must not be blank")
        @IanaTimezone String timezone
) {}
