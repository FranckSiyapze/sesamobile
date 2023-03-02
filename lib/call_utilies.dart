import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sesa/resources/call_state_methods.dart';
import 'package:sesa/ui/utils/utils.dart';
import 'package:sesa/ui/views/call_screens/call_screen1.dart';

import '../core/models/call.dart';
import '../core/models/log.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial(
      {String? currUserAvatar,
      String? currUserName,
      String? currUserId,
      String? receiverAvatar,
      String? receiverName,
      String? receiverId,
      context}) async {
    Call call = Call(
      callerId: currUserId,
      callerName: currUserName,
      callerPic: currUserAvatar,
      receiverId: receiverId,
      receiverName: receiverName,
      receiverPic: receiverAvatar,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
        callerName: currUserName,
        callerPic: currUserAvatar,
        callStatus: CALL_STATUS_DIALLED,
        receiverName: receiverName,
        receiverPic: receiverAvatar,
        email: receiverId,
        timestamp: DateTime.now().toString());

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(currUserId)
          .collection("callLogs")
          .doc(log.timestamp)
          .set({
        "callerName": log.callerName,
        "callerPic": log.callerPic,
        "callStatus": log.callStatus,
        "receiverName": log.receiverName,
        "receiverPic": log.receiverPic,
        "timestamp": log.timestamp,
        "email": log.email,
      });

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen1(
              call: call,
            ),
          ));
    }
  }
}
