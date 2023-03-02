import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/core/controllers/user_controller/user_controller.dart';

import 'package:sesa/core/models/doctors/carnet.dart';
import 'package:sesa/core/models/doctors/parametre.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/text/text.dart';

class AddParams extends StatefulWidget {
  final Parameter? carnet;
  final bool isEdit;
  const AddParams({
    Key? key,
    this.carnet,
    required this.isEdit,
  }) : super(key: key);

  @override
  State<AddParams> createState() => _AddParamsState();
}

class _AddParamsState extends State<AddParams> {
  late CustomAppTheme customAppTheme;
  TextEditingController taille = TextEditingController();
  TextEditingController poids = TextEditingController();
  TextEditingController temperature = TextEditingController();
  TextEditingController frequenceCardiaque = TextEditingController();
  TextEditingController pouls = TextEditingController();
  TextEditingController frequenceRespiratoire = TextEditingController();
  TextEditingController saturationOxygene = TextEditingController();
  TextEditingController perimetreBranchial = TextEditingController();
  bool signIn = false;
  ApiService _apiService = ApiService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.carnet != null) {
      taille.text = (widget.carnet!.taille != 0.0 &&
              widget.carnet!.taille != null &&
              widget.carnet!.taille != 0)
          ? widget.carnet!.taille.toString()
          : "";
      poids.text = (widget.carnet!.poids != 0.0 &&
              widget.carnet!.poids != null &&
              widget.carnet!.poids != 0)
          ? widget.carnet!.poids.toString()
          : "";
      temperature.text = (widget.carnet!.temperature != 0.0 &&
              widget.carnet!.temperature != null &&
              widget.carnet!.temperature != 0)
          ? widget.carnet!.temperature.toString()
          : "";
      frequenceCardiaque.text = (widget.carnet!.frequenceCardiaque != 0.0 &&
              widget.carnet!.frequenceCardiaque != null &&
              widget.carnet!.frequenceCardiaque != 0)
          ? widget.carnet!.frequenceCardiaque.toString()
          : "";
      pouls.text = (widget.carnet!.pouls != 0.0 &&
              widget.carnet!.pouls != null &&
              widget.carnet!.pouls != 0)
          ? widget.carnet!.pouls.toString()
          : "";
      frequenceRespiratoire.text =
          (widget.carnet!.frequenceRespiratoire != 0.0 &&
                  widget.carnet!.frequenceRespiratoire != null &&
                  widget.carnet!.frequenceRespiratoire != 0)
              ? widget.carnet!.frequenceRespiratoire.toString()
              : "";
      saturationOxygene.text = (widget.carnet!.saturationOxygene != 0.0 &&
              widget.carnet!.saturationOxygene != null &&
              widget.carnet!.saturationOxygene != 0)
          ? widget.carnet!.saturationOxygene.toString()
          : "";
      perimetreBranchial.text = (widget.carnet!.perimetreBranchial != 0.0 &&
              widget.carnet!.perimetreBranchial != null &&
              widget.carnet!.perimetreBranchial != 0)
          ? widget.carnet!.perimetreBranchial.toString()
          : "";
    }
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
            elevation: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                MdiIcons.chevronLeft,
                color: customAppTheme.kVioletColor,
                size: 25,
              ),
            ),
          ),
          body: ListView(
            padding: FxSpacing.fromLTRB(24, 0, 24, 24),
            children: [
              FxText.h6(
                (!widget.isEdit)
                    ? 'Ajouter les paramètres'
                    : "Mettre à jour les paramètres",
                textAlign: TextAlign.left,
                fontWeight: 600,
                letterSpacing: 0.8,
                color: customAppTheme.colorTextFeed,
              ),
              FxSpacing.height(20),
              FxSpacing.height(20),
              Text("Taille (m)"),
              TextFormField(
                controller: taille,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: KPlaceholder,
                  ),
                  hintText: "Entrer votre taille",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              Text("Poids (Kg)"),
              TextFormField(
                controller: poids,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: KPlaceholder,
                  ),
                  hintText: "Entrer votre poids",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              Text("Température (°C)"),
              TextFormField(
                controller: temperature,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: KPlaceholder,
                  ),
                  hintText: "Entrer votre temperature",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              Text("Fréquence Cardiaque (bpm)"),
              TextFormField(
                controller: frequenceCardiaque,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: KPlaceholder,
                  ),
                  hintText: "Entrer votre frequenceCardiaque",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              Text("Pouls (Pulsation par minute)"),
              TextFormField(
                controller: pouls,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: KPlaceholder,
                  ),
                  hintText: "Entrer votre pouls",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              Text("Fréquence respiratoire (mvn)"),
              TextFormField(
                controller: frequenceRespiratoire,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: KPlaceholder,
                  ),
                  hintText: "Entrer votre frequenceRespiratoire",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              Text("Saturation d'oxygène (%)"),
              TextFormField(
                controller: saturationOxygene,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: KPlaceholder,
                  ),
                  hintText: "Entrer votre saturationOxygene",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              Text("Périmètre Branchial (cm)"),
              TextFormField(
                controller: perimetreBranchial,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  /* contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), */
                  filled: true,
                  fillColor: kGrayColor.shade200,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: KPlaceholder,
                  ),
                  hintText: "Entrer votre perimetreBranchial",
                  hintStyle: TextStyle(
                    color: KPlaceholder,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrayColor.shade200,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              FxSpacing.height(20),
              FxButton.block(
                onPressed: () {
                  setState(() {
                    signIn = true;
                  });
                  if (widget.isEdit) {
                    _apiService
                        .updateParams(
                      id: widget.carnet!.id,
                      frequenceCardiaque: double.parse(frequenceCardiaque.text),
                      frequenceRespiratoire:
                          double.parse(frequenceRespiratoire.text),
                      perimetreBranchial: double.parse(perimetreBranchial.text),
                      poids: double.parse(poids.text),
                      pouls: double.parse(pouls.text),
                      saturationOxygene: double.parse(saturationOxygene.text),
                      taille: double.parse(taille.text),
                      temperature: double.parse(temperature.text),
                    )
                        .then((value) {
                      if (value["status"] == 201) {
                        context.refresh(authProvider);
                        //Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: "Mise à jour reussi",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 5,
                          backgroundColor: kPrimary,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        setState(() {
                          signIn = false;
                        });
                      } else {
                        setState(() {
                          signIn = false;
                        });
                        Fluttertoast.showToast(
                          msg: "Une erreur est surevenue !",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 5,
                          backgroundColor: kRedColor,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    });
                  } else {
                    _apiService
                        .addParams(
                      id: auth.user.userId,
                      frequenceCardiaque: double.parse(frequenceCardiaque.text),
                      frequenceRespiratoire:
                          double.parse(frequenceRespiratoire.text),
                      perimetreBranchial: double.parse(perimetreBranchial.text),
                      poids: double.parse(poids.text),
                      pouls: double.parse(pouls.text),
                      saturationOxygene: double.parse(saturationOxygene.text),
                      taille: double.parse(taille.text),
                      temperature: double.parse(temperature.text),
                    )
                        .then((value) {
                      if (value["status"] == 201) {
                        context.refresh(authProvider);
                        //Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: "Mise à jour reussi",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 5,
                          backgroundColor: kPrimary,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        setState(() {
                          signIn = false;
                        });
                      } else {
                        setState(() {
                          signIn = false;
                        });
                        Fluttertoast.showToast(
                          msg: "Une erreur est surevenue !",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 5,
                          backgroundColor: kRedColor,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    });
                  }
                },
                backgroundColor: kPrimary,
                borderRadiusAll: 8,
                child: !signIn
                    ? FxText.sh2(
                        (widget.isEdit) ? "Modifier" : "Enregistrer",
                        fontWeight: 700,
                        color: KWhite,
                        letterSpacing: 0.4,
                      )
                    : CircularProgressIndicator(
                        color: kPrimary,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
