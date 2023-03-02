/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';

class test extends StatefulWidget {
  test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  late CustomAppTheme customAppTheme;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        return Scaffold(
          body: ListView(
            padding: FxSpacing.fromLTRB(24, 48, 24, 24),
            children: [
              FxSpacing.height(24),
              Center(
                child: FxContainer(
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
                      image: AssetImage('assets/images/avatar_4.jpg'),
                    ),
                  ),
                ),
              ),
              FxSpacing.height(24),
              FxText.h6(
                'Franck Dabryn SIYAPZE',
                textAlign: TextAlign.center,
                fontWeight: 600,
                letterSpacing: 0.8,
              ),
              FxSpacing.height(4),
              Row(
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
              ),
              FxSpacing.height(24),
              FxText.caption(
                'General',
                color: FxAppTheme.theme.colorScheme.onBackground,
                xMuted: true,
              ),
              FxSpacing.height(24),
              _buildSingleRow(
                  title: 'Subscription & payment', icon: MdiIcons.creditCard),
              FxSpacing.height(8),
              Divider(),
              FxSpacing.height(8),
              _buildSingleRow(title: 'Profile settings', icon: Icons.person),
              FxSpacing.height(8),
              Divider(),
              FxSpacing.height(8),
              _buildSingleRow(title: 'Password', icon: MdiIcons.lock),
              FxSpacing.height(8),
              Divider(),
              FxSpacing.height(8),
              _buildSingleRow(title: 'Notifications', icon: MdiIcons.bell),
              FxSpacing.height(8),
              Divider(),
              FxSpacing.height(8),
              Row(
                children: [
                  FxContainer(
                    paddingAll: 8,
                    borderRadiusAll: 4,
                    color:
                        FxAppTheme.theme.colorScheme.onBackground.withAlpha(20),
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
              _buildSingleRow(title: 'Logout', icon: MdiIcons.logout),
            ],
          ),
        );
      },
    );
  }
}
 */