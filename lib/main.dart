import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sesa/ui/utils/storage.dart';
import 'package:sesa/ui/views/login_page/login_page.dart';
import 'package:sesa/ui/views/main_page.dart';
import 'package:sesa/ui/views/splash_screen/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android,
    );
  if (Platform.isIOS)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.ios,
    );
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: (String email, String utype) => runApp(
        ProviderScope(
          child: MainPageAPP(
            email: email,
            utype: utype,
          ),
        ),
      ),
      onNotLogin: () => runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SESA',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        'home': (BuildContext _context) => LoginPage(),
      },
    );
  }
}

class MainPageAPP extends StatelessWidget {
  final String email;
  final String utype;
  const MainPageAPP({
    Key? key,
    required this.email,
    required this.utype,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SESA',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        'home': (BuildContext _context) => MainPage(
              uuid: email,
              utype: utype,
            ),
      },
    );
  }
}
