import 'package:equatable/equatable.dart';
import 'package:state_management/enums/state.dart';

abstract class BlocState extends Equatable {
  final Status status;

  const BlocState({this.status = Status.notStarted});
  

  @override
  List<Object?> get props => [status];
}
