package tech.likemagic.exercise.property;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import java.time.DateTimeException;
import java.time.ZoneId;

public class IanaTimezoneValidator implements ConstraintValidator<IanaTimezone, String> {

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        if (value == null || value.isBlank()) {
            return true;
        }
        try {
            ZoneId.of(value);
            return true;
        } catch (DateTimeException ignored) {
            return false;
        }
    }
}
