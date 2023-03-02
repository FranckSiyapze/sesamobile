import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/core/controllers/doctors_controllers.dart';
import 'package:sesa/core/controllers/pack_controller/pack_categorie_controller.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/doctors/doctor_data.dart';
import 'package:sesa/core/models/doctors/user.dart';
import 'package:sesa/ui/utils/SizeConfig.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/star_rating.dart';
import 'package:sesa/ui/utils/storage.dart';
import 'package:sesa/ui/utils/styles/style.dart';
import 'package:sesa/ui/utils/themes/app_theme.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/text_style.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/chats/chatting_details.dart';
import 'package:sesa/ui/views/chats/components/chat_for_chats_screen.dart';
import 'package:sesa/ui/views/doctor_page/doctor_page.dart';
import 'package:sesa/ui/views/home_page/models/category.dart';
import 'package:sesa/ui/views/home_page/models/doctor.dart';
import 'package:sesa/ui/widgets/card/card.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/text/text.dart';
import 'package:sesa/ui/widgets/text_field/text_field.dart';
import 'package:getwidget/getwidget.dart';

class DoctorPagee extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<DoctorPagee> {
  late CustomAppTheme customAppTheme;
  int selectedCategory = 0;
  String profile = "";
  List<Category> categoryList = [];
  List<Doctor> doctorList = [];
  late DoctorData _doctorData;
  late DoctorData _patients;
  late List<UserDoctor> doctors = [];
  late List<UserDoctor> patients = [];
  final List<String> imageList = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
  ];
  Widget _buildSingleCategory(
      {int? index, String? categoryName, IconData? categoryIcon}) {
    return Padding(
      padding: FxSpacing.right(16),
      child: FxCard(
        paddingAll: 8,
        borderRadiusAll: 8,
        bordered: true,
        shadow: FxShadow(
          elevation: 0,
        ),
        //splashColor: AppTheme.customTheme.medicarePrimary.withAlpha(40),
        border: Border.all(
            color: selectedCategory == index
                ? customAppTheme.ktransparent
                : customAppTheme.kBackgroundColor,
            width: 1.5),
        color: selectedCategory == index
            ? customAppTheme.kBackgroundColor
            : customAppTheme.ktransparent,
        onTap: () {
          setState(() {
            selectedCategory = index!;
          });
        },
        child: Row(
          children: [
            FxContainer.rounded(
              child: Icon(
                categoryIcon,
                color: AppTheme.customTheme.medicarePrimary,
                size: 16,
              ),
              color: FxAppTheme.theme.colorScheme.onBackground.withAlpha(16),
              paddingAll: 4,
            ),
            FxSpacing.width(8),
            FxText.caption(
              categoryName!,
              fontWeight: 600,
              color: customAppTheme.colorTextFeed,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryList = Category.categoryList();
    doctorList = Doctor.doctorList();
    //getUser();
  }

  /* getUser() async {
    String uuid = await readStorage(value: "uid");
    final DocumentSnapshot user =
        await FirebaseFirestore.instance.collection("users").doc(uuid).get();
    setState(() {
      profile = user["profile"];
    });
  } */

  List<Widget> _buildCategoryList() {
    List<Widget> list = [];

    list.add(FxSpacing.width(24));

    for (int i = 0; i < categoryList.length; i++) {
      list.add(_buildSingleCategory(
          index: i,
          categoryName: categoryList[i].category,
          categoryIcon: categoryList[i].categoryIcon));
    }
    return list;
  }

  List<Widget> _buildDoctorList() {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));

    for (int i = 0; i < doctors.length; i++) {
      list.add(_buildSingleDoctor(doctors[i]));
    }
    return list;
  }

  Widget _buildSingleDoctor(UserDoctor doctor) {
    return FxCard(
      onTap: () {
        /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorPage(doctor: doctor),
          ),
        ); */
      },
      margin: FxSpacing.fromLTRB(24, 0, 24, 16),
      color: customAppTheme.kBackgroundColor,
      paddingAll: 16,
      borderRadiusAll: 16,
      shadow: FxShadow(
        elevation: 0,
      ),
      child: Row(
        children: [
          FxContainer(
            paddingAll: 0,
            borderRadiusAll: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image(
                width: 72,
                height: 72,
                image: AssetImage("assets/images/avatar_2.jpg"),
              ),
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.b1(
                  doctor.username,
                  fontWeight: 600,
                  color: customAppTheme.colorTextFeed,
                ),
                FxSpacing.height(4),
                FxText.caption(
                  doctor.hospitals.name,
                  xMuted: true,
                  color: customAppTheme.colorTextFeed,
                ),
                FxSpacing.height(12),
                Row(
                  children: [
                    FxStarRating.buildRatingStar(
                        rating: 4.5, showInactive: true, size: 15),
                    FxSpacing.width(4),
                    FxText.caption(
                      4.5.toString() + ' | ' + 120.toString() + ' Reviews',
                      xMuted: true,
                      color: customAppTheme.colorTextFeed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatient(
      {required String profile,
      required String prenom,
      required String name,
      required String email,
      UserDoctor? doctor}) {
    return FxCard(
      onTap: () {
        /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorPage(
                doctor: Doctor.getOne(),
                profile: profile,
                name: "${prenom} ${name}",
                email: email),
          ),
        ); */
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              receiverId: email,
              receiverAvatar: "receiverAvatar",
              receiverName: name,
              currUserId: FirebaseAuth.instance.currentUser!.email!,
              currUserAvatar: "currUserAvatar",
              currUserName: FirebaseAuth.instance.currentUser!.displayName!,
            ),
          ),
        );
      },
      margin: FxSpacing.fromLTRB(24, 0, 24, 16),
      color: customAppTheme.kBackgroundColor,
      paddingAll: 16,
      borderRadiusAll: 16,
      shadow: FxShadow(
        elevation: 0,
      ),
      child: Row(
        children: [
          FxContainer(
            paddingAll: 0,
            borderRadiusAll: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image(
                width: 72,
                height: 72,
                image: AssetImage("assets/images/avatar_2.jpg"),
              ),
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.b1(
                  " ${prenom} ${name}",
                  fontWeight: 600,
                  color: customAppTheme.colorTextFeed,
                ),
                FxSpacing.height(4),
                /* FxText.caption(
                  doctor.hospitals.name,
                  xMuted: true,
                  color: customAppTheme.colorTextFeed,
                ), */
                FxSpacing.height(12),
                /* Row(
                  children: [
                    FxStarRating.buildRatingStar(
                        rating: 4.5, showInactive: true, size: 15),
                    FxSpacing.width(4),
                    FxText.caption(
                      4.5.toString() + ' | ' + 120.toString() + ' Reviews',
                      xMuted: true,
                      color: customAppTheme.colorTextFeed,
                    ),
                  ],
                ), */
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer(builder: ((context, watch, child) {
      final themeProvider = watch(themeNotifierProvider);
      customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
      //_doctorData = watch(doctorsControllerDataProvider.state);
      //_patients = watch(patientControllerDataProvider.state);
      final auth = watch(authProvider.state);
      //doctors = _doctorData.doctors;
      //patients = _patients.doctors;
      //final packCategories = watch(packCategoriesControllerDataProvider.state);
      return Scaffold(
        backgroundColor: customAppTheme.kBackgroundColorFinal,
        body: ListView(
          padding: FxSpacing.top(48),
          children: [
            Padding(
              padding: FxSpacing.horizontal(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxSpacing.width(8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FxText.overline(
                        'Current Location',
                        color: customAppTheme.colorTextFeed,
                        xMuted: true,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppTheme.customTheme.medicarePrimary,
                            size: 12,
                          ),
                          FxSpacing.width(4),
                          FxText.caption(
                            'Douala, Cameroon',
                            color: customAppTheme.colorTextFeed,
                            fontWeight: 600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  FxContainer(
                    paddingAll: 4,
                    borderRadiusAll: 4,
                    color: FxAppTheme.customTheme.bgLayer2,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Icon(
                          MdiIcons.bell,
                          size: 20,
                          color: FxAppTheme.theme.colorScheme.onBackground
                              .withAlpha(200),
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: FxContainer.rounded(
                            paddingAll: 4,
                            child: Container(),
                            color: AppTheme.customTheme.medicarePrimary,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FxSpacing.height(24),
            Padding(
              padding: FxSpacing.horizontal(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.b2(
                    'Mes patients',
                    color: customAppTheme.colorTextFeed,
                    fontWeight: 700,
                  ),
                ],
              ),
            ),
            if (auth.asData == true)
              Padding(
                padding: FxSpacing.horizontal(24),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(auth.user.email)
                      .collection("chatList")
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                            customAppTheme.kVioletColor,
                          )),
                        ),
                        height: MediaQuery.of(context).copyWith().size.height -
                            MediaQuery.of(context).copyWith().size.height / 5,
                        width: MediaQuery.of(context).copyWith().size.width,
                      );
                    } else if (snapshot.data!.docs.length == 0) {
                      return Container(
                        child: Column(
                          children: [
                            Text(
                              "No recent chats found",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: customAppTheme.colorTextFeed,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Start searching to chat",
                              style: TextStyle(
                                fontSize: 16,
                                color: customAppTheme.colorTextFeed,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        height: MediaQuery.of(context).copyWith().size.height -
                            MediaQuery.of(context).copyWith().size.height / 5,
                        width: MediaQuery.of(context).copyWith().size.width,
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
                            currUserName: snapshot.data!.docs[index]
                                ["currUserName"],
                            receiverName: snapshot.data!.docs[index]
                                ["receiverName"],
                            currentId: auth.user.email,
                            receiverId: snapshot.data!.docs[index]
                                ["receiverId"],
                            currAvatar: snapshot.data!.docs[index]
                                ["currImgUrl"],
                            receiverAvatar: snapshot.data!.docs[index]
                                ["receivImgUrl"],
                          );
                        }),
                      );
                    }
                  },
                ),
              ),
            if (!auth.asData)
              Container(
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                    customAppTheme.kVioletColor,
                  )),
                ),
                height: MediaQuery.of(context).copyWith().size.height -
                    MediaQuery.of(context).copyWith().size.height / 5,
                width: MediaQuery.of(context).copyWith().size.width,
              ),
            if (auth.isError == true)
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
                          padding: MaterialStateProperty.all(Spacing.xy(16, 0)),
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
    }));
  }
}
