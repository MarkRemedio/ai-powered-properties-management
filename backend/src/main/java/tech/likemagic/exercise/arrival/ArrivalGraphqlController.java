package tech.likemagic.exercise.arrival;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import tech.likemagic.exercise.exception.InvalidPropertyIdException;
import tech.likemagic.exercise.exception.PropertyNotFoundException;
import tech.likemagic.exercise.property.PropertyRepository;
import tech.likemagic.exercise.reservation.Reservation;
import tech.likemagic.exercise.reservation.ReservationRepository;
import tech.likemagic.exercise.unit.Unit;
import tech.likemagic.exercise.unit.UnitRepository;

@Controller
public class ArrivalGraphqlController {
  private final PropertyRepository properties;
  private final ReservationRepository reservations;
  private final UnitRepository units;

  public ArrivalGraphqlController(PropertyRepository properties,
      ReservationRepository reservations,
      UnitRepository units) {
    this.properties = properties;
    this.reservations = reservations;
    this.units = units;
  }

  @QueryMapping(name="arrivalsTodayPerProperty")
  public Flux<Arrival> arrivalsToday(@Argument UUID propertyId) {
    if (propertyId == null) {
      return Flux.error(new InvalidPropertyIdException("propertyId must not be empty"));
    }

    return properties.findById(propertyId)
        .switchIfEmpty(Mono.error(new PropertyNotFoundException(propertyId)))
        .flatMapMany(property -> {
          ZoneId zone = ZoneId.of(property.timezone());
          ZonedDateTime startOfDay = LocalDate.now(zone).atStartOfDay(zone);
          OffsetDateTime from = startOfDay.toOffsetDateTime();
          OffsetDateTime until = startOfDay.plusDays(1).toOffsetDateTime();

          Mono<List<Reservation>> arrivalsMono =
              reservations.findArrivals(propertyId, from, until).collectList();
          Mono<Map<UUID, Unit>> unitsByIdMono =
              units.findAllByPropertyId(propertyId)
                  .collectMap(Unit::id, Function.identity());

          return Mono.zip(arrivalsMono, unitsByIdMono)
              .flatMapMany(tuple -> Flux.fromIterable(tuple.getT1())
                  .map(r -> new Arrival(
                      r.id(),
                      r.guestName(),
                      r.arrival(),
                      r.unitId() == null ? null : tuple.getT2().get(r.unitId()),
                      ReservationStatus.valueOf(r.status())
                  )));
        });
  }
}
