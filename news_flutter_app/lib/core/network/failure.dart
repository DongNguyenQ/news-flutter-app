import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class UnCategorizeFailure extends Failure {
  final String message;
  UnCategorizeFailure(this.message);

  @override
  List<Object?> get props => [message];
}