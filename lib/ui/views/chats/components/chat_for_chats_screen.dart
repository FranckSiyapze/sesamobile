import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sesa/ui/utils/status_indicator.dart';
import 'package:sesa/ui/utils/utils.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/shimmer/shimmer.dart';

import '../../../utils/spacing.dart';
import '../../../utils/storage.dart';
import '../../../utils/themes/custom_app_theme.dart';
import '../../../utils/themes/theme_provider.dart';
import '../chatting_details.dart';

class ChatChatsScreen extends StatefulWidget {
  final DocumentSnapshot data;
  final String receiverId;
  final String currentId;
  final String receiverName;
  final String currUserName;
  final String currAvatar;
  final String receiverAvatar;
  ChatChatsScreen({
    Key? key,
    required this.data,
    required this.receiverId,
    required this.currentId,
    required this.receiverName,
    required this.currUserName,
    required this.currAvatar,
    required this.receiverAvatar,
  }) : super(key: key);
  @override
  _ChatChatsScreenState createState() => _ChatChatsScreenState();
}

class _ChatChatsScreenState extends State<ChatChatsScreen> {
  late String currentuserid;
  late String currentusername;
  late String currentuserphoto;
  late SharedPreferences preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentuser();
  }

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

  String checkDate() {
    var day = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.data["timestamp"]));
    var dt = day.toString().split(' ');
    var hr = dt[1].split('.');

    return formatDateTime(dt[0], hr[0]);
  }

  late CustomAppTheme customAppTheme;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, watch, child) {
      final themeProvider = watch(themeNotifierProvider);
      customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.data["id"])
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container(
                // child: Text("User details not found"),
                );
          } else {
            return InkWell(
              onTap: () {
                // print(widget.data["content"]);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Chat(
                      receiverId: widget.receiverId,
                      receiverAvatar: widget.receiverAvatar,
                      receiverName: widget.receiverName,
                      currUserId: widget.currentId,
                      currUserName: widget.currUserName,
                      currUserAvatar: widget.receiverAvatar,
                    );
                  }),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                margin: FxSpacing.bottom(7),
                decoration: BoxDecoration(
                  color: customAppTheme.kBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        FxContainer(
                          paddingAll: 0,
                          borderRadiusAll: 8,
                          width: 50,
                          height: 50,
                          color: customAppTheme.kBackgroundColor,
                          child: CachedNetworkImage(
                            imageUrl: widget.receiverAvatar,
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              child: Image(
                                image: AssetImage("assets/images/sesabw.png"),
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 3,
                          right: 3,
                          child: StatusIndicator(
                            uid: widget.receiverId,
                            screen: "chatListScreen",
                          ),
                        ),
                      ],
                    ),
                    FxSpacing.width(16),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${widget.receiverName}",
                              style: TextStyle(
                                color: customAppTheme.colorTextFeed,
                                fontWeight: FontWeight.w600,
                                //fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            RichText(
                                text: TextSpan(children: [
                              widget.data["showCheck"]
                                  ? WidgetSpan(
                                      child: Container(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.blueAccent,
                                        size: 16,
                                      ),
                                      padding: EdgeInsets.only(right: 5),
                                    ))
                                  : TextSpan(),
                              TextSpan(
                                text: widget.data["type"] == 3
                                    ? "Sticker"
                                    : widget.data["type"] == 2
                                        ? "GIF"
                                        : widget.data["type"] == 1
                                            ? "IMAGE"
                                            : widget.data["type"] == -1
                                                ? widget.data["content"]
                                                    .toString()
                                                : widget.data["content"]
                                                            .toString()
                                                            .length >
                                                        30
                                                    ? widget.data["content"]
                                                            .toString()
                                                            .substring(0, 30) +
                                                        "..."
                                                    : widget.data["content"]
                                                        .toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: customAppTheme.colorTextFeed,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ])),
                          ],
                        ),
                      ),
                    ),
                    FxSpacing.width(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          checkDate(),
                          style: TextStyle(
                            fontSize: 12,
                            color: customAppTheme.colorTextFeed,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        FxSpacing.height(16)
                        /*  chat.replied
                            ? FxSpacing.height(16)
                            : FxContainer.rounded(
                                paddingAll: 6,
                                color: AppTheme.customTheme.medicarePrimary,
                                child: FxText.overline(
                                  chat.messages,
                                  color: AppTheme.customTheme.medicareOnPrimary,
                                ),
                              ), */
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      );
    }));
  }
}
