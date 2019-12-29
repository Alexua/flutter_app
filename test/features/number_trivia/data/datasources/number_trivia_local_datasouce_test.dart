
import 'dart:convert';
import 'package:flutter_app/core/error/exceptions.dart';
import 'package:flutter_app/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart' as matcher;
import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main(){
  NumberTriviaLocalDataSourceImpl datasource;
  MockSharedPreferences mockSharedPreferences;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDataSourceImpl(sharedPreferences : mockSharedPreferences);
  });
  
  group('getLastNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should return Number Trivia from SharedPreferences when there is one',
        () async{
          when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));
          final result = await datasource.getLastNumberTrivia();
          verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
          expect(result,equals(tNumberTriviaModel));
        });

    test('should throw a CacheException when there is not a cached value',
            () async {
          when(mockSharedPreferences.getString(any)).thenReturn(null);
          final call = datasource.getLastNumberTrivia;

          expect(() => call(),throwsA(matcher.TypeMatcher<CacheException>()));
        });
  });
  
  group('cacheNumberTrivia', (){
    final tNumberTrivia = NumberTriviaModel(number: 1, text: 'test trivia');
    test('sh', (){
      datasource.cacheNumberTrivia(tNumberTrivia);
      final expectedJsonString = json.encode(tNumberTrivia.toJson());
      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}