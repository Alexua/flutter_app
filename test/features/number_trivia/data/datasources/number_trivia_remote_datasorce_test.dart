import 'dart:convert';

import 'package:flutter_app/core/error/exceptions.dart';
import 'package:flutter_app/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart' as matcher;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(){
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404(){
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Error', 404));
  }
  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a Get request on a URL with 
  number being the endpoint and with application/json header''', () async {
      setUpMockHttpClientSuccess200();
      //-- Act
      dataSource.getConcreteNumberTrivia(tNumber);
      //-- Assert
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber', headers:{'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200', () async {
      setUpMockHttpClientSuccess200();
      //-- Act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      //-- Assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the responce code is 404 r other', () async {
      setUpMockHttpClientFailure404();
      //-- Act
      final call = dataSource.getConcreteNumberTrivia;
      //-- Assert
      expect(() => call(tNumber), throwsA(matcher.TypeMatcher<ServerException>()));
    });


  });
}
