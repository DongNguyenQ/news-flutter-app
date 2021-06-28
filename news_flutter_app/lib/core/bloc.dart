import 'package:equatable/equatable.dart';

abstract class Event extends Equatable {
  @override
  List<Object?> get props => [];
}

abstract class BlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

enum StateStatus { haveData, notFound, error, loading, init }
