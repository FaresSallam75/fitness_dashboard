import 'package:fitness_dashboard/business_logic/coach/coach_cubit.dart';
import 'package:fitness_dashboard/business_logic/coach/coach_state.dart';
import 'package:fitness_dashboard/constants/circuler_progress_indicztor.dart';
import 'package:fitness_dashboard/constants/colors.dart';
import 'package:fitness_dashboard/constants/routes.dart';
import 'package:fitness_dashboard/core/helper/show_toast_notification.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/custom_elevated_button.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/customtext.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/customtextformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCoachScreen extends StatefulWidget {
  const AddCoachScreen({super.key});

  @override
  State<AddCoachScreen> createState() => _AddCoachScreenState();
}

class _AddCoachScreenState extends State<AddCoachScreen> {
  late final CoachCubit coachCubit;

  late final TextEditingController name;
  late final TextEditingController email;
  late final TextEditingController password;
  late final TextEditingController phone;
  late final TextEditingController gender;
  late final TextEditingController age;
  late final TextEditingController twon;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    phone = TextEditingController();
    gender = TextEditingController();
    age = TextEditingController();
    twon = TextEditingController();
    coachCubit = context.read<CoachCubit>();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
    password.dispose();
    phone.dispose();
    gender.dispose();
    age.dispose();
    twon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: BlocConsumer<CoachCubit, CoachState>(
        listener: (context, state) {
          if (state is CoachStateFailure) {
            ShowToastMessage.showErrorToastMessage(
              context,
              message: state.message,
            );
          } else if (state is CoachStateLoaded) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.coacheScreen);
          }
        },
        builder: (context, state) {
          if (state is CoachStateLoading) {
            return customCirculrProgressIndicator();
          } else if (state is CoachStateFailure) {
            ShowToastMessage.showErrorToastMessage(
              context,
              message: state.message,
            );
          }
          return customLoadedData(theme);
        },
      ),
    );
  }

  Widget customLoadedData(ThemeData theme) {
    return Form(
      key: formKey,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),

            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: "Name",
                          prefixIcon: null,
                          obscureText: false,
                          suffixIcon: null,
                          validator: (val) {
                            return null;
                          },
                          controller: name,
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: MyColors.dark,
                          ),
                          labelStyle: theme.textTheme.headlineSmall!.copyWith(
                            color: MyColors.greyLight,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: CustomTextFormField(
                          labelText: "Email",
                          prefixIcon: null,
                          obscureText: false,
                          suffixIcon: null,
                          validator: (val) {
                            return null;
                          },
                          controller: email,
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: MyColors.dark,
                          ),
                          labelStyle: theme.textTheme.headlineSmall!.copyWith(
                            color: MyColors.greyLight,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  BlocSelector<CoachCubit, CoachState, bool>(
                    selector: (state) {
                      if (state is CoachStateInitial) {
                        return state.isLoading;
                      }
                      return false;
                    },
                    builder: (context, isPasswordVisible) =>
                        CustomTextFormField(
                          labelText: "Password",
                          prefixIcon: null,
                          obscureText: !isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              coachCubit.changeStatusLoading();
                            },
                          ),
                          validator: (val) {
                            return null;
                          },
                          controller: password,
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: MyColors.dark,
                          ),
                          labelStyle: theme.textTheme.headlineSmall!.copyWith(
                            color: MyColors.greyLight,
                            fontSize: 14.0,
                          ),
                        ),
                  ),
                  CustomTextFormField(
                    labelText: "Phone",
                    prefixIcon: null,
                    obscureText: false,
                    suffixIcon: null,
                    validator: (val) {
                      return null;
                    },
                    controller: phone,
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.dark,
                    ),
                    labelStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.greyLight,
                      fontSize: 14.0,
                    ),
                  ),
                  CustomTextFormField(
                    labelText: "Gender",
                    prefixIcon: null,
                    obscureText: false,
                    suffixIcon: null,
                    validator: (val) {
                      return null;
                    },
                    controller: gender,
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.dark,
                    ),
                    labelStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.greyLight,
                      fontSize: 14.0,
                    ),
                  ),
                  CustomTextFormField(
                    labelText: "Age",
                    prefixIcon: null,
                    obscureText: false,
                    suffixIcon: null,
                    validator: (val) {
                      return null;
                    },
                    controller: age,
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.dark,
                    ),
                    labelStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.greyLight,
                      fontSize: 14.0,
                    ),
                  ),
                  CustomTextFormField(
                    labelText: "Twon",
                    prefixIcon: null,
                    obscureText: false,
                    suffixIcon: null,
                    validator: (val) {
                      return null;
                    },
                    controller: twon,
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.dark,
                    ),
                    labelStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.greyLight,
                      fontSize: 14.0,
                    ),
                  ),

                  // coachCubit.imageName != null
                  //     ? Center(
                  //         child: CustomText(
                  //           title: "Image Selected",
                  //           textStyle: theme.textTheme.headlineMedium!.copyWith(
                  //             fontSize: 14.0,
                  //             fontWeight: FontWeight.w400,
                  //           ),
                  //         ),
                  //       )
                  //     :
                  SizedBox(
                    height: 100.0,
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20.0),
                      ),
                      child: TextButton(
                        onPressed: () {
                          coachCubit.chooseFileFromPC();
                        },
                        child: coachCubit.isLoading
                            ? customCirculrProgressIndicator()
                            : CustomText(
                                title: coachCubit.imageName != null
                                    ? "Image Selected"
                                    : "Upload Image",
                                textStyle: theme.textTheme.headlineSmall!
                                    .copyWith(color: MyColors.blueLight),
                              ),
                      ),
                    ),
                  ),

                  CustomElevatedButton(
                    backgroundColor: MyColors.blueLight,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        coachCubit.addCoaches(
                          name.text.trim(),
                          email.text.trim(),
                          password.text.trim(),
                          phone.text.trim(),
                          gender.text.trim(),
                          age.text.trim(),
                          twon.text.trim(),
                        );

                        ShowToastMessage.showSucessToastMessage(
                          context,
                          message: "Account Created Successfully",
                        );
                        // Navigator.of(
                        //   context,
                        // ).pushReplacementNamed(AppRoutes.coacheScreen);
                      } else {
                        ShowToastMessage.showErrorToastMessage(
                          context,
                          message: "Not Valid Data",
                        );
                      }
                    },
                    buttonText: "Create Account",
                    style: theme.textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
