import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sesa/ui/utils/storage.dart';

class FirebaseAuthenticate {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future registerWithEmailAndPassword(
      {required String name,
      required String prenom,
      required String email,
      required int phoneNumer,
      required String profile,
      required String fcmToken,
      required String password}) async {
    Map dataFinal;
    try {
      print("********************************************");
      print('Email : $email \n mot de passe : $password');
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      result.user!.updateDisplayName(name);
      User? user = result.user;
      print(result.user!.uid);
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.email)
            .set({
          "uuid": user.email,
          "email": user.email,
          "name": name,
          "profile": profile,
          "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
          "state": 1,
          "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
          "fcmToken": fcmToken,
          "paid": false,
        });
        dataFinal = {
          "status": 200,
          "message": "Your feed was create successfully",
        };
        print('*************************success**********************');
        return dataFinal;
        //user.updateDisplayName(name);
      } else {
        dataFinal = {
          "status": 401,
          "message": "Une erreur s'est produite",
        };
        return dataFinal;
      }
      //return _userFromFirebaseUser(user);
    } catch (exception) {
      dataFinal = {
        "status": 500,
        "message": "Une erreur s'est produite",
      };
      print("Connection Timeout please restart the process");
      return dataFinal;
    }
  }

  void registerFirebase(User user) async {
    //String uuid = Uuid().v4();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: user.email)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      /* setStorage("uuid", uuid);
      setStorage("name", user.lname!);
      setStorage("photo", defaultPhotoUrl); */
    }
  }

  Future signIn({required String email, required String password}) async {
    Map dataFinal;
    try {
      print("********************************************");
      print('Email : $email \n mot de passe : $password');
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print(result.user!.uid);
      setStorage("email", email);
      FirebaseFirestore.instance
          .collection("users")
          .doc(email)
          .get()
          .then((datasnapshot) {
        print(datasnapshot.data()!["profile"]);
        setStorage("profile", datasnapshot.data()!["profile"]);
      });
      //setStorage("paid", value)
      if (user != null) {
        dataFinal = {
          "status": 200,
          "message": "Your feed was create successfully",
        };
        return dataFinal;
      } else {
        dataFinal = {
          "status": 401,
          "message": "Une erreur s'est produite",
        };
        return dataFinal;
      }
      //return _userFromFirebaseUser(user);
    } catch (exception) {
      print(exception);
      dataFinal = {
        "status": 500,
        "message": "Une erreur s'est produite",
      };
      print("Connection Timeout please restart the process");
      return dataFinal;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _auth.signOut();
  }
}
