import 'dart:convert';
import 'package:fitness_dashboard/business_logic/auth/login_state.dart';
import 'package:fitness_dashboard/core/app/user_app.dart';
import 'package:fitness_dashboard/core/services/get_it_services.dart';
import 'package:fitness_dashboard/core/services/secure_storage.dart';
import 'package:fitness_dashboard/data/model/admin_model.dart';
import 'package:fitness_dashboard/data/repository/auth_repository.dart';
import 'package:fitness_dashboard/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepositary authRepository;
  LoginCubit(this.authRepository)
    : super(LoginInitial(isPasswordVisible: false));
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  SecureStorage storage = GetItServices.getIt<SecureStorage>();

  void changePasswordVisibility() {
    final currentState = state;
    if (currentState is LoginInitial) {
      final current = currentState.isPasswordVisible;
      emit(LoginInitial(isPasswordVisible: !current));
    }
  }

  // void getUserToken() {
  //   FirebaseMessaging.instance.getToken().then((value) {
  //     log("========================== Value Of Token $value");
  //     // ignore: unused_local_variable
  //     String? token = value;
  //   });
  // }

  Future<void> login() async {
    emit(LoginLoadingState());
    final result = await authRepository.loginData(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    result.fold(
      (failure) {
        emit(LoginFailedState(failure.message));
      },
      (userData) async {
        await saveAdminData(AdminModel.fromJson(userData[0]));
        await AdminApp.adminIsAuthorized();
        emit(LoginSuccessState());
        // FirebaseMessaging.instance.subscribeToTopic("fares");
        // FirebaseMessaging.instance.subscribeToTopic(
        //   "fares${userData[0]['id']}",
        // );
      },
    );
  }

  Future<void> saveAdminData(AdminModel userData) async {
    final jsonString = jsonEncode(userData.toJson());
    await storage.addAdminData(jsonString);
    await myBox!.put("adminId", userData.id.toString());
    await myBox!.put("adminName", userData.name);
    await myBox!.put("adminEmail", userData.email);
  }

  Future<AdminModel?> getAdminData() async {
    final jsonString = await storage.getAdminData();
    if (jsonString != null) {
      final map = jsonDecode(jsonString);
      return AdminModel.fromJson(map);
    }
    return null;
  }
}
