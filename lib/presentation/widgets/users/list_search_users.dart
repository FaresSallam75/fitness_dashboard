import 'package:fitness_dashboard/business_logic/payment/payment_cubit.dart';
import 'package:fitness_dashboard/business_logic/users/users_cubit.dart';
import 'package:fitness_dashboard/business_logic/users/users_state.dart';
import 'package:fitness_dashboard/constants/circuler_progress_indicztor.dart';
import 'package:fitness_dashboard/constants/colors.dart';
import 'package:fitness_dashboard/core/helper/show_toast_notification.dart';
import 'package:fitness_dashboard/data/model/payment_model.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CustomListSearchedUsers extends StatelessWidget {
  final UsersCubit usersCubit;
  final ThemeData theme;
  final PaymentCubit paymentCubit;
  final String adminId;
  const CustomListSearchedUsers({
    super.key,
    required this.usersCubit,
    required this.theme,
    required this.paymentCubit,
    required this.adminId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        if (state is UsersStateLoading) {
          return customCirculrProgressIndicator();
        }

        return Table(
          children: [
            TableRow(
              children: [
                CustomText(
                  title: "Name",
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),
                CustomText(
                  title: "Price",
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),
                CustomText(
                  title: "Start date",
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),
                CustomText(
                  title: "End date",
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),
                CustomText(
                  title: "Remainder",
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),
                CustomText(
                  title: "",
                  textStyle: theme.textTheme.headlineMedium!.copyWith(
                    color: MyColors.grey,
                  ),
                ),
              ],
            ),

            ...List.generate(usersCubit.listSearchUser.length, (index) {
              final now = DateTime.now();
              final nextMonth = DateTime(now.year, now.month + 1, now.day);

              final user = usersCubit.listSearchUser[index];
              // حاول تجيب الـ Payment الخاص بالـ user
              final PaymentModel? userPayment = paymentCubit.listPayments
                  .cast<PaymentModel?>()
                  .firstWhere(
                    (payment) =>
                        payment?.userId.toString() == user.id.toString(),
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
                  CustomText(
                    title: user.name ?? "",
                    textStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.black01,
                    ),
                  ),

                  // Price
                  CustomText(
                    title: "150 E£",
                    textStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.black01,
                    ),
                  ),

                  // Start Date
                  CustomText(
                    title: (userPayment == null || userPayment.status == 0)
                        ? "_"
                        : DateFormat('dd-MM-yyyy').format(startDate!),
                    textStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.black01,
                    ),
                  ),

                  // End Date
                  CustomText(
                    title: (userPayment == null || userPayment.status == 0)
                        ? "_"
                        : DateFormat('dd-MM-yyyy').format(endDate!),
                    textStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.black01,
                    ),
                  ),

                  // Difference in Days
                  CustomText(
                    title: (userPayment == null || userPayment.status == 0)
                        ? "_"
                        : "$differenceInDays",
                    textStyle: theme.textTheme.headlineSmall!.copyWith(
                      color: MyColors.black01,
                    ),
                  ),

                  // Renew Button
                  TextButton(
                    onPressed: () {
                      if (userPayment!.userId.toString() == user.id &&
                          userPayment.status == 1) {
                        ShowToastMessage.showErrorToastMessage(
                          context,
                          message:
                              "This user already has an active subscription.",
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
                      }
                    },
                    child: CustomText(
                      title: (userPayment != null && userPayment.status == 1)
                          ? "Renewed"
                          : "Renew",
                      textStyle: theme.textTheme.headlineSmall!.copyWith(
                        color: MyColors.dark,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}
