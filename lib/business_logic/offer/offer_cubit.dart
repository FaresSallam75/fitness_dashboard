import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fitness_dashboard/business_logic/offer/coach_state.dart';
import 'package:fitness_dashboard/data/model/Offer_model.dart';
import 'package:fitness_dashboard/data/repository/Offer_repository.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class OfferCubit extends Cubit<OfferState> {
  final OfferRepository offerRepository;
  OfferCubit(this.offerRepository) : super(OfferStateInitial(isLoading: false));

  List<OfferModel> listOfferModel = [];
  File? file;
  bool isLoading = false;
  bool isShow = false;
  String? imageName;
  Uint8List? fileBytes;

  void changeStatusLoading() {
    final currentState = state;
    if (currentState is OfferStateInitial) {
      final current = currentState.isLoading;
      emit(OfferStateInitial(isLoading: !current));
    }
  }

  void setLoading(bool value) {
    emit(OfferStateInitial(isLoading: value));
    isShow = true;
  }

  void getAllOffers() async {
    emit(OfferStateLoading());

    final result = await offerRepository.getAllOffersData();
    result.fold(
      (failure) {
        emit(OfferStateFailure(failure.message));
      },
      (userData) async {
        listOfferModel.clear();
        listOfferModel = userData
            .map<OfferModel>((data) => OfferModel.fromJson(data))
            .toList();
        emit(OfferStateLoaded(listOfferModel: listOfferModel));
      },
    );
  }

  refresh() {
    emit(OfferStateLoading());
    getAllOffers();
  }

  void addOfferes(String name, String period, String price) async {
    emit(OfferStateLoading());
    final result = await offerRepository.addOfferData(
      name,
      period,
      price,
      fileBytes,
      imageName,
    );
    result.fold(
      (failure) {
        emit(OfferStateFailure(failure.message));
      },
      (_) async {
        // emit(OfferStateLoading());
        getAllOffers();
      },
    );
  }

  Future<void> chooseFileFromPC() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) {
      // User canceled file picker
      return;
    } else {
      isLoading = true;
      setLoading(true);
      // changeStatusLoading();

      if (kIsWeb) {
        // On web: no path, use bytes
        fileBytes = result.files.single.bytes;
        imageName = result.files.single.name;
      } else {
        // On desktop/mobile: use File
        file = File(result.files.single.path!);
        fileBytes = await file!.readAsBytes(); // so you always have Uint8List
        imageName = path.basename(file!.path);
      }

      Timer(Duration(seconds: 4), () {
        isLoading = false;
        setLoading(false);
        // changeStatusLoading();
      });
    }

    log("result names ================== ${result.names}");
    log("imageName ================== $imageName");
  }
}
