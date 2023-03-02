import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';

import 'package:sesa/core/models/doctors/user.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/text/text.dart';

class ProfileSetting extends StatefulWidget {
  final UserDoctor user;
  const ProfileSetting({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  late CustomAppTheme customAppTheme;
  DateTime selectedDate = DateTime.now();
  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController birthdate = TextEditingController();
  TextEditingController birthdateF = TextEditingController();
  TextEditingController birthdatePlace = TextEditingController();
  TextEditingController sexe = TextEditingController();
  TextEditingController maritalStatus = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController tel1 = TextEditingController();
  bool signIn = false;
  ApiService _apiService = ApiService();
  String selectedValue = "";
  String selectedValue1 = "";
  String selectedValue2 = "";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Aucun"), value: ""),
      DropdownMenuItem(child: Text("Masculin"), value: "M"),
      DropdownMenuItem(child: Text("Feminin"), value: "F"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItems1 {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Aucun"), value: ""),
      DropdownMenuItem(child: Text("Celibataire"), value: "Celibataire"),
      DropdownMenuItem(child: Text("Marié(e)"), value: "Marié(e)"),
      DropdownMenuItem(child: Text("Veuf(ve)"), value: "Veuf(ve)"),
      DropdownMenuItem(child: Text("Divorcé"), value: "Divorcé"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItems2 {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Autres"), value: "Autres"),
      DropdownMenuItem(child: Text("Camerounais"), value: "Camerounais"),
    ];
    return menuItems;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    email.text = widget.user.email;
    firstName.text = widget.user.firstName;
    lastName.text = widget.user.lastName;
    birthdate.text = widget.user.birthdate;
    birthdatePlace.text = widget.user.birthdatePlace;
    print(widget.user.sexe);
    if (widget.user.sexe == "M") {
      selectedValue = "M";
    } else if (widget.user.sexe == "F") {
      selectedValue = "F";
    }
    if (widget.user.maritalStatus == "Celibataire") {
      selectedValue1 = "Celibataire";
    } else if (widget.user.maritalStatus == "Marié(e)") {
      selectedValue1 = "Marié(e)";
    } else if (widget.user.maritalStatus == "Veuf(ve)") {
      selectedValue1 = "Marié(e)";
    } else if (widget.user.maritalStatus == "Divorcé") {
      selectedValue1 = "Divorcé";
    }

    if (widget.user.nationality == "Camerounais") {
      selectedValue2 = "Camerounais";
    }
    //sexe.text = widget.user.sexe;
    //maritalStatus.text = widget.user.maritalStatus;
    //nationality.text = widget.user.nationality;
    tel1.text = widget.user.tel1;
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
          body: ListView(
            padding: FxSpacing.fromLTRB(24, 0, 24, 24),
            children: [
              FxText.h6(
                'Profil',
                textAlign: TextAlign.left,
                fontWeight: 600,
                letterSpacing: 0.8,
                color: customAppTheme.colorTextFeed,
              ),
              FxSpacing.height(20),
              TextFormField(
                controller: email,
                readOnly: true,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.mail,
                    color: KPlaceholder,
                  ),
                  suffixIcon: const Icon(
                    Icons.lock,
                    color: KPlaceholder,
                  ),
                  hintText: "Enter email",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              TextFormField(
                controller: firstName,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: KPlaceholder,
                  ),
                  hintText: "Enter firstname",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              TextFormField(
                controller: lastName,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: KPlaceholder,
                  ),
                  hintText: "Enter Lastname",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              TextFormField(
                controller: tel1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: KPlaceholder,
                  ),
                  hintText: "Enter phone",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              TextFormField(
                controller: birthdate,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(1800, 1),
                    lastDate: DateTime(2101),
                  );
                  if (!mounted) return;
                  setState(() {
                    birthdate.text = Jiffy([
                      picked!.year.toInt(),
                      picked.month.toInt(),
                      picked.day.toInt()
                    ]).yMMMMd;
                    var dt = picked.toString().split(' ');
                    var dy = dt[0].toString().split('-');
                    birthdateF.text = dy[2] + "-" + dy[1] + "-" + dy[0];
                  });
                },
                readOnly: true,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.date_range,
                    color: KPlaceholder,
                  ),
                  hintText: "Enter Date of birth",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              TextFormField(
                controller: birthdatePlace,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.place,
                    color: KPlaceholder,
                  ),
                  hintText: "Enter place of birth",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              Row(
                children: [
                  Text("Sexe : "),
                  FxSpacing.width(10),
                  DropdownButton(
                    value: selectedValue,
                    items: dropdownItems,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value!;
                      });
                      setState(() {
                        sexe.text = selectedValue;
                      });
                    },
                  ),
                ],
              ),
              FxSpacing.height(20),
              Row(
                children: [
                  Text("Situation Matrimoniale : "),
                  FxSpacing.width(10),
                  DropdownButton(
                    value: selectedValue1,
                    items: dropdownItems1,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue1 = value!;
                      });
                      setState(() {
                        maritalStatus.text = selectedValue1;
                      });
                    },
                  ),
                ],
              ),
              FxSpacing.height(20),
              Row(
                children: [
                  Text("Nationalité : "),
                  FxSpacing.width(10),
                  DropdownButton(
                    value: selectedValue2,
                    items: dropdownItems2,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue2 = value!;
                      });
                      setState(() {
                        nationality.text = selectedValue2;
                      });
                    },
                  ),
                ],
              ),
              FxSpacing.height(16),
              FxButton.block(
                onPressed: () {
                  setState(() {
                    signIn = true;
                  });
                  _apiService
                      .updateProfile(
                          id: widget.user.userId,
                          firstName: firstName.text,
                          lastName: lastName.text,
                          birthdate: birthdateF.text,
                          birthdatePlace: birthdatePlace.text,
                          sexe: selectedValue,
                          maritalStatus: selectedValue1,
                          imageUrl: auth.user.imageUrl,
                          nationality: selectedValue2)
                      .then((value) {
                    if (value["status"] == 201) {
                      context.refresh(authProvider);
                      //Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: "MISE A JOUR REUSSI",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 30,
                        backgroundColor: kPrimary,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      setState(() {
                        signIn = false;
                      });
                    } else {
                      setState(() {
                        signIn = false;
                      });
                      Fluttertoast.showToast(
                        msg: value["message"],
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 5,
                        backgroundColor: kRedColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  });
                },
                backgroundColor: kPrimary,
                borderRadiusAll: 8,
                child: !signIn
                    ? FxText.sh2(
                        "Modifier",
                        fontWeight: 700,
                        color: KWhite,
                        letterSpacing: 0.4,
                      )
                    : CircularProgressIndicator(
                        color: KWhite,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
