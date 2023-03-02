import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/core/models/doctors/doctor_data.dart';
import 'package:sesa/core/models/doctors/user.dart';
import 'package:sesa/core/services/api_service.dart';

final doctorsControllerDataProvider =
    StateNotifierProvider<DoctorsController>((ref) {
  return DoctorsController();
});

final patientControllerDataProvider =
    StateNotifierProvider<PatientController>((ref) {
  return PatientController();
});

class DoctorsController extends StateNotifier<DoctorData> {
  DoctorsController([DoctorData? state]) : super(state ?? DoctorData.inital()) {
    getDoctors();
  }
  final ApiService _apiService = ApiService();
  Future<void> getDoctors() async {
    List<UserDoctor> userDoctors = [];
    var dataFinal;
    try {
      dataFinal = await _apiService.getDoctors();
      print("the data : ${dataFinal["data"]}");
      if (dataFinal["status"] == 200) {
        //Map<String, dynamic> _data = dataFinal;
        userDoctors = dataFinal["data"].map<UserDoctor>((_item) {
          return UserDoctor.fromJson(_item);
        }).toList();
        if (userDoctors.isNotEmpty) {
          state = state.copyWith(
            asError: state.asError,
            doctors: [...state.doctors, ...userDoctors],
            asData: true,
          );
        } else {
          state = state.copyWith(
            asError: true,
            doctors: [],
            asData: false,
          );
        }
      } else {
        state = state.copyWith(
          asError: true,
          doctors: [],
          asData: false,
        );
      }
      print("the state is doctors : $state");
    } catch (e) {
      print(e);
    }
  }
}

class PatientController extends StateNotifier<DoctorData> {
  PatientController([DoctorData? state]) : super(state ?? DoctorData.inital()) {
    getDoctors();
  }
  final ApiService _apiService = ApiService();
  Future<void> getDoctors() async {
    List<UserDoctor> userDoctors = [];
    var dataFinal;
    try {
      dataFinal = await _apiService.getPatient();
      print("the data : ${dataFinal["data"]}");
      if (dataFinal["status"] == 200) {
        //Map<String, dynamic> _data = dataFinal;
        userDoctors = dataFinal["data"].map<UserDoctor>((_item) {
          return UserDoctor.fromJson(_item);
        }).toList();
        if (userDoctors.isNotEmpty) {
          state = state.copyWith(
            asError: state.asError,
            doctors: [...state.doctors, ...userDoctors],
            asData: state.asData,
          );
        } else {
          state = state.copyWith(
            asError: state.asError,
            doctors: [],
            asData: !state.asData,
          );
        }
      } else {
        state = state.copyWith(
          asError: !state.asError,
          doctors: [],
          asData: !state.asData,
        );
      }
      print("the state is patient : $state");
    } catch (e) {
      print(e);
    }
  }
}
