import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/features/character_detail/infraestructure/data_sources/character_detail_datasource.dart';

import '../../../../helpers.dart';
import 'fake_data.dart';

class MockHttpClient extends Mock implements http.Client {}

class RequestFake extends Fake implements http.Request {}

const link = 'https://test.com/graphql';

void main() {
  HttpLink httpLink;
  Link link;
  GraphQLClient graphQLClientClient;
  MockHttpClient mockHttpClient;
  CharacterDetailDataSource dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();

    httpLink = HttpLink('https://test.com/graphql', httpClient: mockHttpClient);

    link = getMyAuthLink().concat(httpLink);

    graphQLClientClient = GraphQLClient(
      cache: getTestCache(),
      link: link,
    );

    dataSource =
        GraphQLCharacterDetailDataSource(graphQLClient: graphQLClientClient);
  });

  setUpAll(() {
    registerFallbackValue(RequestFake());
  });

  group('character detail', () {
    test(
      'fetchCharacterDetail should return a valid characterDetailData...',
      () async {
        when(() => mockHttpClient.send(any())).thenAnswer(
          (_) async => simpleResponse(
            body: characterDetailResponse,
          ),
        );
        final id = "1";
        final options = QueryOptions(
          document: gql(GraphQLCharacterDetailDataSource.characterQuery()),
          variables: <String, dynamic>{
            'id': id,
          },
        );
        final actual = await dataSource.fetchCharacterDetail(id);
        final expected = QueryResult(
          options: options,
          data: json.decode(characterDetailData),
          source: QueryResultSource.network,
        );
        expect(actual.data, expected.data);
        //verify(dataSource.fetchCharacterDetail("1")).called(1);
      },
    );

    // test(
    //   'fetchCharacters should throw graphql exception if graphql client call throw some exception',
    //   () async {
    //     when(mockHttpClient.send(any)).thenThrow((exception) async => GraphQLException(exception.toString()));
    //     final _call = dataSource.fetchCharacters;
    //     expect(_call(), throwsA(isA<GraphQLException>()));
    //     verify(dataSource.fetchCharacters()).called(1);
    //   },
    // );
  });
}
