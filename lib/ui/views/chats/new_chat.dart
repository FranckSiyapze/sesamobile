import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/ui/utils/storage.dart';
import 'package:sesa/ui/views/chats/components/chat_single_user.dart';

import '../../utils/SizeConfig.dart';
import '../../utils/colors.dart';
import '../../utils/spacing.dart';
import '../../utils/themes/custom_app_theme.dart';
import '../../utils/themes/theme_provider.dart';
import '../../widgets/text/text.dart';

class NewChatPage extends StatefulWidget {
  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  late CustomAppTheme customAppTheme;
  late String currentuserid;
  late String currentusername;
  late String currentuserphoto;
  var allUserLists;

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

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
    return Consumer(
      builder: ((context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        return Scaffold(
          appBar: AppBar(
            backgroundColor: customAppTheme.kBackgroundColorFinal,
            elevation: 0,
            //leading: ,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: FxText.h6(
              "Listes des utilisateurs",
              fontWeight: 600,
              textAlign: TextAlign.center,
              color: customAppTheme.colorTextFeed,
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  MdiIcons.close,
                  color: customAppTheme.kVioletColor,
                  size: 25,
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: Container(
            color: customAppTheme.kBackgroundColorFinal,
            child: ListView(
              //padding: Spacing.zero,
              padding: FxSpacing.horizontal(24),
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 20,
                        decoration: BoxDecoration(
                          color: kGrayColor.shade200,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 8),
                                child: TextFormField(
                                  style: TextStyle(
                                    letterSpacing: 0,
                                    color: kBlackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Search messages",
                                    hintStyle: TextStyle(
                                        letterSpacing: 0,
                                        color: kBlackColor,
                                        fontWeight: FontWeight.w500),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide.none),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  textInputAction: TextInputAction.search,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: customAppTheme.kVioletColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Icon(
                                  MdiIcons.magnify,
                                  color: customAppTheme.kWhite,
                                  size: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: Spacing.top(24),
                        child: StreamBuilder(
                          stream: _usersStream,
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            } else {
                              snapshot.data!.docs.removeWhere(
                                  (i) => i["uuid"] == currentuserid);
                              allUserLists = snapshot.data!.docs;
                              //print(allUserLists);
                              return ListView.separated(
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: ((context, index) {
                                  /* if (snapshot.data!.docs[index]["uuid"] ==
                                      currentuserid) {
                                    return Container(height: 0);
                                  } */
                                  return ChatSingleUser(
                                    name: snapshot.data!.docs[index]["name"],
                                    image: snapshot.data!.docs[index]
                                        ["photoUrl"],
                                    time: snapshot.data!.docs[index]
                                        ["createdAt"],
                                    isMessageRead: true,
                                    email: snapshot.data!.docs[index]["email"],
                                    userId: snapshot.data!.docs[index]["uuid"],
                                  );
                                }),
                                separatorBuilder: ((context, index) {
                                  return SizedBox(
                                    height: 10,
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
          ),
        );
      }),
    );
  }
}
