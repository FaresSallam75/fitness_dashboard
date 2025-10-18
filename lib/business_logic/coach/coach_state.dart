import 'package:equatable/equatable.dart';
import 'package:fitness_dashboard/data/model/coach_model.dart';

sealed class CoachState extends Equatable {
  const CoachState();
  @override
  List<Object?> get props => [];
}

final class CoachStateInitial extends CoachState {
  final bool isLoading;
  const CoachStateInitial({required this.isLoading});
  @override
  List<Object?> get props => [isLoading];
}

final class CoachStateLoading extends CoachState {
  const CoachStateLoading();
  @override
  List<Object?> get props => [];
}

final class CoachStateLoaded extends CoachState {
  final List<CoachModel> listCoachModel;
  const CoachStateLoaded({required this.listCoachModel});
  @override
  List<Object?> get props => [];
}

final class CoachStateFailure extends CoachState {
  final String message;
  @override
  List<Object?> get props => [message];
  const CoachStateFailure(this.message);
}
