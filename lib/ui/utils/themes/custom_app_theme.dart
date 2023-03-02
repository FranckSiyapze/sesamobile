import 'package:flutter/material.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';

class AppTheme {
  static final int themeLight = 1;
  static final int themeDark = 2;
  static CustomAppTheme customTheme = getCustomAppTheme(AppThemeNotifier.theme);
  //static ThemeData theme = getThemeFromThemeMode(AppThemeNotifier.theme);

  AppTheme._();

  static CustomAppTheme getCustomAppTheme(int? themeMode) {
    if (themeMode == themeLight) {
      return CustomAppTheme.lightCustomAppTheme;
    } else if (themeMode == themeDark) {
      return CustomAppTheme.darkCustomAppTheme;
    }
    return CustomAppTheme.darkCustomAppTheme;
  }
}

class CustomAppTheme {
  final colorTextFeed,
      kBackgroundColorFinal,
      kBackgroundColor,
      blackColor,
      kVioletColor,
      kWhite,
      unselectedButton,
      kButton,
      ktransparent,
      kGreen,
      kgrayColor,
      ktopIcon;
  final Color bgLayer1,
      bgLayer2,
      bgLayer3,
      bgLayer4,
      border1,
      border2,
      disabledColor,
      onDisabled,
      colorInfo,
      colorWarning,
      colorSuccess,
      colorError,
      shadowColor,
      onInfo,
      onWarning,
      onSuccess,
      onError,
      shimmerBaseColor,
      shimmerHighlightColor;

  final Color groceryBg1, groceryBg2;
  final Color groceryPrimary, groceryOnPrimary;

  final Color medicarePrimary, medicareOnPrimary;

  final Color cookifyPrimary, cookifyOnPrimary;

  final Color lightBlack,
      red,
      green,
      yellow,
      orange,
      blue,
      purple,
      pink,
      brown,
      violet,
      indigo;

  final Color estatePrimary,
      estateOnPrimary,
      estateSecondary,
      estateOnSecondary;
  final Color datingPrimary,
      datingOnPrimary,
      datingSecondary,
      datingOnSecondary;

  final Color homemadePrimary,
      homemadeSecondary,
      homemadeOnPrimary,
      homemadeOnSecondary;

  CustomAppTheme({
    this.kBackgroundColorFinal = const Color(0xffffffff),
    this.unselectedButton = const Color(0xff495057),
    this.kGreen = const Color(0xFF4CAF50),
    this.ktopIcon = const Color(0xFF7e57c2),
    this.ktransparent = const Color.fromARGB(0, 255, 255, 255),
    this.kButton = const Color(0xFF2D3E50),
    this.kWhite = const Color(0xffffffff),
    this.kgrayColor = const Color(0xFF9E9E9E),
    this.kVioletColor = const Color(0xFF7e57c2),
    this.blackColor = const Color.fromARGB(255, 0, 0, 0),
    this.kBackgroundColor = const Color(0xfff6f6f6),
    this.colorTextFeed = const Color(0xBD0E0C0C),
    this.border1 = const Color(0xffeeeeee),
    this.border2 = const Color(0xffe6e6e6),
    this.bgLayer1 = const Color(0xffffffff),
    this.bgLayer2 = const Color(0xfff8faff),
    this.bgLayer3 = const Color(0xfff8f8f8),
    this.bgLayer4 = const Color(0xffdcdee3),
    this.disabledColor = const Color(0xffdcc7ff),
    this.onDisabled = const Color(0xffffffff),
    this.colorWarning = const Color(0xffffc837),
    this.colorInfo = const Color(0xffff784b),
    this.colorSuccess = const Color(0xff3cd278),
    this.shadowColor = const Color(0xff1f1f1f),
    this.onInfo = const Color(0xffffffff),
    this.onWarning = const Color(0xffffffff),
    this.onSuccess = const Color(0xffffffff),
    this.colorError = const Color(0xfff0323c),
    this.onError = const Color(0xffffffff),
    this.shimmerBaseColor = const Color(0xFFF5F5F5),
    this.shimmerHighlightColor = const Color(0xFFE0E0E0),
    //Grocery color scheme

    this.groceryPrimary = const Color(0xff10bb6b),
    this.groceryOnPrimary = const Color(0xffffffff),
    this.groceryBg1 = const Color(0xfffbfbfb),
    this.groceryBg2 = const Color(0xfff5f5f5),

    //Cookify
    this.cookifyPrimary = const Color(0xffdf7463),
    this.cookifyOnPrimary = const Color(0xffffffff),

    //Color
    this.lightBlack = const Color(0xffa7a7a7),
    this.red = const Color(0xffFF0000),
    this.green = const Color(0xff008000),
    this.yellow = const Color(0xfffff44f),
    this.orange = const Color(0xffFFA500),
    this.blue = const Color(0xff0000ff),
    this.purple = const Color(0xff800080),
    this.pink = const Color(0xffFFC0CB),
    this.brown = const Color(0xffA52A2A),
    this.indigo = const Color(0xff4B0082),
    this.violet = const Color(0xff9400D3),

    //Medicare Color Scheme
    this.medicarePrimary = const Color(0xff6d65df),
    this.medicareOnPrimary = const Color(0xffffffff),

    //Estate Color Scheme
    this.estatePrimary = const Color(0xff1c8c8c),
    this.estateOnPrimary = const Color(0xffffffff),
    this.estateSecondary = const Color(0xfff15f5f),
    this.estateOnSecondary = const Color(0xffffffff),

    //Dating Color Scheme
    this.datingPrimary = const Color(0xffB428C3),
    this.datingOnPrimary = const Color(0xffffffff),
    this.datingSecondary = const Color(0xfff15f5f),
    this.datingOnSecondary = const Color(0xffffffff),

    //Homemade Color Scheme
    this.homemadePrimary = const Color(0xffc5558e),
    this.homemadeSecondary = const Color(0xffCC9D60),
    this.homemadeOnPrimary = const Color(0xffffffff),
    this.homemadeOnSecondary = const Color(0xffffffff),
  });

