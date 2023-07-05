import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_app/exception/exception_logger.dart';

abstract class CharacterDetailDataSource {
  Future<QueryResult> fetchCharacterDetail(String id);
}

class GraphQLCharacterDetailDataSource extends CharacterDetailDataSource
    with ExceptionLogger {
  final GraphQLClient graphQLClient;

  GraphQLCharacterDetailDataSource({
    graphQLClient,
  }) : this.graphQLClient = graphQLClient ?? Get.find();

  static String characterQuery() {
    return r'''
        query characterDetail($id: ID!) {
      character(id: $id) {
        id
    		name
    		status
    		species
    		type
    		gender
    		image
    		episode {
          id
          name
          air_date
          episode
        }
      }
    }
    ''';
  }

  @override
  Future<QueryResult> fetchCharacterDetail(String id) async {
    try {
      Map<String, dynamic> _variables = <String, dynamic>{
        'id': id,
      };
      QueryResult _result = await graphQLClient.query(
        QueryOptions(
          document: gql(characterQuery()),
          variables: _variables,
        ),
      );
      print(_result.exception);
      return _result;
    } catch (_exception) {
      throw exception(
        ExceptionType.graphql,
        _exception.toString(),
      );
    }
  }
}
