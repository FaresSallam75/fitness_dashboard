import 'dart:developer';
import 'package:fitness_dashboard/business_logic/exports/export_cubit.dart';
import 'package:fitness_dashboard/business_logic/payment/payment_cubit.dart';
import 'package:fitness_dashboard/business_logic/payment/payment_state.dart';
import 'package:fitness_dashboard/business_logic/users/users_cubit.dart';
import 'package:fitness_dashboard/business_logic/users/users_state.dart';
import 'package:fitness_dashboard/constants/circuler_progress_indicztor.dart';
import 'package:fitness_dashboard/constants/colors.dart';
import 'package:fitness_dashboard/constants/routes.dart';
import 'package:fitness_dashboard/core/app/user_app.dart';
import 'package:fitness_dashboard/core/services/get_it_services.dart';
import 'package:fitness_dashboard/core/services/secure_storage.dart';
import 'package:fitness_dashboard/main.dart';
import 'package:fitness_dashboard/presentation/widgets/auth/customtext.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SecureStorage storage = GetItServices.getIt<SecureStorage>();
  int selectedIndex = 0;

  late final UsersCubit usersCubit;
  late final PaymentCubit paymentCubit;
  late final ExportCubit exportCubit;

  late final web.EventListener _onPopStateListener;

  @override
  void initState() {
    super.initState();
    usersCubit = context.read<UsersCubit>();
    paymentCubit = context.read<PaymentCubit>();
    exportCubit = context.read<ExportCubit>();
    usersCubit.getCountUsers();
    exportCubit.getExportTotlaPrice();
    paymentCubit.getCountCoaches();
    paymentCubit.getTotlaPrice();
    if (kIsWeb) {
      log("initState ============================== ");
      _onPopStateListener = ((JSAny? event) {
        web.window.location.reload();
      }).toJS;

      web.window.addEventListener('popstate', _onPopStateListener);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (kIsWeb) {
      web.window.removeEventListener('popstate', _onPopStateListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    log("Rebuild ============================== ");
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          BlocSelector<UsersCubit, UsersState, bool>(
            selector: (state) {
              if (state is UsersStateInitial) {
                return state.isRefresh;
              }
              return false;
            },
            builder: (context, state) {
              return customSliderBar(theme);
            },
          ),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left main content
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top stats
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
                            return topStates();
                          },
                        ),

                        const SizedBox(height: 20),

                        // Line chart
                        lineChart(),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Right profile panel
                  rightProfilePanel(theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rightProfilePanel(ThemeData theme) {
    return Expanded(
      flex: 1,
      child: Card(
        color: MyColors.dark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/images/my.JPG"),
              ),

              //  FadeInImage.assetNetwork(
              //   height: 100.0,
              //   width: 100.0,
              //   placeholder: AppImagesAssets.loading,
              //   image: "${ApiEndPoints.coachImages}/${coaches.coacheImage}",
              //   fit: BoxFit.contain,
              //   imageErrorBuilder: (context, error, stackTrace) {
              //     return Image.asset(
              //       AppImagesAssets.loading,
              //       width: 100,
              //       height: 100,
              //       fit: BoxFit.contain,
              //     );
              //   },
              // ),
              const SizedBox(height: 12),
              CustomText(
                title: "${myBox!.get("adminName")}",
                textStyle: theme.textTheme.headlineSmall!.copyWith(
                  color: MyColors.cyanAccent,
                ),
              ),
              CustomText(
                title: "Edit health details",
                textStyle: theme.textTheme.headlineSmall!.copyWith(
                  color: MyColors.grey,
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoBox(title: "Weight", value: "80kg", theme: theme),
                  _InfoBox(title: "Height", value: "180cm", theme: theme),
                  _InfoBox(title: "Blood", value: "O+", theme: theme),
                ],
              ),

              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: CustomText(
                  title: "Scheduled",
                  textStyle: theme.textTheme.headlineSmall!.copyWith(
                    color: MyColors.cyanAccent,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _ScheduleTile(
                title: "Hatha Yoga",
                time: "Today, 9AM - 10AM",
                theme: theme,
              ),
              _ScheduleTile(
                title: "Body Combat",
                time: "Tomorrow, 5PM - 6PM",
                theme: theme,
              ),
              _ScheduleTile(
                title: "Hatha Yoga",
                time: "Wed, 9AM - 10AM",
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget lineChart() {
    return Expanded(
      child: Card(
        color: MyColors.dark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 1),
                    FlSpot(1, 4),
                    FlSpot(2, 3),
                    FlSpot(3, 6),
                    FlSpot(4, 5),
                    FlSpot(5, 7),
                    FlSpot(6, 4),
                  ],
                  isCurved: true,
                  color: MyColors.cyanAccent,
                  barWidth: 3,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topStates() {
    return Row(
      children: [
        StatCard(
          //local_fire_department
          icon: Icons.group,
          value: "${usersCubit.countUsers ?? ""} ",
          label: "Users",
        ),
        SizedBox(width: 16),
        StatCard(
          icon: Icons.person, //directions_walk
          value: "${paymentCubit.countCoaches ?? ""}", //10,983
          label: "Coaches", //Steps
        ),
        SizedBox(width: 16),
        StatCard(
          icon: Icons.attach_money, //route
          value:
              "${((paymentCubit.totalPrice ?? 0) - (exportCubit.exportTotalPrice ?? 0))} E£", //7 km
          label: "Total Money", //Distance
        ),
        SizedBox(width: 16),
        StatCard(
          icon: Icons.attach_money_outlined, //nights_stay
          value: "${exportCubit.exportTotalPrice ?? 0} E£", //7h 48m
          label: "Export Money", //Sleep
        ),
      ],
    );
  }

  Widget customSliderBar(ThemeData theme) {
    return Container(
      width: 220,
      color: MyColors.dark,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const FlutterLogo(size: 60),
          const SizedBox(height: 40),
          _buildNavItem(Icons.dashboard, "Dashboard", 0, () {
            selectedIndex = 0;
            usersCubit.changeStatusLoading();
          }, theme),

          _buildNavItem(Icons.group_rounded, "Users", 2, () {
            selectedIndex = 2;
            usersCubit.changeStatusLoading();
            Navigator.of(context).pushNamed(AppRoutes.usersScreen);
          }, theme),
          _buildNavItem(Icons.group_rounded, "Coaches", 3, () {
            selectedIndex = 3;
            usersCubit.changeStatusLoading();
            Navigator.of(context).pushNamed(AppRoutes.coacheScreen);
          }, theme),
          _buildNavItem(Icons.import_export_outlined, "Exports", 4, () {
            selectedIndex = 4;
            usersCubit.changeStatusLoading();
            Navigator.of(context).pushNamed(
              AppRoutes.exportsScreen,
              arguments: {"totalPrice": paymentCubit.totalPrice},
            );
          }, theme),

          _buildNavItem(Icons.offline_share_sharp, "Offers", 6, () {
            selectedIndex = 6;
            usersCubit.changeStatusLoading();
            Navigator.of(context).pushNamed(AppRoutes.offerScreen);
          }, theme),

          _buildNavItem(Icons.logout, "Signout", 8, () {
            selectedIndex = 8;
            usersCubit.changeStatusLoading();
            storage.deleteAdminData("adminData");
            myBox!.clear();
            AdminApp.isAuthorized = false;
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          }, theme),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String title,
    int index,
    void Function()? onTap,
    ThemeData theme,
  ) {
    final isActive = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          leading: Icon(
            icon,
            color: isActive ? MyColors.cyanAccent : MyColors.grey,
          ),
          title: CustomText(
            title: title,
            textStyle: theme.textTheme.headlineSmall!.copyWith(
              color: isActive ? MyColors.cyanAccent : MyColors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 17.0,
            ),
          ),
          // ignore: deprecated_member_use
          tileColor: isActive ? MyColors.cyanAccent.withOpacity(0.1) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: MyColors.dark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.cyanAccent),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  color: MyColors.cyanAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;
  final ThemeData theme;

  const _InfoBox({
    required this.title,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          title: value,
          textStyle: theme.textTheme.headlineSmall!.copyWith(
            color: MyColors.cyanAccent,
          ),
        ),
        CustomText(
          title: title,
          textStyle: theme.textTheme.headlineSmall!.copyWith(
            color: MyColors.grey,
            fontSize: 13.0,
          ),
        ),
      ],
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  final String title;
  final String time;
  final ThemeData theme;
  const _ScheduleTile({
    required this.title,
    required this.time,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyColors.dark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: CustomText(
          title: title,
          textStyle: theme.textTheme.headlineSmall!.copyWith(
            color: MyColors.cyanAccent,
          ),
        ),
        subtitle: CustomText(
          title: time,
          textStyle: theme.textTheme.headlineSmall!.copyWith(
            color: MyColors.grey,
            fontSize: 14.0,
          ),
        ),
        trailing: const Icon(Icons.more_vert, color: MyColors.grey),
      ),
    );
  }
}
