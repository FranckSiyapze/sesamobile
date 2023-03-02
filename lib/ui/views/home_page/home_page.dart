import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/core/controllers/doctors_controllers.dart';
import 'package:sesa/core/controllers/medicament_controller/medicament_controller.dart';
import 'package:sesa/core/controllers/pack_controller/pack_categorie_controller.dart';
import 'package:sesa/core/controllers/prestations/prestation_controller.dart';
import 'package:sesa/core/controllers/speciality_controller/speciality_controller.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/doctors/doctor_data.dart';
import 'package:sesa/core/models/doctors/speciality.dart';
import 'package:sesa/core/models/doctors/specility_data.dart';
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
import 'package:sesa/ui/utils/utils.dart';
import 'package:sesa/ui/views/chats/chat_page.dart';
import 'package:sesa/ui/views/chats/chatting_details.dart';
import 'package:sesa/ui/views/chats/components/chat_for_chats_screen.dart';
import 'package:sesa/ui/views/doctor_page/doctor_page.dart';
import 'package:sesa/ui/views/home_page/models/category.dart';
import 'package:sesa/ui/views/home_page/models/doctor.dart';
import 'package:sesa/ui/views/home_page/search_page.dart';
import 'package:sesa/ui/views/home_page/speciality_doctor_page.dart';
import 'package:sesa/ui/widgets/card/card.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/text/text.dart';
import 'package:sesa/ui/widgets/text_field/text_field.dart';
import 'package:getwidget/getwidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late CustomAppTheme customAppTheme;
  int selectedCategory = 0;
  String profile = "";
  List<Category> categoryList = [];
  List<Doctor> doctorList = [];
  late DoctorData _doctorData;
  late SpecialityData _specialityData;
  late DoctorData _patients;
  late List<UserDoctor> doctors = [];
  late List<Speciality> specialitys = [];
  late List<UserDoctor> patients = [];
  Widget _buildSingleCategory({int? index, String? categoryName}) {
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SpecialityDoctorPage(speciality: categoryName!),
            ),
          );
        },
        child: Row(
          children: [
            FxContainer.rounded(
              child: Icon(
                Icons.visibility,
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
    specialitys.sort((a, b) => a.id.compareTo(b.id));
    for (int i = 0; i < specialitys.length; i++) {
      list.add(
        _buildSingleCategory(
          index: i,
          categoryName: specialitys[i].name,
        ),
      );
    }
    return list;
  }

  List<Widget> _buildDoctorList() {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));
    doctors.sort((a, b) => a.firstName.compareTo(b.firstName));
    for (int i = 0; i < doctors.length; i++) {
      list.add(_buildSingleDoctor(doctors[i]));
    }
    return list;
  }

  Widget _buildSingleDoctor(UserDoctor doctor) {
    return FxCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorPage(doctor: doctor),
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
          (doctor.imageUrl == null && doctor.imageUrl == "")
              ? FxContainer(
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
                )
              : FxContainer(
                  paddingAll: 0,
                  borderRadiusAll: 16,
                  /* child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image(
                width: 72,
                height: 72,
                image: AssetImage("assets/images/avatar_2.jpg"),
              ),
            ), */
                  child: CachedNetworkImage(
                    imageUrl: doctor.imageUrl,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: Image(
                        width: 72,
                        height: 72,
                        image: AssetImage("assets/images/avatar_2.jpg"),
                      ),
                    ),
                  ),
                ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.b1(
                  "${doctor.firstName} ${doctor.lastName}",
                  fontWeight: 600,
                  color: customAppTheme.colorTextFeed,
                ),
                FxSpacing.height(4),
                FxText.caption(
                  doctor.department.name,
                  xMuted: true,
                  color: customAppTheme.colorTextFeed,
                ),
                FxText.caption(
                  "Spécialité : " + doctor.speciality.name,
                  xMuted: true,
                  color: customAppTheme.colorTextFeed,
                ),
                FxSpacing.height(12),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(doctor.email)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Row(
                        children: [
                          FxStarRating.buildRatingStar(
                              rating: 0, showInactive: true, size: 15),
                          FxSpacing.width(4),
                          FxText.caption(
                            0.toString(),
                            xMuted: true,
                            color: customAppTheme.colorTextFeed,
                          ),
                        ],
                      );
                    } else {
                      if (snapshot.data!["notes"] == 0) {
                        return Row(
                          children: [
                            FxStarRating.buildRatingStar(
                                rating: 0, showInactive: true, size: 15),
                            FxSpacing.width(4),
                            FxText.caption(
                              0.toString(),
                              xMuted: true,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ],
                        );
                      } else if (snapshot.data!["notes"] > 0 &&
                          snapshot.data!["notes"] < 100) {
                        return Row(
                          children: [
                            FxStarRating.buildRatingStar(
                                rating: 1, showInactive: true, size: 15),
                            FxSpacing.width(4),
                            FxText.caption(
                              1.toString(),
                              xMuted: true,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ],
                        );
                      } else if (snapshot.data!["notes"] > 100 &&
                          snapshot.data!["notes"] < 200) {
                        return Row(
                          children: [
                            FxStarRating.buildRatingStar(
                                rating: 2, showInactive: true, size: 15),
                            FxSpacing.width(4),
                            FxText.caption(
                              2.toString(),
                              xMuted: true,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ],
                        );
                      } else if (snapshot.data!["notes"] > 200 &&
                          snapshot.data!["notes"] < 300) {
                        return Row(
                          children: [
                            FxStarRating.buildRatingStar(
                                rating: 3, showInactive: true, size: 15),
                            FxSpacing.width(4),
                            FxText.caption(
                              3.toString(),
                              xMuted: true,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ],
                        );
                      } else if (snapshot.data!["notes"] > 300 &&
                          snapshot.data!["notes"] < 400) {
                        return Row(
                          children: [
                            FxStarRating.buildRatingStar(
                                rating: 4, showInactive: true, size: 15),
                            FxSpacing.width(4),
                            FxText.caption(
                              4.toString(),
                              xMuted: true,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            FxStarRating.buildRatingStar(
                                rating: 5, showInactive: true, size: 15),
                            FxSpacing.width(4),
                            FxText.caption(
                              5.toString(),
                              xMuted: true,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ],
                        );
                      }
                    }
                  },
                ),
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
      _doctorData = watch(doctorsControllerDataProvider.state);
      final auth = watch(authProvider.state);
      doctors = _doctorData.doctors;
      bool asData = _doctorData.asData;
      bool asError = _doctorData.asError;
      final packCategories = watch(packCategoriesControllerDataProvider.state);
      final prestations = watch(prestationsControllerDataProvider.state);
      final medocs = watch(medocsControllerDataProvider.state);
      _specialityData = watch(specialityControllerDataProvider.state);
      specialitys = _specialityData.specialitys;
      return Scaffold(
          backgroundColor: customAppTheme.kBackgroundColorFinal,
          body: ListView(
            padding: FxSpacing.top(48),
            children: [
              Padding(
                padding: FxSpacing.horizontal(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    /* FxContainer(
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
                    ), */
                  ],
                ),
              ),
              FxSpacing.height(24),
              Padding(
                padding: FxSpacing.horizontal(24),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(doctors: doctors),
                      ),
                    );
                  },
                  child: FxTextField(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(doctors: doctors),
                        ),
                      );
                    },
                    focusedBorderColor: AppTheme.customTheme.medicarePrimary,
                    cursorColor: AppTheme.customTheme.medicarePrimary,
                    textFieldStyle: FxTextFieldStyle.outlined,
                    labelText: 'Search a doctor',
                    labelStyle: FxTextStyle.caption(
                        color: customAppTheme.colorTextFeed, xMuted: true),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: customAppTheme.kBackgroundColor,
                    readOnly: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppTheme.customTheme.medicarePrimary,
                      size: 20,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(24),
              if (auth.asData == true)
                Padding(
                  padding: FxSpacing.horizontal(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FxText.b2(
                        'Dernière discussion',
                        color: customAppTheme.colorTextFeed,
                        fontWeight: 700,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ChatPage();
                            }),
                          );
                        },
                        child: FxText.overline('See all',
                            color: AppTheme.customTheme.medicarePrimary),
                      ),
                    ],
                  ),
                ),
              if (auth.asData == true) FxSpacing.height(24),
              if (auth.asData == true)
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
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
                        );
                      } else if (snapshot.data!.docs.length == 0) {
                        return Container(
                          child: Column(
                            children: [
                              Text(
                                "No Discussion with a doctor Found",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: customAppTheme.colorTextFeed,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return Chat(
                                  receiverId:
                                      snapshot.data!.docs.first["receiverId"],
                                  receiverAvatar:
                                      snapshot.data!.docs.first["receivImgUrl"],
                                  receiverName:
                                      snapshot.data!.docs.first["receiverName"],
                                  currUserId:
                                      snapshot.data!.docs.first["currentId"],
                                  currUserName:
                                      snapshot.data!.docs.first["currUserName"],
                                  currUserAvatar:
                                      snapshot.data!.docs.first["currImgUrl"],
                                );
                              }),
                            );
                          },
                          child: FxContainer(
                            borderRadiusAll: 16,
                            margin: FxSpacing.horizontal(24),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: snapshot
                                          .data!.docs.first["receivImgUrl"],
                                      fit: BoxFit.cover,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16)),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          FxContainer(
                                        paddingAll: 0,
                                        borderRadiusAll: 8,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          child: Image(
                                            height: 40,
                                            width: 40,
                                            image: AssetImage(
                                              'assets/images/sesabw.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    FxSpacing.width(16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FxText.caption(
                                            'Dr. ${snapshot.data!.docs.first["receiverName"]}',
                                            color: AppTheme
                                                .customTheme.medicareOnPrimary,
                                            fontWeight: 700,
                                          ),
                                        ],
                                      ),
                                    ),
                                    FxSpacing.width(16),
                                    /* FxContainer.rounded(
                                    paddingAll: 4,
                                    child: Icon(
                                      Icons.videocam_outlined,
                                      color: AppTheme.customTheme.medicarePrimary,
                                      size: 16,
                                    ),
                                    color: AppTheme.customTheme.medicareOnPrimary,
                                  ), */
                                  ],
                                ),
                                FxSpacing.height(16),
                                FxContainer(
                                  borderRadiusAll: 8,
                                  color: FxAppTheme
                                      .theme.colorScheme.onBackground
                                      .withAlpha(30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.watch_later,
                                        color: AppTheme
                                            .customTheme.medicareOnPrimary
                                            .withAlpha(160),
                                        size: 20,
                                      ),
                                      FxSpacing.width(8),
                                      FxText.caption(
                                        checkDate(snapshot
                                            .data!.docs.first["timestamp"]),
                                        color: AppTheme
                                            .customTheme.medicareOnPrimary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            color: AppTheme.customTheme.medicarePrimary,
                          ),
                        );
                      }
                    }),
              /* FxContainer(
                borderRadiusAll: 16,
                margin: FxSpacing.horizontal(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        FxContainer(
                          paddingAll: 0,
                          borderRadiusAll: 8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: Image(
                              height: 40,
                              width: 40,
                              image: AssetImage(
                                'assets/images/avatar_2.jpg',
                              ),
                            ),
                          ),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FxText.caption(
                                'Dr.Haley lawrence',
                                color: AppTheme.customTheme.medicareOnPrimary,
                                fontWeight: 700,
                              ),
                              FxText.overline(
                                'Dermatologists',
                                color: AppTheme.customTheme.medicareOnPrimary
                                    .withAlpha(200),
                              ),
                            ],
                          ),
                        ),
                        FxSpacing.width(16),
                        FxContainer.rounded(
                          paddingAll: 4,
                          child: Icon(
                            Icons.videocam_outlined,
                            color: AppTheme.customTheme.medicarePrimary,
                            size: 16,
                          ),
                          color: AppTheme.customTheme.medicareOnPrimary,
                        ),
                      ],
                    ),
                    FxSpacing.height(16),
                    FxContainer(
                      borderRadiusAll: 8,
                      color: FxAppTheme.theme.colorScheme.onBackground
                          .withAlpha(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.watch_later,
                            color: AppTheme.customTheme.medicareOnPrimary
                                .withAlpha(160),
                            size: 20,
                          ),
                          FxSpacing.width(8),
                          FxText.caption(
                            'Sun, Jan 19, 08:00am - 10:00am',
                            color: AppTheme.customTheme.medicareOnPrimary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                color: AppTheme.customTheme.medicarePrimary,
              ), */
              /* FxSpacing.height(24),
            //if (profile != "Dr")
              Padding(
                padding: FxSpacing.horizontal(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.b2(
                      'Let\'s find your doctor',
                      fontWeight: 700,
                      color: customAppTheme.colorTextFeed,
                    ),
                    Icon(
                      Icons.tune_outlined,
                      color: AppTheme.customTheme.medicarePrimary,
                      size: 20,
                    ),
                  ],
                ),
              ), */
              //if (profile == "Dr")
              FxSpacing.height(10),
              Padding(
                padding: FxSpacing.horizontal(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.b2(
                      'Nos Spécialités',
                      fontWeight: 700,
                      color: customAppTheme.colorTextFeed,
                    ),
                  ],
                ),
              ),
              FxSpacing.height(24),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildCategoryList(),
                ),
              ),
              FxSpacing.height(16),
              Padding(
                padding: FxSpacing.horizontal(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.b2(
                      'Médecins',
                      color: customAppTheme.colorTextFeed,
                      fontWeight: 700,
                    ),
                  ],
                ),
              ),
              FxSpacing.height(24),
              if (asData == true)
                Column(
                  children: _buildDoctorList(),
                ),
              if (asData == false)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (asError == true)
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
                            context.refresh(doctorsControllerDataProvider);
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
              /*   if (profile != "Dr")
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where('profile', isEqualTo: "Dr")
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
                            "No Doctor found",
                            style: TextStyle(
                                fontSize: 20,
                                color: customAppTheme.colorTextFeed,
                                fontWeight: FontWeight.bold),
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
                        return _buildSingleDoctor1(
                          name: snapshot.data!.docs[index]["name"],
                          prenom: "",
                          profile: snapshot.data!.docs[index]["profile"],
                          email: snapshot.data!.docs[index]["email"],
                        );
                      }),
                    );
                  }
                },
              ),
            if (profile == "Dr")
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where('profile', isEqualTo: "P")
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
                            "No Patient found",
                            style: TextStyle(
                                fontSize: 20,
                                color: customAppTheme.colorTextFeed,
                                fontWeight: FontWeight.bold),
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
                        return _buildPatient(
                          name: snapshot.data!.docs[index]["name"],
                          prenom: "",
                          profile: snapshot.data!.docs[index]["profile"],
                          email: snapshot.data!.docs[index]["email"],
                        );
                      }),
                    );
                  }
                },
              ),
           */
            ],
          ));
    }));
  }
}