  //--------------------------------------  Custom App Theme ----------------------------------------//

  static final CustomAppTheme lightCustomAppTheme = CustomAppTheme(
      colorTextFeed: Color(0xBD0E0C0C),
      kBackgroundColorFinal: Color(0xffffffff),
      blackColor: Color.fromARGB(255, 0, 0, 0),
      kBackgroundColor: Color(0xfff6f6f6),
      ktopIcon: Color(0xFF7e57c2).withOpacity(0.3),
      kButton: Color(0xFF2D3E50),
      unselectedButton: Color(0xff495057),
      bgLayer1: Color(0xffffffff),
      bgLayer2: Color(0xfff9f9f9),
      bgLayer3: Color(0xffe8ecf4),
      bgLayer4: Color(0xffdcdee3),
      border1: const Color(0xffeeeeee),
      disabledColor: Color(0xff636363),
      onDisabled: Color(0xffffffff),
      colorInfo: Color(0xffff784b),
      colorWarning: Color(0xffffc837),
      colorSuccess: Color(0xff3cd278),
      shadowColor: Color(0xffd9d9d9),
      onInfo: Color(0xffffffff),
      onSuccess: Color(0xffffffff),
      onWarning: Color(0xffffffff),
      colorError: Color(0xfff0323c),
      onError: Color(0xffffffff),
      shimmerBaseColor: Color(0xFFF5F5F5),
      shimmerHighlightColor: Color(0xFFE0E0E0));

  static final CustomAppTheme darkCustomAppTheme = CustomAppTheme(
      colorTextFeed: Color(0xFFFFFFFF),
      kBackgroundColorFinal: Color(0xff212429),
      kBackgroundColor: Color(0xff383942),
      unselectedButton: Color(0xffffffff),
      kButton: Color(0xFFFFFFFF),
      ktopIcon: Color(0xff383942),
      blackColor: Color(0xFFFFFFFF),
      bgLayer1: Color(0xff212429),
      bgLayer2: Color(0xff282930),
      bgLayer3: Color(0xff303138),
      bgLayer4: Color(0xff383942),
      border1: Color.fromARGB(255, 75, 74, 74),
      border2: Color(0xff363636),
      disabledColor: Color(0xffbababa),
      onDisabled: Color(0xff000000),
      colorInfo: Color(0xffff784b),
      colorWarning: Color(0xffffc837),
      colorSuccess: Color(0xff3cd278),
      shadowColor: Color(0xffffffff),
      onInfo: Color(0xffffffff),
      onSuccess: Color(0xffffffff),
      onWarning: Color(0xffffffff),
      colorError: Color(0xfff0323c),
      onError: Color(0xffffffff),
      shimmerBaseColor: Color(0xFF1a1a1a),
      shimmerHighlightColor: Color(0xFF454545),

      //Grocery Dark
      groceryBg1: Color(0xff212429),
      groceryBg2: Color(0xff282930));
}
