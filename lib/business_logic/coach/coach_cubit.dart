import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fitness_dashboard/business_logic/coach/coach_state.dart';
import 'package:fitness_dashboard/data/model/coach_model.dart';
import 'package:fitness_dashboard/data/repository/coach_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class CoachCubit extends Cubit<CoachState> {
  final CoachRepository coachRepository;
  CoachCubit(this.coachRepository) : super(CoachStateInitial(isLoading: false));

  List<CoachModel> listCoachModel = [];
  File? file;
  bool isLoading = false;
  bool isShow = false;
  String? imageName;
  Uint8List? fileBytes;

  void changeStatusLoading() {
    final currentState = state;
    if (currentState is CoachStateInitial) {
      final current = currentState.isLoading;
      emit(CoachStateInitial(isLoading: !current));
    }
  }

  void setLoading(bool value) {
    emit(CoachStateInitial(isLoading: value));
    isShow = true;
  }

  void getAllCoaches() async {
    emit(CoachStateLoading());

    final result = await coachRepository.getCoachesData();
    result.fold(
      (failure) {
        emit(CoachStateFailure(failure.message));
      },
      (userData) async {
        listCoachModel.clear();
        listCoachModel = userData
            .map<CoachModel>((data) => CoachModel.fromJson(data))
            .toList();
        emit(CoachStateLoaded(listCoachModel: listCoachModel));
      },
    );
  }

  refresh() {
    emit(CoachStateLoading());
    getAllCoaches();
  }

  void addCoaches(
    String name,
    String email,
    String password,
    String phone,
    String gender,
    String age,
    String twon, [
    File? file,
  ]) async {
    emit(CoachStateLoading());
    final result = await coachRepository.addCoachesData(
      name,
      email,
      password,
      phone,
      gender,
      age,
      twon,
      fileBytes,
      imageName,
    );
    result.fold(
      (failure) {
        emit(CoachStateFailure(failure.message));
      },
      (_) async {
        // emit(CoachStateLoading());
        getAllCoaches();
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
      // setLoading(true);
      changeStatusLoading();

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
        // setLoading(false);
        changeStatusLoading();
      });
    }

    log("result names ================== ${result.names}");
    log("imageName ================== $imageName");
  }
}
