import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/doctors/user.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/ui/utils/SizeConfig.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/text_style.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/chats/chatting_details.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/shimmer/shimmer.dart';
import 'package:sesa/ui/widgets/text/text.dart';

class MyAppointmentPage extends StatefulWidget {
  const MyAppointmentPage({Key? key});

  @override
  State<MyAppointmentPage> createState() => _MyAppointmentPageState();
}

class _MyAppointmentPageState extends State<MyAppointmentPage> {
  late CustomAppTheme customAppTheme;

  Widget Bloc(
      {required BuildContext context,
      required CustomAppTheme customAppTheme,
      required DocumentSnapshot docs,
      required UserDoctor auth}) {
    bool create = true;
    bool create1 = true;
    bool create2 = true;
    final ApiService _apiService = GetIt.instance.get<ApiService>();
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: true,
          backgroundColor: Ktransparent,
          isDismissible: true,
          builder: (context) {
            return DraggableScrollableSheet(
              builder: (context, scrollController) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setAppoint) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      color: customAppTheme.kBackgroundColorFinal,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Scaffold(
                      backgroundColor: Ktransparent,
                      appBar: AppBar(
                        backgroundColor: customAppTheme.kBackgroundColorFinal,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        automaticallyImplyLeading: false,
                        title: Row(
                          children: [
                            FxSpacing.width(5),
                            Text(
                              "Details",
                              softWrap: true,
                              style: TextStyle(
                                color: customAppTheme.colorTextFeed,
                                fontFamily: "Roboto-Bold",
                              ),
                            ),
                          ],
                        ),
                        centerTitle: false,
                        actions: [
                          Container(
                            padding: EdgeInsets.all(15),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  FontAwesomeIcons.close,
                                  size: 30,
                                  color: customAppTheme.colorTextFeed,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      body: ListView(
                        controller: scrollController,
                        padding: FxSpacing.fromLTRB(24, 10, 24, 10),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FxText.b2(
                                "request by : ",
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: customAppTheme.kgrayColor,
                                muted: true,
                                fontWeight: 600,
                              ),
                              FxText.b2(
                                "${docs["nameAuthor"]}",
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: customAppTheme.colorTextFeed,
                                muted: true,
                                fontWeight: 600,
                              ),
                            ],
                          ),
                          FxSpacing.height(15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FxText.b2(
                                "Status : ",
                                fontSize: 15,
                                letterSpacing: 0.2,
                                color: customAppTheme.kgrayColor,
                                muted: true,
                                fontWeight: 600,
                              ),
                              FxText.b2(
                                (docs["status"] == "P")
                                    ? "En attente"
                                    : (docs["status"] == "A")
                                        ? "Accepter"
                                        : "Annuler",
                                color: kPrimary,
                                letterSpacing: 0,
                                fontWeight: 500,
                              ),
                            ],
                          ),
                          FxSpacing.height(15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FxText.b2(
                                "Time of appointment : ",
                                fontSize: 15,
                                letterSpacing: 0.2,
                                color: customAppTheme.kgrayColor,
                                muted: true,
                                fontWeight: 600,
                              ),
                              FxText.b2(
                                "${docs["hour"]}",
                                fontSize: 13,
                                letterSpacing: 0.2,
                                color: customAppTheme.colorTextFeed,
                                muted: true,
                                fontWeight: 600,
                              ),
                            ],
                          ),
                          FxSpacing.height(15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FxText.b2(
                                "Date of appointment : ",
                                fontSize: 15,
                                letterSpacing: 0.2,
                                color: customAppTheme.kgrayColor,
                                muted: true,
                                fontWeight: 600,
                              ),
                              FxText.b2(
                                "${docs["day"]}",
                                fontSize: 13,
                                letterSpacing: 0.2,
                                color: customAppTheme.colorTextFeed,
                                muted: true,
                                fontWeight: 600,
                              ),
                            ],
                          ),
                          FxSpacing.height(20),
                          if (docs["status"] == "P" &&
                              docs["author"] != auth.email)
                            InkWell(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(auth.email)
                                    .collection("appointments")
                                    .doc(docs.id)
                                    .update({
                                  "status": "A",
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 150,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: customAppTheme.kButton,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Accept",
                                  style: TextStyle(
                                    color: customAppTheme.kWhite,
                                  ),
                                ),
                              ),
                            ),
                          FxSpacing.height(10),
                          if (docs["status"] == "P" || docs["status"] == "A")
                            InkWell(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(auth.email)
                                    .collection("appointments")
                                    .doc(docs.id)
                                    .update({
                                  "status": "C",
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 150,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: customAppTheme.kButton,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Annuler",
                                  style: TextStyle(
                                    color: customAppTheme.kWhite,
                                  ),
                                ),
                              ),
                            ),
                          FxSpacing.height(10),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  /* (item.author != user.email)
                                      ? item.authorProf.email
                                      : item.guestProf.email, */
                                  return Chat(
                                    receiverId: (docs["author"] != auth.email)
                                        ? docs["author"]
                                        : docs["forAuthor"],
                                    receiverAvatar: "config.photoName",
                                    receiverName: (docs["author"] != auth.email)
                                        ? docs["nameAuthor"]
                                        : docs["forName"],
                                    currUserId: auth.email,
                                    currUserName:
                                        "${auth.firstName} ${auth.lastName} ",
                                    currUserAvatar: "auth.user.photoName",
                                  );
                                }),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 150,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: customAppTheme.kButton,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Envoyer un message",
                                style: TextStyle(
                                  color: customAppTheme.kWhite,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            );
          },
        );
      },
      child: FxContainer.bordered(
        bordered: false,
        paddingAll: 16,
        margin: FxSpacing.fromLTRB(0, 0, 0, 8),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: customAppTheme.kBackgroundColor,
        borderRadiusAll: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: FxSpacing.left(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FxText.b1(
                      (docs["author"] != auth.email)
                          ? "RDV avec : " + docs["nameAuthor"]
                          : "RDV avec : " + docs["forName"],
                      color: customAppTheme.colorTextFeed,
                      fontWeight: 600,
                      letterSpacing: -0.2,
                    ),
                    FxSpacing.height(6),
                    FxText.b2(
                      "${docs["day"]} à ${docs["hour"]}",
                      fontSize: 12,
                      letterSpacing: 0.2,
                      color: customAppTheme.kgrayColor,
                      muted: true,
                      fontWeight: 600,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: FxSpacing.top(2),
                  child: FxText.b2(
                    (docs["status"] == "P")
                        ? "En attente"
                        : (docs["status"] == "A")
                            ? "Accepter"
                            : "Annuler",
                    color: kPrimary,
                    letterSpacing: 0,
                    fontWeight: 500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        final auth = watch(authProvider.state);
        return Scaffold(
          backgroundColor: customAppTheme.kBackgroundColorFinal,
          appBar: AppBar(
            backgroundColor: customAppTheme.kBackgroundColorFinal,
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: customAppTheme.colorTextFeed,
                size: 15,
              ),
            ),
            elevation: 0,
            title: Text(
              'My Appointment',
              style: FxTextStyle.b1(fontWeight: 700),
            ),
          ),
          body: ListView(
            padding: FxSpacing.fromLTRB(24, 44, 24, 24),
            children: [
              if (auth.asData)
                /* FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("users")
                      .doc(auth.user.email)
                      .collection("appointments")
                      .orderBy("createdAt", descending: true)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (context, i) {
                          return Container(
                            padding: EdgeInsets.all(12),
                            child: shimmerForum(
                                context: context,
                                customAppTheme: customAppTheme),
                          );
                        },
                        separatorBuilder: (context, i) {
                          return Container(
                            margin: Spacing.fromLTRB(75, 0, 0, 0),
                          );
                        },
                      );
                    }
                    if (snapshot.hasData) if (snapshot.data!.docs.length > 0) {
                      return ListView.separated(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          return Bloc(
                            context: context,
                            customAppTheme: customAppTheme,
                            docs: snapshot.data!.docs[i],
                            auth: auth.user,
                          );
                        },
                        separatorBuilder: (context, i) {
                          return Container(
                            margin: Spacing.fromLTRB(75, 0, 0, 0),
                            child: Divider(
                              height: 10,
                              color: customAppTheme.colorTextFeed,
                              thickness: 0.1,
                            ),
                          );
                        },
                      );
                    } else {
                      return Container(
                        child: Column(
                          children: [
                            Text(
                              "This is where all your appointments are listed",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Roboto-Medium',
                              ),
                            ),
                            FxSpacing.height(10),
                            Text(
                              "Make an appointment with a doctor to see it appear here",
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
                            "This is where all your appointments are listed",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Roboto-Medium',
                            ),
                          ),
                          FxSpacing.height(10),
                          Text(
                            "Make an appointment with a doctor to see it appear here",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      height: MediaQuery.of(context).copyWith().size.height -
                          MediaQuery.of(context).copyWith().size.height / 5,
                      width: MediaQuery.of(context).copyWith().size.width,
                    );
                  },
                ), */
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(auth.user.email)
                        .collection("appointments")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: 10,
                          itemBuilder: (context, i) {
                            return Container(
                              padding: EdgeInsets.all(12),
                              child: shimmerForum(
                                  context: context,
                                  customAppTheme: customAppTheme),
                            );
                          },
                          separatorBuilder: (context, i) {
                            return Container(
                              margin: Spacing.fromLTRB(75, 0, 0, 0),
                            );
                          },
                        );
                      } else if (snapshot.data!.docs.length == 0) {
                        return Container(
                          child: Column(
                            children: [
                              Text(
                                "This is where all your appointments are listed",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Roboto-Medium',
                                ),
                              ),
                              FxSpacing.height(10),
                              Text(
                                "Make an appointment with a doctor to see it appear here",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          height: MediaQuery.of(context)
                                  .copyWith()
                                  .size
                                  .height -
                              MediaQuery.of(context).copyWith().size.height / 5,
                          width: MediaQuery.of(context).copyWith().size.width,
                        );
                      } else {
                        return ListView.separated(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, i) {
                            return Bloc(
                              context: context,
                              customAppTheme: customAppTheme,
                              docs: snapshot.data!.docs[i],
                              auth: auth.user,
                            );
                          },
                          separatorBuilder: (context, i) {
                            return Container(
                              margin: Spacing.fromLTRB(75, 0, 0, 0),
                              child: Divider(
                                height: 10,
                                color: customAppTheme.colorTextFeed,
                                thickness: 0.1,
                              ),
                            );
                          },
                        );
                      }
                    }),
              if (!auth.asData)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //ForumWidget(context, customAppTheme),
                      FxSpacing.height(MediaQuery.of(context).size.height / 10),
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
                              color: customAppTheme.kVioletColor.withAlpha(20),
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
        );
      },
    );
  }
}
