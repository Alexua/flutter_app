import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/core/usecases/usecase.dart';
import 'package:flutter_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_app/core/error/failures.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams>{
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params)
  async
  {
    return await repository.getRandomNumberTrivia();
  }

}