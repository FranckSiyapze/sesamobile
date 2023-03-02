import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/ui/utils/storage.dart';

import '../../utils/SizeConfig.dart';
import '../../utils/colors.dart';
import '../../utils/spacing.dart';
import '../../utils/themes/custom_app_theme.dart';
import '../../utils/themes/theme_provider.dart';
import '../../widgets/text/text.dart';
import 'components/chat_for_chats_screen.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late CustomAppTheme customAppTheme;
  var allUserLists;
  late String token;
  late String currentuserid;
  final Stream<QuerySnapshot> _recentsChats =
      FirebaseFirestore.instance.collection('users').snapshots();

  final GetIt getIt = GetIt.instance;
  ApiService api = ApiService();

  getCurrUserId() async {
    String preferences = await readStorage(value: "email");
    setState(() {
      currentuserid = preferences;
    });
  }

  @override
  void initState() {
    getCurrUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        final auth = watch(authProvider.state);
        return Scaffold(
          //appBar: AppBar(),
          appBar: AppBar(
            backgroundColor: customAppTheme.kBackgroundColorFinal,
            elevation: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                MdiIcons.chevronLeft,
                color: customAppTheme.kVioletColor,
                size: 25,
              ),
            ),
          ),
          body: Container(
            color: customAppTheme.kBackgroundColorFinal,
            child: ListView(
              padding: FxSpacing.fromLTRB(24, 10, 24, 24),
              children: [
                if (auth.asData)
                  Column(
                    children: [
                      Text(
                        "Chats History",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: 'Roboto-Bold',
                          color: customAppTheme.colorTextFeed,
                        ),
                      ),
                      FxSpacing.height(10),
                      FxSpacing.height(20),
                      FxSpacing.height(0),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(auth.user.email)
                                    .collection("chatList")
                                    .orderBy("timestamp", descending: true)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container(
                                      child: Center(
                                        child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                          customAppTheme.kVioletColor,
                                        )),
                                      ),
                                      height: MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .height -
                                          MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .height /
                                              5,
                                      width: MediaQuery.of(context)
                                          .copyWith()
                                          .size
                                          .width,
                                    );
                                  } else if (snapshot.data!.docs.length == 0) {
                                    return Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            "No recent chats found",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: customAppTheme
                                                    .colorTextFeed,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Start searching to chat",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  customAppTheme.colorTextFeed,
                                            ),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                      ),
                                      height: MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .height -
                                          MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .height /
                                              5,
                                      width: MediaQuery.of(context)
                                          .copyWith()
                                          .size
                                          .width,
                                    );
                                  } else {
                                    return ListView.builder(
                                      physics: ClampingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: ((context, index) {
                                        return ChatChatsScreen(
                                          data: snapshot.data!.docs[index],
                                          currUserName: snapshot.data!
                                              .docs[index]["currUserName"],
                                          receiverName: snapshot.data!
                                              .docs[index]["receiverName"],
                                          currentId: auth.user.email,
                                          receiverId: snapshot.data!.docs[index]
                                              ["receiverId"],
                                          currAvatar: snapshot.data!.docs[index]
                                              ["currImgUrl"],
                                          receiverAvatar: snapshot.data!
                                              .docs[index]["receivImgUrl"],
                                        );
                                      }),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (!auth.asData)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //ForumWidget(context, customAppTheme),
                        FxSpacing.height(
                            MediaQuery.of(context).size.height / 10),
                        Container(
                          //height: 200,
                          child: Image.asset(
                            "assets/images/no-internet.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 24),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Une erreur est survenu",
                                style: TextStyle(
                                  color: customAppTheme.colorTextFeed,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    customAppTheme.kVioletColor.withAlpha(20),
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(Spacing.xy(16, 0)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(kPrimary),
                            ),
                            onPressed: () {
                              context.refresh(authProvider);
                            },
                            child: Text(
                              "Ressayer",
                              style: TextStyle(
                                color: customAppTheme.kWhite,
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
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
