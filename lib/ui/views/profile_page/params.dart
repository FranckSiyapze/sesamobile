import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/profile_page/add_params.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/text/text.dart';

class ParamsPatient extends StatefulWidget {
  const ParamsPatient({Key? key});

  @override
  State<ParamsPatient> createState() => _ParamsPatientState();
}

class _ParamsPatientState extends State<ParamsPatient> {
  late CustomAppTheme customAppTheme;
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
            backgroundColor: kPrimary,
            title: Text(
              "Mes paramètres",
              style: TextStyle(
                color: KWhite,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: true,
          ),
          body: ListView(
            padding: FxSpacing.fromLTRB(24, 0, 24, 24),
            children: [
              FxSpacing.height(40),
              if (auth.user.carnet.parametres.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Taille  : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ),
                          TextSpan(
                            text:
                                "${auth.user.carnet.parametres.last.taille} m",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: customAppTheme.colorTextFeed,
                            ),
                          )
                        ],
                      ),
                    ),
                    FxSpacing.height(15),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Poids : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ),
                          TextSpan(
                            text:
                                "${auth.user.carnet.parametres.last.poids} Kg",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: customAppTheme.colorTextFeed,
                            ),
                          )
                        ],
                      ),
                    ),
                    FxSpacing.height(15),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Température : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ),
                          TextSpan(
                            text:
                                "${auth.user.carnet.parametres.last.temperature} °C",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: customAppTheme.colorTextFeed,
                            ),
                          )
                        ],
                      ),
                    ),
                    FxSpacing.height(15),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Fréquence cardiaque : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ),
                          TextSpan(
                            text:
                                "${auth.user.carnet.parametres.last.frequenceCardiaque} Bpm",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: customAppTheme.colorTextFeed,
                            ),
                          )
                        ],
                      ),
                    ),
                    FxSpacing.height(15),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Pouls : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ),
                          TextSpan(
                            text:
                                "${auth.user.carnet.parametres.last.pouls} Pulsation par minute",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: customAppTheme.colorTextFeed,
                            ),
                          )
                        ],
                      ),
                    ),
                    FxSpacing.height(15),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Fréquence respiratoire : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ),
                          TextSpan(
                            text:
                                "${auth.user.carnet.parametres.last.frequenceRespiratoire} Mvm",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: customAppTheme.colorTextFeed,
                            ),
                          )
                        ],
                      ),
                    ),
                    FxSpacing.height(15),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Saturation d'oxygène : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ),
                          TextSpan(
                            text:
                                "${auth.user.carnet.parametres.last.saturationOxygene} %",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: customAppTheme.colorTextFeed,
                            ),
                          )
                        ],
                      ),
                    ),
                    FxSpacing.height(15),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Périmètre branchiale : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: customAppTheme.colorTextFeed,
                            ),
                          ),
                          TextSpan(
                            text:
                                "${auth.user.carnet.parametres.last.perimetreBranchial} Cm",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: customAppTheme.colorTextFeed,
                            ),
                          )
                        ],
                      ),
                    ),
                    FxSpacing.height(15),
                    FxButton.block(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddParams(
                              isEdit: true,
                              carnet: auth.user.carnet.parametres.last,
                            ),
                          ),
                        );
                      },
                      backgroundColor: kPrimary,
                      borderRadiusAll: 8,
                      child: FxText.sh2(
                        "Mettre à jour les paramètres",
                        fontWeight: 700,
                        color: KWhite,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              if (auth.user.carnet.parametres.isEmpty)
                Center(
                  child: FxButton.block(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddParams(
                            isEdit: false,
                          ),
                        ),
                      );
                    },
                    backgroundColor: kPrimary,
                    borderRadiusAll: 8,
                    child: FxText.sh2(
                      "Ajouter les paramètres",
                      fontWeight: 700,
                      color: KWhite,
                      letterSpacing: 0.4,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
