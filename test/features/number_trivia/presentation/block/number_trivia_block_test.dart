import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/error/failures.dart';
import 'package:flutter_app/core/util/input_converter.dart';
import 'package:flutter_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_app/features/number_trivia/presentation/block/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial State should be empty',()
  {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', (){
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('verify call the InputConverter',() async {
      //-- arrange
      when(mockInputConverter.stringTounsignedInterger(any))
          .thenReturn(Right(tNumberParsed));
      //-- act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringTounsignedInterger(any));
      //-- assert
      verify(mockInputConverter.stringTounsignedInterger(tNumberString));
    });

    test('verify emit [Error] when the input is invalid',() async {
      //-- arrange
      when(mockInputConverter.stringTounsignedInterger(any))
          .thenReturn(Left(InvalidInputFailure()));
      //-- assert later
      expectLater(bloc.state, emitsInOrder([Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)]));

      //-- act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));

    });

    test('should get data from the concrete use case',() async {
      //-- arrange
      when(mockInputConverter.stringTounsignedInterger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));

      //-- act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //--asserts
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',() async {
      //-- arrange
      when(mockInputConverter.stringTounsignedInterger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      //-- expect later
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.state, emitsInOrder(expected));

      //-- act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when data is gotten successfully',() async {
      //-- arrange
      when(mockInputConverter.stringTounsignedInterger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //-- expect later
      final expected = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));

      //-- act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] with a proper message for error',() async {
      //-- arrange
      when(mockInputConverter.stringTounsignedInterger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      //-- expect later
      final expected = [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));

      //-- act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

  });


}
