import 'dart:convert';
import 'dart:developer';
import 'package:fitness_dashboard/business_logic/coach/coach_cubit.dart';
import 'package:fitness_dashboard/business_logic/coach/coach_state.dart';
import 'package:fitness_dashboard/constants/circuler_progress_indicztor.dart';
import 'package:fitness_dashboard/constants/colors.dart';
import 'package:fitness_dashboard/constants/routes.dart';
import 'package:fitness_dashboard/core/helper/show_toast_notification.dart';
import 'package:fitness_dashboard/core/services/get_it_services.dart';
import 'package:fitness_dashboard/core/services/secure_storage.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/customtext.dart';
import 'package:fitness_dashboard/presentation/widgets/users/search_testformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CoacheScreen extends StatefulWidget {
  const CoacheScreen({super.key});

  @override
  State<CoacheScreen> createState() => _CoacheScreenState();
}

class _CoacheScreenState extends State<CoacheScreen> {
  late final CoachCubit coacheCubit;
  late final TextEditingController searchController;
  SecureStorage storage = GetItServices.getIt<SecureStorage>();
  late String adminId;

  void getAdminData() async {
    final jsonString = await storage.getAdminData();
    if (jsonString != null) {
      final map = jsonDecode(jsonString);
      adminId = map['id'];
      log("map ========================== $map");
    }
  }

  @override
  void initState() {
    super.initState();
    getAdminData();
    searchController = TextEditingController();
    coacheCubit = context.read<CoachCubit>();
    coacheCubit.getAllCoaches();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.addCoachScreen);
        },
        child: Icon(Icons.add, color: MyColors.whiteObasity),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: BlocListener<CoachCubit, CoachState>(
          listener: (context, state) {
            if (state is CoachStateFailure) {
              ShowToastMessage.showErrorToastMessage(
                context,
                message: state.message,
              );
            }
          },
          child: BlocBuilder<CoachCubit, CoachState>(
            builder: (context, state) {
              if (state is CoachStateLoading) {
                return customCirculrProgressIndicator();
              }
              return customCoachBody(theme);
            },
          ),
        ),
      ),
    );
  }

  Widget customCoachBody(ThemeData theme) {
    return ListView(
      children: [
        CustomSearchTextFormField(
          labelText: "search",
          keyboardType: TextInputType.multiline,
          icon: Icons.person,
          obscureText: false,
          suffixIcon: IconButton(
            onPressed: () {
              // coacheCubit.showSearchUsers(searchController.text.trim());
              // searchController.clear();
            },
            icon: Icon(Icons.search),
          ),
          validator: (val) {
            return "";
          },
          controller: searchController,
          onChanged: (val) {
            log("value =================== $val");
          },
          theme: theme.textTheme,
        ),
        SizedBox(height: 20.0),
        Table(
          children: [
            // Header Row
            TableRow(
              children: [
                CustomText(
                  title: "Name",
                  textAlign: TextAlign.center,
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),
                CustomText(
                  title: "Email",
                  textAlign: TextAlign.center,
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),
                CustomText(
                  title: "Phone",
                  textAlign: TextAlign.center,
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),

                CustomText(
                  title: "Gender",
                  textAlign: TextAlign.center,
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),
                CustomText(
                  title: "Age",
                  textAlign: TextAlign.center,
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),
                CustomText(
                  title: "town",
                  textAlign: TextAlign.center,
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),
                CustomText(
                  title: "Joining date",
                  textAlign: TextAlign.center,
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),
              ],
            ),

            ...List.generate(coacheCubit.listCoachModel.length, (index) {
              final coach = coacheCubit.listCoachModel[index];

              return TableRow(
                children: [
                  CustomText(
                    title: coach.name ?? "",
                    textAlign: TextAlign.center,
                    textStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.black01,
                      fontSize: 15.0,
                    ),
                  ),

                  CustomText(
                    title: coach.email ?? "",
                    textAlign: TextAlign.center,
                    textStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.black01,
                      fontSize: 15.0,
                    ),
                  ),

                  CustomText(
                    title: coach.phone ?? "",
                    textAlign: TextAlign.center,
                    textStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.black01,
                      fontSize: 15.0,
                    ),
                  ),

                  CustomText(
                    title: coach.gender!,
                    textAlign: TextAlign.center,
                    textStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.black01,
                      fontSize: 15.0,
                    ),
                  ),
                  CustomText(
                    title: "${coach.age}",
                    textAlign: TextAlign.center,
                    textStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.black01,
                      fontSize: 15.0,
                    ),
                  ),
                  CustomText(
                    title: "${coach.twon}",
                    textAlign: TextAlign.center,
                    textStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.black01,
                      fontSize: 15.0,
                    ),
                  ),
                  CustomText(
                    title: DateFormat(
                      'dd-MM-yyyy',
                    ).format(DateTime.parse(coach.emailCreate!)),
                    textAlign: TextAlign.center,
                    textStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.black01,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }
}
