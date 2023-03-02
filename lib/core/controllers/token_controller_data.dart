import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:sesa/core/models/token.dart';

import '../services/api_service.dart';

final tokenProvider = StateNotifierProvider((ref) {
  return TokenGenerateController();
});

class TokenGenerateController extends StateNotifier<TokenGenerate> {
  TokenGenerateController([TokenGenerate? state])
      : super(state ?? TokenGenerate.inital()) {
    getToken();
  }
  final ApiService _apiService = GetIt.instance.get<ApiService>();
  Future getToken() async {
    //final readStorage = await storage.read(key: "email");
    try {
      TokenGenerate _token;
      Map dataFinal;
      _token = await _apiService.generateToken();
      state = _token;
      print("Provider Token" + state.toString());
    } catch (e) {
      print("Catch error : " + e.toString());
    }
  }
}
