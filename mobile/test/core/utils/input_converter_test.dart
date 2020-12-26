import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  test('''should return an integer when the string represents 
      a simple unsigned integer''', () async {
    final tString = '1';

    final result = inputConverter.stringToUnsignedInteger(tString);

    expect(result, Right(1));
  });

  test('''should return an integer when the string represents 
      an unsigned integer with left zeroes''', () async {
    final tString = '0024';

    final result = inputConverter.stringToUnsignedInteger(tString);

    expect(result, Right(24));
  });

  test('''should return Failure when the string is a negative integer''',
      () async {
    final tString = '-12';

    final result = inputConverter.stringToUnsignedInteger(tString);

    expect(result, Left(InvalidInputFailure()));
  });

  test(
    '''should return a Failure when the string is 
    not an integer''',
    () async {
      final tString = 'one';

      final result = inputConverter.stringToUnsignedInteger(tString);

      expect(result, Left(InvalidInputFailure()));
    },
  );
}
