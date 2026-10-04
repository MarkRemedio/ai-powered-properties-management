package tech.likemagic.exercise.property;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.graphql.GraphQlTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.graphql.test.tester.GraphQlTester;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@GraphQlTest(PropertyGraphqlController.class)
class PropertyGraphqlControllerGraphQlTest {

    @Autowired
    GraphQlTester graphQlTester;

    @MockBean
    PropertyService propertyService;

    @Test
    void returnsProperties() {
        Property zurich = new Property(
                UUID.fromString("11111111-1111-1111-1111-111111111111"),
                "ZRH",
                "Magic Hotel Zurich",
                "Europe/Zurich"
        );
        Property london = new Property(
                UUID.fromString("22222222-2222-2222-2222-222222222222"),
                "LON",
                "Magic Suites London",
                "Europe/London"
        );
        when(propertyService.listProperties()).thenReturn(Flux.just(london, zurich));

        graphQlTester.document("{ properties { code name timezone } }")
                .execute()
                .path("properties")
                .entityList(Object.class)
                .hasSize(2);
    }

    @Test
    void createsProperty() {
        Property created = new Property(
                UUID.fromString("44444444-4444-4444-4444-444444444444"),
                "MNL",
                "Magic Residences Manila",
                "Asia/Manila"
        );
        when(propertyService.createProperty("MNL", "Magic Residences Manila", "Asia/Manila"))
                .thenReturn(Mono.just(created));

        graphQlTester.document("""
                        mutation {
                          createProperty(input: {
                            code: "MNL",
                            name: "Magic Residences Manila",
                            timezone: "Asia/Manila"
                          }) {
                            id
                            code
                            name
                            timezone
                          }
                        }
                        """)
                .execute()
                .path("createProperty.code").entity(String.class).isEqualTo("MNL")
                .path("createProperty.name").entity(String.class).isEqualTo("Magic Residences Manila")
                .path("createProperty.timezone").entity(String.class).isEqualTo("Asia/Manila")
                .path("createProperty.id").entity(String.class).isEqualTo("44444444-4444-4444-4444-444444444444");

        verify(propertyService).createProperty("MNL", "Magic Residences Manila", "Asia/Manila");
    }

    @Test
    void rejectsBlankFields() {
        graphQlTester.document("""
                        mutation {
                          createProperty(input: {
                            code: "   ",
                            name: "",
                            timezone: "Asia/Manila"
                          }) {
                            id
                          }
                        }
                        """)
                .execute()
                .errors()
                .satisfy(errors -> {
                    assertThat(errors).isNotEmpty();
                    assertThat(errors)
                            .anySatisfy(error -> assertThat(error.getMessage()).contains("code must not be blank"));
                    assertThat(errors)
                            .anySatisfy(error -> assertThat(error.getMessage()).contains("name must not be blank"));
                });

        verifyNoInteractions(propertyService);
    }

    @Test
    void rejectsInvalidIanaTimezone() {
        graphQlTester.document("""
                        mutation {
                          createProperty(input: {
                            code: "MNL",
                            name: "Magic Residences Manila",
                            timezone: "Manila/Asia"
                          }) {
                            id
                          }
                        }
                        """)
                .execute()
                .errors()
                .satisfy(errors -> {
                    assertThat(errors).isNotEmpty();
                    assertThat(errors).anySatisfy(error ->
                            assertThat(error.getMessage()).contains("must be a valid IANA timezone string"));
                });

        verifyNoInteractions(propertyService);
    }
}
