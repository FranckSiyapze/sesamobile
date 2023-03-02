import 'package:flutter/material.dart';
import 'package:sesa/core/services/api_service.dart';

import 'package:sesa/ui/utils/Size.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/views/login_page/login_page.dart';
import 'package:sesa/ui/widgets/otpInput.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  const OtpPage({
    Key? key,
    required this.phone,
  }) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  int currentStep = 1;
  int stepLength = 0;
  bool complete = false;
  bool _verify = false;
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Row(
                children: [
                  Text(
                    "To help, ",
                    //"${AppLocalizations.of(context)!.follow}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 26,
                    ),
                  ),
                  Text(
                    'You',
                    //"${AppLocalizations.of(context)!.follow}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Color(0xFF7e57c2),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 150,
              ),
              Text(
                'Saisissez le code de confirmation à 4 chiffres',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              Text(
                'que vous avez reçu par sms ',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / kSepartion,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OtpInput(_fieldOne, true),
                    OtpInput(_fieldTwo, false),
                    OtpInput(_fieldThree, false),
                    OtpInput(_fieldFour, false),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _verify = true;
                  });
                  String code = _fieldOne.text +
                      _fieldTwo.text +
                      _fieldThree.text +
                      _fieldFour.text;
                  apiService
                      .validateAccount(code: code, tel: widget.phone)
                      .then((value) {
                    if (value["status"] == 200) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    } else {
                      final snackBar = SnackBar(
                        content: Text("Une erreur est survenue"),
                      );
                      setState(() {
                        _verify = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            kButton,
                            kButton,
                            kButton,
                          ])),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: (_verify == false)
                        ? Text(
                            'Verify',
                            style: TextStyle(
                                color: KWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          )
                        : CircularProgressIndicator(
                            color: KWhite,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
