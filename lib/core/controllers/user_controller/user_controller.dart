import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sesa/core/models/doctors/user.dart';
import 'package:sesa/core/models/doctors/user_data.dart';
import 'package:sesa/core/services/api_service.dart';

final authProvider = StateNotifierProvider<LoginDataController>((ref) {
  return LoginDataController();
});

class LoginDataController extends StateNotifier<UserData> {
  final storage = FlutterSecureStorage();
  LoginDataController([UserData? state]) : super(state ?? UserData.inital()) {
    getUser();
  }
  final ApiService _apiService = ApiService();

  Future getUser() async {
    final readStorage = await storage.read(key: "email");
    print(readStorage);
    try {
      UserDoctor _user;
      var dataFinal;
      // ignore: unnecessary_null_comparison

      dataFinal = await _apiService.getMe();
      if (dataFinal["status"] == 200) {
        _user = UserDoctor.fromJson(dataFinal["data"]);
        state = state.copyWith(
          user: _user,
          asData: true,
          isError: state.isError,
        );
      } else {
        state = state.copyWith(
          user: state.user,
          asData: false,
          isError: !state.isError,
        );
      }

      print("Value State : " + state.toString());
      /* if (_response.data["data"] != null) {
      _user = User.fromJson(_response.data["data"]);
    } */
      ;

      //print("Testtttttttttttt" + state.toString());
    } catch (e) {
      print("Catch error : " + e.toString());
    }
  }
}
