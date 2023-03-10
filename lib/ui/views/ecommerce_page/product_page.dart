import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/core/controllers/medicament_controller/medicament_controller.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/medicaments/medicament.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/text_utils.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/ecommerce_page/checkout_page.dart';
import 'package:sesa/ui/views/ecommerce_page/models/product.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/generator.dart';
import 'package:sesa/ui/widgets/text/text.dart';
import 'package:uuid/uuid.dart';

class ProductPage extends StatefulWidget {
  final String heroKey;
  final String name;
  final String uuid;
  final int price;
  final int oldPrice;
  final int qty;

  ProductPage(
      {Key? key,
      required this.heroKey,
      required this.name,
      required this.uuid,
      required this.price,
      required this.oldPrice,
      required this.qty})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  late CustomAppTheme customAppTheme;
  late List<Product> products;
  int quantity = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    products = Product.getList();
  }

  List<Widget> buildProducts(List<Medicament> medicaments) {
    List<Widget> list = [];
    for (Medicament product in medicaments) {
      list.add(getSingleProduct(product));
    }
    return list;
  }

  Widget getSingleProduct(Medicament product) {
    String heroKey = Generator.getRandomString(10);

    return InkWell(
      onTap: () {
        /* Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) =>
                    GrocerySingleProductScreen(product, heroKey))); */
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
                  FxText.b2(product.decription,
                      color: customAppTheme.colorTextFeed, fontWeight: 600),
                  FxSpacing.height(8),
                  FxSpacing.height(8),
                  FxText.b2(
                      FxTextUtils.doubleToString(product.amount.toDouble()) +
                          " FCFA",
                      color: customAppTheme.colorTextFeed,
                      fontWeight: 700),
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
        final auth = watch(authProvider.state);
        final medocs = watch(medocsControllerDataProvider.state);
        return Scaffold(
          backgroundColor: customAppTheme.colorTextFeed,
          body: Container(
            color: AppTheme.customTheme.groceryPrimary.withAlpha(68),
            child: ListView(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: widget.heroKey,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Image.asset(
                            "assets/images/sesabw.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -10,
                      child: Container(
                        margin: FxSpacing.fromLTRB(24, 48, 24, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: FxSpacing.all(5),
                                decoration: BoxDecoration(
                                  color: customAppTheme.kBackgroundColorFinal,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Icon(
                                  MdiIcons.chevronLeft,
                                  size: 25,
                                  color: customAppTheme.blackColor,
                                ),
                              ),
                            ),
                            /* InkWell(
                              child: Container(
                                padding: Spacing.all(5),
                                decoration: BoxDecoration(
                                  color: customAppTheme.kBackgroundColorFinal,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Icon(
                                  MdiIcons.shareOutline,
                                  size: 25,
                                  color: customAppTheme.blackColor,
                                ),
                              ),
                            ) */
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                FxSpacing.height(24),
                FxContainer(
                  padding: FxSpacing.all(24),
                  color: AppTheme.customTheme.bgLayer1,
                  borderRadiusAll: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.sh1(
                                  widget.name,
                                  fontWeight: 700,
                                  color: customAppTheme.colorTextFeed,
                                ),
                                FxSpacing.height(8),
                                Row(
                                  children: [
                                    FxText.caption(
                                      FxTextUtils.doubleToString(
                                              widget.oldPrice.toDouble()) +
                                          " FCFA",
                                      decoration: TextDecoration.lineThrough,
                                      color: customAppTheme.colorTextFeed,
                                    ),
                                    FxSpacing.width(8),
                                    // Space.width(8),
                                    FxText.b2(
                                      FxTextUtils.doubleToString(
                                              widget.price.toDouble()) +
                                          " FCFA",
                                      fontWeight: 600,
                                      color: customAppTheme.colorTextFeed,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          /* FxContainer(
                            onTap: () {
                              /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GroceryProductReviewScreen())); */
                            },
                            padding: FxSpacing.fromLTRB(8, 6, 8, 6),
                            color: AppTheme.customTheme.groceryPrimary
                                .withAlpha(40),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FxText.b2("(${widget.qty} Quantit??)",
                                    color: AppTheme.customTheme.groceryPrimary,
                                    fontWeight: 500,
                                    letterSpacing: -0.2),
                                Icon(
                                  MdiIcons.chevronRight,
                                  size: 14,
                                  color: AppTheme.customTheme.groceryPrimary,
                                )
                              ],
                            ),
                          ) */
                        ],
                      ),
                      FxSpacing.height(4),
                      FxSpacing.height(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FxContainer(
                                borderRadiusAll: 4,
                                onTap: () {
                                  setState(() {
                                    if (quantity > 1) quantity--;
                                  });
                                },
                                padding: FxSpacing.all(6),
                                color: AppTheme.customTheme.groceryPrimary
                                    .withAlpha(48),
                                child: Icon(
                                  MdiIcons.minus,
                                  size: 14,
                                  color: AppTheme.customTheme.groceryPrimary,
                                ),
                              ),
                              FxSpacing.width(12),
                              FxText.b1(quantity.toString(), fontWeight: 600),
                              FxSpacing.width(12),
                              FxContainer(
                                borderRadiusAll: 4,
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                padding: FxSpacing.all(6),
                                color: AppTheme.customTheme.groceryPrimary,
                                child: Icon(
                                  MdiIcons.plus,
                                  size: 14,
                                  color: AppTheme.customTheme.groceryOnPrimary,
                                ),
                              ),
                            ],
                          ),
                          FxSpacing.width(24),
                          Expanded(
                              child: FxButton(
                            borderRadiusAll: 4,
                            elevation: 0,
                            onPressed: () async {
                              /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPage(),
                                ),
                              ); */
                              final QuerySnapshot result =
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .where("email",
                                          isEqualTo: auth.user.email)
                                      .get();
                              int price = result.docs[0]["price"];
                              var newPrice = price + (widget.price * quantity);
                              print("New Price is : " + newPrice.toString());
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(auth.user.email)
                                  .update({
                                "price": newPrice,
                              });
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(auth.user.email)
                                  .collection("carts")
                                  .doc(Uuid().v4())
                                  .set({
                                "name": widget.name,
                                "price": widget.price,
                                "qty": quantity,
                                /* "new": true, */
                              });

                              Fluttertoast.showToast(
                                msg: 'Produit ajout?? avec success',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                backgroundColor: kPrimary,
                              );
                              /* FirebaseFirestore.instance
                                  .collection("products")
                                  .doc(widget.uuid)
                                  .update({
                                "qty": widget.qty - quantity,
                              }); */
                            },
                            child: FxText.b2(
                              "Add to Cart",
                              fontWeight: 600,
                              color: AppTheme.customTheme.groceryOnPrimary,
                            ),
                            backgroundColor:
                                AppTheme.customTheme.groceryPrimary,
                          ))
                        ],
                      ),
                      FxSpacing.height(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FxText.sh1("Related", fontWeight: 600),
                          FxText.caption("See All",
                              fontWeight: 600, xMuted: true, letterSpacing: 0),
                        ],
                      ),
                      FxSpacing.height(16),
                      Column(
                        children: buildProducts(medocs.medicaments),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
