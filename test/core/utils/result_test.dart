import 'package:flutter_test/flutter_test.dart';
import 'package:enya_gitarre_learn/core/utils/result.dart';

void main() {
  group('Success', () {
    test('isSuccess is true', () {
      const result = Success(42);
      expect(result.isSuccess, isTrue);
    });

    test('isFailure is false', () {
      const result = Success(42);
      expect(result.isFailure, isFalse);
    });

    test('dataOrNull returns the data value', () {
      const result = Success(42);
      expect(result.dataOrNull, equals(42));
    });

    test('errorMessage is null', () {
      const result = Success(42);
      expect(result.errorMessage, isNull);
    });

    test('works with string data', () {
      const result = Success('hello');
      expect(result.dataOrNull, equals('hello'));
    });

    test('works with null as data', () {
      const result = Success<String?>(null);
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, isNull);
    });
  });

  group('Failure', () {
    test('isFailure is true', () {
      const result = Failure<int>('error');
      expect(result.isFailure, isTrue);
    });

    test('isSuccess is false', () {
      const result = Failure<int>('error');
      expect(result.isSuccess, isFalse);
    });

    test('dataOrNull is null', () {
      const result = Failure<int>('error');
      expect(result.dataOrNull, isNull);
    });

    test('errorMessage returns the message', () {
      const result = Failure<int>('something went wrong');
      expect(result.errorMessage, equals('something went wrong'));
    });

    test('can include an error object', () {
      final exception = Exception('boom');
      final result = Failure<int>('error', error: exception);
      expect(result.error, equals(exception));
    });

    test('error is null when not provided', () {
      const result = Failure<int>('error');
      expect(result.error, isNull);
    });
  });

  group('Result.map', () {
    test('transforms success value', () {
      const result = Success(5);
      final mapped = result.map((v) => v * 2);
      expect(mapped.dataOrNull, equals(10));
    });

    test('map on failure passes through error message', () {
      const result = Failure<int>('oops');
      final mapped = result.map((v) => v * 2);
      expect(mapped.isFailure, isTrue);
      expect(mapped.errorMessage, equals('oops'));
    });

    test('map changes the type of the result', () {
      const result = Success(42);
      final mapped = result.map((v) => v.toString());
      expect(mapped.dataOrNull, equals('42'));
    });
  });

  group('Result.flatMap', () {
    test('chains success results', () {
      const result = Success(5);
      final chained = result.flatMap((v) => Success(v.toString()));
      expect(chained.dataOrNull, equals('5'));
    });

    test('propagates failure without calling transform', () {
      const result = Failure<int>('original error');
      var called = false;
      final chained = result.flatMap((v) {
        called = true;
        return Success(v * 2);
      });
      expect(called, isFalse);
      expect(chained.isFailure, isTrue);
      expect(chained.errorMessage, equals('original error'));
    });

    test('flatMap can return a failure from a success', () {
      const result = Success(5);
      final chained = result.flatMap<int>((_) => const Failure('computed error'));
      expect(chained.isFailure, isTrue);
      expect(chained.errorMessage, equals('computed error'));
    });
  });

  group('Result.getOrElse', () {
    test('returns data on success', () {
      const result = Success(42);
      expect(result.getOrElse(() => 0), equals(42));
    });

    test('returns fallback on failure', () {
      const result = Failure<int>('err');
      expect(result.getOrElse(() => 99), equals(99));
    });

    test('fallback is not called on success', () {
      var fallbackCalled = false;
      const result = Success(1);
      result.getOrElse(() {
        fallbackCalled = true;
        return 0;
      });
      expect(fallbackCalled, isFalse);
    });
  });

  group('Result.onSuccess', () {
    test('calls action with data on success', () {
      int? received;
      Success(7).onSuccess((v) => received = v);
      expect(received, equals(7));
    });

    test('does not call action on failure', () {
      var called = false;
      const Failure<int>('err').onSuccess((_) => called = true);
      expect(called, isFalse);
    });

    test('returns the same result for chaining', () {
      const result = Success(3);
      final returned = result.onSuccess((_) {});
      expect(returned.dataOrNull, equals(3));
    });
  });

  group('Result.onFailure', () {
    test('calls action with message on failure', () {
      String? receivedMessage;
      const Failure<int>('bad thing').onFailure((msg, _) => receivedMessage = msg);
      expect(receivedMessage, equals('bad thing'));
    });

    test('does not call action on success', () {
      var called = false;
      const Success(1).onFailure((_, __) => called = true);
      expect(called, isFalse);
    });

    test('returns the same result for chaining', () {
      const result = Failure<int>('err');
      final returned = result.onFailure((_, __) {});
      expect(returned.isFailure, isTrue);
    });
  });
}
