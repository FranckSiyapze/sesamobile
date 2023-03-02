import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:sesa/core/controllers/doctors_controllers.dart';
import 'package:sesa/core/controllers/medicament_controller/medicament_controller.dart';
import 'package:sesa/core/controllers/prestations/prestation_controller.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/doctors/user_data.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/ui/utils/SizeConfig.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/flash.dart';
import 'package:sesa/ui/utils/progress_widget.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/star_rating.dart';
import 'package:sesa/ui/utils/storage.dart';
import 'package:sesa/ui/utils/themes/app_theme.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/text_style.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/appointment_page/myappointment.dart';
import 'package:sesa/ui/views/chats/chat_page.dart';
import 'package:sesa/ui/views/home_page/models/category.dart';
import 'package:sesa/ui/views/home_page/models/doctor.dart';
import 'package:sesa/ui/views/login_page/login_page.dart';
import 'package:sesa/ui/views/profile_page/params.dart';
import 'package:sesa/ui/views/profile_page/profile_setting.dart';
import 'package:sesa/ui/views/subscription_page/subscription_page.dart';
import 'package:sesa/ui/widgets/card/card.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/text/text.dart';
import 'package:sesa/ui/widgets/text_field/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class MediCareProfileScreen extends StatefulWidget {
  const MediCareProfileScreen({Key? key}) : super(key: key);

  @override
  _MediCareProfileScreenState createState() => _MediCareProfileScreenState();
}

