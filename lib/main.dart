import 'package:fitness_dashboard/business_logic/theme/theme_cubit.dart';
import 'package:fitness_dashboard/business_logic/theme/theme_state.dart';
import 'package:fitness_dashboard/core/app/user_app.dart';
import 'package:fitness_dashboard/core/dio_services/dio.dart';
import 'package:fitness_dashboard/core/routes/app_route.dart';
import 'package:fitness_dashboard/core/services/get_it_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

Box? myBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetItServices.setup();
  await Future.wait([AdminApp.adminIsAuthorized(), DioService.init()]);
  await Hive.initFlutter();
  myBox = await Hive.openBox("fares");
  if (!myBox!.containsKey("isDark")) {
    myBox!.put("isDark", false);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppSettingsCubit(),

      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) => MaterialApp(
          title: 'Fitness Dashboard',
          locale: state.locale,
          theme: state.themeData,
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          themeAnimationCurve: Curves.fastOutSlowIn,
          themeAnimationDuration: const Duration(milliseconds: 1500),
          onGenerateRoute: AppRouter().generateRoute,
        ),
      ),
    );
  }
}
