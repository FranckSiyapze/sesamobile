import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/core/controllers/medicament_controller/medicament_controller.dart';
import 'package:sesa/core/controllers/prestations/prestation_controller.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/prestations/prestation_data.dart';
import 'package:sesa/ui/utils/SizeConfig.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/styles/style.dart';
import 'package:sesa/ui/utils/text_utils.dart';
import 'package:sesa/ui/utils/themes/app_theme.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/ecommerce_page/cart_page.dart';
import 'package:sesa/ui/views/ecommerce_page/medicament.dart';
import 'package:sesa/ui/views/ecommerce_page/models/product.dart';
import 'package:sesa/ui/views/ecommerce_page/prestation_details.dart';
import 'package:sesa/ui/views/ecommerce_page/prestations.dart';
import 'package:sesa/ui/views/ecommerce_page/product_page.dart';
import 'package:sesa/ui/widgets/card/card.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/generator.dart';
import 'package:sesa/ui/widgets/text/text.dart';
import 'package:sesa/ui/widgets/widget.dart';

class EcommercePage extends StatefulWidget {
  final BuildContext rootContext;
  EcommercePage({Key? key, required this.rootContext}) : super(key: key);

  @override
  State<EcommercePage> createState() => _EcommercePageState();
}

class _EcommercePageState extends State<EcommercePage> {
  late CustomAppTheme customAppTheme;

