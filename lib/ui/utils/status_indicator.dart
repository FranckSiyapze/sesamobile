import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sesa/ui/utils/colors.dart';

import '../../resources/user_state_methods.dart';
import '../utils/enum/user_state.dart';
import '../utils/themes/custom_app_theme.dart';
import '../utils/themes/theme_provider.dart';
import '../utils/utils_firebase.dart';

class StatusIndicator extends StatelessWidget {
  final String uid;
  final String screen;
  final UserStateMethods userStateMethods = UserStateMethods();

  StatusIndicator({required this.uid, required this.screen});

  late CustomAppTheme customAppTheme;

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return Consumer(builder: ((context, watch, child) {
      final themeProvider = watch(themeNotifierProvider);
      customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
      return StreamBuilder(
        stream: userStateMethods.getUserStream(uid: uid),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          var user;
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                  kVioletColor,
                )),
              ),
              height: MediaQuery.of(context).copyWith().size.height -
                  MediaQuery.of(context).copyWith().size.height / 5,
              width: MediaQuery.of(context).copyWith().size.width,
            );
          }
          user = snapshot.data!.data();
          if (screen == "chatDetailScreen") {
            return Text(
              user["state"] == 1
                  ? "Online"
                  : "Last Seen " +
                      DateFormat("dd MMMM, hh:mm aa").format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(user["lastSeen"]))),
              style: TextStyle(
                color: customAppTheme.colorTextFeed,
                fontSize: 12,
              ),
            );
          } else {
            return Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: getColor(user["state"])),
              margin: EdgeInsets.only(top: 4),
            );
          }
        },
      );
    }));
  }
}
