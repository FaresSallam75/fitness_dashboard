import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fitness_dashboard/core/dio_services/api_end_point.dart';
import 'package:fitness_dashboard/core/dio_services/dio.dart';
import 'package:fitness_dashboard/core/error/failure.dart';

class ExportRepository {
  const ExportRepository();

  Future<Either<Failure, List<Map<String, dynamic>>>> getExportData() async {
    final response = await DioService.postData(
      url: ApiEndPoints.viewExports,
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
      log("Data ============= $convertedData");
      return Right(convertedData);
    } else {
      return Left(ServerFailure("Error Of Getting Data."));
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> addExportData(
    String name,
    String count,
    String price,
    String adminId,
  ) async {
    final response = await DioService.postData(
      url: ApiEndPoints.addExports,
      body: {"name": name, "count": count, "price": price, "adminId": adminId},
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

  Future<Either<Failure, List<Map<String, dynamic>>>>
  viewExportsTotalPrice() async {
    final response = await DioService.postData(
      url: ApiEndPoints.viewExportsTotalPrice,
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
