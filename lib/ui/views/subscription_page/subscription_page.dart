import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/ui/utils/SizeConfig.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/payment_page/pack_categorie.dart';
import 'package:sesa/ui/views/payment_page/payment_page.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/text/text.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  late CustomAppTheme customAppTheme;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        final auth = watch(authProvider.state);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimary,
            title: Text(
              "Subscription & Payment",
              style: TextStyle(
                color: KWhite,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: true,
          ),
          backgroundColor: customAppTheme.kBackgroundColorFinal,
          body: ListView(
            shrinkWrap: true,
            padding: FxSpacing.horizontal(16),
            children: [
              FxSpacing.height(20),
              FxButton.block(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PackCategoriePage(),
                    ),
                  );
                },
                backgroundColor: kPrimary,
                borderRadiusAll: 8,
                child: FxText.sh2(
                  "Souscrire à un abonnement",
                  fontWeight: 700,
                  color: KWhite,
                  letterSpacing: 0.4,
                ),
              ),
              FxSpacing.height(20),
              ListView.separated(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: customAppTheme.kBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        FxContainer(
                          paddingAll: 0,
                          borderRadiusAll: 16,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: Image(
                              width: 72,
                              height: 72,
                              image: AssetImage("assets/images/sesabw.png"),
                            ),
                          ),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FxText.b1(
                                auth.user.abonnements[index].packSesa.acronyme
                                    .toUpperCase(),
                                fontWeight: 600,
                                color: customAppTheme.colorTextFeed,
                              ),
                              FxText.b1(
                                auth.user.abonnements[index].packSesa
                                    .description,
                                fontWeight: 600,
                                fontSize: 14,
                                color: customAppTheme.colorTextFeed,
                              ),
                              FxSpacing.height(4),
                              FxText.caption(
                                (auth.user.abonnements[index].etat)
                                    ? "En cours jusau'au : ${auth.user.abonnements[index].endDate}"
                                    : "Expirer depuis le : ${auth.user.abonnements[index].endDate}",
                                xMuted: true,
                                color: (auth.user.abonnements[index].etat)
                                    ? customAppTheme.green
                                    : customAppTheme.red,
                                fontWeight: 600,
                                fontSize: 14,
                              ),
                              FxSpacing.height(12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    margin: Spacing.fromLTRB(75, 0, 0, 10),
                  );
                },
                itemCount: auth.user.abonnements.length,
              ),
              /* StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('payment')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.only(
                        top: 100,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.data!.exists)
                    return Text(
                      "${snapshot.data!["details"]}",
                      //style: style,
                    );
                  if (!snapshot.data!.exists)
                    return Container(
                      margin: EdgeInsets.only(
                        top: 100,
                      ),
                      child: Text(
                        "Aucun abonnement actif",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    );

                  return Container();

                  //return Container();
                },
              ), */
            ],
          ),
        );
      },
    );
  }
}
