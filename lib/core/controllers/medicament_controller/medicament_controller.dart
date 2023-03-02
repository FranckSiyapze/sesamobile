import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/core/models/medicaments/medicament.dart';
import 'package:sesa/core/models/medicaments/medicament_data.dart';
import 'package:sesa/core/services/api_service.dart';

final medocsControllerDataProvider =
    StateNotifierProvider<MedicamentsController>((ref) {
  return MedicamentsController();
});

class MedicamentsController extends StateNotifier<MedicamentData> {
  MedicamentsController([MedicamentData? state])
      : super(state ?? MedicamentData.inital()) {
    getCategories();
  }
  final ApiService _apiService = ApiService();
  Future<void> getCategories() async {
    List<Medicament> medicaments = [];
    var dataFinal;
    try {
      dataFinal = await _apiService.getMedicaments();
      print("the data : ${dataFinal["data"]}");
      if (dataFinal["status"] == 200) {
        //Map<String, dynamic> _data = dataFinal;
        medicaments = dataFinal["data"].map<Medicament>((_item) {
          return Medicament.fromJson(_item);
        }).toList();
        if (medicaments.isNotEmpty) {
          state = state.copyWith(
            asError: state.asError,
            medicaments: [...state.medicaments, ...medicaments],
            asData: state.asData,
          );
        } else {
          state = state.copyWith(
            asError: state.asError,
            medicaments: [],
            asData: !state.asData,
          );
        }
      } else {
        state = state.copyWith(
          asError: !state.asError,
          medicaments: [],
          asData: !state.asData,
        );
      }
      print("the state is doctors : $state");
    } catch (e) {
      print(e);
    }
  }
}
