import 'dart:convert';
import 'dart:developer';
import 'package:fitness_dashboard/business_logic/exports/export.state.dart';
import 'package:fitness_dashboard/business_logic/exports/export_cubit.dart';
import 'package:fitness_dashboard/constants/circuler_progress_indicztor.dart';
import 'package:fitness_dashboard/constants/colors.dart';
import 'package:fitness_dashboard/core/helper/show_toast_notification.dart';
import 'package:fitness_dashboard/core/helper/valid_input.dart';
import 'package:fitness_dashboard/core/services/get_it_services.dart';
import 'package:fitness_dashboard/core/services/secure_storage.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/customtext.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/customtextformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExportsScreen extends StatefulWidget {
  final int totalPrice;
  const ExportsScreen({super.key, required this.totalPrice});

  @override
  State<ExportsScreen> createState() => _ExportsScreenState();
}

class _ExportsScreenState extends State<ExportsScreen> {
  late final ExportCubit exportCubit;
  SecureStorage storage = GetItServices.getIt<SecureStorage>();
  late String adminId;
  int? getTotal;
  late TextEditingController name;
  late TextEditingController count;
  late TextEditingController price;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    exportCubit = context.read<ExportCubit>();
    exportCubit.getExportTotlaPrice();
    exportCubit.getExportData();
    getAdminData();
    name = TextEditingController();
    count = TextEditingController();
    price = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    count.dispose();
    price.dispose();
    formState.currentState?.dispose();
  }

  void getAdminData() async {
    final jsonString = await storage.getAdminData();
    if (jsonString != null) {
      final map = jsonDecode(jsonString);
      adminId = map['id'];
    }
  }

  void decrementTotalPrice() {
    getTotal =
        ((widget.totalPrice - exportCubit.exportTotalPrice!) -
        int.parse(price.text));
    exportCubit.setLoading(true);
    log("getTotla ==========================$getTotal ");
  }

  int get getExportTotal =>
      ((widget.totalPrice) - (exportCubit.exportTotalPrice!));

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<ExportCubit, ExportState>(
          builder: (context, state) {
            if (state is ExportStateLoading) {
              return customCirculrProgressIndicator();
            } else if (state is ExportStateFailure) {
              ShowToastMessage.showErrorToastMessage(
                context,
                message: state.message,
              );
            }
            return Form(
              key: formState,
              child: ListView(
                children: [
                  BlocSelector<ExportCubit, ExportState, bool>(
                    selector: (state) {
                      if (state is ExportStateInitial) {
                        return state.isRefresh;
                      }
                      return false;
                    },

                    builder: (context, state) {
                      if (state is ExportStateLoading) {
                        return customCirculrProgressIndicator();
                      }
                      return CustomText(
                        textAlign: TextAlign.center,
                        title: "Total Price : ${getTotal ?? getExportTotal} E£",
                        textStyle: theme.textTheme.headlineMedium!.copyWith(
                          color: MyColors.grey,
                        ),
                      );
                    },
                  ),

                  customAddedExports(theme),

                  customViewExports(theme),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget customViewExports(ThemeData theme) {
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
              title: "Count",
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
              title: "date",
              textStyle: theme.textTheme.headlineMedium!.copyWith(
                color: MyColors.grey,
              ),
            ),
          ],
        ),

        ...List.generate(exportCubit.listExportModel.length, (index) {
          final export = exportCubit.listExportModel[index];
          return TableRow(
            children: [
              CustomText(
                title: export.name!,
                textStyle: theme.textTheme.headlineSmall!.copyWith(
                  color: MyColors.black01,
                ),
              ),
              CustomText(
                title: "${export.count}",
                textStyle: theme.textTheme.headlineSmall!.copyWith(
                  color: MyColors.black01,
                ),
              ),

              CustomText(
                title: "${export.price} E£",
                textStyle: theme.textTheme.headlineSmall!.copyWith(
                  color: MyColors.black01,
                ),
              ),

              CustomText(
                title: "${export.exportDate}",
                textStyle: theme.textTheme.headlineSmall!.copyWith(
                  color: MyColors.black01,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget customAddedExports(ThemeData theme) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 270),
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
                          return validInput(val!, 2, 100, "Name");
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
                        labelText: "Count",
                        prefixIcon: null,
                        obscureText: false,
                        suffixIcon: null,
                        validator: (val) {
                          return validInput(val!, 1, 100, "Count");
                        },
                        controller: count,
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
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Price",
                        prefixIcon: null,
                        obscureText: false,
                        suffixIcon: null,
                        validator: (val) {
                          return validInput(val!, 2, 100, "Price");
                        },
                        controller: price,
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
                      child: TextButton(
                        onPressed: () {
                          if (formState.currentState!.validate()) {
                            formState.currentState!.save();
                            if (int.parse(price.text) > widget.totalPrice) {
                              ShowToastMessage.showErrorToastMessage(
                                context,
                                message:
                                    "No Money Available, OR Greater Than You Have",
                              );
                            } else {
                              exportCubit.addExportData(
                                name.text.trim(),
                                count.text.trim(),
                                price.text.trim(),
                                adminId,
                              );
                              decrementTotalPrice();
                            }
                          } else {
                            ShowToastMessage.showErrorToastMessage(
                              context,
                              message: "Check Your Inputs",
                            );
                          }
                        },
                        child: CustomText(
                          title: "Add",
                          textStyle: theme.textTheme.headlineSmall!.copyWith(
                            color: MyColors.blueLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
