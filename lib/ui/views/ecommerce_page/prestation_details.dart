import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/prestations/prest_details.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/ecommerce_page/service_page.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/generator.dart';
import 'package:sesa/ui/widgets/text/text.dart';

class PrestationDetails extends StatefulWidget {
  final int id;
  final BuildContext rootContext;
  final String name;
  const PrestationDetails({
    Key? key,
    required this.id,
    required this.rootContext,
    required this.name,
  }) : super(key: key);

  @override
  State<PrestationDetails> createState() => _PrestationDetailsState();
}

class _PrestationDetailsState extends State<PrestationDetails> {
  late CustomAppTheme customAppTheme;
  List<PrestDetails> presDetails = [];
  ApiService apiService = ApiService();
  bool load = false;
  bool asData = true;
  Widget getSingleProduct(
      {required String name,
      required int price,
      required String uuid,
      required List<PrestDetails> prest}) {
    String heroKey = Generator.getRandomString(10);

    return InkWell(
      onTap: () {
        Navigator.push(
          widget.rootContext,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => SerivcePage(
              heroKey: heroKey,
              name: name,
              uuid: uuid,
              price: price,
              prest: prest,
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
                    name + " - " + price.toString() + " FCFA",
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
  void initState() {
    super.initState();
    apiService.getPrestationsDetails(id: widget.id).then((value) {
      if (value["status"] == 200) {
        if (!mounted) return;
        setState(() {
          load = true;
          presDetails = value["data"].map<PrestDetails>((_item) {
            return PrestDetails.fromJson(_item);
          }).toList();
          if (presDetails.length == 0) {
            asData = false;
          }
        });
        print("The pack is : $presDetails");
      } else {
        setState(() {
          load = true;
          asData = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
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
                      "Prestations : ${widget.name}",
                      color: customAppTheme.colorTextFeed,
                      fontWeight: 600,
                    ),
                  ],
                ),
              ),
              FxSpacing.height(24),
              if (!load) Center(child: CircularProgressIndicator()),
              if (asData)
                Padding(
                  padding: FxSpacing.horizontal(24),
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: presDetails.length,
                    itemBuilder: ((context, index) {
                      return getSingleProduct(
                        name: presDetails[index].nom,
                        price: presDetails[index].price,
                        uuid: auth.user.email,
                        prest: presDetails,
                      );
                    }),
                  ),
                ),
              if (!asData)
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "PAS DE DONNEES POUR CE SERVICE",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Roboto-Medium',
                        ),
                      ),
                      FxSpacing.height(10),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  height: MediaQuery.of(context).copyWith().size.height -
                      MediaQuery.of(context).copyWith().size.height / 5,
                  width: MediaQuery.of(context).copyWith().size.width,
                ),
            ],
          ),
        );
      },
    );
  }
}
