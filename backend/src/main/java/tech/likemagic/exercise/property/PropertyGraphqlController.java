package tech.likemagic.exercise.property;

import jakarta.validation.Valid;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * WORKED EXAMPLE.
 *
 * This is the complete pattern for a reactive GraphQL query:
 *   schema.graphqls -> this controller -> service -> repository -> Flux
 *
 * Note that nothing here blocks. The Flux is handed to Spring GraphQL, which
 * subscribes to it. Copy this shape for your own query.
 */
@Controller
public class PropertyGraphqlController {

    private final PropertyService properties;

    public PropertyGraphqlController(PropertyService properties) {
        this.properties = properties;
    }

    @QueryMapping
    public Flux<Property> properties() {
        return properties.listProperties();
    }

    @MutationMapping
    public Mono<Property> createProperty(@Argument @Valid PropertyCreateInput input) {
        return properties.createProperty(
                input.code(),
                input.name(),
                input.timezone()
        );
    }
}
