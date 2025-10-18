import 'dart:convert';
import 'dart:developer';
import 'package:fitness_dashboard/business_logic/payment/payment_cubit.dart';
import 'package:fitness_dashboard/business_logic/payment/payment_state.dart';
import 'package:fitness_dashboard/business_logic/users/users_cubit.dart';
import 'package:fitness_dashboard/business_logic/users/users_state.dart';
import 'package:fitness_dashboard/constants/circuler_progress_indicztor.dart';
import 'package:fitness_dashboard/constants/colors.dart';
import 'package:fitness_dashboard/core/helper/show_toast_notification.dart';
import 'package:fitness_dashboard/core/services/get_it_services.dart';
import 'package:fitness_dashboard/core/services/secure_storage.dart';
import 'package:fitness_dashboard/data/model/payment_model.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/customtext.dart';
import 'package:fitness_dashboard/presentation/widgets/users/list_search_users.dart';
import 'package:fitness_dashboard/presentation/widgets/users/search_testformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late final UsersCubit usersCubit;
  late final PaymentCubit paymentCubit;
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
    usersCubit = context.read<UsersCubit>();
    paymentCubit = context.read<PaymentCubit>();
    usersCubit.getAllUsers();
    paymentCubit.viewPayment();

    paymentCubit.getTotlaPrice();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: BlocListener<UsersCubit, UsersState>(
          listener: (context, state) {
            if (state is UsersStateFailure) {
              ShowToastMessage.showErrorToastMessage(
                context,
                message: state.message,
              );
            }
          },
          child: BlocBuilder<UsersCubit, UsersState>(
            builder: (context, state) {
              if (state is UsersStateLoading) {
                return customCirculrProgressIndicator();
              }
              return customUserBody(theme);
            },
          ),
        ),
      ),
    );
  }

  Widget customUserBody(ThemeData theme) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        if (state is PaymentStateLoading) {
          return customCirculrProgressIndicator();
        } else if (state is PaymentStateFailure) {
          ShowToastMessage.showErrorToastMessage(
            context,
            message: state.message,
          );
        }
        return ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            CustomSearchTextFormField(
              labelText: "search",
              keyboardType: TextInputType.multiline,
              icon: Icons.person,
              obscureText: false,
              suffixIcon: IconButton(
                onPressed: () {
                  usersCubit.showSearchUsers(searchController.text.trim());
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

            BlocSelector<PaymentCubit, PaymentState, bool>(
              selector: (state) {
                if (state is PaymentStateInitial) {
                  return state.isRefresh;
                }
                return false;
              },

              builder: (context, state) {
                if (state is PaymentStateLoading) {
                  return customCirculrProgressIndicator();
                }
                return CustomText(
                  textAlign: TextAlign.center,
                  title: "Total Price : ${paymentCubit.totalPrice ?? 0} E£",
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                );
              },
            ),

            SizedBox(height: 20.0),
            searchController.text.isNotEmpty
                ? CustomListSearchedUsers(
                    usersCubit: usersCubit,
                    theme: theme,
                    paymentCubit: paymentCubit,
                    adminId: adminId,
                  )
                : Table(
                    children: [
                      // Header Row
                      TableRow(
                        children: [
                          CustomText(
                            textAlign: TextAlign.center,
                            title: "Name",
                            textStyle: theme.textTheme.headlineMedium!.copyWith(
                              color: MyColors.grey,
                            ),
                          ),
                          CustomText(
                            textAlign: TextAlign.center,
                            title: "Price",
                            textStyle: theme.textTheme.headlineMedium!.copyWith(
                              color: MyColors.grey,
                            ),
                          ),
                          CustomText(
                            textAlign: TextAlign.center,
                            title: "Start date",
                            textStyle: theme.textTheme.headlineMedium!.copyWith(
                              color: MyColors.grey,
                            ),
                          ),
                          CustomText(
                            textAlign: TextAlign.center,
                            title: "End date",
                            textStyle: theme.textTheme.headlineMedium!.copyWith(
                              color: MyColors.grey,
                            ),
                          ),
                          CustomText(
                            textAlign: TextAlign.center,
                            title: "Remainder",
                            textStyle: theme.textTheme.headlineMedium!.copyWith(
                              color: MyColors.grey,
                            ),
                          ),
                          CustomText(
                            textAlign: TextAlign.center,
                            title: "",
                            textStyle: theme.textTheme.headlineMedium!.copyWith(
                              color: MyColors.grey,
                            ),
                          ),
                        ],
                      ),

                      ...List.generate(usersCubit.listUserModel.length, (
                        index,
                      ) {
                        final now = DateTime.now();
                        final nextMonth = DateTime(
                          now.year,
                          now.month + 1,
                          now.day,
                        );

                        final user = usersCubit.listUserModel[index];
                        // حاول تجيب الـ Payment الخاص بالـ user
                        final PaymentModel? userPayment = paymentCubit
                            .listPayments
                            .cast<PaymentModel?>()
                            .firstWhere(
                              (payment) =>
                                  payment?.userId.toString() ==
                                  user.id.toString(),
                              orElse: () => null,
                            );
                        final startDate = userPayment?.startDate != null
                            ? DateTime.parse(userPayment!.startDate!)
                            : null;
                        final endDate = userPayment?.endDate != null
                            ? DateTime.parse(userPayment!.endDate!)
                            : null;

                        final differenceInDays = endDate
                            ?.difference(DateTime.now())
                            .inDays;

                        return TableRow(
                          children: [
                            // User Name
                            InkWell(
                              onTap: () {
                                log("userId =============== ${user.id}");
                              },
                              child: CustomText(
                                textAlign: TextAlign.center,
                                title: user.name ?? "",
                                textStyle: theme.textTheme.headlineSmall!
                                    .copyWith(color: MyColors.black01),
                              ),
                            ),

                            // Price
                            CustomText(
                              textAlign: TextAlign.center,
                              title: "150 E£",
                              textStyle: theme.textTheme.headlineSmall!
                                  .copyWith(color: MyColors.black01),
                            ),

                            // Start Date
                            CustomText(
                              textAlign: TextAlign.center,
                              title:
                                  (userPayment == null ||
                                      userPayment.status == 0)
                                  ? "_"
                                  : differenceInDays! <= 0
                                  ? "_"
                                  : DateFormat('dd-MM-yyyy').format(startDate!),
                              textStyle: theme.textTheme.headlineSmall!
                                  .copyWith(color: MyColors.black01),
                            ),

                            // End Date
                            CustomText(
                              textAlign: TextAlign.center,
                              title:
                                  (userPayment == null ||
                                      userPayment.status == 0)
                                  ? "_"
                                  : differenceInDays! <= 0
                                  ? "_"
                                  : DateFormat('dd-MM-yyyy').format(endDate!),
                              textStyle: theme.textTheme.headlineSmall!
                                  .copyWith(color: MyColors.black01),
                            ),

                            // Difference in Days
                            CustomText(
                              textAlign: TextAlign.center,
                              title:
                                  (userPayment == null ||
                                      userPayment.status == 0)
                                  ? "_"
                                  : "${differenceInDays! <= 0 ? 0 : differenceInDays} ",
                              textStyle: theme.textTheme.headlineSmall!
                                  .copyWith(color: MyColors.black01),
                            ),

                            // Renew Button
                            TextButton(
                              onPressed: () {
                                if (userPayment?.userId.toString() == user.id &&
                                    differenceInDays! > 0) {
                                  ShowToastMessage.showErrorToastMessage(
                                    context,
                                    message:
                                        "This user already Paid this Month.",
                                  );
                                  return;
                                } else {
                                  paymentCubit.addPayment(
                                    user.id!,
                                    adminId,
                                    "150 E£",
                                    "$now",
                                    "$nextMonth",
                                    "cash",
                                  );
                                  ShowToastMessage.showSucessToastMessage(
                                    context,
                                    message: "Renewed Successfully.",
                                  );
                                }
                              },
                              child: CustomText(
                                title:
                                    (userPayment != null &&
                                        differenceInDays! > 0)
                                    ? "Renewed"
                                    : "Renew",
                                textStyle: theme.textTheme.headlineSmall!
                                    .copyWith(color: MyColors.dark),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
          ],
        );
      },
    );
  }
}
