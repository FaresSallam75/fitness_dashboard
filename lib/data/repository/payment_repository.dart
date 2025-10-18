import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fitness_dashboard/core/dio_services/api_end_point.dart';
import 'package:fitness_dashboard/core/dio_services/dio.dart';
import 'package:fitness_dashboard/core/error/failure.dart';

class PaymentRepository {
  const PaymentRepository();

  Future<Either<Failure, List<Map<String, dynamic>>>> addPaymentData(
    String userId,
    String adminId,
    String price,
    String startDate,
    String endDate,
    String type,
  ) async {
    final response = await DioService.postData(
      url: ApiEndPoints.addPayment,
      body: {
        "userId": userId,
        "adminId": adminId,
        "price": price,
        "startDate": startDate,
        "endDate": endDate,
        "type": type,
      },
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
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> viewPaymentData() async {
    final response = await DioService.postData(
      url: ApiEndPoints.viewPayment,
      body: {},
    );
    late Map<String, dynamic> data;
    if (response.data is String) {
      data = jsonDecode(response.data);
    } else {
      data = Map<String, dynamic>.from(response.data);
    }
    if (data['status'] == 'success') {
      final convertedData = List<Map<String, dynamic>>.from(data['data']);
      log("Payment Data ============= $convertedData");
      return Right(convertedData);
    } else {
      return Left(ServerFailure("Error Of Getting Data."));
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> viewTotlaPrice() async {
    final response = await DioService.postData(
      url: ApiEndPoints.viewTotalPrice,
      body: {},
    );
    late Map<String, dynamic> data;
    if (response.data is String) {
      data = jsonDecode(response.data);
    } else {
      data = Map<String, dynamic>.from(response.data);
    }
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
      return Left(ServerFailure("Error Of Getting Data."));
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getCountCoaches() async {
    final response = await DioService.postData(
      url: ApiEndPoints.countCoaches,
      body: {},
    );
    late Map<String, dynamic> data;
    if (response.data is String) {
      data = jsonDecode(response.data);
    } else {
      data = Map<String, dynamic>.from(response.data);
    }
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
      return Left(ServerFailure("Error Of Getting Data."));
    }
  }
}
