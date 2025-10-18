import 'package:fitness_dashboard/business_logic/offer/coach_state.dart';
import 'package:fitness_dashboard/business_logic/offer/offer_cubit.dart';
import 'package:fitness_dashboard/constants/circuler_progress_indicztor.dart';
import 'package:fitness_dashboard/constants/colors.dart';
import 'package:fitness_dashboard/core/helper/show_toast_notification.dart';
import 'package:fitness_dashboard/core/helper/valid_input.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/customtext.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/customtextformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  late final TextEditingController offerName;
  late final TextEditingController offerPeriod;
  late final TextEditingController offerPrice;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late final OfferCubit offerCubit;

  @override
  void initState() {
    super.initState();
    offerName = TextEditingController();
    offerPeriod = TextEditingController();
    offerPrice = TextEditingController();
    offerCubit = context.read<OfferCubit>();
    offerCubit.getAllOffers();
  }

  @override
  void dispose() {
    super.dispose();
    offerName.dispose();
    offerPeriod.dispose();
    offerPrice.dispose();
    formState.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<OfferCubit, OfferState>(
          builder: (context, state) {
            if (state is OfferStateLoading) {
              return customCirculrProgressIndicator();
            } else if (state is OfferStateFailure) {
              ShowToastMessage.showErrorToastMessage(
                context,
                message: state.message,
              );
            }
            return Form(
              key: formState,
              child: Column(
                children: [customAddedOffer(theme), customViewOffers(theme)],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget customViewOffers(ThemeData theme) {
    return Table(
      children: [
        TableRow(
          children: [
            CustomText(
              title: "Offer Name",
              textStyle: theme.textTheme.headlineMedium!.copyWith(
                color: MyColors.grey,
              ),
            ),
            CustomText(
              title: "Offer Perid",
              textStyle: theme.textTheme.headlineMedium!.copyWith(
                color: MyColors.grey,
              ),
            ),
            CustomText(
              title: "Offer Price",
              textStyle: theme.textTheme.headlineMedium!.copyWith(
                color: MyColors.grey,
              ),
            ),
            CustomText(
              title: "Publish Date",
              textStyle: theme.textTheme.headlineMedium!.copyWith(
                color: MyColors.grey,
              ),
            ),
          ],
        ),

        ...List.generate(offerCubit.listOfferModel.length, (index) {
          final offer = offerCubit.listOfferModel[index];
          return TableRow(
            children: [
              CustomText(
                title: offer.name!,
                textStyle: theme.textTheme.headlineSmall!.copyWith(
                  color: MyColors.black01,
                ),
              ),
              CustomText(
                title: "${offer.period}",
                textStyle: theme.textTheme.headlineSmall!.copyWith(
                  color: MyColors.black01,
                ),
              ),

              CustomText(
                title: "${offer.price} E£",
                textStyle: theme.textTheme.headlineSmall!.copyWith(
                  color: MyColors.black01,
                ),
              ),

              CustomText(
                title: "${offer.offerDateTime}",
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

  Widget customAddedOffer(ThemeData theme) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 400),
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
                SizedBox(
                  height: 100.0,
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(20.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        offerCubit.chooseFileFromPC();
                      },
                      child: offerCubit.isLoading
                          ? customCirculrProgressIndicator()
                          : CustomText(
                              title: offerCubit.imageName != null
                                  ? "Image Selected"
                                  : "Upload Image",
                              textStyle: theme.textTheme.headlineSmall!
                                  .copyWith(color: MyColors.blueLight),
                            ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Offer Name",
                        prefixIcon: null,
                        obscureText: false,
                        suffixIcon: null,
                        validator: (val) {
                          return validInput(val!, 2, 100, "Name");
                        },
                        controller: offerName,
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
                        labelText: "Offer Period",
                        prefixIcon: null,
                        obscureText: false,
                        suffixIcon: null,
                        validator: (val) {
                          return validInput(val!, 1, 100, "Count");
                        },
                        controller: offerPeriod,
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
                        labelText: "Offer Price",
                        prefixIcon: null,
                        obscureText: false,
                        suffixIcon: null,
                        validator: (val) {
                          return validInput(val!, 2, 100, "Price");
                        },
                        controller: offerPrice,
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
                            // formState.currentState!.save();
                            offerCubit.addOfferes(
                              offerName.text.trim(),
                              offerPeriod.text.trim(),
                              offerPrice.text.trim(),
                            );
                            offerName.text = "";
                            offerPeriod.text = "";
                            offerPrice.text = "";
                            offerCubit.imageName = null;
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
