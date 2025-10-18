import 'package:equatable/equatable.dart';
import 'package:fitness_dashboard/data/model/Offer_model.dart';

sealed class OfferState extends Equatable {
  const OfferState();
  @override
  List<Object?> get props => [];
}

final class OfferStateInitial extends OfferState {
  final bool isLoading;
  const OfferStateInitial({required this.isLoading});
  @override
  List<Object?> get props => [isLoading];
}

final class OfferStateLoading extends OfferState {
  const OfferStateLoading();
  @override
  List<Object?> get props => [];
}

final class OfferStateLoaded extends OfferState {
  final List<OfferModel> listOfferModel;
  const OfferStateLoaded({required this.listOfferModel});
  @override
  List<Object?> get props => [];
}

final class OfferStateFailure extends OfferState {
  final String message;
  @override
  List<Object?> get props => [message];
  const OfferStateFailure(this.message);
}
