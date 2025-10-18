import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fitness_dashboard/core/dio_services/api_end_point.dart';
import 'package:fitness_dashboard/core/dio_services/dio.dart';
import 'package:fitness_dashboard/core/error/failure.dart';

class AuthRepositary {
  // Future<Either<Failure, Map<String, dynamic>>> regsterData(
  //   String userName,
  //   String email,
  //   String password,
  // ) async {
  //   final response = await DioService.postData(
  //     url: ApiEndPoints.register,
  //     body: {"name": userName, "email": email, "password": password},
  //   );

  //   late Map<String, dynamic> data;
  //   if (response.data is String) {
  //     data = jsonDecode(response.data);
  //   } else {
  //     data = Map<String, dynamic>.from(response.data);
  //   }
  //   if (data['status'] == 'success') {
  //     return Right(Map<String, dynamic>.from(data['data']));
  //   } else {
  //     return Left(ServerFailure("Registration failed"));
  //   }
  // }

  Future<Either<Failure, List<Map<String, dynamic>>>> loginData(
    String email,
    String password,
  ) async {
    try {
      final response = await DioService.postData(
        url: ApiEndPoints.login,
        body: {"email": email, "password": password},
      );
      late Map<String, dynamic> data;
      if (response.data is String) {
        data = jsonDecode(response.data);
      } else {
        data = Map<String, dynamic>.from(response.data);
      }
      // userTableName = data['name'];
      if (data['status'] == 'success') {
        if (data.containsKey('data')) {
          if (data['data'] is List) {
            final convertedData = List<Map<String, dynamic>>.from(data['data']);
            return Right(convertedData);
          } else if (data['data'] is Map) {
            final convertedData = [Map<String, dynamic>.from(data['data'])];
            return Right(convertedData);
          }
        }
        return Right([]);
      } else {
        return Left(ServerFailure("Error Of Getting Failed."));
      }
    } catch (error) {
      return Left(ServerFailure("Error: ${error.toString()}"));
    }
  }
}
