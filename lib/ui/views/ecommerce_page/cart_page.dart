import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/core/models/doctors/user_data.dart';
import 'package:sesa/core/services/api.dart';
import 'package:sesa/ui/utils/SizeConfig.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/text_utils.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/text_style.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/ecommerce_page/checkout_page.dart';
import 'package:sesa/ui/views/ecommerce_page/models/cart.dart';
import 'package:sesa/ui/views/ecommerce_page/payment.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/dash_divider/dash_divider.dart';
import 'package:sesa/ui/widgets/generator.dart';
import 'package:sesa/ui/widgets/text/text.dart';
import 'package:sesa/ui/widgets/text_field/text_field.dart';

class CartPage extends StatefulWidget {
  final BuildContext rootContext;
  final String email;
  const CartPage({
    Key? key,
    required this.rootContext,
    required this.email,
  }) : super(key: key);

  @override
  _GroceryCartScreenState createState() => _GroceryCartScreenState();
}

class _GroceryCartScreenState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  late List<Cart> carts;
  int total = 0;
  late Api apiservice = Api();
  getFees(amount, description) {
    apiservice.getADPToken().then((value) async {
      setState(() {
        //print(value["data"]["tokenCode"]);
        apiservice
            .getFees(value["data"]["tokenCode"], amount.toString())
            .then((value1) async {
          //print(value1["data"]);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PayEcommerce(
                data: value1["data"],
                amount: amount.toString(),
                details: description,
              ),
            ),
          );
        });
      });
    });
  }

  int totalF = 0;
  var data = [];
  late UserData auth;
  String? heroKey;
  late CustomAppTheme customAppTheme;
  @override
  initState() {
    super.initState();
    carts = Cart.getList();
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.email)
        .collection("carts")
        .get()
        .then((value) {
      print(value);
    });
  }

  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final themeProvider = watch(themeNotifierProvider);
      customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
      auth = watch(authProvider.state);
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: AppTheme.customTheme.groceryBg1,
            title: FxText.h6("Cart", fontWeight: 600),
          ),
          backgroundColor: AppTheme.customTheme.groceryBg1,
          body: ListView(
            shrinkWrap: true,
            padding: FxSpacing.fromLTRB(24, 8, 24, 70),
            children: [
              /* Column(
                children: buildCarts(),
              ), */
              //SingleCartWidget()
              Padding(
                padding: FxSpacing.horizontal(0),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(auth.user.email)
                      .collection("carts")
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
                      return ListView.builder(
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          /* return SingleCartWidget(
                              rootContext: widget.rootContext,
                              name: snapshot.data!.docs[index]["name"],
                              price: snapshot.data!.docs[index]["price"],
                              qty: snapshot.data!.docs[index]["qty"]); */

                          heroKey = Generator.getRandomString(10);
                          return Dismissible(
                            key: ValueKey(snapshot.data!.docs[index].id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: customAppTheme.kBackgroundColor,
                            ),
                            secondaryBackground: Container(
                              color: AppTheme.customTheme.groceryBg1,
                              padding: Spacing.horizontal(20),
                              alignment: AlignmentDirectional.centerEnd,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    margin: Spacing.right(8),
                                    padding: Spacing.all(16),
                                    decoration: BoxDecoration(
                                        color: customAppTheme.red.withAlpha(40),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      MdiIcons.trashCan,
                                      size: 22,
                                      color: customAppTheme.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onDismissed: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                final QuerySnapshot result =
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .where("email",
                                            isEqualTo: auth.user.email)
                                        .get();
                                int price = result.docs[0]["price"];
                                var newPrice = price -
                                    (snapshot.data!.docs[index]["price"] *
                                        snapshot.data!.docs[index]["qty"]);
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(auth.user.email)
                                    .collection("carts")
                                    .doc(snapshot.data!.docs[index].id)
                                    .delete()
                                    .then((value) {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(auth.user.email)
                                      .update({
                                    "price": (newPrice > 0) ? newPrice : 0,
                                  });
                                });
                              }
                            },
                            child: Container(
                              //width: 100,
                              child: FxContainer(
                                color: AppTheme.customTheme.groceryBg2,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FxContainer(
                                      color: AppTheme.customTheme.groceryPrimary
                                          .withAlpha(32),
                                      padding: FxSpacing.all(8),
                                      child: Hero(
                                        tag: heroKey!,
                                        child: ClipRRect(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FxText.b1(
                                            snapshot.data!.docs[index]["name"],
                                            fontWeight: 600,
                                          ),
                                          FxSpacing.height(8),
                                          FxText.b2(
                                              FxTextUtils.doubleToString(
                                                      snapshot.data!
                                                          .docs[index]["price"]
                                                          .toDouble()) +
                                                  " FCFA",
                                              color:
                                                  customAppTheme.colorTextFeed,
                                              fontWeight: 700),
                                          FxSpacing.height(8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              FxSpacing.width(12),
                                              FxText.b1(
                                                  snapshot
                                                      .data!.docs[index]["qty"]
                                                      .toString(),
                                                  fontWeight: 600),
                                              FxSpacing.width(12),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }
                  },
                ),
              ),
              /* FxSpacing.height(16),
              FxContainer(
                color: AppTheme.customTheme.groceryBg2,
                padding: FxSpacing.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: FxTextField(
                        hintText: "Promo Code",
                        hintStyle: FxTextStyle.b2(),
                        labelStyle: FxTextStyle.b2(),
                        style: FxTextStyle.b2(),
                        labelText: "Promo Code",
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: FxSpacing.right(16),
                        focusedBorderColor: Colors.transparent,
                        cursorColor: AppTheme.customTheme.groceryPrimary,
                        prefixIcon: Icon(
                          MdiIcons.ticketPercentOutline,
                          size: 22,
                          color: customAppTheme.colorTextFeed.withAlpha(150),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    FxButton.medium(
                      onPressed: () {
                        /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GroceryCouponScreen())); */
                      },
                      child: FxText.button("Find",
                          letterSpacing: 0.5,
                          fontWeight: 600,
                          color: AppTheme.customTheme.groceryOnPrimary),
                      backgroundColor: AppTheme.customTheme.groceryPrimary,
                      borderRadiusAll: 4,
                      padding: FxSpacing.xy(32, 12),
                    ),
                  ],
                ),
              ), */
              FxSpacing.height(16),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(auth.user.email)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Column(
                        children: [
                          FxSpacing.height(12),
                          FxDashedDivider(
                            dashSpace: 6,
                            height: 1.2,
                            dashWidth: 8,
                            color: customAppTheme.colorTextFeed,
                          ),
                          FxSpacing.height(12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FxText.b1("Total", fontWeight: 700),
                              FxText.b1("0.0 FCFA",
                                  letterSpacing: 0.25, fontWeight: 700),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          FxSpacing.height(12),
                          FxDashedDivider(
                            dashSpace: 6,
                            height: 1.2,
                            dashWidth: 8,
                            color: customAppTheme.colorTextFeed,
                          ),
                          FxSpacing.height(12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FxText.b1("Total", fontWeight: 700),
                              FxText.b1("${snapshot.data!["price"]} FCFA",
                                  letterSpacing: 0.25, fontWeight: 700),
                            ],
                          ),
                          FxSpacing.height(24),
                          Center(
                            child: FxButton.medium(
                              onPressed: () {
                                getFees(snapshot.data!["price"],
                                    "Paiement ecommerce");
                              },
                              child: FxText.button(
                                "CHECKOUT",
                                letterSpacing: 0.5,
                                fontWeight: 600,
                                color: AppTheme.customTheme.groceryOnPrimary,
                              ),
                              backgroundColor:
                                  AppTheme.customTheme.groceryPrimary,
                              borderRadiusAll: 4,
                              padding: FxSpacing.xy(32, 12),
                              elevation: 2,
                            ),
                          )
                        ],
                      );
                    }
                  }),

              /* Center(
                child: FxButton.medium(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(),
                      ),
                    );
                    getFees("2000", "Paiement ecommerce");
                  },
                  child: FxText.button(
                    "CHECKOUT",
                    letterSpacing: 0.5,
                    fontWeight: 600,
                    color: AppTheme.customTheme.groceryOnPrimary,
                  ),
                  backgroundColor: AppTheme.customTheme.groceryPrimary,
                  borderRadiusAll: 4,
                  padding: FxSpacing.xy(32, 12),
                  elevation: 2,
                ),
              ) */
            ],
          ));
    });
  }

  /* List<Widget> buildCarts() {
    List<Widget> list = [];

    for (int i = 0; i < carts.length; i++) {
      list.add(SingleCartWidget(context, carts[i]));
      if (i + 1 < carts.length) list.add(FxSpacing.height(16));
    }

    return list;
  } */
}

