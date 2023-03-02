import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/text/text.dart';

Widget getBannerWidget({required BuildContext context}) {
  late CustomAppTheme customAppTheme;
  return Consumer(builder: ((context, watch, child) {
    final themeProvider = watch(themeNotifierProvider);
    customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
    return FxContainer(
      color: kVioletColor.withAlpha(28),
      padding: FxSpacing.all(24),
      margin: FxSpacing.horizontal(24),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.b1(
            "Enjoy the special offer\nup to 60%",
            color: customAppTheme.kVioletColor,
            fontWeight: 600,
            letterSpacing: 0,
          ),
          FxSpacing.height(8),
          FxText.caption(
            "at 15 - 25 March 2021",
            color: customAppTheme.blackColor.withAlpha(100),
            fontWeight: 500,
            letterSpacing: -0.2,
          ),
        ],
      ),
    );
  }));
}