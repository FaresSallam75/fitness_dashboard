import 'dart:developer';

import 'package:fitness_dashboard/business_logic/exports/export.state.dart';
import 'package:fitness_dashboard/data/model/export_model.dart';
import 'package:fitness_dashboard/data/repository/export_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExportCubit extends Cubit<ExportState> {
  final ExportRepository exportRepository;
  ExportCubit(this.exportRepository)
    : super(ExportStateInitial(isRefresh: false));

  List<ExportModel> listExportModel = [];
  int? exportTotalPrice;

  void changeStatusLoading() {
    final currentState = state;
    if (currentState is ExportStateInitial) {
      final current = currentState.isRefresh;
      emit(ExportStateInitial(isRefresh: !current));
    }
    setLoading(true);
  }

  void setLoading(bool value) {
    emit(ExportStateInitial(isRefresh: value));
  }

  void getExportData() async {
    final response = await exportRepository.getExportData();
    response.fold(
      (failure) {
        emit(ExportStateFailure(message: failure.message));
      },
      (data) {
        listExportModel = data
            .map<ExportModel>((data) => ExportModel.fromJson(data))
            .toList();
        emit(ExportStateLoaded(listExportModel: listExportModel));
        log("listExportModel ================== $listExportModel");
      },
    );
  }

  void addExportData(
    String name,
    String count,
    String price,
    String adminId,
  ) async {
    final response = await exportRepository.addExportData(
      name,
      count,
      price,
      adminId,
    );
    response.fold(
      (failure) {
        emit(ExportStateFailure(message: failure.message));
      },
      (data) {
        getExportData();
      },
    );
  }

  void getExportTotlaPrice() async {
    emit(ExportStateLoading());
    final result = await exportRepository.viewExportsTotalPrice();
    result.fold(
      (failure) {
        emit(ExportStateFailure(message: failure.message));
      },
      (userData) {
        exportTotalPrice = int.parse(userData[0]['totalPrice'] ?? 0);

        log("exportTotalPrice ========================== $exportTotalPrice");
      },
    );
  }
}
