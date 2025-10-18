import 'package:equatable/equatable.dart';
import 'package:fitness_dashboard/data/model/user_model.dart';

sealed class UsersState extends Equatable {
  const UsersState();
  @override
  List<Object?> get props => [];
}

final class UsersStateInitial extends UsersState {
  final bool isRefresh;
  const UsersStateInitial({required this.isRefresh});
  @override
  List<Object?> get props => [isRefresh];
}

final class UsersStateLoading extends UsersState {
  const UsersStateLoading();
  @override
  List<Object?> get props => [];
}

final class UsersStateLoaded extends UsersState {
  final List<UserModel> listUserModel;
  final List<UserModel> listSearchUser;
  const UsersStateLoaded({
    required this.listUserModel,
    required this.listSearchUser,
  });
  @override
  List<Object?> get props => [listUserModel, listSearchUser];
}

final class UsersStateFailure extends UsersState {
  final String message;
  @override
  List<Object?> get props => [message];
  const UsersStateFailure(this.message);
}
