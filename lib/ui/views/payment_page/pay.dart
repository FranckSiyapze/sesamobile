import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/doctors/user_data.dart';
import 'package:sesa/core/services/api.dart';
import 'package:sesa/core/services/api_service.dart';

import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/main_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class PayCheckout extends StatefulWidget {
  final String details;
  final String amount;
  final List data;
  const PayCheckout({
    Key? key,
    required this.details,
    required this.amount,
    required this.data,
  }) : super(key: key);

  @override
  State<PayCheckout> createState() => _PayCheckoutState();
}

class _PayCheckoutState extends State<PayCheckout> {
  late CustomAppTheme customAppTheme;
  bool _isLoading = true;
  String currency = "";
  var uuid = Uuid();
  late Timer _timer;
  int _start = 10;
  final numberController = TextEditingController();
  late Api apiservice = Api();
  late ApiService _apiService = ApiService();
  late UserData auth;
  /*  _onAlertFinalPay(context, meanCode, feesAmout, total, orderNumber) {
    var priceFinal = int.parse(total) + feesAmout;
    Alert(
        context: context,
        title: "Montant total : " + (priceFinal).toString() + " " + currency,
        content: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            TextField(
              decoration: const InputDecoration(
                icon: Icon(Icons.phone),
                labelText: 'Numero de téléphone',
              ),
              controller: numberController,
            )
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.white,
            onPressed: () {},
            child: ProgressButton(
              progressIndicatorColor: Colors.white,
              color: Color.fromRGBO(90, 144, 53, 1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              strokeWidth: 2,
              child: const Text(
                "Valider le paiement",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onPressed: (AnimationController controller) async {
                FocusScope.of(context).requestFocus(FocusNode());
                requestToPay(total, meanCode, numberController.text,
                    orderNumber, feesAmout);
              },
            ),
          ),
        ]).show();
  } */

