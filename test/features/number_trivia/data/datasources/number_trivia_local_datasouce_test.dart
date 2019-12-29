
import 'package:flutter_app/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main(){
  NumberTriviaLocalDataSourceImpl datasource;
  MockSharedPreferences mockSharedPreferences;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDataSourceImpl(sharedPreferences : mockSharedPreferences);
  });
}