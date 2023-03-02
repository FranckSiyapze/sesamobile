import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sesa/ui/utils/utils_firebase.dart';
import 'package:sesa/ui/views/login_page/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/utils/enum/user_state.dart';

class UserStateMethods {
  //late SharedPreferences preferences;
  late FlutterSecureStorage storage;

  void setUserState({required String userId, required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);
    FirebaseFirestore.instance.collection("users").doc(userId).update({
      "state": stateNum,
      "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Stream<DocumentSnapshot> getUserStream({required String uid}) =>
      FirebaseFirestore.instance.collection("users").doc(uid).snapshots();

  Future<Null> logoutuser(BuildContext context) async {
    //preferences = await SharedPreferences.getInstance();
    setUserState(
        userId: await storage.read(key: "uid"), userState: UserState.Offline);
    //await FirebaseAuth.instance.signOut();
    await storage.deleteAll();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }
}
