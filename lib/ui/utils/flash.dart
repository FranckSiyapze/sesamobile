//import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:sesa/ui/utils/colors.dart';

void showSnackBar(
    {required BuildContext context,
    required String message,
    required bool isError}) {
  final snackBar = SnackBar(
    content: Container(
      padding: EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    elevation: 0,
    duration: Duration(seconds: 10),
    backgroundColor: isError ? kRedColor : KGreen,
    //width: 340.0,
    padding: const EdgeInsets.symmetric(
      horizontal: 10.0,
    ),
    behavior: SnackBarBehavior.fixed,
    /* shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius),
    ), */
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
