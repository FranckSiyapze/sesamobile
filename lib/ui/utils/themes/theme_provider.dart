/*
* File : App Theme Notifier (Listener)
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    ChangeNotifierProvider<AppThemeNotifier>((_) => AppThemeNotifier());

class AppThemeNotifier extends ChangeNotifier {
  static int _themeMode = 1;
  static int theme = 1;
  static bool _valueTheme = false;

  AppThemeNotifier() {
    init();
  }

  init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? data = sharedPreferences.getInt("themeMode");
    bool? value = sharedPreferences.getBool("valueThemeMode");
    if (data == null) {
      _themeMode = 1;
      theme = 1;
    } else {
      _themeMode = data;
      theme = data;
    }

    if (value == null) {
      _valueTheme = false;
    } else {
      _valueTheme = value;
    }

    _changeTheme(_themeMode);
    notifyListeners();
  }

  value() => _valueTheme;
  themeMode() => _themeMode;

  updateTheme(int themeMode, bool valueThemeMode) {
    AppThemeNotifier._themeMode = themeMode;
    AppThemeNotifier.theme = themeMode;
    AppThemeNotifier._valueTheme = valueThemeMode;

    //AppTheme.theme = AppTheme.getThemeFromThemeMode(themeMode);
    AppTheme.customTheme = AppTheme.getCustomAppTheme(themeMode);

    _changeTheme(themeMode);

    notifyListeners();

    updateInStorage(themeMode, valueThemeMode);
  }

  Future<void> updateInStorage(int themeMode, bool valueThemeMode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("themeMode", themeMode);
    sharedPreferences.setBool("valueThemeMode", valueThemeMode);
  }

  _changeTheme(int themeMode) {
    AppTheme.customTheme = AppTheme.getCustomAppTheme(themeMode);
    //AppTheme.theme = AppTheme.getThemeFromThemeMode(themeMode);

    /* if(themeMode==1){
      FxAppTheme.changeThemeType(FxAppThemeType.light);
      FxCustomTheme.changeThemeType(FxCustomThemeType.light);
    }else if(themeMode==2){
      FxAppTheme.changeThemeType(FxAppThemeType.dark);
      FxCustomTheme.changeThemeType(FxCustomThemeType.dark);
    } */
  }
}
