import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/core/controllers/pack_controller/pack_categorie_controller.dart';
import 'package:sesa/ui/utils/SizeConfig.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/payment_page/payment_page.dart';

class PackCategoriePage extends StatefulWidget {
  const PackCategoriePage({Key? key});

  @override
  State<PackCategoriePage> createState() => _PackCategorieState();
}

class _PackCategorieState extends State<PackCategoriePage> {
  late CustomAppTheme customAppTheme;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        final packCategories =
            watch(packCategoriesControllerDataProvider.state);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimary,
            title: Text("Pack Categories"),
            centerTitle: true,
            automaticallyImplyLeading: true,
          ),
          body: ListView(
            padding: FxSpacing.fromLTRB(0, 48, 0, 70),
            children: [
              /* ListView.separated(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      //getFees(29000, "Sécu-Santé de Base - 12 Mois");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            id: packCategories.packCategories[index].id,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title:
                            Text("${packCategories.packCategories[index].nom}"),
                        leading: Text("${index + 1}"),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    margin: Spacing.fromLTRB(75, 0, 0, 10),
                  );
                },
                itemCount: packCategories.packCategories.length,
              ), */
              if (packCategories.asData)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          id: packCategories.packCategories[0].id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    margin: FxSpacing.fromLTRB(10, 12, 10, 16),
                    decoration: BoxDecoration(
                      color: customAppTheme.kBackgroundColor,
                      border: Border.all(
                        color: customAppTheme.kBackgroundColor,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          child: Image(
                            image:
                                AssetImage('assets/images/pack_indiviuel.webp'),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.55,
                          ),
                        ),
                        Container(
                          padding: Spacing.fromLTRB(16, 24, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: Spacing.top(8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${packCategories.packCategories[0].nom}",
                                        /* style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 600), */
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: customAppTheme.colorTextFeed,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              30,
                                      width: MediaQuery.of(context).size.width /
                                          3.4,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: kVioletColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                        child: Text(
                                          "Consulter",
                                          //textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: KWhite,
                                            fontSize: 10,
                                            fontFamily: 'Roboto-Medium',
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              if (packCategories.asData)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          id: packCategories.packCategories[1].id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    margin: FxSpacing.fromLTRB(10, 12, 10, 16),
                    decoration: BoxDecoration(
                      color: customAppTheme.kBackgroundColor,
                      border: Border.all(
                        color: customAppTheme.kBackgroundColor,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          child: Image(
                            image: AssetImage('assets/images/scolaire.jpg'),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.55,
                          ),
                        ),
                        Container(
                          padding: Spacing.fromLTRB(16, 24, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: Spacing.top(8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${packCategories.packCategories[1].nom}",
                                        /* style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 600), */
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: customAppTheme.colorTextFeed,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              30,
                                      width: MediaQuery.of(context).size.width /
                                          3.4,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: kVioletColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                        child: Text(
                                          "Consulter",
                                          //textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: KWhite,
                                            fontSize: 10,
                                            fontFamily: 'Roboto-Medium',
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              if (packCategories.asData)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          id: packCategories.packCategories[2].id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    margin: FxSpacing.fromLTRB(10, 12, 10, 16),
                    decoration: BoxDecoration(
                      color: customAppTheme.kBackgroundColor,
                      border: Border.all(
                        color: customAppTheme.kBackgroundColor,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          child: Image(
                            image:
                                AssetImage('assets/images/communautaire.jpeg'),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.55,
                          ),
                        ),
                        Container(
                          padding: Spacing.fromLTRB(16, 24, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: Spacing.top(8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${packCategories.packCategories[2].nom}",
                                        /* style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 600), */
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: customAppTheme.colorTextFeed,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              30,
                                      width: MediaQuery.of(context).size.width /
                                          3.4,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: kVioletColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                        child: Text(
                                          "Consulter",
                                          //textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: KWhite,
                                            fontSize: 10,
                                            fontFamily: 'Roboto-Medium',
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              if (!packCategories.asData)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //ForumWidget(context, customAppTheme),
                      FxSpacing.height(MediaQuery.of(context).size.height / 10),
                      Container(
                        //height: 200,
                        child: Image.asset(
                          "assets/images/no-internet.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 24),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Une erreur est survenu",
                              style: TextStyle(
                                color: customAppTheme.colorTextFeed,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                              color: customAppTheme.kVioletColor.withAlpha(20),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(Spacing.xy(16, 0)),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kPrimary),
                          ),
                          onPressed: () {
                            context
                                .refresh(packCategoriesControllerDataProvider);
                          },
                          child: Text(
                            "Ressayer",
                            style: TextStyle(
                              color: customAppTheme.kWhite,
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
