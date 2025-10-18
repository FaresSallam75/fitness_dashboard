import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  // final String token = "token";
  final String adminName = "adminName";
  final String adminId = "adminId";
  final String adminData = "adminData";

  Future<void> _write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> _read(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<bool> containsKey(String key) async {
    final value = await _secureStorage.read(key: key);
    return value != null;
  }

  Future<void> addAdminData(String value) async {
    return await _write(adminData, value);
  }

  Future<void> deleteAdminData(String key) async {
    await _secureStorage.delete(key: key); // "userData"
  }

  Future<String?> getAdminData() async {
    return await _read(adminData);
  }

  Future<void> addAdminName(String value) async {
    return await _write(adminName, value);
  }

  Future<void> addAdminId(String value) async {
    return await _write(adminId, value);
  }

  Future<String?> getAdminId() async {
    return await _read(adminId);
  }

  Future<String?> getAdminName() async {
    return await _read(adminName);
  }

  Future<void> deleteAdminName() async {
    await _secureStorage.delete(key: adminName);
  }
}
