import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:sesa/core/models/app_config.dart';
import 'package:sesa/core/models/mobile_config.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/core/services/http_service.dart';
import 'package:sesa/ui/utils/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  final Function onInitializationComplete;
  final VoidCallback onNotLogin;

  const SplashPage({
    key,
    required this.onInitializationComplete,
    required this.onNotLogin,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  final storage = FlutterSecureStorage();

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  @override
  void initState() {
    super.initState();
    /* Future.delayed(Duration(seconds: 5)).then(
      (_) => _setup(context).then(
        (_) => widget.onInitializationComplete(),
      ),
    ); */
    checkGps();
    checkLoginStatus();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
  }

  getLocation() async {
    //String myLocale = AppLocalizations.of(context)!.localeName;
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("Longitude : " + position.longitude.toString()); //Output: 80.24599079
    print("Latitude : " + position.latitude.toString()); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();
    if (!mounted) return;
    setState(() {
      //refresh UI
      long = position.longitude.toString();
      lat = position.latitude.toString();
    });
    await storage.write(
      key: "lat",
      value: position.latitude.toString(),
    );
    await storage.write(
      key: "long",
      value: position.longitude.toString(),
    );
  }

  Future checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first_run') ?? true) {
      FlutterSecureStorage storage = FlutterSecureStorage();

      await storage.deleteAll();
      await storage.delete(key: "isConnected");
      print("testt");
      prefs.setBool('first_run', false);
    }
    String loggedIn = await storage.read(key: "loginstatus");
    print("the loggedIn is : ${loggedIn}");
    String isConnect = await storage.read(key: "isConnected");
    print("isConnected is : ${isConnect}");
    if (loggedIn == null || loggedIn == "loggedout") {
      if (mounted)
        Future.delayed(Duration(seconds: 5)).then(
          (_) => _setup(context).then(
            (_) => widget.onNotLogin(),
          ),
        );
    } else {
      if (loggedIn == "loggedin") {
        String uuuid = await storage.read(key: "email") ?? "";
        String utype = await storage.read(key: "utype");
        print("the utype is $utype");
        Future.delayed(Duration(seconds: 5)).then(
          (_) => _setup(context).then(
            (_) => widget.onInitializationComplete(uuuid, utype),
          ),
        );
      }
    }
  }

  Future<void> _setup(BuildContext _context) async {
    final getIt = GetIt.instance;
    final configFile = await rootBundle.loadString('assets/config/main.json');
    final configData = jsonDecode(configFile);

    if (!getIt.isRegistered<AppConfig>()) {
      getIt.registerSingleton<AppConfig>(
        AppConfig(
          BASE_API_URL: configData["BASE_API_URL"],
        ),
      );
      print("THe getIT AppConfig: ${getIt.isRegistered<AppConfig>()}");
    } else {
      //print("THe getIT HTTPService1: ${getIt.isRegistered<HTTPService>()}");
    }

    if (!getIt.isRegistered<MobileConfig>()) {
      getIt.registerSingleton<MobileConfig>(
        MobileConfig(
          lat: lat,
          long: long,
        ),
      );
      MobileConfig _config = getIt.get<MobileConfig>();
      print("Config Mobile : ${_config}");
      print("THe getIT MobileInfos: ${getIt.isRegistered<MobileConfig>()}");
    } else {
      //print("THe getIT MobileInfos1: ${getIt.isRegistered<MobileInfos>()}");
    }

    if (!getIt.isRegistered<HttpService>()) {
      getIt.registerSingleton<HttpService>(
        HttpService(),
      );
      print("THe getIT HTTPService: ${getIt.isRegistered<HttpService>()}");
    } else {
      //print("THe getIT HTTPService1: ${getIt.isRegistered<HTTPService>()}");
    }
    if (!getIt.isRegistered<ApiService>()) {
      getIt.registerSingleton<ApiService>(
        ApiService(),
      );
      print("THe getIT ApiService: ${getIt.isRegistered<ApiService>()}");
    } else {
      //print("THe getIT ApiService1: ${getIt.isRegistered<ApiService>()}");
    }

    /*getIt.registerSingleton<MovieService>(
      MovieService(),
    ); */
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SESA',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 250,
                width: 250,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/logo_dark.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
