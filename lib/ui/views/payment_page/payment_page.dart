import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sesa/core/models/doctors/pack_sesa.dart';
import 'package:sesa/core/services/api.dart';
import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/ui/utils/SizeConfig.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/payment_page/pay.dart';
import 'package:sesa/ui/widgets/button/button.dart';
import 'package:sesa/ui/widgets/text/text.dart';

class PaymentPage extends StatefulWidget {
  final int id;
  const PaymentPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late CustomAppTheme customAppTheme;
  late Api apiservice = Api();
  final ApiService _apiService = ApiService();
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
              builder: (context) => PayCheckout(
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

  List<PackSeSa> packsesa = [];
  bool load = false;
  bool asData = true;
  @override
  void initState() {
    super.initState();
    _apiService.getCategoriesPackSesa(widget.id).then((value) {
      if (value["status"] == 200) {
        setState(() {
          load = true;
          packsesa = value["data"].map<PackSeSa>((_item) {
            return PackSeSa.fromJson(_item);
          }).toList();
          if (packsesa.length == 0) {
            asData = false;
          }
        });
        print("The pack is : $packsesa");
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
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimary,
            title: Text("Souscrire"),
            centerTitle: true,
            automaticallyImplyLeading: true,
          ),
          body: ListView(
            padding: FxSpacing.fromLTRB(0, 48, 0, 70),
            children: [
              if (!load) Center(child: CircularProgressIndicator()),
              if (asData)
                ListView.separated(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        /*  getFees(packsesa[index].price,
                          "${packsesa[index].description}"); */
                      },
                      /* child: Card(
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${packsesa[index].description}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            FxSpacing.height(20),
                            if (packsesa[index].acronyme == "SeSa-UR")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Carte d’inscription informatisée de membre de Sécu-Santé"),
                                  Text(
                                      "Check up initial, examen et rapport médical(GS/RH gratuit)"),
                                  Text(
                                      "-10% sur les consultations courantes et spécialisées"),
                                  Text("-10% analyses biomédicales"),
                                  Text("-10% hospitalisations"),
                                  Text("-10% dossier médical"),
                                  Text("-10% livret médical"),
                                  Text(
                                      "-10% réduction sur les transferts assistés par ambulance"),
                                  Text(
                                      "Médecin conseil et équipe multidisciplinaire"),
                                ],
                              ),
                            if (packsesa[index].acronyme == "SeSa-B")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                  Text(
                                      "Check up initial, examen et rapport médical ;"),
                                  Text(
                                      "Consultations courantes et spécialisées ;"),
                                  Text("03 visites médicales en salle ;"),
                                  Text(
                                      "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                  Text(
                                      "-10% sur les autres analyses biomédicales ;"),
                                  Text(
                                      "72 heures hospitalisations standards ;"),
                                  Text("01 dossier médical ;"),
                                  Text("01 livret médical ;"),
                                  Text("Crédits santé et pré – paiement ;"),
                                  Text(
                                      "Médecin conseil et équipe multidisciplinaire ;"),
                                  Text(
                                      "-10% transfert assisté par ambulance ;"),
                                  Text("01 visite domiciliaire par semestre ;"),
                                  Text(
                                      "Education sanitaire et télé conseils ;"),
                                ],
                              ),
                            if (packsesa[index].acronyme == "SeSa-I")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "	Carte d’inscription informatisée Sécu-Santé membre "),
                                  Text(
                                      "	Check up initial, examen et rapport médical ;"),
                                  Text(
                                      "	Consultations courantes et spécialisées ;"),
                                  Text("	Visites médicales en salle ;"),
                                  Text(
                                      "	Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                  Text(
                                      "	-10% sur les autres analyses biomédicales ;"),
                                  Text("	01 dossier médical"),
                                  Text(
                                      "	72 heures hospitalisations Haut standing ;"),
                                  Text("01 livret médical ;"),
                                  Text("Crédits santé et pré – paiement ;"),
                                  Text(
                                      "Médecin conseil et équipe multidisciplinaire ;"),
                                  Text(
                                      "-10% transfert assisté par ambulance ;"),
                                  Text(
                                      "	Visites domiciliaires une fois par semestre"),
                                  Text(
                                      "Education sanitaire et télé conseils ;"),
                                ],
                              ),
                            if (packsesa[index].acronyme == "SeSa-U")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                  Text(
                                      "Check up initial, examen et rapport médical ;"),
                                  Text(
                                      "Consultations courantes et spécialisées ;"),
                                  Text("	Visites médicales en salle "),
                                  Text(
                                      "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                  Text(
                                      "-10% sur les autres analyses biomédicales ;"),
                                  Text(
                                      "72 heures hospitalisations standards ;"),
                                  Text("01 dossier médical ;"),
                                  Text("01 livret médical ;"),
                                  Text("Crédits santé et pré – paiement ;"),
                                  Text(
                                      "Médecin conseil et équipe multidisciplinaire ;"),
                                  Text(
                                      "-10% transfert assisté par ambulance ;"),
                                  Text("01 visite domiciliaire par semestre ;"),
                                  Text(
                                      "Education sanitaire et télé conseils ;"),
                                ],
                              ),
                            if (packsesa[index].acronyme == "SeSa-M")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                  Text(
                                      "Check up initial, examen et rapport médical ;"),
                                  Text(
                                      "Consultations courantes et spécialisées ;"),
                                  Text("	Visites médicales en salle "),
                                  Text(
                                      "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                  Text(
                                      "-10% sur les autres analyses biomédicales ;"),
                                  Text(
                                      "72 heures hospitalisations standards ;"),
                                  Text("01 dossier médical ;"),
                                  Text("01 livret médical ;"),
                                  Text("Crédits santé et pré – paiement ;"),
                                  Text(
                                      "Médecin conseil et équipe multidisciplinaire ;"),
                                  Text(
                                      "-10% transfert assisté par ambulance ;"),
                                  Text("01 visite domiciliaire par semestre ;"),
                                  Text(
                                      "Education sanitaire et télé conseils ;"),
                                ],
                              ),
                            if (packsesa[index].acronyme == "SeSa-S1")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                  Text(
                                      "Check up initial, examen et rapport médical ;"),
                                  Text(
                                      "Consultations courantes et spécialisées ;"),
                                  Text("	Visites médicales en salle "),
                                  Text(
                                      "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                  Text(
                                      "-10% sur les autres analyses biomédicales ;"),
                                  Text(
                                      "72 heures hospitalisations standards ;"),
                                  Text("01 dossier médical ;"),
                                  Text("01 livret médical ;"),
                                  Text("Crédits santé et pré – paiement ;"),
                                  Text(
                                      "Médecin conseil et équipe multidisciplinaire ;"),
                                  Text(
                                      "-10% transfert assisté par ambulance ;"),
                                  Text("01 visite domiciliaire par semestre ;"),
                                  Text(
                                      "Education sanitaire et télé conseils ;"),
                                ],
                              ),
                            if (packsesa[index].acronyme == "SeSa-S2")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                  Text(
                                      "Check up initial, examen et rapport médical ;"),
                                  Text(
                                      "Consultations courantes et spécialisées ;"),
                                  Text("	Visites médicales en salle "),
                                  Text(
                                      "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                  Text(
                                      "-10% sur les autres analyses biomédicales ;"),
                                  Text(
                                      "72 heures hospitalisations standards ;"),
                                  Text("01 dossier médical ;"),
                                  Text("01 livret médical ;"),
                                  Text("Crédits santé et pré – paiement ;"),
                                  Text(
                                      "Médecin conseil et équipe multidisciplinaire ;"),
                                  Text(
                                      "-10% transfert assisté par ambulance ;"),
                                  Text("01 visite domiciliaire par semestre ;"),
                                  Text(
                                      "Education sanitaire et télé conseils ;"),
                                ],
                              ),
                            if (packsesa[index].acronyme == "SeSa-S3")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                  Text(
                                      "Check up initial, examen et rapport médical ;"),
                                  Text(
                                      "Consultations courantes et spécialisées ;"),
                                  Text("	Visites médicales en salle "),
                                  Text(
                                      "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                  Text(
                                      "-10% sur les autres analyses biomédicales ;"),
                                  Text(
                                      "72 heures hospitalisations standards ;"),
                                  Text("01 dossier médical ;"),
                                  Text("01 livret médical ;"),
                                  Text("Crédits santé et pré – paiement ;"),
                                  Text(
                                      "Médecin conseil et équipe multidisciplinaire ;"),
                                  Text(
                                      "-10% transfert assisté par ambulance ;"),
                                  Text("01 visite domiciliaire par semestre ;"),
                                  Text(
                                      "Education sanitaire et télé conseils ;"),
                                ],
                              ),
                            if (packsesa[index].acronyme == "SeSa-G")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                  Text(
                                      "Check up initial, examen et rapport médical ;"),
                                  Text(
                                      "Consultations courantes et spécialisées ;"),
                                  Text("	Visites médicales en salle "),
                                  Text(
                                      "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                  Text(
                                      "-10% sur les autres analyses biomédicales ;"),
                                  Text(
                                      "72 heures hospitalisations standards ;"),
                                  Text("01 dossier médical ;"),
                                  Text("01 livret médical ;"),
                                  Text("Crédits santé et pré – paiement ;"),
                                  Text(
                                      "Médecin conseil et équipe multidisciplinaire ;"),
                                  Text(
                                      "-10% transfert assisté par ambulance ;"),
                                  Text("01 visite domiciliaire par semestre ;"),
                                  Text(
                                      "Education sanitaire et télé conseils ;"),
                                ],
                              ),
                            if (packsesa[index].acronyme == "SeSa-F")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                  Text(
                                      "Check up initial, examen et rapport médical ;"),
                                  Text(
                                      "Consultations courantes et spécialisées ;"),
                                  Text("	Visites médicales en salle "),
                                  Text(
                                      "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                  Text(
                                      "-10% sur les autres analyses biomédicales ;"),
                                  Text(
                                      "72 heures hospitalisations standards ;"),
                                  Text("01 dossier médical ;"),
                                  Text("01 livret médical ;"),
                                  Text("Crédits santé et pré – paiement ;"),
                                  Text(
                                      "Médecin conseil et équipe multidisciplinaire ;"),
                                  Text(
                                      "-10% transfert assisté par ambulance ;"),
                                  Text("01 visite domiciliaire par semestre ;"),
                                  Text(
                                      "Education sanitaire et télé conseils ;"),
                                ],
                              ),
                          ],
                        ),
                        trailing: Text(
                          "${packsesa[index].price}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ), */
                      child: ExpansionTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${packsesa[index].description}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "${packsesa[index].price}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        children: [
                          if (packsesa[index].acronyme == "SeSa-UR")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Carte d’inscription informatisée de membre de Sécu-Santé"),
                                Text(
                                    "Check up initial, examen et rapport médical(GS/RH gratuit)"),
                                Text(
                                    "-10% sur les consultations courantes et spécialisées"),
                                Text("-10% analyses biomédicales"),
                                Text("-10% hospitalisations"),
                                Text("-10% dossier médical"),
                                Text("-10% livret médical"),
                                Text(
                                    "-10% réduction sur les transferts assistés par ambulance"),
                                Text(
                                    "Médecin conseil et équipe multidisciplinaire"),
                              ],
                            ),
                          if (packsesa[index].acronyme == "SeSa-B")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                Text(
                                    "Check up initial, examen et rapport médical ;"),
                                Text(
                                    "Consultations courantes et spécialisées ;"),
                                Text("03 visites médicales en salle ;"),
                                Text(
                                    "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                Text(
                                    "-10% sur les autres analyses biomédicales ;"),
                                Text("72 heures hospitalisations standards ;"),
                                Text("01 dossier médical ;"),
                                Text("01 livret médical ;"),
                                Text("Crédits santé et pré – paiement ;"),
                                Text(
                                    "Médecin conseil et équipe multidisciplinaire ;"),
                                Text("-10% transfert assisté par ambulance ;"),
                                Text("01 visite domiciliaire par semestre ;"),
                                Text("Education sanitaire et télé conseils ;"),
                              ],
                            ),
                          if (packsesa[index].acronyme == "SeSa-I")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "	Carte d’inscription informatisée Sécu-Santé membre "),
                                Text(
                                    "	Check up initial, examen et rapport médical ;"),
                                Text(
                                    "	Consultations courantes et spécialisées ;"),
                                Text("	Visites médicales en salle ;"),
                                Text(
                                    "	Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                Text(
                                    "	-10% sur les autres analyses biomédicales ;"),
                                Text("	01 dossier médical"),
                                Text(
                                    "	72 heures hospitalisations Haut standing ;"),
                                Text("01 livret médical ;"),
                                Text("Crédits santé et pré – paiement ;"),
                                Text(
                                    "Médecin conseil et équipe multidisciplinaire ;"),
                                Text("-10% transfert assisté par ambulance ;"),
                                Text(
                                    "	Visites domiciliaires une fois par semestre"),
                                Text("Education sanitaire et télé conseils ;"),
                              ],
                            ),
                          if (packsesa[index].acronyme == "SeSa-U")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                Text(
                                    "Check up initial, examen et rapport médical ;"),
                                Text(
                                    "Consultations courantes et spécialisées ;"),
                                Text("	Visites médicales en salle "),
                                Text(
                                    "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                Text(
                                    "-10% sur les autres analyses biomédicales ;"),
                                Text("72 heures hospitalisations standards ;"),
                                Text("01 dossier médical ;"),
                                Text("01 livret médical ;"),
                                Text("Crédits santé et pré – paiement ;"),
                                Text(
                                    "Médecin conseil et équipe multidisciplinaire ;"),
                                Text("-10% transfert assisté par ambulance ;"),
                                Text("01 visite domiciliaire par semestre ;"),
                                Text("Education sanitaire et télé conseils ;"),
                              ],
                            ),
                          if (packsesa[index].acronyme == "SeSa-M")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                Text(
                                    "Check up initial, examen et rapport médical ;"),
                                Text(
                                    "Consultations courantes et spécialisées ;"),
                                Text("	Visites médicales en salle "),
                                Text(
                                    "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                Text(
                                    "-10% sur les autres analyses biomédicales ;"),
                                Text("72 heures hospitalisations standards ;"),
                                Text("01 dossier médical ;"),
                                Text("01 livret médical ;"),
                                Text("Crédits santé et pré – paiement ;"),
                                Text(
                                    "Médecin conseil et équipe multidisciplinaire ;"),
                                Text("-10% transfert assisté par ambulance ;"),
                                Text("01 visite domiciliaire par semestre ;"),
                                Text("Education sanitaire et télé conseils ;"),
                              ],
                            ),
                          if (packsesa[index].acronyme == "SeSa-S1")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                Text(
                                    "Check up initial, examen et rapport médical ;"),
                                Text(
                                    "Consultations courantes et spécialisées ;"),
                                Text("	Visites médicales en salle "),
                                Text(
                                    "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                Text(
                                    "-10% sur les autres analyses biomédicales ;"),
                                Text("72 heures hospitalisations standards ;"),
                                Text("01 dossier médical ;"),
                                Text("01 livret médical ;"),
                                Text("Crédits santé et pré – paiement ;"),
                                Text(
                                    "Médecin conseil et équipe multidisciplinaire ;"),
                                Text("-10% transfert assisté par ambulance ;"),
                                Text("01 visite domiciliaire par semestre ;"),
                                Text("Education sanitaire et télé conseils ;"),
                              ],
                            ),
                          if (packsesa[index].acronyme == "SeSa-S2")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                Text(
                                    "Check up initial, examen et rapport médical ;"),
                                Text(
                                    "Consultations courantes et spécialisées ;"),
                                Text("	Visites médicales en salle "),
                                Text(
                                    "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                Text(
                                    "-10% sur les autres analyses biomédicales ;"),
                                Text("72 heures hospitalisations standards ;"),
                                Text("01 dossier médical ;"),
                                Text("01 livret médical ;"),
                                Text("Crédits santé et pré – paiement ;"),
                                Text(
                                    "Médecin conseil et équipe multidisciplinaire ;"),
                                Text("-10% transfert assisté par ambulance ;"),
                                Text("01 visite domiciliaire par semestre ;"),
                                Text("Education sanitaire et télé conseils ;"),
                              ],
                            ),
                          if (packsesa[index].acronyme == "SeSa-S3")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                Text(
                                    "Check up initial, examen et rapport médical ;"),
                                Text(
                                    "Consultations courantes et spécialisées ;"),
                                Text("	Visites médicales en salle "),
                                Text(
                                    "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                Text(
                                    "-10% sur les autres analyses biomédicales ;"),
                                Text("72 heures hospitalisations standards ;"),
                                Text("01 dossier médical ;"),
                                Text("01 livret médical ;"),
                                Text("Crédits santé et pré – paiement ;"),
                                Text(
                                    "Médecin conseil et équipe multidisciplinaire ;"),
                                Text("-10% transfert assisté par ambulance ;"),
                                Text("01 visite domiciliaire par semestre ;"),
                                Text("Education sanitaire et télé conseils ;"),
                              ],
                            ),
                          if (packsesa[index].acronyme == "SeSa-G")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                Text(
                                    "Check up initial, examen et rapport médical ;"),
                                Text(
                                    "Consultations courantes et spécialisées ;"),
                                Text("	Visites médicales en salle "),
                                Text(
                                    "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                Text(
                                    "-10% sur les autres analyses biomédicales ;"),
                                Text("72 heures hospitalisations standards ;"),
                                Text("01 dossier médical ;"),
                                Text("01 livret médical ;"),
                                Text("Crédits santé et pré – paiement ;"),
                                Text(
                                    "Médecin conseil et équipe multidisciplinaire ;"),
                                Text("-10% transfert assisté par ambulance ;"),
                                Text("01 visite domiciliaire par semestre ;"),
                                Text("Education sanitaire et télé conseils ;"),
                              ],
                            ),
                          if (packsesa[index].acronyme == "SeSa-F")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Carte d’inscription informatisée Sécu-Santé membre ;"),
                                Text(
                                    "Check up initial, examen et rapport médical ;"),
                                Text(
                                    "Consultations courantes et spécialisées ;"),
                                Text("	Visites médicales en salle "),
                                Text(
                                    "Analyses médicales (GE, Selles, NFS, CRP, GS/Rh, COVID 19) ;"),
                                Text(
                                    "-10% sur les autres analyses biomédicales ;"),
                                Text("72 heures hospitalisations standards ;"),
                                Text("01 dossier médical ;"),
                                Text("01 livret médical ;"),
                                Text("Crédits santé et pré – paiement ;"),
                                Text(
                                    "Médecin conseil et équipe multidisciplinaire ;"),
                                Text("-10% transfert assisté par ambulance ;"),
                                Text("01 visite domiciliaire par semestre ;"),
                                Text("Education sanitaire et télé conseils ;"),
                              ],
                            ),
                          Container(
                            padding: EdgeInsets.all(12),
                            child: FxButton.block(
                              onPressed: () {
                                getFees(
                                  packsesa[index].price,
                                  "${packsesa[index].description}",
                                );
                              },
                              child: FxText.sh2(
                                "Payer le pack",
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
                  separatorBuilder: (context, index) {
                    return Container(
                      margin: Spacing.fromLTRB(75, 0, 0, 10),
                    );
                  },
                  itemCount: packsesa.length,
                ),
              if (!asData)
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "PAS DE DONNEES",
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
