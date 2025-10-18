import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
// ignore: implementation_imports
import 'package:dio/src/response.dart';
import 'package:fitness_dashboard/core/dio_services/api_end_point.dart';
import 'package:fitness_dashboard/core/dio_services/dio.dart';
import 'package:fitness_dashboard/core/error/failure.dart';

class CoachRepository {
  const CoachRepository();

  Future<Either<Failure, List<Map<String, dynamic>>>> getCoachesData() async {
    final response = await DioService.postData(
      url: ApiEndPoints.viewCoaches,
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

  Future<Either<Failure, List<Map<String, dynamic>>>> addCoachesData(
    String name,
    String email,
    String password,
    String phone,
    String gender,
    String age,
    String twon, [
    Uint8List? fileBytes, // allow nullable
    String? fileName,
  ]) async {
    try {
      final Response response;

      if (fileBytes == null) {
        // ✅ No image, just send normal data
        response = await DioService.postData(
          url: ApiEndPoints.addCoaches,
          body: {
            "name": name,
            "email": email,
            "password": password,
            "phone": phone,
            "gender": gender,
            "age": age,
            "twon": twon,
          },
        );
      } else {
        // ✅ Upload with image (web & mobile)
        response = await DioService.uploadImage(
          url: ApiEndPoints.addCoaches,
          data: {
            "name": name,
            "email": email,
            "password": password,
            "phone": phone,
            "gender": gender,
            "age": age,
            "twon": twon,
          },
          fileBytes: fileBytes,
          fileName: fileName ?? "upload.jpg",
        );
      }

      // ✅ Parse response
      late Map<String, dynamic> data;
      if (response.data is String) {
        data = jsonDecode(response.data);
      } else {
        data = Map<String, dynamic>.from(response.data);
      }

      if (data['status'] == 'success') {
        if (data['data'] != null && data['data'] is List) {
          final convertedData = List<Map<String, dynamic>>.from(data['data']);
          log("chats Data ============= $convertedData");
          return Right(convertedData);
        } else {
          return Right([]);
        }
      } else {
        return Left(ServerFailure("Error Of Getting Data."));
      }
    } catch (e) {
      log("Error In Chat Repository:============== $e");
      return Left(ServerFailure(e.toString()));
    }
  }
}
