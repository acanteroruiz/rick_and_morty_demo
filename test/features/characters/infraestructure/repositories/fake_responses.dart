import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_app/features/characters/infraestructure/data_sources/characters_data_source.dart';

final errors = [GraphQLError(message: 'error')];

final tResponseWithErrors = QueryResult(
  options: QueryOptions(
    document: gql(GraphQLCharactersDataSource.charactersQuery()),
  ),
  exception: OperationException(graphqlErrors: errors),
  source: QueryResultSource.network,
);

final charactersDataResponse = <String, dynamic>{
  'characters': {
    "info": {"count": 100, "pages": 10, "next": 2, "prev": null},
    "results": [
      {
        "id": "id",
        "name": "name",
        "status": "status",
        "species": "species",
        "type": "type",
        "gender": "gender",
        "image": "image"
      }
    ]
  }
};

final tCharactersResponse = QueryResult(
  options: QueryOptions(
    document: gql(GraphQLCharactersDataSource.charactersQuery()),
  ),
  data: charactersDataResponse,
  source: QueryResultSource.network,
);
