import 'package:fitness_dashboard/business_logic/auth/login_cubit.dart';
import 'package:fitness_dashboard/business_logic/auth/login_state.dart';
import 'package:fitness_dashboard/constants/colors.dart';
import 'package:fitness_dashboard/constants/routes.dart';
import 'package:fitness_dashboard/core/helper/show_toast_notification.dart';
import 'package:fitness_dashboard/core/helper/valid_input.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/custom_elevated_button.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/customtext.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/customtextformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final LoginCubit loginCubit;

  @override
  void initState() {
    loginCubit = context.read<LoginCubit>();
    super.initState();
  }

  @override
  void dispose() {
    loginCubit.emailController.dispose();
    loginCubit.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginFailedState) {
                  ShowToastMessage.showErrorToastMessage(
                    context,
                    message: state.message,
                  );
                } else if (state is LoginSuccessState) {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(AppRoutes.homeScreen);
                }
              },
              builder: (context, state) {
                if (state is LoginLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return customBodyLogin(themeData);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget customBodyLogin(TextTheme themeData) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: loginCubit.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                title: "Welcome Back",
                textStyle: themeData.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: MyColors.blueGrey,
                ),
              ),

              const SizedBox(height: 10),
              CustomText(
                title: "Login with your email and password",
                textStyle: themeData.headlineSmall?.copyWith(
                  color: MyColors.grey,
                ),
              ),
              const SizedBox(height: 30),
              // Email
              email(themeData),
              const SizedBox(height: 20),
              // Password
              password(themeData),
              const SizedBox(height: 15),
              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: CustomText(
                    title: "Forgot Password?",
                    textStyle: themeData.headlineSmall!.copyWith(
                      color: MyColors.dark,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Login button
              button(themeData),
              const SizedBox(height: 20),
              // Register link
              customRegisterLink(themeData),
            ],
          ),
        ),
      ),
    );
  }

  Widget email(TextTheme theme) {
    return CustomTextFormField(
      labelText: "Email",
      style: theme.headlineSmall!.copyWith(color: MyColors.dark),
      labelStyle: theme.headlineSmall!.copyWith(color: MyColors.dark),

      // GoogleFonts.poppins(
      //   textStyle: TextStyle(
      //     color: MyColors.dark,
      //     fontSize: 16.0,
      //     fontWeight: FontWeight.w500,
      //   ),
      // ),
      obscureText: false,
      suffixIcon: null,
      prefixIcon: Icon(Icons.email_outlined),
      validator: (value) {
        return validInput(value!, 4, 30, "email");
      },
      controller: loginCubit.emailController,
    );
  }

  Widget password(TextTheme theme) {
    return BlocSelector<LoginCubit, LoginState, bool>(
      selector: (state) {
        if (state is LoginInitial) {
          return state.isPasswordVisible;
        }
        return false;
      },
      builder: (context, isPasswordVisible) {
        return CustomTextFormField(
          labelText: "Password",
          style: theme.headlineSmall!.copyWith(color: MyColors.dark),
          labelStyle: theme.headlineSmall!.copyWith(color: MyColors.dark),
          // labelStyle: GoogleFonts.poppins(
          //   textStyle: TextStyle(
          //     color: MyColors.dark,
          //     fontSize: 16.0,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          prefixIcon: Icon(Icons.lock_outline),
          obscureText: !isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              loginCubit.changePasswordVisibility();
            },
          ),
          validator: (value) {
            return validInput(value!, 4, 20, "password");
          },
          controller: loginCubit.passwordController,
        );
      },
    );
  }

  Widget button(TextTheme themeData) {
    return CustomElevatedButton(
      backgroundColor: MyColors.blueGrey,
      onPressed: () {
        if (loginCubit.formKey.currentState!.validate()) {
          loginCubit.formKey.currentState!.save();
          loginCubit.login();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText(
                title: "Please fill all the fields",
                textStyle: themeData.headlineSmall,
              ),
            ),
          );
        }
      },
      buttonText: "Login",
      style: themeData.headlineSmall,
    );
  }

  Widget customRegisterLink(TextTheme themeData) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.register);
      },
      child: Text.rich(
        TextSpan(
          text: "Don’t have an account? ",
          style: themeData.headlineSmall?.copyWith(color: MyColors.grey),
          children: [
            TextSpan(
              text: "Register now",
              style: themeData.headlineSmall!.copyWith(color: MyColors.dark),
            ),
          ],
        ),
      ),
    );
  }
}
