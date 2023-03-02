import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sesa/ui/utils/spacing.dart';

const String CALL_STATUS_DIALLED = "dialled";
const String CALL_STATUS_RECEIVED = "received";

const String APP_ID = "b87ad04386734ecf8322d949023bb32a";
const String CALL_STATUS_MISSED = "missed";

formatDateTime(String starDate, String hour) {
  var dt = hour.split(':');
  var hr = "${dt[0]}:${dt[1]}";
  var chiffre = starDate.split("-");

  return isToday(starDate)
      ? hr
      : isYesterday(starDate)
          ? "Yesterday" + " at " + hr
          : dateString(starDate) + " ${chiffre[2]} at " + hr;
}

String checkDate(timestamp) {
  var day = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  var dt = day.toString().split(' ');
  var hr = dt[1].split('.');

  return formatDateTime(dt[0], hr[0]);
}

dividerFeed() {
  return Container(
    margin: FxSpacing.top(1.5),
    child: Divider(
      height: 0,
      thickness: 5,
      color: Color(0xFFf3f2ef),
    ),
  );
}

//Monday,Tuesday
dateString(date) {
  var dd = DateTime.parse(date);
  return DateFormat('EEEE').format(dd);
}

formatDate(String starDate) {
  return isToday(starDate)
      ? "Today"
      : isYesterday(starDate)
          ? "Yesterday"
          : dateToString(starDate);
}

formatTime(String hour) {
  var dt = hour.split(':');
  var hr = "${dt[0]}:${dt[1]}";
  return hr;
}

bool isToday(String date) {
  DateTime today = DateTime.now();
  DateTime curr = DateTime.parse(date);
  if (curr.day == today.day) {
    return true;
  } else {
    return false;
  }
}

bool isYesterday(String date) {
  DateTime today = DateTime.now();
  DateTime curr = DateTime.parse(date);
  if (curr.day == (today.day - 1)) {
    return true;
  } else {
    return false;
  }
}

dateToString(String date) {
  String finalDate = "";
  if (date != "") {
    DateTime start = DateTime.parse(date);
    finalDate =
        Jiffy([start.year.toInt(), start.month.toInt(), start.day.toInt()])
            .yMMMMd;
  } else {
    finalDate = "";
  }

  return finalDate;
}

dateTimeToString(String day) {
  String finalDate = "";
  if (day != "") {
    var dt = day.split('T');
    var hr = dt[1].split('.');
    finalDate = dateToString(dt[0]) + " at " + formatTime(hr[0]);
  } else {
    finalDate = "";
  }
  return finalDate;
}

bool isAvantHier(String date) {
  DateTime today = DateTime.now();
  DateTime curr = DateTime.parse(date);
  if (curr.day == (today.day - 2)) {
    return true;
  } else {
    return false;
  }
}

bool isTomorrow(String date) {
  DateTime today = DateTime.now();
  DateTime curr = DateTime.parse(date);
  if (curr.day == (today.day + 1)) {
    return true;
  } else {
    return false;
  }
}

bool isMonth(String date) {
  DateTime today = DateTime.now();
  DateTime curr = DateTime.parse(date);
  if (curr.month == (today.month + 1)) {
    return true;
  } else {
    return false;
  }
}

const String FCM_SERVER_KEY =
    "AAAAGr5yG2s:APA91bEe5lEb_XCKdDHZ8F96d_sg-nD394gWcMPdjVncCi6bdzw4c9quQBwCIY4YOApfixw-AzoaEQQvB7vvtHIdWBVxVTQNTu6mjJQAuMEMZUBzJJB6Zgmhk1FdAU2hZf_FEIoLy37c";

