import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/main_page.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/text/text.dart';

class OrderComplete extends StatefulWidget {
  OrderComplete({Key? key}) : super(key: key);

  @override
  State<OrderComplete> createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> {
  late CustomAppTheme customAppTheme;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        return Scaffold(
          backgroundColor: customAppTheme.kBackgroundColorFinal,
          body: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image(
                      image: AssetImage('assets/images/order-confirm.png'),
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                  FxSpacing.height(32),
                  FxText.b2(
                    "Your order placed successfully",
                    color: customAppTheme.colorTextFeed,
                  ),
                  FxSpacing.height(16),
                  /* FxText.b2(
                  "You won a scratch coupon",
                ),
                FxSpacing.height(16), */
                  FxButton(
                    backgroundColor: kPrimary,
                    borderRadiusAll: 4,
                    elevation: 0,
                    onPressed: () {
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(),
                        ),
                      ); */
                      /* Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => OrderPage(
                            rootContext: widget.rootContext,
                          ),
                        ),
                        (Route<dynamic> route) => false,
                      ); */
                    },
                    child: FxText.b2(
                      "Consult your order list",
                      fontWeight: 600,
                      color: customAppTheme.kWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
