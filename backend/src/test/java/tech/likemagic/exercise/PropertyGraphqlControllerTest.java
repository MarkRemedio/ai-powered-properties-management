package tech.likemagic.exercise;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.graphql.test.tester.HttpGraphQlTester;

/**
 * WORKED EXAMPLE of a GraphQL test.
 *
 * Disabled by default because it needs the database running
 * (docker compose up -d). Remove @Disabled to run it, and feel free to
 * copy this shape for your own query if you have time for a test.
 */
@Disabled("requires a running database: docker compose up -d")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class PropertyGraphqlControllerTest {

    @Autowired
    HttpGraphQlTester graphQlTester;

    @Test
    void returnsSeededProperties() {
        graphQlTester.document("{ properties { code name timezone } }")
                .execute()
                .path("properties")
                .entityList(Object.class)
                .hasSizeGreaterThan(2);
    }
}
