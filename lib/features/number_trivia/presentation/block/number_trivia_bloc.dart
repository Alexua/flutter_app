import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/core/error/failures.dart';
import 'package:flutter_app/core/usecases/usecase.dart';
import 'package:flutter_app/core/util/input_converter.dart';
import 'package:flutter_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import './bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required this.getConcreteNumberTrivia, @required this.getRandomNumberTrivia, @required this.inputConverter});

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetNumberTriviaForConcreteNumber) {
      final inputEither = inputConverter.stringTounsignedInterger(event.numberString);
      yield* inputEither.fold((failure) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (integer) async* {
        yield Loading();
        final failureOrTrivia = await getConcreteNumberTrivia(Params(integer));
        yield failureOrTrivia.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)),
            (trivia) => Loaded(trivia: trivia));
      });
    } else if(event is GetNumberTriviaForRandomNumber){
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield failureOrTrivia.fold(
              (failure) => Error(message: _mapFailureToMessage(failure)),
              (trivia) => Loaded(trivia: trivia));
    }
  }

  String _mapFailureToMessage(Failure failure){
    switch(failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
