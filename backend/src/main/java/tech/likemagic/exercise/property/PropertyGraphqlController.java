package tech.likemagic.exercise.property;

import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import reactor.core.publisher.Flux;

/**
 * WORKED EXAMPLE.
 *
 * This is the complete pattern for a reactive GraphQL query:
 *   schema.graphqls -> this controller -> ReactiveCrudRepository -> Flux
 *
 * Note that nothing here blocks. The Flux is handed to Spring GraphQL, which
 * subscribes to it. Copy this shape for your own query.
 */
@Controller
public class PropertyGraphqlController {

    private final PropertyRepository properties;

    public PropertyGraphqlController(PropertyRepository properties) {
        this.properties = properties;
    }

    @QueryMapping
    public Flux<Property> properties() {
        return properties.findAllByOrderByNameAsc();
    }
}