  final List<String> imageList = [
    "https://firebasestorage.googleapis.com/v0/b/sesa-716cf.appspot.com/o/banners%2F49beca90-1dd8-4ead-9964-ebc0368dfabf.JPG?alt=media&token=5c44a7e5-30e1-49f2-9beb-1b8179e5d509",
    "https://firebasestorage.googleapis.com/v0/b/sesa-716cf.appspot.com/o/banners%2F46cd2bb5-a837-416a-bcee-c98fc5b4224d.JPG?alt=media&token=434680b0-ab56-4550-a4ae-3d0b6d6478fa",
    "https://firebasestorage.googleapis.com/v0/b/sesa-716cf.appspot.com/o/banners%2F5c9c8dd2-3156-4b1c-98d1-143db9812374.JPG?alt=media&token=37cb93cb-e456-42da-ba46-24eab1cca744",
    "https://firebasestorage.googleapis.com/v0/b/sesa-716cf.appspot.com/o/banners%2F62729c80-f578-4eb7-8200-213ac925f060.JPG?alt=media&token=0729a91b-d1b2-4532-9949-f88306a93f2b",
    "https://firebasestorage.googleapis.com/v0/b/sesa-716cf.appspot.com/o/banners%2F83b95bfc-40cb-4575-aba8-cbc6c7145411.JPG?alt=media&token=b074ef8b-0918-43ea-a24f-f9825878fb90",
    "https://firebasestorage.googleapis.com/v0/b/sesa-716cf.appspot.com/o/banners%2F9ddebb5e-9b09-4aa8-bf27-a384b9ae8211.JPG?alt=media&token=58e7fa41-2e22-4c40-b940-f429fd9831b0",
    "https://firebasestorage.googleapis.com/v0/b/sesa-716cf.appspot.com/o/banners%2Fbd91529c-e559-48c9-aaf5-0dcf65f44703.JPG?alt=media&token=823e5535-053b-4058-a1da-9f485f8c0bd9",
    "https://firebasestorage.googleapis.com/v0/b/sesa-716cf.appspot.com/o/banners%2Fc45e81f9-89c5-49a6-ad8a-ad474ab5cee1.JPG?alt=media&token=7f55ef73-b45c-4446-9dd3-4e3094273484",
    "https://firebasestorage.googleapis.com/v0/b/sesa-716cf.appspot.com/o/banners%2Fcb86f14b-ac9b-4406-a6a6-c1412cb8b614.JPG?alt=media&token=01b9d478-b1a6-4e62-9458-2a7e2e02453d"
  ];
  Widget _buildSingleCategory({String? categoryName, int? id}) {
    return InkWell(
      onTap: () {
        setState(() {
          //selectedCategory = index!;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrestationDetails(
              id: id!,
              name: categoryName!,
              rootContext: widget.rootContext,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          border: Border.all(
            color: customAppTheme.border2,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.only(right: 5),
        child: FxText.caption(
          categoryName!,
          fontWeight: 600,
          color: customAppTheme.colorTextFeed,
        ),
      ),
    );
  }

  Widget getSingleCategory({String? imgUrl, required String name}) {
    String heroTag = Generator.getRandomString(10);

    return Hero(
      tag: heroTag,
      child: Material(
        color: customAppTheme.kVioletColor.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: FxSpacing.only(
            left: MediaQuery.of(context).size.width / 40,
            right: MediaQuery.of(context).size.width / 40,
            top: MediaQuery.of(context).size.height / 110,
            bottom: MediaQuery.of(context).size.height / 110,
          ),
          decoration: BoxDecoration(
            color: customAppTheme.kVioletColor.withAlpha(50),
            borderRadius: BorderRadius.circular(8),
          ),
          width: MediaQuery.of(context).size.width / 3,
          child: Column(
            children: [
              FxText.overline(
                "${name}",
                color: customAppTheme.colorTextFeed,
                fontSize: 15,
                overflow: TextOverflow.ellipsis,
                fontWeight: 900,
              )
            ],
          ),
        ),
      ),
    );
  }

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

  late PrestationData prestations;

  Widget _buildSingleCategoryT({int? id, String? categoryName}) {
    return Padding(
      padding: FxSpacing.right(16),
      child: FxCard(
        paddingAll: 8,
        borderRadiusAll: 8,
        bordered: true,
        shadow: FxShadow(
          elevation: 0,
        ),
        //splashColor: AppTheme.customTheme.medicarePrimary.withAlpha(40),
        border: Border.all(color: customAppTheme.kBackgroundColor, width: 1.5),
        color: customAppTheme.ktransparent,
        onTap: () {
          setState(() {
            //selectedCategory = index!;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrestationDetails(
                id: id!,
                name: categoryName!,
                rootContext: widget.rootContext,
              ),
            ),
          );
        },
        child: Row(
          children: [
            FxText.caption(
              categoryName!,
              fontWeight: 600,
              color: customAppTheme.colorTextFeed,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategoryList() {
    List<Widget> list = [];

    list.add(FxSpacing.width(24));
    prestations.prestations.sort((a, b) => a.id.compareTo(b.id));
    for (int i = 0; i < prestations.prestations.length; i++) {
      list.add(
        _buildSingleCategoryT(
          id: prestations.prestations[i].id,
          categoryName: prestations.prestations[i].nom,
        ),
      );
    }
    return list;
  }

//
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        final medocs = watch(medocsControllerDataProvider.state);
        final auth = watch(authProvider.state);

        prestations = watch(prestationsControllerDataProvider.state);
        return Scaffold(
          backgroundColor: customAppTheme.kBackgroundColorFinal,
          body: ListView(
            padding: FxSpacing.fromLTRB(0, 48, 0, 70),
            children: [
              if (auth.asData)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(auth.user.email)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              } else {
                                return FxText.h6(
                                  "Hi, ${auth.user.firstName}!",
                                  fontWeight: 600,
                                  color: customAppTheme.colorTextFeed,
                                );
                              }
                              //return Container();
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartPage(
                                    rootContext: widget.rootContext,
                                    email: auth.user.email,
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  MdiIcons.cartOutline,
                                  size: 22,
                                  color: customAppTheme.blackColor,
                                ),
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    padding: FxSpacing.zero,
                                    height: 12,
                                    width: 12,
                                    decoration: BoxDecoration(
                                      color: kRedColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(40),
                                      ),
                                    ),
                                    child: Center(
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(auth.user.email)
                                            .collection("carts")
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return Container(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                  customAppTheme.kVioletColor,
                                                )),
                                              ),
                                            );
                                          } else if (snapshot
                                                  .data!.docs.length ==
                                              0) {
                                            return FxText.overline(
                                              "0",
                                              color: customAppTheme.kWhite,
                                              fontSize: 8,
                                              fontWeight: 500,
                                            );
                                          } else {
                                            return FxText.overline(
                                              "${snapshot.data!.docs.length}",
                                              color: customAppTheme.kWhite,
                                              fontSize: 8,
                                              fontWeight: 500,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    FxSpacing.height(8),
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: FxText.b2(
                        "Prévenir n'est pas prévoir",
                        color: customAppTheme.colorTextFeed,
                        fontWeight: 500,
                        xMuted: true,
                      ),
                    ),
                    FxSpacing.height(24),
                    GFCarousel(
                      items: imageList.map(
                        (url) {
                          return Container(
                            margin: EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(url,
                                  fit: BoxFit.cover, width: 1000.0),
                            ),
                          );
                        },
                      ).toList(),
                      onPageChanged: (index) {
                        setState(() {
                          index;
                        });
                      },
                    ),
                    FxSpacing.height(24),
                    /* Padding(
                  padding: FxSpacing.horizontal(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FxText.sh1(
                        "Categories",
                        letterSpacing: 0,
                        color: customAppTheme.colorTextFeed,
                        fontWeight: 600,
                      ),
                      FxText.caption(
                        "See All",
                        color: customAppTheme.colorTextFeed,
                        fontWeight: 600,
                        xMuted: true,
                        letterSpacing: 0,
                      ),
                    ],
                  ),
                ), */
                    //FxSpacing.height(16),
                    /* Padding(
                  padding: FxSpacing.horizontal(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedicamentPage(
                                rootContext: widget.rootContext,
                              ),
                            ),
                          );
                        },
                        child: getSingleCategory(name: "Medicaments"),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrestationPage(
                                rootContext: widget.rootContext,
                              ),
                            ),
                          );
                        },
                        child: getSingleCategory(name: "Nos Services"),
                      ),
                    ],
                  ),
                ), */
                    FxSpacing.height(10),
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FxText.sh1(
                            "Nos services",
                            color: customAppTheme.colorTextFeed,
                            fontWeight: 600,
                          ),
                        ],
                      ),
                    ),
                    FxSpacing.height(10),
                    /* Container(
                      margin: FxSpacing.only(
                        left: 16,
                      ),
                      padding: FxSpacing.only(
                        bottom: 24,
                        top: 0,
                      ),
                      height: MediaQuery.of(context).size.height / 15,
                      child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: prestations.prestations.length,
                        itemBuilder: ((context, index) {
                          return _buildSingleCategory(
                            categoryName: prestations.prestations[index].nom,
                            id: prestations.prestations[index].id,
                          );
                        }),
                      ),
                    ), */

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _buildCategoryList(),
                      ),
                    ),
                    FxSpacing.height(10),
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FxText.sh1(
                            "Nos Médicaments",
                            color: customAppTheme.colorTextFeed,
                            fontWeight: 600,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicamentPage(
                                    rootContext: widget.rootContext,
                                  ),
                                ),
                              );
                            },
                            child: FxText.overline(
                              'Voir Plus',
                              color: kPrimary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FxSpacing.height(0),
                    /* Padding(
                  padding: FxSpacing.horizontal(24),
                  child: Column(
                    children: buildProducts(),
                  ),
                ), */

                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: /* StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                              customAppTheme.kVioletColor,
                            )),
                          ),
                        );
                      } else if (snapshot.data!.docs.length == 0) {
                        return Container(
                          child: Column(
                            children: [
                              Text(
                                "No products found",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: customAppTheme.colorTextFeed,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        );
                      } else {
                        return 
                      }
                    },
                  ), */
                          ListView.builder(
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: (medocs.medicaments.length == 1)
                            ? medocs.medicaments.length
                            : (medocs.medicaments.length / 2).truncate(),
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
              if (!auth.asData)
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
                            context.refresh(medocsControllerDataProvider);
                            context.refresh(prestationsControllerDataProvider);
                            context.refresh(authProvider);
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
