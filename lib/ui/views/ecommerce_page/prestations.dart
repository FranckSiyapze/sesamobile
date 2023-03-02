import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/core/controllers/prestations/prestation_controller.dart';

import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/text_utils.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/ecommerce_page/prestation_details.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/generator.dart';
import 'package:sesa/ui/widgets/text/text.dart';

class PrestationPage extends StatefulWidget {
  final BuildContext rootContext;
  const PrestationPage({
    Key? key,
    required this.rootContext,
  }) : super(key: key);

  @override
  State<PrestationPage> createState() => _PrestationPageState();
}

class _PrestationPageState extends State<PrestationPage> {
  late CustomAppTheme customAppTheme;
  Widget getSingleProduct({
    required String name,
    required int id,
  }) {
    String heroKey = Generator.getRandomString(10);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrestationDetails(
              id: id,
              name: name,
              rootContext: widget.rootContext,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.b2(
                    name,
                    color: customAppTheme.colorTextFeed,
                    fontWeight: 600,
                    fontSize: 20,
                  ),
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
        final prestations = watch(prestationsControllerDataProvider.state);
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
                      "Nos categories",
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
                  itemCount: prestations.prestations.length,
                  itemBuilder: ((context, index) {
                    return getSingleProduct(
                      name: prestations.prestations[index].nom,
                      id: prestations.prestations[index].id,
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
