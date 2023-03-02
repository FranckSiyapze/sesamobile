import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/doctors/user.dart';
import 'package:sesa/ui/utils/colors.dart';

import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/star_rating.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/text_style.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/appointment_page/appointment_page.dart';
import 'package:sesa/ui/views/chat_page/chat_page.dart';
import 'package:sesa/ui/views/chats/chatting_details.dart';
import 'package:sesa/ui/views/home_page/models/doctor.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/card/card.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/text/text.dart';

class DoctorPage extends StatefulWidget {
  final UserDoctor doctor;
  DoctorPage({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  late CustomAppTheme customAppTheme;
  TextEditingController note = TextEditingController();

  void _makeASubscription() {
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Fermer', style: TextStyle(color: kPrimary)));
    Widget continueButton = TextButton(
        onPressed: () async{

          final QuerySnapshot result =
              await FirebaseFirestore.instance
              .collection("users")
              .where("email",
              isEqualTo: widget.doctor.email)
              .get();
          int price = result.docs[0]["notes"];
          var newPrice =0;
          if(note.text.isNotEmpty){
            newPrice = price + int.parse(note.text);
          }else{
            newPrice = price;
          }
          FirebaseFirestore.instance
              .collection("users")
              .doc(widget.doctor.email)
              .update({
            "notes": newPrice,
          });
          Navigator.pop(context);
          //_getCurrentLocation();
        },
        child: Text('Souscrire', style: TextStyle(color: kPrimary)));

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        "Notation d'un docteur",
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Veuillez saisir un nombre compris entre 0 et 5",
            style: TextStyle(
              fontSize: 13,
              color: customAppTheme.colorTextFeed,
            ),
          ),
          TextField(
            controller: note,
            keyboardType: TextInputType.number,

          ),
        ],
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
          body: ListView(
            padding: FxSpacing.fromLTRB(24, 44, 24, 24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: FxContainer(
                      color: customAppTheme.kBackgroundColor,
                      child: Icon(
                        Icons.chevron_left,
                        color: customAppTheme.colorTextFeed.withAlpha(160),
                        size: 24,
                      ),
                      paddingAll: 4,
                      borderRadiusAll: 8,
                    ),
                  ),
                  FxCard.rounded(
                    onTap: () {
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chat: Chat(
                              widget.doctor.image,
                              widget.doctor.name,
                              '',
                              '',
                              '',
                              false,
                            ),
                          ),
                        ),
                      ); */
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(
                            receiverId: widget.doctor.email,
                            receiverAvatar: widget.doctor.imageUrl,
                            receiverName: widget.doctor.lastName +
                                " " +
                                widget.doctor.firstName,
                            currUserId: auth.user.email,
                            currUserAvatar: auth.user.imageUrl,
                            currUserName:
                                auth.user.lastName + " " + auth.user.firstName,
                          ),
                        ),
                      );
                    },
                    color: customAppTheme.kBackgroundColor,
                    child: Icon(
                      MdiIcons.message,
                      color: customAppTheme.colorTextFeed.withAlpha(160),
                      size: 20,
                    ),
                    paddingAll: 8,
                  ),
                ],
              ),
              FxSpacing.height(32),
              Row(
                children: [
                  (widget.doctor.imageUrl == null &&
                          widget.doctor.imageUrl == "")
                      ? FxCard(
                          paddingAll: 0,
                          borderRadiusAll: 16,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: Image(
                              fit: BoxFit.cover,
                              height: 160,
                              width: 120,
                              image: AssetImage("assets/images/sesabw.png"),
                            ),
                          ),
                        )
                      : FxCard(
                          paddingAll: 0,
                          borderRadiusAll: 16,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: CachedNetworkImage(
                              imageUrl: widget.doctor.imageUrl,
                              fit: BoxFit.cover,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 160,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                child: Image(
                                  width: 72,
                                  height: 72,
                                  image:
                                      AssetImage("assets/images/avatar_2.jpg"),
                                ),
                              ),
                            ),
                          ),
                        ),
                  FxSpacing.width(24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.b1(
                          "${widget.doctor.firstName} ${widget.doctor.lastName}",
                          fontWeight: 700,
                          fontSize: 18,
                        ),
                        FxSpacing.height(8),
                        FxText.b2(
                          widget.doctor.speciality.name,
                          color: customAppTheme.colorTextFeed,
                          xMuted: true,
                        ),
                        FxSpacing.height(12),
                        StreamBuilder<DocumentSnapshot>(
                          stream:FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.doctor.email)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot>
                              snapshot) {
                            if (!snapshot.hasData) {
                              return Row(
                                children: [
                                  FxStarRating.buildRatingStar(
                                      rating: 0, showInactive: true, size: 15),
                                  FxSpacing.width(4),
                                  FxText.caption(
                                    0.toString() ,
                                    xMuted: true,
                                    color: customAppTheme.colorTextFeed,
                                  ),
                                ],
                              );
                            } else {
                              if(snapshot.data!["notes"] ==0) {
                                return Row(
                                  children: [
                                    FxStarRating.buildRatingStar(
                                        rating: 0, showInactive: true, size: 15),
                                    FxSpacing.width(4),
                                    FxText.caption(
                                      0.toString() ,
                                      xMuted: true,
                                      color: customAppTheme.colorTextFeed,
                                    ),
                                  ],
                                );
                              }else if(snapshot.data!["notes"] >0 && snapshot.data!["notes"] <100) {
                                return Row(
                                  children: [
                                    FxStarRating.buildRatingStar(
                                        rating: 1, showInactive: true, size: 15),
                                    FxSpacing.width(4),
                                    FxText.caption(
                                      1.toString() ,
                                      xMuted: true,
                                      color: customAppTheme.colorTextFeed,
                                    ),
                                  ],
                                );
                              }else if(snapshot.data!["notes"] >100 && snapshot.data!["notes"] <200){
                                return Row(
                                  children: [
                                    FxStarRating.buildRatingStar(
                                        rating: 2, showInactive: true, size: 15),
                                    FxSpacing.width(4),
                                    FxText.caption(
                                      2.toString() ,
                                      xMuted: true,
                                      color: customAppTheme.colorTextFeed,
                                    ),
                                  ],
                                );
                              }else if(snapshot.data!["notes"] >200 && snapshot.data!["notes"] <300){
                                return Row(
                                  children: [
                                    FxStarRating.buildRatingStar(
                                        rating: 3, showInactive: true, size: 15),
                                    FxSpacing.width(4),
                                    FxText.caption(
                                      3.toString() ,
                                      xMuted: true,
                                      color: customAppTheme.colorTextFeed,
                                    ),
                                  ],
                                );
                              }else if(snapshot.data!["notes"] >300 && snapshot.data!["notes"] <400){
                                return Row(
                                  children: [
                                    FxStarRating.buildRatingStar(
                                        rating: 4, showInactive: true, size: 15),
                                    FxSpacing.width(4),
                                    FxText.caption(
                                      4.toString() ,
                                      xMuted: true,
                                      color: customAppTheme.colorTextFeed,
                                    ),
                                  ],
                                );
                              }else{
                                return Row(
                                  children: [
                                    FxStarRating.buildRatingStar(
                                        rating: 5, showInactive: true, size: 15),
                                    FxSpacing.width(4),
                                    FxText.caption(
                                      5.toString() ,
                                      xMuted: true,
                                      color: customAppTheme.colorTextFeed,
                                    ),
                                  ],
                                );
                              }
                            }
                          },
                        ),
                        /* Row(
                          children: [
                            FxContainer(
                              child: Icon(
                                Icons.star_rounded,
                                color: AppTheme.customTheme.colorWarning,
                              ),
                              paddingAll: 8,
                              color: customAppTheme.kBackgroundColor,
                            ),
                            FxSpacing.width(16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.caption(
                                  'Rating',
                                  color: customAppTheme.colorTextFeed,
                                  xMuted: true,
                                ),
                                FxSpacing.height(2),
                                FxText.caption(
                                  "4" + ' out of 5',
                                  color: customAppTheme.colorTextFeed,
                                  fontWeight: 700,
                                ),
                              ],
                            ),
                          ],
                        ), */
                        FxSpacing.height(8),
                        Row(
                          children: [
                            FxContainer(
                              color: customAppTheme.kBackgroundColor,
                              child: Icon(
                                Icons.group,
                                color: AppTheme.customTheme.blue,
                              ),
                              paddingAll: 8,
                            ),
                            FxSpacing.width(16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.caption(
                                  'Patients',
                                  color: customAppTheme.colorTextFeed,
                                  xMuted: true,
                                ),
                                FxSpacing.height(2),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.doctor.email)
                                      .collection("chatList")
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return FxText.caption(
                                        "0",
                                        color: customAppTheme.colorTextFeed,
                                        fontWeight: 700,
                                      );
                                    } else if (snapshot.data!.docs.length ==
                                        0) {
                                      return FxText.caption(
                                        "0",
                                        color: customAppTheme.colorTextFeed,
                                        fontWeight: 700,
                                      );
                                    } else {
                                      return FxText.caption(
                                        "${snapshot.data!.docs.length}",
                                        color: customAppTheme.colorTextFeed,
                                        fontWeight: 700,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              FxSpacing.height(32),
              Container(
                height: 50,
                child: FxButton.block(
                  elevation: 0,
                  borderRadiusAll: 8,
                  backgroundColor: AppTheme.customTheme.medicarePrimary,
                  onPressed: () {
                    _makeASubscription();
                  },
                  child: FxText.b1(
                    'Cliquez pour noter',
                    color: AppTheme.customTheme.medicareOnPrimary,
                    fontWeight: 600,
                  ),
                ),
              ),
              FxSpacing.height(32),
              FxContainer(
                color: customAppTheme.kBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.b1(
                      'Biography',
                      fontWeight: 600,
                    ),
                    FxSpacing.height(16),
                    /* RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: widget.doctor.biography,
                          style: FxTextStyle.caption(
                            color: customAppTheme.colorTextFeed,
                            xMuted: true,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: " Read more",
                          style: FxTextStyle.caption(
                            color: customAppTheme.blue,
                          ),
                        ),
                      ]),
                    ), */
                    FxSpacing.height(24),
                    FxText.b1(
                      'Location',
                      fontWeight: 600,
                    ),
                    FxSpacing.height(16),
                    FxContainer(
                      paddingAll: 0,
                      borderRadiusAll: 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        child: Image(
                          fit: BoxFit.cover,
                          height: 140,
                          width: MediaQuery.of(context).size.width - 96,
                          image: AssetImage('assets/images/map-md-snap.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                paddingAll: 10,
                borderRadiusAll: 16,
              ),
              FxSpacing.height(32),
              FxButton.block(
                elevation: 0,
                borderRadiusAll: 8,
                backgroundColor: AppTheme.customTheme.medicarePrimary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentPage(
                        doctor: widget.doctor,
                      ),
                    ),
                  );
                },
                child: FxText.b1(
                  'Make Appointment',
                  color: AppTheme.customTheme.medicareOnPrimary,
                  fontWeight: 600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
