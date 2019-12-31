import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const<dynamic>[]]) : super(props);
//  const NumberTriviaEvent();
}

class GetNumberTriviaForConcreteNumber extends NumberTriviaEvent{
  final String numberString;

  GetNumberTriviaForConcreteNumber(this.numberString): super([numberString]);
}
class GetNumberTriviaForRandomNumber extends NumberTriviaEvent{

}

