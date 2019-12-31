import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/error/failures.dart';

class InputConverter{
  Either<Failure, int> stringTounsignedInterger(String str){
    try{
      final integer = int.parse(str);
      if(integer < 0)
        throw FormatException();
    } on FormatException{
      return Left(InvalidInputFailure());
    }
    return Right(int.parse(str));
  }
}

class InvalidInputFailure extends Failure{}