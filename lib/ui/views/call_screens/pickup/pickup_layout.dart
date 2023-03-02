import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:sesa/ui/views/call_screens/pickup/pickup_screen.dart';

import '../../../../core/models/call.dart';
import '../../../../resources/call_state_methods.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final String uid;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    required this.scaffold,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return uid != null
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: uid),
            // initialData: null,
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data!.data() != null) {
                print("snapshots test : " + snapshot.data!.data().toString());
                Call call = Call.fromMap(
                    snapshot.data!.data() as Map<dynamic, dynamic>);
                print("call has dialledt : " + call.callerId.toString());
                print("call has dialledt user: " + uid);

                if (call.hasDialled != null) {
                  FlutterRingtonePlayer.playRingtone();
                  // print("PLAY");
                  if (uid == call.receiverId) {
                    return PickupScreen(
                      call: call,
                    );
                  }
                }
                // print("STOP");
                print("=====================////====");
                FlutterRingtonePlayer.stop();
                return scaffold;
              }
              // print("STOP");
              FlutterRingtonePlayer.stop();
              return scaffold;
            })
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
