import 'package:fitness_dashboard/core/services/secure_storage.dart';
import 'package:fitness_dashboard/data/repository/Offer_repository.dart';
import 'package:fitness_dashboard/data/repository/auth_repository.dart';
import 'package:fitness_dashboard/data/repository/coach_repository.dart';
import 'package:fitness_dashboard/data/repository/export_repository.dart';
import 'package:fitness_dashboard/data/repository/payment_repository.dart';
import 'package:fitness_dashboard/data/repository/user_repository.dart';
import 'package:get_it/get_it.dart';

abstract class GetItServices {
  static final GetIt getIt = GetIt.instance;
  static void setup() {
    getIt.registerLazySingleton<AuthRepositary>(() => AuthRepositary());
    getIt.registerLazySingleton<UserRepository>(() => UserRepository());
    getIt.registerLazySingleton<PaymentRepository>(() => PaymentRepository());
    getIt.registerLazySingleton<CoachRepository>(() => CoachRepository());
    getIt.registerLazySingleton<ExportRepository>(() => ExportRepository());
    getIt.registerLazySingleton<OfferRepository>(() => OfferRepository());
    getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());
  }
}
