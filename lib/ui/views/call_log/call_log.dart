import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/storage.dart';
import 'package:sesa/ui/views/call_log/log_list_container.dart';

import '../../utils/themes/custom_app_theme.dart';
import '../../utils/themes/theme_provider.dart';
import '../../widgets/text/text.dart';

class CallLog extends StatefulWidget {
  @override
  _CallLog createState() => _CallLog();
}

class _CallLog extends State<CallLog> {
  late String currentuserid = "";

  @override
  void initState() {
    getCurrUserId();
    super.initState();
  }

  getCurrUserId() async {
    String preferences = await readStorage(value: "email");
    setState(() {
      currentuserid = preferences;
    });
  }

  //late UserData auth;

  late CustomAppTheme customAppTheme;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer(builder: ((context, watch, child) {
      final themeProvider = watch(themeNotifierProvider);
      customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
      //auth = watch(authProvider.state);
      return Scaffold(
        backgroundColor: customAppTheme.kBackgroundColorFinal,
        appBar: AppBar(
          backgroundColor: customAppTheme.kBackgroundColorFinal,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              MdiIcons.chevronLeft,
              color: customAppTheme.colorTextFeed,
              size: 25,
            ),
          ),
          actions: [],
        ),
        body: ListView(
          shrinkWrap: true,
          padding: FxSpacing.fromLTRB(24, 10, 24, 24),
          children: [
            Text(
              "Call History",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: 'Roboto-Bold',
                color: customAppTheme.colorTextFeed,
              ),
            ),
            FxSpacing.height(25),
            LogListContainer(
              currentuserid: currentuserid,
              customAppTheme: customAppTheme,
              name: currentuserid,
            ),
          ],
        ),
      );
    }));
  }
}
