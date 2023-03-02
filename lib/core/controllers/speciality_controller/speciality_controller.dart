import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/core/models/doctors/speciality.dart';
import 'package:sesa/core/models/doctors/specility_data.dart';
import 'package:sesa/core/services/api_service.dart';

final specialityControllerDataProvider =
    StateNotifierProvider<SpecialityController>((ref) {
  return SpecialityController();
});

class SpecialityController extends StateNotifier<SpecialityData> {
  SpecialityController([SpecialityData? state])
      : super(state ?? SpecialityData.inital()) {
    getSpeciality();
  }
  final ApiService _apiService = ApiService();
  Future<void> getSpeciality() async {
    List<Speciality> userDoctors = [];
    var dataFinal;
    try {
      dataFinal = await _apiService.getSpeciality();
      print("the data : ${dataFinal["data"]}");
      if (dataFinal["status"] == 200) {
        //Map<String, dynamic> _data = dataFinal;
        userDoctors = dataFinal["data"].map<Speciality>((_item) {
          return Speciality.fromJson(_item);
        }).toList();
        if (userDoctors.isNotEmpty) {
          state = state.copyWith(
            asError: state.asError,
            specialitys: [...state.specialitys, ...userDoctors],
            asData: state.asData,
          );
        } else {
          state = state.copyWith(
            asError: state.asError,
            specialitys: [],
            asData: !state.asData,
          );
        }
      } else {
        state = state.copyWith(
          asError: !state.asError,
          specialitys: [],
          asData: !state.asData,
        );
      }
      print("the state is doctors : $state");
    } catch (e) {
      print(e);
    }
  }
}
