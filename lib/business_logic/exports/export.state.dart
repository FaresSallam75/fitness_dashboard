import 'package:equatable/equatable.dart';
import 'package:fitness_dashboard/data/model/export_model.dart';

sealed class ExportState extends Equatable {
  const ExportState();
  @override
  List<Object?> get props => [];
}

class ExportStateInitial extends ExportState {
  final bool isRefresh;

  const ExportStateInitial({required this.isRefresh});
  @override
  List<Object?> get props => [isRefresh];
}

class ExportStateLoading extends ExportState {
  const ExportStateLoading();
  @override
  List<Object?> get props => [];
}

class ExportStateLoaded extends ExportState {
  final List<ExportModel> listExportModel;
  const ExportStateLoaded({required this.listExportModel});
  @override
  List<Object?> get props => [];
}

class ExportStateFailure extends ExportState {
  final String message;
  const ExportStateFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
