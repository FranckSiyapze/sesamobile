import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/core/models/prestations/prestation.dart';
import 'package:sesa/core/models/prestations/prestation_data.dart';
import 'package:sesa/core/services/api_service.dart';

final prestationsControllerDataProvider =
    StateNotifierProvider<PrestationController>((ref) {
  return PrestationController();
});

class PrestationController extends StateNotifier<PrestationData> {
  PrestationController([PrestationData? state])
      : super(state ?? PrestationData.inital()) {
    getCategories();
  }
  final ApiService _apiService = ApiService();
  Future<void> getCategories() async {
    List<Prestation> userDoctors = [];
    var dataFinal;
    try {
      dataFinal = await _apiService.getPrestations();
      print("the data : ${dataFinal["data"]}");
      if (dataFinal["status"] == 200) {
        //Map<String, dynamic> _data = dataFinal;
        userDoctors = dataFinal["data"].map<Prestation>((_item) {
          return Prestation.fromJson(_item);
        }).toList();
        if (userDoctors.isNotEmpty) {
          state = state.copyWith(
            asError: state.asError,
            prestations: [...state.prestations, ...userDoctors],
            asData: state.asData,
          );
        } else {
          state = state.copyWith(
            asError: state.asError,
            prestations: [],
            asData: !state.asData,
          );
        }
      } else {
        state = state.copyWith(
          asError: !state.asError,
          prestations: [],
          asData: !state.asData,
        );
      }
      print("the state is doctors : $state");
    } catch (e) {
      print(e);
    }
  }
}
