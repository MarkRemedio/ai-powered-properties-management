package tech.likemagic.exercise.property;

import java.util.UUID;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;

public interface PropertyRepository extends ReactiveCrudRepository<Property, UUID> {

    Flux<Property> findAllByOrderByNameAsc();
}
