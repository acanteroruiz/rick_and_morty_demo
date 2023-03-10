import 'package:graphql_flutter/graphql_flutter.dart';

class MyGraphQlClient {
  final cache = GraphQLCache();

  GraphQLClient get client {
    Link link = HttpLink('https://rickandmortyapi.com/graphql/');

    return GraphQLClient(
      cache: cache,
      link: link,
    );
  }
}

String uuidFromObject(Object object) {
  if (object is Map<String, Object>) {
    final String typeName = object['__typename'] as String;
    final String id = object['id'].toString();
    if (typeName != null && id != null) {
      return <String>[typeName, id].join('/');
    }
  }
  return null;
}
