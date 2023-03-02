import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:sesa/core/controllers/medicament_controller/medicament_controller.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/text_utils.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/ecommerce_page/product_page.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/generator.dart';
import 'package:sesa/ui/widgets/text/text.dart';

class MedicamentPage extends StatefulWidget {
  final BuildContext rootContext;
  const MedicamentPage({
    Key? key,
    required this.rootContext,
  }) : super(key: key);

  @override
  State<MedicamentPage> createState() => _MedicamentPageState();
}

class _MedicamentPageState extends State<MedicamentPage> {
  late CustomAppTheme customAppTheme;
  Widget getSingleProduct(
      {required String name,
      required String uuid,
      required int price,
      required int oldPrice,
      required int qty}) {
    String heroKey = Generator.getRandomString(10);

    return InkWell(
      onTap: () {
        Navigator.push(
          widget.rootContext,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => ProductPage(
              heroKey: heroKey,
              name: name,
              oldPrice: oldPrice,
              price: price,
              uuid: uuid,
              qty: qty,
            ),
          ),
        );
      },
      child: FxContainer(
        margin: FxSpacing.bottom(16),
        color: AppTheme.customTheme.groceryBg2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxContainer(
              color: AppTheme.customTheme.groceryPrimary.withAlpha(32),
              padding: FxSpacing.all(8),
              child: Hero(
                tag: heroKey,
                child: ClipRRect(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.asset(
                    "assets/images/sesabw.png",
                    width: 72,
                    height: 72,
                  ),
                ),
              ),
            ),
            FxSpacing.width(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.b2(
                    name,
                    color: customAppTheme.colorTextFeed,
                    fontWeight: 600,
                  ),
                  FxSpacing.height(8),
                  Row(
                    children: [
                      FxText.caption(
                        FxTextUtils.doubleToString(oldPrice.toDouble()) +
                            " FCFA",
                        decoration: TextDecoration.lineThrough,
                        fontWeight: 300,
                        color: customAppTheme.colorTextFeed,
                      ),
                      // Space.width(8),
                      FxSpacing.width(8),
                      FxText.b2(
                        FxTextUtils.doubleToString(price.toDouble()) + " FCFA",
                        color: customAppTheme.colorTextFeed,
                        fontWeight: 700,
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Space.width(8),
            /* Icon(
              MdiIcons.heartOutline,
              color: AppTheme.customTheme.groceryPrimary,
              size: 18,
            ) */
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        final medocs = watch(medocsControllerDataProvider.state);
        final auth = watch(authProvider.state);
        return Scaffold(
          backgroundColor: customAppTheme.kBackgroundColorFinal,
          appBar: AppBar(
            backgroundColor: customAppTheme.kBackgroundColorFinal,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: customAppTheme.colorTextFeed,
              ),
            ),
            elevation: 0,
          ),
          body: ListView(
            padding: FxSpacing.fromLTRB(0, 0, 0, 70),
            children: [
              Padding(
                padding: FxSpacing.horizontal(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.sh1(
                      "Tous les Medicaments",
                      color: customAppTheme.colorTextFeed,
                      fontWeight: 600,
                    ),
                  ],
                ),
              ),
              FxSpacing.height(24),
              Padding(
                padding: FxSpacing.horizontal(24),
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: medocs.medicaments.length,
                  itemBuilder: ((context, index) {
                    return getSingleProduct(
                      name: medocs.medicaments[index].decription,
                      price: medocs.medicaments[index].amount.toInt(),
                      oldPrice: 0,
                      uuid: auth.user.email,
                      qty: medocs.medicaments[index].quantite,
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
