package tech.likemagic.exercise.config;

import graphql.scalars.ExtendedScalars;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.graphql.execution.RuntimeWiringConfigurer;

/**
 * Registers the DateTime scalar declared in schema.graphqls.
 *
 * Without this, graphql-java fails the schema build at startup with
 * "There is no scalar implementation for the named 'DateTime' scalar type".
 */
@Configuration
public class GraphQlConfig {

    @Bean
    RuntimeWiringConfigurer scalarConfigurer() {
        return wiring -> wiring.scalar(ExtendedScalars.DateTime);
    }
}