class _MediCareProfileScreenState extends State<MediCareProfileScreen> {
  late CustomAppTheme customAppTheme;
  ApiService _apiService = ApiService();
  GlobalKey gifBtnKey = GlobalKey();
  bool isLoading = false;
  ImagePicker picker = ImagePicker();
  Future getCamera(source) async {
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 20,
    );
    String type = "";
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String fileName = pickedFile.path.split('/').last;
      print("THe file isssss : $file");
      type = fileName.split('.').last;
      setState(() {
        isLoading = true;
      });
      uploadDocuement(file, auth.user.email);
    }
  }

  createLoading() {
    return Positioned(
      child: isLoading ? loading(context) : Container(),
    );
  }

  void listMenu() {
    PopupMenu menu = PopupMenu(
      context: context,
      items: [
        MenuItem(
            title: 'Camera',
            image: Icon(
              Icons.camera_alt,
              color: Colors.white,
            )),
        MenuItem(
            title: 'Gallery',
            image: Icon(
              Icons.image,
              color: Colors.white,
            )),
      ],
      onClickMenu: onClickMenu,
      onDismiss: onDismiss,
    );

    menu.show(
      widgetKey: gifBtnKey,
    );
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  void onClickMenu(
    MenuItemProvider item,
  ) {
    switch (item.menuTitle) {
      case "Camera":
        getCamera(ImageSource.camera);
        //getImage(ImgSource.Camera);
        /* setState(() {
          isDisplaySticker = false;
        }); */
        break;

      case "Gallery":
        getCamera(ImageSource.gallery);
        //getImage(ImgSource.Gallery);
        /*setState(() {
          isDisplaySticker = false;
        }); */
        break;
    }

    print('Click menu -> ${item.menuTitle}');
  }

  Widget _buildSingleRow({String? title, IconData? icon}) {
    return Row(
      children: [
        FxContainer(
          paddingAll: 8,
          borderRadiusAll: 4,
          color: customAppTheme.kBackgroundColor,
          child: Icon(
            icon,
            color: AppTheme.customTheme.medicarePrimary,
            size: 20,
          ),
        ),
        FxSpacing.width(16),
        Expanded(
          child: FxText.caption(
            title!,
            letterSpacing: 0.5,
            color: customAppTheme.colorTextFeed,
          ),
        ),
        FxSpacing.width(16),
        Icon(
          Icons.keyboard_arrow_right,
          color: customAppTheme.kBackgroundColor.withAlpha(160),
        ),
      ],
    );
  }

  late UserData auth;

  Future uploadDocuement(imageFile, String email) async {
    String imageUrl = "";
    String fileName =
        email + "-" + DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child("profilesUser").child(fileName);
    TaskSnapshot storageUploadTask = await storageReference.putFile(imageFile!);
    storageUploadTask.ref.getDownloadURL().then((downloadUrl) {
      //print("storageUploadTask: " + downloadUrl);
      imageUrl = downloadUrl;
      setState(() {
        //onSendMessage(imageUrl!, MessageType.Pdf);
        _apiService
            .updateProfile(
                id: auth.user.userId,
                firstName: auth.user.firstName,
                lastName: auth.user.lastName,
                birthdate: auth.user.birthdate,
                birthdatePlace: auth.user.birthdatePlace,
                sexe: auth.user.sexe,
                maritalStatus: auth.user.maritalStatus,
                nationality: auth.user.nationality,
                imageUrl: imageUrl)
            .then((value) {
          print("THe valus is $value");
          if (value["status"] == 201) {
            setState(() {
              isLoading = false;
            });
            context.refresh(authProvider);
          } else {
            showSnackBar(
              context: context,
              message: "Impossible de mettre à jour, veuillew reesayer",
              isError: true,
            );
          }
        });
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      print("Error: " + error);
      showSnackBar(
        context: context,
        message: "Impossible de mettre à jour, veuillew reesayer",
        isError: true,
      );
      //Fluttertoast.showToast(msg: "Error: " + error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        auth = watch(authProvider.state);
        return Scaffold(
          backgroundColor: customAppTheme.kBackgroundColorFinal,
          body: Stack(
            children: [
              ListView(
                padding: FxSpacing.fromLTRB(24, 48, 24, 24),
                children: [
                  if (auth.asData)
                    Column(
                      children: [
                        FxSpacing.height(24),
                        Center(
                          child: (auth.user.imageUrl == null &&
                                  auth.user.imageUrl == "")
                              ? Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    FxContainer(
                                      paddingAll: 0,
                                      borderRadiusAll: 24,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(24),
                                        ),
                                        child: Image(
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                          image: AssetImage(
                                              'assets/images/sesabw.png'),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom:
                                          MediaQuery.of(context).size.height /
                                              300,
                                      right: -10,
                                      child: InkWell(
                                        key: gifBtnKey,
                                        onTap: () {
                                          listMenu();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: customAppTheme.kWhite,
                                                width: 2,
                                                style: BorderStyle.solid),
                                            color: customAppTheme.kVioletColor,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Icon(
                                              MdiIcons.camera,
                                              size: 20,
                                              color: customAppTheme.kWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    FxContainer(
                                      paddingAll: 0,
                                      borderRadiusAll: 24,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(24),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: auth.user.imageUrl,
                                          fit: BoxFit.cover,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder:
                                              (context, imageProvider) =>
                                                  ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)),
                                            child: Image(
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                              image: AssetImage(
                                                  'assets/images/sesabw.png'),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)),
                                            child: Image(
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                              image: AssetImage(
                                                  'assets/images/sesabw.png'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom:
                                          MediaQuery.of(context).size.height /
                                              300,
                                      right: -10,
                                      child: InkWell(
                                        key: gifBtnKey,
                                        onTap: () {
                                          listMenu();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: customAppTheme.kWhite,
                                                width: 2,
                                                style: BorderStyle.solid),
                                            color: customAppTheme.kVioletColor,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Icon(
                                              MdiIcons.camera,
                                              size: 20,
                                              color: customAppTheme.kWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                        ),
                        FxSpacing.height(24),
                        FxText.h6(
                          '${auth.user.lastName} ${auth.user.firstName}',
                          textAlign: TextAlign.center,
                          fontWeight: 600,
                          letterSpacing: 0.8,
                          color: customAppTheme.colorTextFeed,
                        ),
                        FxSpacing.height(4),
                        /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FxContainer.rounded(
                        color: AppTheme.customTheme.medicarePrimary,
                        height: 6,
                        width: 6,
                        child: Container(),
                      ),
                      FxSpacing.width(6),
                      FxText.button(
                        'Premium (9 days)',
                        color: AppTheme.customTheme.medicarePrimary,
                        muted: true,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ), */
                        FxSpacing.height(24),
                        FxText.caption(
                          'Général',
                          color: customAppTheme.colorTextFeed,
                          xMuted: true,
                        ),
                        FxSpacing.height(24),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubscriptionPage(),
                              ),
                            );
                          },
                          child: _buildSingleRow(
                              title: 'Subscription & payment',
                              icon: MdiIcons.creditCard),
                        ),
                        FxSpacing.height(8),
                        Divider(),
                        FxSpacing.height(8),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileSetting(
                                  user: auth.user,
                                ),
                              ),
                            );
                          },
                          child: _buildSingleRow(
                            title: 'Profile settings',
                            icon: Icons.person,
                          ),
                        ),
                        FxSpacing.height(8),
                        /* Divider(),
                  FxSpacing.height(8),
                  _buildSingleRow(title: 'Password', icon: MdiIcons.lock), */
                        Divider(),
                        FxSpacing.height(8),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyAppointmentPage(),
                              ),
                            );
                          },
                          child: _buildSingleRow(
                            title: 'Mes rendez-vous',
                            icon: MdiIcons.api,
                          ),
                        ),
                        Divider(),
                        FxSpacing.height(8),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(),
                              ),
                            );
                          },
                          child: _buildSingleRow(
                              title: 'Mes Chats', icon: MdiIcons.message),
                        ),
                        FxSpacing.height(8),
                        if (auth.user.roles.length == 1) Divider(),
                        if (auth.user.roles.length == 1) FxSpacing.height(8),
                        if (auth.user.roles.length == 1)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ParamsPatient(),
                                ),
                              );
                            },
                            child: _buildSingleRow(
                                title: 'Mes paramètres',
                                icon: MdiIcons.eyeSettings),
                          ),
                        FxSpacing.height(8),
                        Divider(),
                        FxSpacing.height(8),
                        Row(
                          children: [
                            FxContainer(
                              paddingAll: 8,
                              borderRadiusAll: 4,
                              color: FxAppTheme.theme.colorScheme.onBackground
                                  .withAlpha(20),
                              child: Icon(
                                Icons.dark_mode,
                                color: AppTheme.customTheme.medicarePrimary,
                                size: 20,
                              ),
                            ),
                            FxSpacing.width(16),
                            Expanded(
                              child: FxText.caption(
                                "Mode Dark",
                                letterSpacing: 0.5,
                                color: customAppTheme.colorTextFeed,
                              ),
                            ),
                            FxSpacing.width(16),
                            CupertinoSwitch(
                              value: themeProvider.value(),
                              onChanged: (value) {
                                if (themeProvider.themeMode() == 1) {
                                  themeProvider.updateTheme(2, true);
                                } else {
                                  themeProvider.updateTheme(1, false);
                                }
                                print(themeProvider.themeMode());
                                //state = value;
                                //print(value);

                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        Divider(),
                        FxSpacing.height(8),
                        InkWell(
                          onTap: () async {
                            print("logout");
                            await storage.delete(key: "loginstatus");
                            //await storage.deleteAll();
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: _buildSingleRow(
                              title: 'Logout', icon: MdiIcons.logout),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
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
                                padding: MaterialStateProperty.all(
                                    Spacing.xy(16, 0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(kPrimary),
                              ),
                              onPressed: () {
                                context.refresh(doctorsControllerDataProvider);
                                context
                                    .refresh(prestationsControllerDataProvider);
                                context.refresh(medocsControllerDataProvider);
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
              createLoading(),
            ],
          ),
        );
      },
    );
  }
}
