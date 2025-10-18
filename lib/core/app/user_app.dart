import 'package:fitness_dashboard/core/services/get_it_services.dart';
import 'package:fitness_dashboard/core/services/secure_storage.dart';

class AdminApp {
  static bool isAuthorized = false;
  static Future<void> adminIsAuthorized() async {
    String? uthorized = await GetItServices.getIt<SecureStorage>()
        .getAdminData();
    isAuthorized = (uthorized != null);
    // if (isAuthorized) {
    //   await ConnectionsServices.initConnection();
    // }
  }
}
