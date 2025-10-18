import 'package:fitness_dashboard/business_logic/auth/login_cubit.dart';
import 'package:fitness_dashboard/business_logic/coach/coach_cubit.dart';
import 'package:fitness_dashboard/business_logic/exports/export_cubit.dart';
import 'package:fitness_dashboard/business_logic/offer/offer_cubit.dart';
import 'package:fitness_dashboard/business_logic/payment/payment_cubit.dart';
import 'package:fitness_dashboard/business_logic/users/users_cubit.dart';
import 'package:fitness_dashboard/constants/routes.dart';
import 'package:fitness_dashboard/core/app/user_app.dart';
import 'package:fitness_dashboard/core/routes/base_route.dart';
import 'package:fitness_dashboard/core/services/get_it_services.dart';
import 'package:fitness_dashboard/data/repository/Offer_repository.dart';
import 'package:fitness_dashboard/data/repository/auth_repository.dart';
import 'package:fitness_dashboard/data/repository/coach_repository.dart';
import 'package:fitness_dashboard/data/repository/export_repository.dart';
import 'package:fitness_dashboard/data/repository/payment_repository.dart';
import 'package:fitness_dashboard/data/repository/user_repository.dart';
import 'package:fitness_dashboard/presentation/screens/auth/login.dart';
import 'package:fitness_dashboard/presentation/screens/home/coach/add_coaches.dart';
import 'package:fitness_dashboard/presentation/screens/home/coach/coaches.dart';
import 'package:fitness_dashboard/presentation/screens/home/exports/exports.dart';
import 'package:fitness_dashboard/presentation/screens/home/home.dart';
import 'package:fitness_dashboard/presentation/screens/home/offeres.dart';
import 'package:fitness_dashboard/presentation/screens/home/payments.dart';
import 'package:fitness_dashboard/presentation/screens/home/users.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    final CoachCubit coachCubit = CoachCubit(
      GetItServices.getIt<CoachRepository>(),
    );
    final UsersCubit usersCubit = UsersCubit(
      GetItServices.getIt<UserRepository>(),
    );
    final PaymentCubit paymentCubit = PaymentCubit(
      GetItServices.getIt<PaymentRepository>(),
    );
    final ExportCubit exportCubit = ExportCubit(
      GetItServices.getIt<ExportRepository>(),
    );

    switch (settings.name) {
      case AppRoutes.login:
        return BaseRoute(
          pageBuilder: (_, _, _) => (AdminApp.isAuthorized)
              ? MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: usersCubit),
                    BlocProvider.value(value: paymentCubit),
                    BlocProvider.value(value: exportCubit),
                  ],
                  child: HomeScreen(),
                )
              : BlocProvider(
                  create: (_) =>
                      LoginCubit(GetItServices.getIt<AuthRepositary>()),
                  child: const Login(),
                ),
        );

      case AppRoutes.homeScreen:
        return BaseRoute(
          pageBuilder: (_, _, _) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: usersCubit),
              BlocProvider.value(value: paymentCubit),
              BlocProvider.value(value: exportCubit),
            ],
            child: HomeScreen(),
          ),
        );

      case AppRoutes.coacheScreen:
        return BaseRoute(
          pageBuilder: (_, _, _) =>
              BlocProvider.value(value: coachCubit, child: CoacheScreen()),
        );
      case AppRoutes.addCoachScreen:
        return BaseRoute(
          pageBuilder: (_, _, _) =>
              BlocProvider.value(value: coachCubit, child: AddCoachScreen()),
        );

      case AppRoutes.usersScreen:
        return BaseRoute(
          pageBuilder: (_, _, _) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: usersCubit),
              BlocProvider.value(value: paymentCubit),
            ],
            child: UsersScreen(),
          ),
        );
      case AppRoutes.paymentScreen:
        return BaseRoute(
          pageBuilder: (_, _, _) =>
              BlocProvider.value(value: paymentCubit, child: PaymentScreen()),
        );
      case AppRoutes.offerScreen:
        return BaseRoute(
          pageBuilder: (_, _, _) => BlocProvider(
            create: (context) =>
                OfferCubit(GetItServices.getIt<OfferRepository>()),
            child: OfferScreen(),
          ),
        );
      case AppRoutes.exportsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return BaseRoute(
          pageBuilder: (_, _, _) => BlocProvider.value(
            value: exportCubit,
            child: ExportsScreen(totalPrice: args['totalPrice']),
          ),
        );

      default:
        return BaseRoute(
          pageBuilder: (_, _, _) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
