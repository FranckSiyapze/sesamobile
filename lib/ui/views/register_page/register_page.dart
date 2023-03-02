import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/core/services/firebase_service.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/storage.dart';
import 'package:sesa/ui/views/login_page/login_page.dart';
import 'package:sesa/ui/views/register_page/otp.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/text/text.dart';
import 'package:sesa/ui/widgets/text_field/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController name = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumer = TextEditingController();
  TextEditingController password = TextEditingController();
  late String fcmToken;
  ApiService apiService = ApiService();
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String selectedValue = "P";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Patient"), value: "P"),
      DropdownMenuItem(child: Text("Docteur"), value: "Dr"),
    ];
    return menuItems;
  }

  @override
  void initState() {
    super.initState();

    _messaging.getToken().then((value) {
      fcmToken = value!;
    });
  }

  bool signIn = false;
  FirebaseAuthenticate _firebaseAuthenticate = FirebaseAuthenticate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: FxSpacing.horizontal(16),
          child: ListView(
            children: [
              FxSpacing.height(100),
              Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/logo_dark.png'),
                  ),
                ),
              ),
              FxSpacing.height(24),
              Text("Nom"),
              FxTextField(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                controller: name,
                autoFocusedBorder: true,
                textFieldStyle: FxTextFieldStyle.outlined,
                textFieldType: FxTextFieldType.name,
                filled: true,
                fillColor: kPrimary.withAlpha(50),
                enabledBorderColor: kPrimary,
                focusedBorderColor: kPrimary,
                prefixIconColor: kPrimary,
                labelTextColor: kPrimary,
                cursorColor: kPrimary,
              ),
              FxSpacing.height(24),
              Text("Username"),
              FxTextField(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                controller: prenom,
                autoFocusedBorder: true,
                labelText: "USERNAME",
                textFieldStyle: FxTextFieldStyle.outlined,
                textFieldType: FxTextFieldType.name,
                filled: true,
                fillColor: kPrimary.withAlpha(50),
                enabledBorderColor: kPrimary,
                focusedBorderColor: kPrimary,
                prefixIconColor: kPrimary,
                labelTextColor: kPrimary,
                cursorColor: kPrimary,
              ),
              FxSpacing.height(24),
              Text("Adresse mail"),
              FxTextField(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                controller: email,
                autoFocusedBorder: true,
                textFieldStyle: FxTextFieldStyle.outlined,
                textFieldType: FxTextFieldType.email,
                filled: true,
                fillColor: kPrimary.withAlpha(50),
                enabledBorderColor: kPrimary,
                focusedBorderColor: kPrimary,
                prefixIconColor: kPrimary,
                labelTextColor: kPrimary,
                cursorColor: kPrimary,
              ),
              FxSpacing.height(24),
              Text("Mot de passe"),
              FxTextField(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                controller: password,
                autoFocusedBorder: true,
                textFieldStyle: FxTextFieldStyle.outlined,
                textFieldType: FxTextFieldType.password,
                filled: true,
                fillColor: kPrimary.withAlpha(50),
                enabledBorderColor: kPrimary,
                focusedBorderColor: kPrimary,
                prefixIconColor: kPrimary,
                labelTextColor: kPrimary,
                cursorColor: kPrimary,
              ),
              FxSpacing.height(24),
              Text("Numero de telephone"),
              FxTextField(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                controller: phoneNumer,
                autoFocusedBorder: true,
                textFieldStyle: FxTextFieldStyle.outlined,
                textFieldType: FxTextFieldType.mobileNumber,
                filled: true,
                fillColor: kPrimary.withAlpha(50),
                enabledBorderColor: kPrimary,
                focusedBorderColor: kPrimary,
                prefixIconColor: kPrimary,
                labelTextColor: kPrimary,
                cursorColor: kPrimary,
              ),
              FxSpacing.height(16),
              FxButton.block(
                borderRadiusAll: 8,
                onPressed: () {
                  /* Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OTPPage()),
                  ); */
                  setState(() {
                    signIn = true;
                  });
                  apiService
                      .signUp(
                    email: email.text,
                    password: password.text,
                    tel1: "+237${phoneNumer.text}",
                    username: prenom.text,
                    firstName: name.text,
                  )
                      .then((value) {
                    if (value["status"] == 201) {
                      setState(() {
                        signIn = false;
                      });
                      registerFirebase(
                          email: email.text,
                          fcmToken: fcmToken,
                          name: name.text,
                          password: "",
                          phoneNumer: int.parse(phoneNumer.text),
                          prenom: "",
                          profile: "P");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtpPage(
                                  phone: "+237${phoneNumer.text}",
                                )),
                      );
                    } else {
                      setState(() {
                        signIn = false;
                      });
                      Fluttertoast.showToast(
                        msg: value["message"],
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 5,
                        backgroundColor: kRedColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  });
                  /* _firebaseAuthenticate
                      .registerWithEmailAndPassword(
                          name: name.text,
                          prenom: prenom.text,
                          email: email.text,
                          phoneNumer: int.parse(phoneNumer.text),
                          profile: "P",
                          password: password.text,
                          fcmToken: fcmToken)
                      .then((value) {
                    if (value["status"] == 200) {
                      setState(() {
                        signIn = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } else {
                      setState(() {
                        signIn = false;
                      });
                      Fluttertoast.showToast(
                        msg: "Une erreur est surevenue !",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 5,
                        backgroundColor: kRedColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  }); */
                },
                backgroundColor: kPrimary,
                child: !signIn
                    ? FxText.sh2(
                        "Creer votre compte",
                        fontWeight: 700,
                        color: KWhite,
                        letterSpacing: 0.4,
                      )
                    : CircularProgressIndicator(
                        color: KWhite,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerFirebase(
      {required String name,
      required String prenom,
      required String email,
      required int phoneNumer,
      required String profile,
      required String fcmToken,
      required String password}) async {
    //String uuid = Uuid().v4();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      FirebaseFirestore.instance.collection("users").doc(email).set({
        "uuid": email,
        "email": email,
        "name": "${name} ${prenom} ",
        "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
        "state": 1,
        "price": 0,
        "notes": 0,
        "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
        "fcmToken": fcmToken,
        "profile": profile,
        "paid": false,
      });
      /* setStorage("uuid", uuid);
      setStorage("name", user.lname!);
      setStorage("photo", defaultPhotoUrl); */
    }
  }
}
