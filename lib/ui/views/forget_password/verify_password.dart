import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/views/login_page/login_page.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/text/text.dart';
import 'package:sesa/ui/widgets/text_field/text_field.dart';

class VerifyPassword extends StatefulWidget {
  final String number;
  const VerifyPassword({
    Key? key,
    required this.number,
  }) : super(key: key);

  @override
  State<VerifyPassword> createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPassword> {
  TextEditingController password = TextEditingController();
  TextEditingController code = TextEditingController();
  ApiService _apiService = ApiService();
  bool signIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KWhite,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: KWhite,
        actions: [
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
                right: MediaQuery.of(context).size.width / 30),
            // ignore: prefer_const_constructors
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: const TextStyle(
                    color: kPrimary, fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: FxSpacing.horizontal(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 9,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Row(
                  children: [
                    Text(
                      "Veuillew saisir le\nnouveau mot de passe ",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 26,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Code OTP"),
              FxTextField(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                controller: code,
                autoFocusedBorder: true,
                textFieldStyle: FxTextFieldStyle.outlined,
                textFieldType: FxTextFieldType.mobileNumber,
                labelText: "CODE OTP",
                filled: true,
                fillColor: kPrimary.withAlpha(50),
                enabledBorderColor: kPrimary,
                focusedBorderColor: kPrimary,
                prefixIconColor: kPrimary,
                labelTextColor: kPrimary,
                cursorColor: kPrimary,
              ),
              SizedBox(
                height: 20,
              ),
              Text("Nouveau mot de passe"),
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
              Container(
                //height: 150,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                child: ListView(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  //scrollDirection: A,
                  children: [
                    ListTile(
                      leading: Text('\u2022'),
                      dense: true,
                      title: Text(
                        "Require that at least one digit appear anywhere in the string",
                        style: TextStyle(fontSize: 12, color: kRedColor),
                      ),
                      minLeadingWidth: 2,
                      horizontalTitleGap: 5.0,
                    ),
                    ListTile(
                      leading: Text('\u2022'),
                      dense: true,
                      title: Text(
                        "Require that at least one lowercase letter appear anywhere in the string",
                        style: TextStyle(fontSize: 12, color: kRedColor),
                      ),
                      minLeadingWidth: 2,
                      horizontalTitleGap: 5.0,
                    ),
                    ListTile(
                      leading: Text('\u2022'),
                      dense: true,
                      title: Text(
                        "Require that at least one uppercase letter appear anywhere in the string",
                        style: TextStyle(fontSize: 12, color: kRedColor),
                      ),
                      minLeadingWidth: 2,
                      horizontalTitleGap: 5.0,
                    ),
                    ListTile(
                      leading: Text('\u2022'),
                      dense: true,
                      title: Text(
                        'Require that at least one special character appear anywhere in the string [!@#\$%^&*(),.?":{}|<>/_-]',
                        style: TextStyle(fontSize: 12, color: kRedColor),
                      ),
                      minLeadingWidth: 2,
                      horizontalTitleGap: 5.0,
                    ),
                    ListTile(
                      leading: Text('\u2022'),
                      dense: true,
                      title: Text(
                        "The password must be at least 8 characters long, but no more than 32",
                        style: TextStyle(fontSize: 12, color: kRedColor),
                      ),
                      minLeadingWidth: 2,
                      horizontalTitleGap: 5.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              !signIn
                  ? FxButton.block(
                      borderRadiusAll: 8,
                      onPressed: () {
                        setState(() {
                          signIn = true;
                        });
                        _apiService
                            .validate(
                          id: widget.number,
                          code: code.text,
                          password: password.text,
                        )
                            .then((value) {
                          print(value);
                          if (value["status"] == 200) {
                            setState(() {
                              signIn = false;
                            });
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                            Fluttertoast.showToast(
                              msg: "Mot de passe modifié avec success !",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 5,
                              backgroundColor: kPrimary,
                              textColor: Colors.white,
                              fontSize: 16.0,
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
                        });
                      },
                      backgroundColor: kPrimary,
                      child: FxText.sh2(
                        "Verify",
                        fontWeight: 700,
                        color: KWhite,
                        letterSpacing: 0.4,
                      ),
                    )
                  : CircularProgressIndicator(
                      color: kPrimary,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
