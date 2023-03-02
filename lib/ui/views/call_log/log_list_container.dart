import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sesa/call_utilies.dart';
import 'package:sesa/core/models/user.dart';
import 'package:sesa/ui/utils/SizeConfig.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/permissions.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/utils.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/shimmer/shimmer.dart';

import '../../utils/progress_widget.dart';

class LogListContainer extends StatefulWidget {
  final String currentuserid;
  final CustomAppTheme customAppTheme;
  final String name;
  //final User user;
  LogListContainer({
    required this.currentuserid,
    required this.name,
    required this.customAppTheme,
  });

  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
  getIcon(String callStatus) {
    Icon _icon;
    double _iconSize = 15;

    switch (callStatus) {
      case CALL_STATUS_DIALLED:
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Colors.green,
        );
        break;

      case CALL_STATUS_MISSED:
        _icon = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: _iconSize,
        );
        break;

      default:
        _icon = Icon(
          Icons.call_received,
          size: _iconSize,
          color: Colors.grey,
        );
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.currentuserid == null
        ? oldcircularprogress()
        : FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("users")
                .doc(widget.currentuserid)
                .collection("callLogs")
                .orderBy("timestamp", descending: true)
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, i) {
                    return shimmerForum(
                        context: context,
                        customAppTheme: widget.customAppTheme);
                  },
                  separatorBuilder: (context, i) {
                    return Container(
                      margin: Spacing.fromLTRB(75, 0, 0, 0),
                    );
                  },
                );
              }

              if (snapshot.hasData) {
                if (snapshot.data!.docs.length > 0) {
                  return ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      var _log = snapshot.data!.docs[i];
                      bool hasDialled =
                          _log["callStatus"] == CALL_STATUS_DIALLED;
                      var dt = _log["timestamp"].split(' ');
                      var hr = dt[1].split('.');
                      //var dateT = DateTime.parse(dt[0]);
                      return InkWell(
                        onLongPress: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Delete this Log?"),
                                  content: Text(
                                      "Are you sure you want to delete this log?"),
                                  actions: [
                                    FlatButton(
                                      child: Text("YES"),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(widget.currentuserid)
                                            .collection("callLogs")
                                            .doc(_log["timestamp"])
                                            .delete();
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("NO"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                )),
                        onTap: () async {
                          await Permissions
                                  .cameraAndMicrophonePermissionsGranted()
                              ? CallUtils.dial(
                                  currUserId: widget.currentuserid,
                                  currUserName: widget.name,
                                  currUserAvatar: "widget.user.photoName",
                                  receiverId: _log["email"],
                                  receiverAvatar: _log["receiverPic"],
                                  receiverName: _log["receiverName"],
                                  context: context,
                                )
                              : {};
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Stack(
                                      children: [
                                        /* CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              hasDialled
                                                  ? _log["receiverPic"]
                                                  : _log["callerPic"]),
                                          maxRadius: 20,
                                        ), */
                                        FxContainer(
                                          paddingAll: 0,
                                          borderRadiusAll: 8,
                                          width: 50,
                                          height: 50,
                                          color: Ktransparent,
                                          child: CachedNetworkImage(
                                            imageUrl: hasDialled
                                                ? _log["receiverPic"]
                                                : _log["callerPic"],
                                            fit: BoxFit.cover,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30),
                                              ),
                                              child: Image(
                                                image: AssetImage(
                                                    "assets/images/profile.png"),
                                                width: 50,
                                                height: 50,
                                              ),
                                            ),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              hasDialled
                                                  ? _log["receiverName"]
                                                  : _log["callerName"],
                                              style: TextStyle(
                                                color: (_log["callStatus"] ==
                                                        CALL_STATUS_MISSED)
                                                    ? Colors.red
                                                    : widget.customAppTheme
                                                        .colorTextFeed,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                //getIcon(_log["callStatus"]),
                                                Icon(
                                                  CupertinoIcons
                                                      .video_camera_solid,
                                                  size: 20,
                                                  color: widget.customAppTheme
                                                      .colorTextFeed
                                                      .withOpacity(0.6),
                                                ),
                                                if (_log["callStatus"] ==
                                                    CALL_STATUS_DIALLED)
                                                  Text(
                                                    "Sortant",
                                                    style: TextStyle(
                                                      color: widget
                                                          .customAppTheme
                                                          .colorTextFeed,
                                                    ),
                                                  ),
                                                if (_log["callStatus"] ==
                                                    CALL_STATUS_MISSED)
                                                  Text(
                                                    "Manqué",
                                                    style: TextStyle(
                                                      color: widget
                                                          .customAppTheme
                                                          .colorTextFeed,
                                                    ),
                                                  ),
                                                if (_log["callStatus"] ==
                                                    CALL_STATUS_RECEIVED)
                                                  Text(
                                                    "Entrant",
                                                    style: TextStyle(
                                                      color: widget
                                                          .customAppTheme
                                                          .colorTextFeed,
                                                    ),
                                                  ),
                                                /* Text(
                                                  DateFormat(
                                                          "dd MMMM yyy hh:mm aa")
                                                      .format(DateTime.parse(
                                                          _log["timestamp"])),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ) */
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    //dateString(dateT),
                                    formatDateTime(dt[0], hr[0]),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  FxSpacing.width(5),
                                  Icon(
                                    CupertinoIcons.info,
                                    size: 15,
                                    color: Colors.grey.shade500,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, i) {
                      return Container(
                        margin: Spacing.fromLTRB(75, 0, 0, 0),
                        child: Divider(
                          height: 10,
                          color: widget.customAppTheme.colorTextFeed,
                          thickness: 0.1,
                        ),
                      );
                    },
                  );
                }
                return Container(
                  child: Column(
                    children: [
                      Text(
                        "This is where all your call logs are listed",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Roboto-Medium',
                        ),
                      ),
                      FxSpacing.height(10),
                      Text(
                        "Make a call with a Med Personnal to see it appear here",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  height: MediaQuery.of(context).copyWith().size.height -
                      MediaQuery.of(context).copyWith().size.height / 5,
                  width: MediaQuery.of(context).copyWith().size.width,
                );
              }

              return Container(
                child: Column(
                  children: [
                    Text(
                      "This is where all your call logs are listed",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: widget.customAppTheme.colorTextFeed,
                      ),
                    ),
                    Text(
                      "Video Call people with just one click",
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.customAppTheme.colorTextFeed,
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                height: MediaQuery.of(context).copyWith().size.height -
                    MediaQuery.of(context).copyWith().size.height / 5,
                width: MediaQuery.of(context).copyWith().size.width,
              );
            },
          );
  }
}
