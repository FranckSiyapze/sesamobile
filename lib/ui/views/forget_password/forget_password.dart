import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/views/forget_password/verify_password.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/text/text.dart';
import 'package:sesa/ui/widgets/text_field/text_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController phone = TextEditingController();
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
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 9,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Row(
                  children: [
                    Text(
                      "Donner nous votre numero\nde téléphone, ",
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
              FxTextField(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                controller: phone,
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
              !signIn
                  ? FxButton.block(
                      borderRadiusAll: 8,
                      onPressed: () {
                        String utype = "";
                        setState(() {
                          signIn = true;
                        });
                        _apiService
                            .forgetPassword(
                          id: phone.text,
                        )
                            .then((value) {
                          print(value);
                          if (value["status"] == 200) {
                            setState(() {
                              signIn = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifyPassword(
                                  number: phone.text,
                                ),
                              ),
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
