import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/doctors/user.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/core/services/firebase_service.dart';
import 'package:sesa/main.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/storage.dart';
import 'package:sesa/ui/utils/themes/text_style.dart';
import 'package:sesa/ui/views/forget_password/forget_password.dart';
import 'package:sesa/ui/views/login_page/otp_page.dart';
import 'package:sesa/ui/views/main_page.dart';
import 'package:sesa/ui/views/register_page/registDoctor.dart';
import 'package:sesa/ui/views/register_page/register_page.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/text/text.dart';
import 'package:sesa/ui/widgets/text_field/text_field.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ApiService _apiService = ApiService();
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  bool signIn = false;
  FirebaseAuthenticate _firebaseAuthenticate = FirebaseAuthenticate();
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: FxSpacing.horizontal(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  FxTextField(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    controller: pwd,
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
                  FxSpacing.height(16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FxButton.text(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPassword(),
                            ),
                          );
                        },
                        splashColor: kPrimary.withAlpha(40),
                        child: Text(
                          "Mot de passe oublié",
                          style: FxTextStyle.caption(color: kPrimary),
                        )),
                  ),
                  FxSpacing.height(16),
                  !signIn
                      ? FxButton.block(
                          borderRadiusAll: 8,
                          onPressed: () {
                            String utype = "";
                            setState(() {
                              signIn = true;
                            });
                            _apiService
                                .login(email: email.text, pwd: pwd.text)
                                .then((value) {
                              print(value);
                              if (value["status"] == 200) {
                                setStorage(
                                    "bearer", value["data"]["bearerToken"]);
                                setStorage("refreshToken",
                                    value["data"]["refreshToken"]);
                                _apiService.getMe().then((value1) {
                                  if (value1["status"] == 200) {
                                    print(value1["data"]);
                                    UserDoctor user =
                                        UserDoctor.fromJson(value1["data"]);
                                    print(user);
                                    setStorage("email", user.email);
                                    if (user.roles.length == 1) {
                                      utype = "P";
                                    } else {
                                      utype = "Dr";
                                    }
                                    print(utype);
                                    setStorage("loginstatus", "loggedin");
                                    setStorage("utype", utype);
                                    context.refresh(authProvider);
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => MainPage(
                                          uuid: email.text,
                                          utype: utype,
                                        ),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                    /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainPage(
                                      uuid: email.text,
                                      utype: utype,
                                    ),
                                  ),
                                ); */
                                  } else {
                                    setState(() {
                                      signIn = false;
                                    });
                                    Fluttertoast.showToast(
                                      msg: value1["message"],
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: kRedColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                });
                                /* setState(() {
                              signIn = false;
                            });
                             */
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
                          },
                          backgroundColor: kPrimary,
                          child: FxText.sh2(
                            "LOG IN",
                            fontWeight: 700,
                            color: KWhite,
                            letterSpacing: 0.4,
                          ),
                        )
                      : CircularProgressIndicator(
                          color: kPrimary,
                        ),
                  FxSpacing.height(16),
                  FxButton.text(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    splashColor: kPrimary.withAlpha(40),
                    child: FxText.button("I haven\'t an account",
                        decoration: TextDecoration.underline, color: kPrimary),
                  ),
                  FxSpacing.height(16),
                  /* FxButton.text(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPageDoctor(),
                        ),
                      );
                    },
                    splashColor: kPrimary.withAlpha(40),
                    child: FxText.button("I haven\'t an account Doctor",
                        decoration: TextDecoration.underline, color: kPrimary),
                  ), */
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
