import 'package:equatable/equatable.dart';
import 'package:fitness_dashboard/data/model/payment_model.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();
  @override
  List<Object?> get props => [];
}

class PaymentStateInitial extends PaymentState {
  final bool isRefresh;
  const PaymentStateInitial({required this.isRefresh});
  @override
  List<Object?> get props => [isRefresh];
}

class PaymentStateLoading extends PaymentState {
  const PaymentStateLoading();
  @override
  List<Object?> get props => [];
}

class PaymentStateLoaded extends PaymentState {
  final List<PaymentModel> listPaymentModel;
  const PaymentStateLoaded({required this.listPaymentModel});
  @override
  List<Object?> get props => [listPaymentModel];
}

class PaymentStateFailure extends PaymentState {
  final String message;
  const PaymentStateFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
