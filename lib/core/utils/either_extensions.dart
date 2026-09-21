import 'package:dartz/dartz.dart';

extension EitherX<L, R> on Either<L, R> {
  R? get asRight => fold((_) => null, (r) => r);
  L? get asLeft => fold((l) => l, (_) => null);
  bool get isSuccessful => isRight();
  bool get hasFailed => isLeft();
}
