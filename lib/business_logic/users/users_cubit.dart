import 'dart:developer';

import 'package:fitness_dashboard/business_logic/users/users_state.dart';
import 'package:fitness_dashboard/data/model/user_model.dart';
import 'package:fitness_dashboard/data/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersCubit extends Cubit<UsersState> {
  final UserRepository userRepository;
  UsersCubit(this.userRepository) : super(UsersStateInitial(isRefresh: false));

  List<UserModel> listUserModel = [];
  List<UserModel> listSearchUser = [];
  int? countUsers;

  void changeStatusLoading() {
    final currentState = state;
    if (currentState is UsersStateInitial) {
      final current = currentState.isRefresh;
      emit(UsersStateInitial(isRefresh: !current));
    }
    setLoading(true);
  }

  void setLoading(bool value) {
    emit(UsersStateInitial(isRefresh: value));
  }

  void getAllUsers() async {
    emit(UsersStateLoading());
    final result = await userRepository.getUserData();
    result.fold(
      (failure) {
        emit(UsersStateFailure(failure.message));
      },
      (userData) async {
        listUserModel = userData
            .map<UserModel>((data) => UserModel.fromJson(data))
            .toList();
        emit(
          UsersStateLoaded(listUserModel: listUserModel, listSearchUser: []),
        );
        setLoading(true);
      },
    );
  }

  void getCountUsers() async {
    emit(UsersStateLoading());
    final result = await userRepository.getCountUsers();
    result.fold(
      (failure) {
        emit(UsersStateFailure(failure.message));
      },
      (userData) {
        countUsers = userData[0]['countUsers'];
        setLoading(true);
        log("countUsers =============================== $countUsers");
      },
    );
  }

  void showSearchUsers(String search) async {
    emit(UsersStateLoading());
    final result = await userRepository.searchUserData(search);
    result.fold(
      (failure) {
        listSearchUser = [];
        emit(UsersStateFailure(failure.message));
      },
      (userData) async {
        listSearchUser = userData
            .map<UserModel>((data) => UserModel.fromJson(data))
            .toList();
        emit(
          UsersStateLoaded(listUserModel: [], listSearchUser: listSearchUser),
        );

        log("listSearchUser =================== $listSearchUser");
      },
    );
  }
}
