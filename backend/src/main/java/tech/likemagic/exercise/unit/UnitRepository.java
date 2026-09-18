package tech.likemagic.exercise.unit;

import java.util.Collection;
import java.util.UUID;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;

public interface UnitRepository extends ReactiveCrudRepository<Unit, UUID> {

    Flux<Unit> findAllByPropertyId(UUID propertyId);

    /**
     * Provided because you may or may not find it useful. Think about when you
     * would reach for this rather than looking units up one at a time.
     */
    Flux<Unit> findAllByIdIn(Collection<UUID> ids);
}
