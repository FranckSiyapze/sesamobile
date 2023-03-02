import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/core/models/pack_sesa/pack_categorie.dart';
import 'package:sesa/core/models/pack_sesa/pack_categorie_data.dart';
import 'package:sesa/core/services/api_service.dart';

final packCategoriesControllerDataProvider =
    StateNotifierProvider<PackCategoriesControlelr>((ref) {
  return PackCategoriesControlelr();
});

class PackCategoriesControlelr extends StateNotifier<PackCategorieData> {
  PackCategoriesControlelr([PackCategorieData? state])
      : super(state ?? PackCategorieData.inital()) {
    getCategories();
  }
  final ApiService _apiService = ApiService();
  Future<void> getCategories() async {
    List<PackCategorie> userDoctors = [];
    var dataFinal;
    try {
      dataFinal = await _apiService.getCategoriesPack();
      print("the data : ${dataFinal["data"]}");
      if (dataFinal["status"] == 200) {
        //Map<String, dynamic> _data = dataFinal;
        userDoctors = dataFinal["data"].map<PackCategorie>((_item) {
          return PackCategorie.fromJson(_item);
        }).toList();
        if (userDoctors.isNotEmpty) {
          state = state.copyWith(
            asError: state.asError,
            packCategories: [...state.packCategories, ...userDoctors],
            asData: true,
          );
        } else {
          state = state.copyWith(
            asError: state.asError,
            packCategories: [],
            asData: false,
          );
        }
      } else {
        state = state.copyWith(
          asError: !state.asError,
          packCategories: [],
          asData: !false,
        );
      }
      print("the state is doctors : $state");
    } catch (e) {
      print(e);
    }
  }
}
