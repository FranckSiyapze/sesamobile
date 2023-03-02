import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/ui/utils/status_indicator.dart';

import '../../../utils/SizeConfig.dart';
import '../../../utils/storage.dart';
import '../../../utils/themes/custom_app_theme.dart';
import '../../../utils/themes/theme_provider.dart';
import '../chatting_details.dart';

class ChatSingleUser extends StatefulWidget {
  final String name;
  // final String secondaryText;
  final String image;
  final String time;
  final bool isMessageRead;
  final String userId;
  final String email;
  ChatSingleUser(
      {required this.name,
      // @required this.secondaryText,
      required this.image,
      required this.time,
      required this.isMessageRead,
      required this.email,
      // @required this.screen,
      required this.userId});
  @override
  _ChatSingleUserState createState() => _ChatSingleUserState();
}

class _ChatSingleUserState extends State<ChatSingleUser> {
  late CustomAppTheme customAppTheme;
  late String currentuserid;
  late String currentusername;
  late String currentuserphoto;
  getCurrentuser() async {
    String local = await readStorage(value: "uid");
    String name = await readStorage(value: "name");
    String photo = await readStorage(value: "photo");
    setState(() {
      currentuserid = local;
      currentusername = name;
      currentuserphoto = photo;
    });
    print(currentuserid);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentuser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer(
      builder: ((context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Chat(
                receiverId: widget.userId,
                receiverAvatar: widget.image,
                receiverName: widget.name,
                currUserId: currentuserid,
                currUserName: currentusername,
                currUserAvatar: currentuserphoto,
              );
            }));
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            //margin: Spacing.top(24),
            decoration: BoxDecoration(
              color: customAppTheme.kBackgroundColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(widget.image),
                            maxRadius: 23,
                          ),
                          Positioned(
                            bottom: 3,
                            right: 3,
                            child: StatusIndicator(
                              uid: widget.userId,
                              screen: "chatListScreen",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.name,
                                style: TextStyle(
                                  color: customAppTheme.colorTextFeed,
                                  fontWeight: FontWeight.w600,
                                  /* fontSize: 18, */
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                widget.email,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: customAppTheme.colorTextFeed,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Container(
                        margin: Spacing.top(8),
                        padding: Spacing.fromLTRB(16, 8, 16, 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: customAppTheme.kVioletColor,
                        ),
                        child: Text(
                          "Chat",
                          /* style: AppTheme.getTextStyle(themeData.textTheme.caption,
                    color: themeData.colorScheme.onPrimary,
                    fontWeight: 600,
                    letterSpacing: 0.3), */
                          style: TextStyle(
                            fontSize: 13,
                            color: customAppTheme.kWhite,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
