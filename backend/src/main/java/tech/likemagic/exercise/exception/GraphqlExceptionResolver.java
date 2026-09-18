package tech.likemagic.exercise.exception;

import graphql.GraphQLError;
import graphql.GraphqlErrorBuilder;
import graphql.schema.DataFetchingEnvironment;
import java.util.List;
import org.springframework.graphql.execution.DataFetcherExceptionResolver;
import org.springframework.graphql.execution.ErrorType;
import org.springframework.stereotype.Component;
import org.springframework.validation.BindException;
import reactor.core.publisher.Mono;

@Component
public class GraphqlExceptionResolver implements DataFetcherExceptionResolver {

  @Override
  public Mono<List<GraphQLError>> resolveException(Throwable ex, DataFetchingEnvironment env) {
    if (ex instanceof BindException) {
      return Mono.just(List.of(
          GraphqlErrorBuilder.newError(env)
              .errorType(ErrorType.BAD_REQUEST)
              .message("propertyId must be a valid UUID")
              .build()));
    }

    if (ex instanceof PropertyNotFoundException) {
      return Mono.just(List.of(
          GraphqlErrorBuilder.newError(env)
              .errorType(ErrorType.NOT_FOUND)
              .message(ex.getMessage())
              .build()));
    }
    if (ex instanceof InvalidPropertyIdException) {
      return Mono.just(List.of(
          GraphqlErrorBuilder.newError(env)
              .errorType(ErrorType.BAD_REQUEST)
              .message(ex.getMessage())
              .build()));
    }

    // Generic safety net for unclassified type/coercion problems
    if (ex instanceof IllegalArgumentException || ex instanceof ClassCastException) {
      return Mono.just(List.of(
          GraphqlErrorBuilder.newError(env)
              .errorType(ErrorType.BAD_REQUEST)
              .message("Invalid input: " + ex.getMessage())
              .build()));
    }
    return Mono.empty(); // fall through to Spring's default handler for anything else
  }
}
