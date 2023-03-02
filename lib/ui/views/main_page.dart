import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:sesa/core/controllers/token_controller_data.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/doctors/user_data.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/resources/user_state_methods.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/enum/user_state.dart';
import 'package:sesa/ui/utils/storage.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/text_style.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/call_screens/pickup/pickup_layout.dart';
import 'package:sesa/ui/views/ecommerce_page/ecommerce_page.dart';
import 'package:sesa/ui/views/home_page/doctor_page.dart';
import 'package:sesa/ui/views/home_page/home_page.dart';
import 'package:sesa/ui/views/payment_page/pack_categorie.dart';
import 'package:sesa/ui/views/payment_page/payment_page.dart';
import 'package:sesa/ui/views/profile_page/profile_page.dart';
import 'package:sesa/ui/widgets/bottom_navigation/bottom_navigation_bar.dart';
import 'package:sesa/ui/widgets/bottom_navigation/bottom_navigation_bar_item.dart';

class MainPage extends StatefulWidget {
  final String uuid;
  final String utype;
  const MainPage({
    Key? key,
    required this.uuid,
    required this.utype,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late CustomAppTheme customAppTheme;
  ApiService _apiService = ApiService();
  bool paid = false;
  String profile = "";
  TextEditingController _etMessage = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late UserData auth;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        widget.uuid != null
            ? UserStateMethods()
                .setUserState(userId: widget.uuid, userState: UserState.Online)
            : print("Resumed State");
        break;
      case AppLifecycleState.inactive:
        widget.uuid != null
            ? UserStateMethods()
                .setUserState(userId: widget.uuid, userState: UserState.Offline)
            : print("Inactive State");
        break;
      case AppLifecycleState.paused:
        widget.uuid != null
            ? UserStateMethods()
                .setUserState(userId: widget.uuid, userState: UserState.Waiting)
            : print("Paused State");
        break;
      case AppLifecycleState.detached:
        widget.uuid != null
            ? UserStateMethods()
                .setUserState(userId: widget.uuid, userState: UserState.Offline)
            : print("Detached State");
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    //getUser();
    print("the widget utype is ${widget.utype}");
  }

  /* getUser() async {
    String uuid = await readStorage(value: "uid");
    String dd = await readStorage(value: "profile");
    final DocumentSnapshot user =
        await FirebaseFirestore.instance.collection("users").doc(uuid).get();
    setState(() {
      paid = user["paid"];
      profile = dd;
    });
  } */

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        final token = watch(tokenProvider.state);
        auth = watch(authProvider.state);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        if (token.token!.isNotEmpty) {
          setStorage("agoraToken", token.token!);
          setStorage("uidToken", token.channel!);
        }
        return PickupLayout(
          uid: widget.uuid,
          scaffold: Scaffold(
            resizeToAvoidBottomInset: false,
            drawerScrimColor: Colors.black87,
            key: _scaffoldKey,
            /* drawer: Drawer(
            scaffoldKey: _scaffoldKey,
            fadeInFadeOut: _fadeInFadeOut,
          ), */
            body: FxBottomNavigationBar(
              activeIconColor: kPrimary,
              iconColor: kUnselectedButton.withAlpha(140),
              activeContainerColor: kPrimary.withAlpha(30),
              activeIconSize: 24,
              iconSize: 24,
              itemList: [
                FxBottomNavigationBarItem(
                  page: (widget.utype == "P") ? HomePage() : DoctorPagee(),
                  activeIconData: Icons.house,
                  iconData: Icons.house_outlined,
                ),
                /* FxBottomNavigationBarItem(
                page: HomePage(),
                activeIconData: MdiIcons.hospital,
                iconData: MdiIcons.hospitalBoxOutline,
              ), */
                FxBottomNavigationBarItem(
                  page: EcommercePage(
                    rootContext: context,
                  ),
                  activeIconData: MdiIcons.shopping,
                  iconData: MdiIcons.shoppingOutline,
                ),
                FxBottomNavigationBarItem(
                  page: MediCareProfileScreen(),
                  activeIconData: Icons.person,
                  iconData: Icons.person_outline,
                ),
              ],
              fxBottomNavigationBarType: FxBottomNavigationBarType.containered,
              backgroundColor: customAppTheme.kBackgroundColorFinal,
              showLabel: false,
              showActiveLabel: false,
              labelSpacing: 2,
              initialIndex: 0,
              labelDirection: Axis.horizontal,
            ),
            floatingActionButton: (widget.utype == "P")
                ? DraggableFab(
                    initPosition: Offset(
                        MediaQuery.of(context).size.width / 1.5,
                        MediaQuery.of(context).size.height / 1.23),
                    child: FloatingActionButton(
                      onPressed: () async {
                        //_scaffoldKey.currentState?.openDrawer();
                        if (auth.user.abonnements.length > 0) {
                          _showPopup3();
                        } else {
                          _makeASubscription();
                        }
                      },
                      backgroundColor: kPrimary,
                      child: Icon(
                        MdiIcons.bellBadge,
                        color: customAppTheme.kWhite,
                        size: 30,
                      ),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }

  void _showPopup3() {
    // set up the buttons
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: 'Press Cancel', toastLength: Toast.LENGTH_SHORT);
        },
        child: Text('Fermer', style: TextStyle(color: kPrimary)));
    Widget continueButton = TextButton(
        onPressed: () {
          _apiService
              .sosDoctor(_etMessage.text,
                  "${auth.user.lastName} ${auth.user.firstName}")
              .then((value) {
            if (value["status"] == 200) {
              Fluttertoast.showToast(
                msg: "SOS Envoyé",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 5,
                backgroundColor: kPrimary,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.pop(context);
            } else {
              Fluttertoast.showToast(
                msg: "Veuillez reasseye s'il vous plait",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 5,
                backgroundColor: kRedColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          });
          //_getCurrentLocation();
        },
        child: Text('Envoyer', style: TextStyle(color: kPrimary)));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: customAppTheme.kBackgroundColor,
      title: Text(
        'Envoyer une URGENCE ',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Détailler l\'urgence ici, préciser tous les détails nécessaire pour vous aider rapidement.',
            style: TextStyle(
              fontSize: 13,
              color: customAppTheme.colorTextFeed,
            ),
          ),
          TextField(
            autofocus: true,
            controller: _etMessage,
            style: TextStyle(color: customAppTheme.colorTextFeed),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimary,
                  width: 2.0,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCCCCCC)),
              ),
            ),
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

  void _makeASubscription() {
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Fermer', style: TextStyle(color: kPrimary)));
    Widget continueButton = TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PackCategoriePage(),
            ),
          );
          //_getCurrentLocation();
        },
        child: Text('Souscrire', style: TextStyle(color: kPrimary)));

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        'Vous devez souscrire à un abonnement ',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Vous ne pouvez pas envoyer un message d'urgence sans souscrire à un abonnement",
            style: TextStyle(
              fontSize: 13,
              color: customAppTheme.colorTextFeed,
            ),
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
}
