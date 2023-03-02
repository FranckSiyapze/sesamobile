import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/ui/utils/colors.dart';

import '../../../utils/enum/message_type.dart';
import '../../../utils/themes/custom_app_theme.dart';
import '../../../utils/themes/theme_provider.dart';
import '../../../utils/utils_firebase.dart';
import '../pdf_viewer.dart';

class MessageItem extends StatelessWidget {
  final int index;
  final DocumentSnapshot document;
  final List listMessage;
  final String currUserId;
  final String receiverAvatar;
  final BuildContext context;
  final Function onDeleteMsg;

  MessageItem({
    required this.index,
    required this.document,
    required this.currUserId,
    required this.receiverAvatar,
    required this.context,
    required this.onDeleteMsg,
    required this.listMessage,
  });

  @override
  Widget build(BuildContext context) {
    bool isLastMsgLeft(int index) {
      if ((index > 0 && listMessage != null) &&
              listMessage[index - 1]["idFrom"] == currUserId ||
          index == 0) {
        return true;
      } else {
        return false;
      }
    }

    bool isLastMsgRight(int index) {
      if ((index > 0 && listMessage != null) &&
              listMessage[index - 1]["idFrom"] != currUserId ||
          index == 0) {
        return true;
      } else {
        return false;
      }
    }

    bool isNewMsg(int index) {
      if (index == (listMessage.length - 1)) {
        return true;
      }
      DateTime curr = DateTime.fromMillisecondsSinceEpoch(
          int.parse(listMessage[index]["timestamp"]));
      DateTime prev = DateTime.fromMillisecondsSinceEpoch(
          int.parse(listMessage[index + 1]["timestamp"]));
      if (curr.year == prev.year &&
          curr.month == prev.month &&
          curr.day == prev.day) {
        return false;
      } else {
        return true;
      }
    }

    bool isToday(int index) {
      DateTime today = DateTime.now();
      DateTime curr = DateTime.fromMillisecondsSinceEpoch(
          int.parse(listMessage[index]["timestamp"]));
      if (curr.day == today.day) {
        return true;
      } else {
        return false;
      }
    }

    bool isYesterday(int index) {
      DateTime today = DateTime.now();
      DateTime curr = DateTime.fromMillisecondsSinceEpoch(
          int.parse(listMessage[index]["timestamp"]));
      if (curr.day == (today.day - 1)) {
        return true;
      } else {
        return false;
      }
    }

    late CustomAppTheme customAppTheme;

    return Consumer(
      builder: ((context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        //Logged User Messages - right side
        if (document["idFrom"] == currUserId) {
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                isNewMsg(index)
                    ? Bubble(
                        elevation: 0,
                        margin: BubbleEdges.only(top: 20, bottom: 20),
                        alignment: Alignment.center,
                        color: Color.fromRGBO(212, 234, 244, 1.0),
                        child: Text(
                          isToday(index)
                              ? "TODAY"
                              : isYesterday(index)
                                  ? "YESTERDAY"
                                  : DateFormat("dd MMMM yyy").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(document["timestamp"]))),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11.0),
                        ),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    document["type"] == Utils.msgToNum(MessageType.Deleted)
                        ? Container(
                            child: Bubble(
                              nip: isLastMsgRight(index)
                                  ? BubbleNip.rightBottom
                                  : BubbleNip.no,
                              elevation: 0,
                              padding: BubbleEdges.all(10),
                              margin: BubbleEdges.only(top: 5),
                              color: kPrimary,
                              radius: Radius.circular(5),
                              child: Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.4),
                                    child: Text(
                                      document["content"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 10.0, top: 5.0),
                                    child: Text(
                                      DateFormat("hh:mm aa").format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(
                                                  document["timestamp"]))),
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12.0,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : FocusedMenuHolder(
                            blurSize: 0,
                            menuWidth: MediaQuery.of(context).size.width * 0.5,
                            duration: Duration(milliseconds: 200),
                            child: Container(
                              child: document["type"] ==
                                      Utils.msgToNum(MessageType.Text)
                                  ? Bubble(
                                      padding: BubbleEdges.all(10),
                                      margin: BubbleEdges.only(top: 5),
                                      alignment: Alignment.topRight,
                                      elevation: 0,
                                      nip: isLastMsgRight(index)
                                          ? BubbleNip.rightBottom
                                          : BubbleNip.no,
                                      color: kPrimary.withOpacity(0.9),
                                      radius: Radius.circular(5),
                                      child: Row(
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4),
                                            child: Text(
                                              document["content"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0, top: 5.0),
                                            child: Text(
                                              DateFormat("hh:mm aa").format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          int.parse(document[
                                                              "timestamp"]))),
                                              style: TextStyle(
                                                  color: Colors.white54,
                                                  fontSize: 12.0,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          )
                                        ],
                                      ),
                                    )

                                  // Image Msg
                                  : document["type"] ==
                                          Utils.msgToNum(MessageType.Image)
                                      ? Container(
                                          child: GestureDetector(
                                            onTap: () {
                                              /* Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullPhoto(
                                                          url: document[
                                                              "content"]),
                                                ),
                                              ); */
                                            },
                                            child: Material(
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    Container(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            kPrimary),
                                                  ),
                                                  width: 200.0,
                                                  height: 200.0,
                                                  padding: EdgeInsets.all(70.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0)),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Material(
                                                  child: Image.asset(
                                                    "images/profile.png",
                                                    width: 200.0,
                                                    height: 200.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  clipBehavior: Clip.hardEdge,
                                                ),
                                                imageUrl: document["content"],
                                                width: 200.0,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              clipBehavior: Clip.hardEdge,
                                            ),
                                          ),
                                          // margin: EdgeInsets.only(bottom: 10.0),
                                        )

                                      // GIF Msg
                                      : document["type"] ==
                                              Utils.msgToNum(MessageType.Pdf)
                                          ? Bubble(
                                              padding: BubbleEdges.all(10),
                                              margin: BubbleEdges.only(top: 5),
                                              alignment: Alignment.topRight,
                                              elevation: 0,
                                              nip: isLastMsgRight(index)
                                                  ? BubbleNip.rightBottom
                                                  : BubbleNip.no,
                                              color: kPrimary.withOpacity(0.7),
                                              radius: Radius.circular(20),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return PDFViewer(
                                                      senderDoc:
                                                          document["nameFrom"],
                                                      url: document["content"],
                                                    );
                                                  }));
                                                },
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      6,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Center(
                                                    child: Stack(
                                                      children: [
                                                        PDFWIDGET(
                                                          senderDoc: document[
                                                              "nameFrom"],
                                                          url: document[
                                                              "content"],
                                                        ),
                                                        Positioned(
                                                          bottom: 0,
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    4),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: kPrimary
                                                                  .withOpacity(
                                                                      0.7),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child: Row(
                                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                //FxSpacing.width(10),
                                                                Text(
                                                                  "Open ",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: customAppTheme
                                                                        .kWhite,
                                                                  ),
                                                                ),
                                                                /* Icon(
                                                                MdiIcons
                                                                    .downloadCircleOutline,
                                                                color:
                                                                    customAppTheme
                                                                        .kWhite,
                                                                size: 15,
                                                              ) */
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : document["type"] ==
                                                  Utils.msgToNum(
                                                      MessageType.Video)
                                              ? Container(
                                                  /* child: Image.asset(
                                                  "images/${document['content']}.gif",
                                                  width: 100.0,
                                                  height: 100.0,
                                                  fit: BoxFit.cover,
                                                ), */
                                                  child:
                                                      Text(document["content"]),
                                                  margin: EdgeInsets.only(
                                                      bottom: 10.0),
                                                )
                                              : Container(),
                            ),
                            bottomOffsetHeight: 100,
                            menuItems: <FocusedMenuItem>[
                              FocusedMenuItem(
                                  title: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                  trailingIcon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    onDeleteMsg(document);
                                  }),
                            ],
                            onPressed: () {},
                          )
                  ],
                ),
                //MSG TIME
                document["type"] != Utils.msgToNum(MessageType.Text) &&
                        document["type"] != Utils.msgToNum(MessageType.Deleted)
                    ? Container(
                        child: Text(
                          DateFormat("hh:mm aa").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(document["timestamp"]))),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                              fontStyle: FontStyle.italic),
                        ),
                        margin:
                            EdgeInsets.only(right: 5.0, top: 10.0, bottom: 5.0),
                      )
                    : Container()
              ],
            ),
          );
        } else {
          return Container(
            child: Column(
              children: [
                isNewMsg(index)
                    ? Bubble(
                        elevation: 0,
                        margin: BubbleEdges.only(top: 20, bottom: 20),
                        alignment: Alignment.center,
                        color: Color.fromRGBO(212, 234, 244, 1.0),
                        child: Text(
                            isToday(index)
                                ? "TODAY"
                                : isYesterday(index)
                                    ? "YESTERDAY"
                                    : DateFormat("dd MMMM yyy").format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(document["timestamp"]))),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11.0)),
                      )
                    : Container(),

                Row(
                  children: [
                    // DISPLAY RECIEVER PROFILE IMAGE
                    isLastMsgLeft(index)
                        ? Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Material(
                              color: Ktransparent,
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(kPrimary),
                                  ),
                                  width: 35.0,
                                  height: 35.0,
                                  padding: EdgeInsets.all(10.0),
                                ),
                                errorWidget: (context, url, error) => ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  child: Image(
                                    image:
                                        AssetImage("assets/images/sesabw.png"),
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                imageUrl: receiverAvatar,
                                width: 40.0,
                                height: 40.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18.0)),
                              //clipBehavior: Clip.hardEdge,
                            ),
                          )
                        : Container(
                            width: 35.0,
                          ),

                    document["type"] == Utils.msgToNum(MessageType.Deleted)
                        ? Container(
                            child: Bubble(
                            elevation: 0,
                            nip: isLastMsgLeft(index)
                                ? BubbleNip.leftBottom
                                : BubbleNip.no,
                            padding: BubbleEdges.all(10),
                            margin: BubbleEdges.only(top: 5),
                            alignment: Alignment.topRight,
                            radius: Radius.circular(20),
                            // nip: BubbleNip.rightTop,
                            color: customAppTheme.kBackgroundColor,
                            child: Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.4),
                                  child: Text(
                                    document["content"],
                                    style: TextStyle(
                                      color: customAppTheme.colorTextFeed,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, top: 5.0),
                                  child: Text(
                                    DateFormat("hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(document["timestamp"]),
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))
                        :
                        // DISPLAY MESSAGES
                        document["type"] == Utils.msgToNum(MessageType.Text)
                            ? Bubble(
                                elevation: 0,
                                padding: BubbleEdges.all(10),
                                margin: BubbleEdges.only(top: 5),
                                alignment: Alignment.topRight,
                                nip: isLastMsgLeft(index)
                                    ? BubbleNip.leftBottom
                                    : BubbleNip.no,
                                color: customAppTheme.kBackgroundColor,
                                radius: Radius.circular(5),
                                child: Row(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4),
                                      child: Text(
                                        document["content"],
                                        style: TextStyle(
                                            color:
                                                customAppTheme.colorTextFeed),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10.0, top: 5.0),
                                      child: Text(
                                        DateFormat("hh:mm aa").format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(document["timestamp"]),
                                          ),
                                        ),
                                        style: TextStyle(
                                          color: customAppTheme.colorTextFeed
                                              .withOpacity(0.5),
                                          fontSize: 12.0,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )

                            // Image Msg
                            : document["type"] ==
                                    Utils.msgToNum(MessageType.Image)
                                ? Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FullPhoto(
                                                url: document["content"]),
                                          ),
                                        ); */
                                      },
                                      child: Material(
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      kPrimary),
                                            ),
                                            width: 200.0,
                                            height: 200.0,
                                            padding: EdgeInsets.all(70.0),
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Material(
                                            child: Image.asset(
                                              "images/profile.png",
                                              width: 200.0,
                                              height: 200.0,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            clipBehavior: Clip.hardEdge,
                                          ),
                                          imageUrl: document["content"],
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                    ),
                                    // margin: EdgeInsets.only(bottom: 10.0),
                                  )

                                // GIF Msg
                                : document["type"] ==
                                        Utils.msgToNum(MessageType.Pdf)
                                    ? Bubble(
                                        elevation: 0,
                                        padding: BubbleEdges.all(10),
                                        margin: BubbleEdges.only(top: 5),
                                        alignment: Alignment.topRight,
                                        nip: isLastMsgLeft(index)
                                            ? BubbleNip.leftBottom
                                            : BubbleNip.no,
                                        color: customAppTheme.kBackgroundColor,
                                        radius: Radius.circular(20),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return PDFViewer(
                                                senderDoc: document["nameFrom"],
                                                url: document["content"],
                                              );
                                            }));
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Stack(
                                                children: [
                                                  PDFWIDGET(
                                                    senderDoc:
                                                        document["nameFrom"],
                                                    url: document["content"],
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    child: Container(
                                                      margin: EdgeInsets.all(4),
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      decoration: BoxDecoration(
                                                        color: kPrimary
                                                            .withOpacity(0.8),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Row(
                                                        //crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          //FxSpacing.width(10),
                                                          Text(
                                                            "Open ",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  customAppTheme
                                                                      .kWhite,
                                                            ),
                                                          ),
                                                          /* Icon(
                                                                MdiIcons
                                                                    .downloadCircleOutline,
                                                                color:
                                                                    customAppTheme
                                                                        .kWhite,
                                                                size: 15,
                                                              ) */
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : document["type"] ==
                                            Utils.msgToNum(MessageType.Video)
                                        ? Container(
                                            child: Text(document["content"]),
                                            margin:
                                                EdgeInsets.only(bottom: 10.0),
                                          )
                                        : Container(),
                  ],
                ),

                //Msg Time
                document["type"] != Utils.msgToNum(MessageType.Text) &&
                        document["type"] != Utils.msgToNum(MessageType.Deleted)
                    ? Container(
                        child: Text(
                          DateFormat("hh:mm aa").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(document["timestamp"]))),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                              fontStyle: FontStyle.italic),
                        ),
                        margin:
                            EdgeInsets.only(left: 40.0, top: 10.0, bottom: 5.0),
                      )
                    : Container()
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            margin: EdgeInsets.only(bottom: 10.0),
          );
        }
      }),
    );
  }
}
