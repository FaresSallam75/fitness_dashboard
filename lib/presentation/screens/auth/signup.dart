// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   late final RegisterCubit registerCubit;

//   @override
//   void initState() {
//     registerCubit = context.read<RegisterCubit>();
//     super.initState();
//   }

//   @override
//   dispose() {
//     registerCubit.nameController.dispose();
//     registerCubit.emailController.dispose();
//     registerCubit.passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final themeData = Theme.of(context).textTheme;
//     return Scaffold(
//       body: BlocConsumer<RegisterCubit, RegisterState>(
//         listener: (context, state) {
//           if (state is RegisterLoadingState) {
//             const Center(child: CircularProgressIndicator());
//           } else if (state is RegisterFailedState) {
//             ShowToastMessage.showErrorToastMessage(
//               context,
//               message: state.message,
//             );
//           } else if (state is RegisterSuccessState) {
//             Navigator.of(context).pushReplacementNamed(AppRoutes.login);
//           }
//         },

//         builder: (context, state) => customRegisterBody(screenSize, themeData),
//       ),
//     );
//   }

//   Widget customRegisterBody(Size screenSize, TextTheme themeData) {
//     return Stack(
//       children: [
//         Container(color: MyColors.blueDark),
//         ClipPath(
//           clipper: BackgroundCurveClipper(),
//           child: Container(
//             height: screenSize.height * 0.55,
//             color: Color(0xFF3B8FBD),
//           ),
//         ),
//         Positioned(
//           top: screenSize.height * 0.15,
//           left: 0,
//           right: 0,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Create your account",
//                   style: themeData.headlineLarge!.copyWith(),
//                 ),
//                 const SizedBox(height: 10),

//                 SizedBox(height: screenSize.height * 0.1),
//                 Form(
//                   key: registerCubit.formKey,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 25.0,
//                       vertical: 35.0,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(25.0),
//                       boxShadow: [
//                         BoxShadow(
//                           // ignore: deprecated_member_use
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CustomTextFormField(
//                           labelText: "UserName",
//                           keyboardType: TextInputType.emailAddress,
//                           icon: Icons.person,
//                           validator: (value) {
//                             return validInput(value!, 4, 20, "username");
//                           },
//                           obscureText: false,
//                           controller: registerCubit.nameController,
//                           suffixIcon: null,
//                         ),
//                         SizedBox(height: 20.0),
//                         CustomTextFormField(
//                           labelText: "E-mail ID",
//                           keyboardType: TextInputType.emailAddress,
//                           icon: Icons.email_outlined,
//                           validator: (value) {
//                             return validInput(value!, 4, 20, "email");
//                           },
//                           obscureText: false,
//                           controller: registerCubit.emailController,
//                           suffixIcon: null,
//                         ),

//                         SizedBox(height: 20.0),
//                         BlocSelector<RegisterCubit, RegisterState, bool>(
//                           selector: (state) {
//                             if (state is RegisterInitial) {
//                               return state.isPasswordVisible;
//                             }
//                             return false;
//                           },

//                           builder: (context, isPasswordVisible) {
//                             return CustomTextFormField(
//                               labelText: "Password",
//                               keyboardType: TextInputType.emailAddress,
//                               icon: Icons.lock_outline,
//                               validator: (value) {
//                                 return validInput(value!, 4, 20, "password");
//                               },
//                               obscureText: !isPasswordVisible,
//                               controller: context
//                                   .read<RegisterCubit>()
//                                   .passwordController,
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   isPasswordVisible
//                                       ? Icons.visibility_off
//                                       : Icons.visibility,
//                                   color: Colors.grey.shade500,
//                                 ),
//                                 onPressed: () {
//                                   context
//                                       .read<RegisterCubit>()
//                                       .changePasswordVisibility();
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         CustomMaterialButton(
//                           height: 55.0,
//                           color: MyColors.blueDark,
//                           minWidth: MediaQuery.of(context).size.width - 80,
//                           onPressed: () {
//                             if (registerCubit.formKey.currentState!
//                                 .validate()) {
//                               registerCubit.formKey.currentState!.save();
//                               registerCubit.register();
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                     "Please fill all the fields",
//                                     style: themeData.headlineSmall!.copyWith(
//                                       color: MyColors.white,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }
//                           },
//                           radius: 15.0,
//                           child: Text(
//                             "Register",
//                             style: themeData.headlineLarge!.copyWith(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: 50.0),
//                 InkWell(
//                   onTap: () {
//                     Navigator.pushReplacementNamed(context, AppRoutes.login);
//                   },
//                   child: Center(
//                     child: RichText(
//                       text: TextSpan(
//                         text: "Already have an account? ",
//                         style: themeData.bodySmall!.copyWith(
//                           color: MyColors.grey03,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: "Login",
//                             style: themeData.bodySmall!.copyWith(
//                               color: MyColors.blueLight,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