class SingleCartWidget extends StatefulWidget {
  final BuildContext rootContext;
  final Cart? cart;
  final String name;
  final int price;
  final int qty;

  const SingleCartWidget({
    Key? key,
    required this.rootContext,
    this.cart,
    required this.name,
    required this.price,
    required this.qty,
  }) : super(key: key);

  @override
  _SingleCartWidgetState createState() => _SingleCartWidgetState();
}

class _SingleCartWidgetState extends State<SingleCartWidget> {
  late int quantity;
  late BuildContext rootContext;

  String? heroKey;

  @override
  void initState() {
    super.initState();
    quantity = widget.cart!.quantity;
    rootContext = widget.rootContext;
    heroKey = Generator.getRandomString(10);
  }

  late CustomAppTheme customAppTheme;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        return Container(
          width: 100,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              color: AppTheme.customTheme.groceryBg1,
            ),
            secondaryBackground: Container(
              color: AppTheme.customTheme.groceryBg1,
              padding: FxSpacing.horizontal(20),
              alignment: AlignmentDirectional.centerEnd,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: FxSpacing.right(8),
                    padding: FxSpacing.all(16),
                    decoration: BoxDecoration(
                        color: AppTheme.customTheme.red.withAlpha(40),
                        shape: BoxShape.circle),
                    child: Icon(
                      MdiIcons.delete,
                      size: 22,
                      color: AppTheme.customTheme.red,
                    ),
                  ),
                ],
              ),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                setState(() {
                  //TODO: perform delete operation
                });
              }
            },
            child: FxContainer(
              color: AppTheme.customTheme.groceryBg2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxContainer(
                    color: AppTheme.customTheme.groceryPrimary.withAlpha(32),
                    padding: FxSpacing.all(8),
                    child: Hero(
                      tag: heroKey!,
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          widget.cart!.image,
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
                        FxText.b1(widget.name, fontWeight: 600),
                        FxSpacing.height(8),
                        /* widget.cart.discountedPrice != widget.cart.price
                            ? Row(
                                children: [
                                  FxText.caption(
                                      FxTextUtils.doubleToString(
                                              widget.cart.price) +
                                          " FCFA",
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: 500),
                                  // Space.width(8),
                                  FxSpacing.width(8),
                                  FxText.b2(
                                      FxTextUtils.doubleToString(
                                              widget.cart.discountedPrice) +
                                          " FCFA",
                                      color: customAppTheme.colorTextFeed,
                                      fontWeight: 700),
                                ],
                              ):  */
                        FxText.b2(
                            FxTextUtils.doubleToString(
                                    widget.price.toDouble()) +
                                " FCFA",
                            color: customAppTheme.colorTextFeed,
                            fontWeight: 700),
                        FxSpacing.height(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FxContainer(
                              onTap: () {
                                setState(() {
                                  if (quantity > 1) quantity--;
                                });
                              },
                              paddingAll: 8,
                              borderRadiusAll: 4,
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
                              padding: FxSpacing.all(8),
                              borderRadiusAll: 4,
                              onTap: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              color: AppTheme.customTheme.groceryPrimary,
                              child: Icon(
                                MdiIcons.plus,
                                size: 14,
                                color: AppTheme.customTheme.groceryOnPrimary,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
