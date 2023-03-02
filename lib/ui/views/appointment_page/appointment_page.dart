import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/doctors/user.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/ui/utils/SizeConfig.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/text_style.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/home_page/models/date_time.dart';
import 'package:sesa/ui/views/home_page/models/slot.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:uuid/uuid.dart';

class AppointmentPage extends StatefulWidget {
  final UserDoctor doctor;
  AppointmentPage({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  late int selectedDate = 0;
  late int selectedSlot = 0;
  late List<String> morningSlots;
  late List<String> afternoonSlots;
  late List<String> eveningSlots;
  late CustomAppTheme customAppTheme;

  late String dateIsSelected = DateTime.now().toString().split(' ').first;
  late String hourIsSelected = "08:00";

  TextEditingController description = TextEditingController();
  int selectCategory = -1;
  late DateTime now = DateTime.now();
  bool create = true;

  String dateSlot = DateTime.now().toString().split(' ').first;
  late String timeSlot;
  final ApiService _apiService = GetIt.instance.get<ApiService>();

  String selectStringDate =
      (DateFormat('EEEE').format(DateTime.now())).toLowerCase();

  @override
  initState() {
    super.initState();
    morningSlots = Slot.morningList();
    afternoonSlots = Slot.afternoonList();
  }

  Widget singleDateWidget(
      {String? date, DateTime? dat, required int index, String? stringDate}) {
    String type = dat.toString().split(' ').first;
    if (selectedDate == index) {
      return InkWell(
        onTap: () {
          setState(() {
            selectedDate = index;
            selectStringDate = stringDate!.toLowerCase();
            dateSlot = type;
            dateIsSelected = type;
          });
          print(type);
        },
        child: Container(
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: kPrimary,
          ),
          padding: Spacing.fromLTRB(0, 8, 0, 14),
          child: Column(
            children: [
              Text(
                date!,
                /* style: AppTheme.getTextStyle(themeData.textTheme.caption,
                    fontWeight: 600,
                    color: themeData.colorScheme.onPrimary,
                    height: 1.9,), */
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: customAppTheme.kWhite,
                  height: 1.9,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: Spacing.top(12),
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: customAppTheme.kWhite,
                  shape: BoxShape.circle,
                ),
              )
            ],
          ),
        ),
      );
    }
    return InkWell(
      onTap: () {
        setState(() {
          selectedDate = index;
          selectStringDate = stringDate!.toLowerCase();
          dateSlot = type;
          dateIsSelected = type;
        });
        print(type);
      },
      child: Container(
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: customAppTheme.bgLayer1,
            boxShadow: [
              BoxShadow(
                color: customAppTheme.shadowColor,
                blurRadius: 0.5,
                spreadRadius: 0.0,
                offset: Offset(0, 0.1),
              )
            ]),
        padding: Spacing.fromLTRB(0, 8, 0, 14),
        child: Column(
          children: [
            Text(
              date!,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: customAppTheme.colorTextFeed,
                height: 1.9,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMorningSlotList() {
    List<Widget> list = [];
    for (int i = 0; i < morningSlots.length; i++) {
      list.add(_buildSingleSlot(time: morningSlots[i], index: i));
    }
    return list;
  }

  List<Widget> _buildAfternoonSlotList() {
    List<Widget> list = [];
    for (int i = 0; i < afternoonSlots.length; i++) {
      list.add(_buildSingleSlot(
          time: afternoonSlots[i], index: i + morningSlots.length));
    }
    return list;
  }

  Widget _buildSingleSlot({String? time, int? index}) {
    return InkWell(
        onTap: () {
          setState(() {
            selectedSlot = index!;
            hourIsSelected = time!;
          });
        },
        child: FxContainer(
          color: selectedSlot == index ? kPrimary : customAppTheme.bgLayer2,
          child: Text(
            time!,
            style: FxTextStyle.caption(
                fontWeight: 700,
                color: selectedSlot == index
                    ? customAppTheme.medicareOnPrimary
                    : customAppTheme.colorTextFeed),
          ),
          padding: FxSpacing.symmetric(vertical: 8, horizontal: 16),
          borderRadiusAll: 4,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
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
            'Appointment',
            style: FxTextStyle.b1(fontWeight: 700),
          ),
        ),
        body: Container(
          color: customAppTheme.kBackgroundColorFinal,
          child: Column(
            children: [
              SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: FxSpacing.x(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      singleDateWidget(
                        date:
                            "${now.day}\n${DateFormat('EEEE').format(now).substring(0, 3)}",
                        dat: now,
                        index: 0,
                        stringDate: DateFormat('EEEE').format(now),
                      ),
                      FxSpacing.width(18),
                      singleDateWidget(
                        date:
                            "${now.add(Duration(days: 1)).day}\n${DateFormat('EEEE').format(now.add(Duration(days: 1))).substring(0, 3)}",
                        index: 1,
                        dat: now.add(Duration(days: 1)),
                        stringDate: DateFormat('EEEE')
                            .format(now.add(Duration(days: 1))),
                      ),
                      FxSpacing.width(18),
                      singleDateWidget(
                        date:
                            "${now.add(Duration(days: 2)).day}\n${DateFormat('EEEE').format(now.add(Duration(days: 2))).substring(0, 3)}",
                        index: 2,
                        dat: now.add(Duration(days: 2)),
                        stringDate: DateFormat('EEEE')
                            .format(now.add(Duration(days: 2))),
                      ),
                      FxSpacing.width(18),
                      singleDateWidget(
                        date:
                            "${now.add(Duration(days: 3)).day}\n${DateFormat('EEEE').format(now.add(Duration(days: 3))).substring(0, 3)}",
                        index: 3,
                        dat: now.add(Duration(days: 3)),
                        stringDate: DateFormat('EEEE')
                            .format(now.add(Duration(days: 3))),
                      ),
                      FxSpacing.width(18),
                      singleDateWidget(
                        date:
                            "${now.add(Duration(days: 4)).day}\n${DateFormat('EEEE').format(now.add(Duration(days: 4))).substring(0, 3)}",
                        index: 4,
                        dat: now.add(Duration(days: 4)),
                        stringDate: DateFormat('EEEE')
                            .format(now.add(Duration(days: 4))),
                      ),
                      FxSpacing.width(18),
                      singleDateWidget(
                        date:
                            "${now.add(Duration(days: 5)).day}\n${DateFormat('EEEE').format(now.add(Duration(days: 5))).substring(0, 3)}",
                        index: 5,
                        dat: now.add(Duration(days: 5)),
                        stringDate: DateFormat('EEEE')
                            .format(now.add(Duration(days: 5))),
                      ),
                      FxSpacing.width(18),
                      singleDateWidget(
                        date:
                            "${now.add(Duration(days: 6)).day}\n${DateFormat('EEEE').format(now.add(Duration(days: 6))).substring(0, 3)}",
                        index: 6,
                        dat: now.add(Duration(days: 6)),
                        stringDate: DateFormat('EEEE')
                            .format(now.add(Duration(days: 6))),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: FxSpacing.all(24),
                  children: [
                    Text(
                      'Morning Slots',
                      style: FxTextStyle.b2(fontWeight: 800),
                    ),
                    FxSpacing.height(8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: _buildMorningSlotList(),
                    ),
                    FxSpacing.height(32),
                    Text(
                      'Afternoon Slots',
                      style: FxTextStyle.b2(fontWeight: 800),
                    ),
                    FxSpacing.height(8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: _buildAfternoonSlotList(),
                    ),
                    FxSpacing.height(32),
                  ],
                ),
              ),
              Padding(
                padding: FxSpacing.all(24),
                child: FxButton.block(
                  borderRadiusAll: 8,
                  onPressed: () {
                    print(dateIsSelected);
                    print(hourIsSelected);

                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(auth.user.email)
                        .collection("appointments")
                        .doc(Uuid().v4())
                        .set({
                      "author": auth.user.email,
                      "nameAuthor":
                          auth.user.firstName + " " + auth.user.lastName,
                      "forAuthor": widget.doctor.email,
                      "forName": widget.doctor.lastName +
                          " " +
                          widget.doctor.firstName,
                      "day": dateIsSelected,
                      "hour": hourIsSelected,
                      "status": "P",
                      "createdAt": DateTime.now()
                    }).then((value) {
                      print("Reuusiiiiii");
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.doctor.email)
                          .collection("appointments")
                          .doc(Uuid().v4())
                          .set({
                        "author": auth.user.email,
                        "nameAuthor":
                            auth.user.firstName + " " + auth.user.lastName,
                        "forAuthor": widget.doctor.email,
                        "forName": widget.doctor.lastName +
                            " " +
                            widget.doctor.firstName,
                        "day": dateIsSelected,
                        "hour": hourIsSelected,
                        "status": "P",
                        "createdAt": DateTime.now()
                      }).then((value) {
                        Fluttertoast.showToast(
                          msg: 'Rendez-vous enregistré',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          backgroundColor: kPrimary,
                        );
                        Navigator.pop(context);
                      });
                    });
                    /*  */
                  },
                  backgroundColor: kPrimary,
                  child: Text(
                    "Confirm Appointment",
                    style: FxTextStyle.b2(
                      fontWeight: 700,
                      color: KWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