  savePayment(String details, String amount) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("payment")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      await FirebaseFirestore.instance
          .collection("payment")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set({
        "uuid": FirebaseAuth.instance.currentUser!.email,
        "details": details,
        "amount": amount,
        "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
        "updatedAt": DateTime.now().millisecondsSinceEpoch.toString(),
      });
    } else {
      await FirebaseFirestore.instance
          .collection("payment")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        "details": details,
        "amount": amount,
        "updatedAt": DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }
  }

  checkStatus(
    adpFootprint,
    meanCode,
  ) {
    var message = '';

    int modePay = (meanCode == "ORANGE-MONEY")
        ? 1
        : (meanCode == "MOBILE-MONEY")
            ? 2
            : (meanCode == "EXPRESS-UNION")
                ? 3
                : 4;
    apiservice.getADPToken().then((value1) async {
      if (!mounted) return;
      setState(() {
        //print(value["data"]["tokenCode"]);

        _apiService
            .chcekStatus(
                modePayId: modePay,
                adpFootprint: adpFootprint,
                tokenCode: value1["data"]["tokenCode"])
            .then((value) {
          if (value["data"] != null) {
            print(value["data"]);
            if (value["data"]["status"] == 'T') {
              /* context.showSuccessBar(
                  content: Text('Paiement réussi avec succès')); */
              setState(() {
                startPay = true;
              });
              Fluttertoast.showToast(
                msg: 'Paiement effectué avec success',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: kPrimary,
              );
              //savePayment(widget.details, widget.amount);
              /* await FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .update({'paid': true}).then((value) {
                setState(() {
                  _start = 0;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(
                      uuid: FirebaseAuth.instance.currentUser!.email!,
                      utype: (auth.user.roles.length == 1) ? "P" : "Dr",
                    ),
                  ),
                );
              }).catchError(
                      (error) => print("Failed to update user paid: $error")); */

              //controller.reset();
              print("delay end");
              //AddTrip();
              /****
               * C'est ici qu'on impelemente
               * la rédirection sur la page de réussite du paiement
               * */
            } else if (value["data"]["status"] != 'E') {
              setState(() {
                startPay = true;
              });
              message = value["data"]["description"];
              if (value["data"]["status"] != 'O') {
                message = "La transaction n'a pas été effectué";
              }
              setState(() {
                _start = 0;
              });
              //context.showErrorBar(content: Text(message));
              Fluttertoast.showToast(
                msg: '${message}',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: kRedColor,
              );
              //controller.reset();
              print("delay end");
              /****
               * C'est ici qu'on impelemente
               * Une action lorsqu'il y'a une erreur de paiement
               * */
            }
          }
        });
        /* apiservice
            .checkStatus(value1["data"]["tokenCode"], meanCode, adpFootprint)
            .then((value) async {
          if (value["data"] != null) {
            print(value["data"]);
            if (value["data"]["status"] == 'T') {
              /* context.showSuccessBar(
                  content: Text('Paiement réussi avec succès')); */
              setState(() {
                startPay = true;
              });
              //savePayment(widget.details, widget.amount);
              /* await FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .update({'paid': true}).then((value) {
                setState(() {
                  _start = 0;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(
                      uuid: FirebaseAuth.instance.currentUser!.email!,
                      utype: (auth.user.roles.length == 1) ? "P" : "Dr",
                    ),
                  ),
                );
              }).catchError(
                      (error) => print("Failed to update user paid: $error")); */

              //controller.reset();
              print("delay end");
              //AddTrip();
              /****
               * C'est ici qu'on impelemente
               * la rédirection sur la page de réussite du paiement
               * */
            } else if (value["data"]["status"] != 'E') {
              setState(() {
                startPay = true;
              });
              message = value["data"]["description"];
              if (value["data"]["status"] != 'O') {
                message = "La transaction n'a pas été effectué";
              }
              setState(() {
                _start = 0;
              });
              //context.showErrorBar(content: Text(message));
              Fluttertoast.showToast(
                msg: '${message}',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: kRedColor,
              );
              //controller.reset();
              print("delay end");
              /****
               * C'est ici qu'on impelemente
               * Une action lorsqu'il y'a une erreur de paiement
               * */
            }
          }
        }); */
      });
    });
  }

  requestToPay(amount, meanCode, paymentNumber, orderNumber, feesAmount, userId,
      descritpion) {
    var message = "";
    //controller.forward();
    int modePay = (meanCode == "ORANGE-MONEY")
        ? 1
        : (meanCode == "MOBILE-MONEY")
            ? 2
            : (meanCode == "EXPRESS-UNION")
                ? 3
                : 4;
    print("delay start");

    apiservice.getADPToken().then((value1) async {
      setState(() {
        //print(value["data"]["tokenCode"]);

        _apiService
            .requestPayment(
                userId: userId,
                modePayId: modePay,
                amount: amount,
                descriptionPresta: descritpion,
                tokenCode: value1["data"]["tokenCode"],
                paymentNumber: paymentNumber,
                commisssionAmount: feesAmount)
            .then((value) {
          if (value["data"] != null) {
            if (value["data"]["status"] == 'G') {
              //controller.reset();
              setState(() {
                startPay = true;
              });
              print("delay end");
              /* context.showErrorBar(
                  content: const Text("Une erreur s'est produiteeee")); */
              Fluttertoast.showToast(
                msg: "Une erreur s'est produite",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: kRedColor,
              );
              print("Une erreur s'est produiteeeee");
            } else if (value["data"]["status"] != 'E') {
              //controller.reset();
              print("delay end");
              setState(() {
                startPay = true;
              });
              message = value["data"]["description"];
              if (value["data"]["status"] != 'O') {
                message = "La transaction n'a pas été effectué";
              }
              //context.showErrorBar(content: Text(message));
              Fluttertoast.showToast(
                msg: "${message}",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: kRedColor,
              );
              print("La transaction n'a pas été effectué");
            } else {
              //print("Reussi");
              //context.showInfoBar(content: const Text('Paiement initié'));
              Fluttertoast.showToast(
                msg: "Paiement initié",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: kPrimary,
              );
              const oneSec = Duration(seconds: 15);
              _timer = Timer.periodic(oneSec, (timer) {
                if (_start == 0) {
                  setState(() {
                    _timer.cancel();
                  });
                } else {
                  checkStatus(
                    //controller,
                    value["data"]["adpFootprint"],
                    meanCode,
                  );
                }
              });
            }
          } else {
            setState(() {
              startPay = true;
            });
            print(value);
            message = "Une erreur est survenueeee";
            if (value["pesake"]["code"] == 30118) {
              message = value["pesake"]["detail"];
              print(message);
              //controller.reset();
              print("delay end");
            } else if (value["pesake"]["code"] == 20008) {
              message = "Le numéro payeur de correspond pas à l'opérateur";
              //controller.reset();
              print("delay end");
            }
            //controller.reset();
            print("delay end");
            Fluttertoast.showToast(
              msg: "${message}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              backgroundColor: kRedColor,
            );
            //context.showErrorBar(content: Text(message));
          }
        });

        /* apiservice
            .requestToPay(value1["data"]["tokenCode"], meanCode, paymentNumber,
                orderNumber, amount, feesAmount)
            .then((value) async {
          if (value["data"] != null) {
            if (value["data"]["status"] == 'G') {
              //controller.reset();
              setState(() {
                startPay = true;
              });
              print("delay end");
              /* context.showErrorBar(
                  content: const Text("Une erreur s'est produiteeee")); */
              Fluttertoast.showToast(
                msg: "Une erreur s'est produite",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: kRedColor,
              );
              print("Une erreur s'est produiteeeee");
            } else if (value["data"]["status"] != 'E') {
              //controller.reset();
              print("delay end");
              setState(() {
                startPay = true;
              });
              message = value["data"]["description"];
              if (value["data"]["status"] != 'O') {
                message = "La transaction n'a pas été effectué";
              }
              //context.showErrorBar(content: Text(message));
              Fluttertoast.showToast(
                msg: "${message}",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: kRedColor,
              );
              print("La transaction n'a pas été effectué");
            } else {
              //print("Reussi");
              //context.showInfoBar(content: const Text('Paiement initié'));
              Fluttertoast.showToast(
                msg: "Paiement initié",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: kPrimary,
              );
              const oneSec = Duration(seconds: 15);
              _timer = Timer.periodic(oneSec, (timer) {
                if (_start == 0) {
                  setState(() {
                    _timer.cancel();
                  });
                } else {
                  checkStatus(
                    //controller,
                    value["data"]["adpFootprint"],
                    meanCode,
                  );
                }
              });
            }
          } else {
            setState(() {
              startPay = true;
            });
            print(value);
            message = "Une erreur est survenueeee";
            if (value["pesake"]["code"] == 30118) {
              message = value["pesake"]["detail"];
              print(message);
              //controller.reset();
              print("delay end");
            } else if (value["pesake"]["code"] == 20008) {
              message = "Le numéro payeur de correspond pas à l'opérateur";
              //controller.reset();
              print("delay end");
            }
            //controller.reset();
            print("delay end");
            Fluttertoast.showToast(
              msg: "${message}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              backgroundColor: kRedColor,
            );
            //context.showErrorBar(content: Text(message));
          }
        }); */
      });
    });
  }

  bool startPay = true;
  _onAlertFinalPay(
      context, meanCode, feesAmout, total, orderNumber, userId, description) {
    var priceFinal = int.parse(total) + feesAmout;
    Widget continueButton = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          startPay = false;
        });
        requestToPay(total, meanCode, numberController.text, orderNumber,
            feesAmout, userId, description);
      },
      child: startPay
          ? Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "Payer",
                style: TextStyle(
                  color: KWhite,
                  fontSize: 15,
                ),
              ),
            )
          : CircularProgressIndicator(),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        "Montant total : " + (priceFinal).toString() + " " + currency,
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              icon: Icon(Icons.phone),
              labelText: 'Numero de téléphone',
            ),
            controller: numberController,
          )
        ],
      ),
      actions: [
        //cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data.isNotEmpty) {
      setState(() {
        _isLoading = false;
      });
    }
    print(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        final auth = watch(authProvider.state);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimary,
            title: Text(
              "Paiement - Mode de paiement",
              style: TextStyle(
                color: customAppTheme.kWhite,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: true,
          ),
          body: ListView(
            children: [
              if (_isLoading)
                Shimmer.fromColors(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                ),
              if (!_isLoading)
                Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Montant à payer : \n\t\t\t' +
                      (int.parse(widget.amount)).toString() +
                      " " +
                      currency +
                      "  + 2% de frais transactionel"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: ListView.builder(
                        itemCount: widget.data.length,
                        shrinkWrap: true,
                        itemBuilder: (context, int i) {
                          return InkWell(
                            onTap: () => {
                              _onAlertFinalPay(
                                context,
                                widget.data[i]["meanCode"],
                                widget.data[i]["feesAmount"],
                                widget.amount,
                                uuid.v4(),
                                auth.user.userId,
                                widget.details,
                              )
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      "assets/images/payment/" +
                                          widget.data[i]["meanCode"] +
                                          ".png",
                                      width: 50,
                                      height: 50,
                                    ),
                                    Text(
                                      widget.data[i]["meanCode"],
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ])
            ],
          ),
        );
      },
    );
  }
}
