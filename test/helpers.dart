import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

void overridePrint(testFn(List<String> log)) => () {
      final log = <String>[];
      final spec = ZoneSpecification(print: (_, __, ___, String msg) {
        log.add(msg);
      });
      return Zone.current.fork(specification: spec).run(() => testFn(log));
    };

GraphQLCache getTestCache() => GraphQLCache();

http.StreamedResponse simpleResponse({@required String body, int status}) {
  final bytes = utf8.encode(body);
  final stream = Stream<List<int>>.fromIterable(<List<int>>[bytes]);

  final r = http.StreamedResponse(stream, status ?? 200);

  return r;
}

AuthLink getMyAuthLink() {
  return AuthLink(
    getToken: () async => 'token',
  );
}
