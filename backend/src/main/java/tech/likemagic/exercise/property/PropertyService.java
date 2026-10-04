package tech.likemagic.exercise.property;

import java.util.UUID;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Service
public class PropertyService {

    private final PropertyRepository properties;

    public PropertyService(PropertyRepository properties) {
        this.properties = properties;
    }

    public Flux<Property> listProperties() {
        return properties.findAllByOrderByNameAsc();
    }

    public Mono<Property> createProperty(String code, String name, String timezone) {
        Property property = new Property(UUID.randomUUID(), code, name, timezone);
        return properties.save(property);
    }
}
