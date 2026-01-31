import 'dart:async';

typedef Defaulted<T> = FutureOr<T>;

final class Omit<T> implements Future<T> {
  const Omit();
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
