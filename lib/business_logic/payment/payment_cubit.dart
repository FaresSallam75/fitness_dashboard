import 'dart:developer';
import 'package:fitness_dashboard/business_logic/payment/payment_state.dart';
import 'package:fitness_dashboard/data/model/payment_model.dart';
import 'package:fitness_dashboard/data/repository/payment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository paymentRepository;
  PaymentCubit(this.paymentRepository)
    : super(PaymentStateInitial(isRefresh: false));

  List<PaymentModel> listPayments = [];
  int? totalPrice;
  int? countCoaches;

  void changeStatusLoading() {
    final currentState = state;
    if (currentState is PaymentStateInitial) {
      final current = currentState.isRefresh;
      emit(PaymentStateInitial(isRefresh: !current));
    }
  }

  void setLoading(bool value) {
    emit(PaymentStateInitial(isRefresh: value));
  }

  Future<void> viewPayment() async {
    listPayments.clear();
    final result = await paymentRepository.viewPaymentData();
    result.fold(
      (failure) {
        emit(PaymentStateFailure(message: failure.message));
      },
      (userData) {
        listPayments = userData
            .map<PaymentModel>((data) => PaymentModel.fromJson(data))
            .toList();
        emit(PaymentStateLoaded(listPaymentModel: listPayments));
        log("listPayments ===================== $listPayments");
      },
    );
  }

  Future<void> addPayment(
    String usersId,
    String admind,
    String price,
    String startDate,
    String endDate,
    String type,
  ) async {
    emit(PaymentStateLoading());

    final result = await paymentRepository.addPaymentData(
      usersId,
      admind,
      price,
      startDate,
      endDate,
      type,
    );
    result.fold(
      (failure) {
        emit(PaymentStateFailure(message: failure.message));
      },
      (userData) async {
        await viewPayment();
        await getTotlaPrice();
      },
    );
  }

  Future<void> getTotlaPrice() async {
    emit(PaymentStateLoading());
    final result = await paymentRepository.viewTotlaPrice();
    result.fold(
      (failure) {
        emit(PaymentStateFailure(message: failure.message));
      },
      (userData) {
        totalPrice = int.parse(userData[0]['totalPrice'] ?? 0);
        setLoading(true);
        log("totalPrice ========================== $totalPrice");
      },
    );
  }

  void getCountCoaches() async {
    emit(PaymentStateLoading());
    final result = await paymentRepository.getCountCoaches();
    result.fold(
      (failure) {
        emit(PaymentStateFailure(message: failure.message));
      },
      (userData) {
        countCoaches = userData[0]['countCoaches'];
        setLoading(true);
        log("countCoaches ======================== $countCoaches");
      },
    );
  }
}
