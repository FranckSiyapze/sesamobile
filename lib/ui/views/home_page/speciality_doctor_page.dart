import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/core/models/doctors/user.dart';

import 'package:sesa/core/services/api_service.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/star_rating.dart';
import 'package:sesa/ui/utils/styles/style.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/doctor_page/doctor_page.dart';
import 'package:sesa/ui/widgets/card/card.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/text/text.dart';

class SpecialityDoctorPage extends StatefulWidget {
  final String speciality;
  const SpecialityDoctorPage({
    Key? key,
    required this.speciality,
  }) : super(key: key);

  @override
  State<SpecialityDoctorPage> createState() => _SpecialityDoctorPageState();
}

class _SpecialityDoctorPageState extends State<SpecialityDoctorPage> {
  ApiService _apiService = ApiService();
  late CustomAppTheme customAppTheme;
  List<UserDoctor> userDoctors = [];
  bool load = false;
  bool asData = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiService.getDoctorPerSpeciality().then((value) {
      List<UserDoctor> users = [];
      if (value["status"] == 200) {
        setState(() {
          load = true;
          users = value["data"].map<UserDoctor>((_item) {
            return UserDoctor.fromJson(_item);
          }).toList();
          if (users.length == 0) {
            asData = false;
          } else {
            userDoctors = users
                .where((i) => i.speciality.name == widget.speciality)
                .toList();
            print(userDoctors);
          }
        });
      } else {
        setState(() {
          load = true;
          asData = false;
        });
      }
    });
  }

  Widget _buildSingleDoctor(UserDoctor doctor) {
    return FxCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorPage(doctor: doctor),
          ),
        );
      },
      margin: FxSpacing.fromLTRB(24, 0, 24, 16),
      color: customAppTheme.kBackgroundColor,
      paddingAll: 16,
      borderRadiusAll: 16,
      shadow: FxShadow(
        elevation: 0,
      ),
      child: Row(
        children: [
          (doctor.imageUrl == null && doctor.imageUrl == "")
              ? FxContainer(
                  paddingAll: 0,
                  borderRadiusAll: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Image(
                      width: 72,
                      height: 72,
                      image: AssetImage("assets/images/avatar_2.jpg"),
                    ),
                  ),
                )
              : FxContainer(
                  paddingAll: 0,
                  borderRadiusAll: 16,
                  /* child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image(
                width: 72,
                height: 72,
                image: AssetImage("assets/images/avatar_2.jpg"),
              ),
            ), */
                  child: CachedNetworkImage(
                    imageUrl: doctor.imageUrl,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: Image(
                        width: 72,
                        height: 72,
                        image: AssetImage("assets/images/avatar_2.jpg"),
                      ),
                    ),
                  ),
                ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.b1(
                  "${doctor.firstName} ${doctor.lastName}",
                  fontWeight: 600,
                  color: customAppTheme.colorTextFeed,
                ),
                FxSpacing.height(4),
                FxText.caption(
                  doctor.department.name,
                  xMuted: true,
                  color: customAppTheme.colorTextFeed,
                ),
                FxText.caption(
                  "Spécialité : " + doctor.speciality.name,
                  xMuted: true,
                  color: customAppTheme.colorTextFeed,
                ),
                FxSpacing.height(12),
                /* Row(
                  children: [
                    FxStarRating.buildRatingStar(
                        rating: 4.5, showInactive: true, size: 15),
                    FxSpacing.width(4),
                    FxText.caption(
                      4.5.toString() + ' | ' + 120.toString() + ' Reviews',
                      xMuted: true,
                      color: customAppTheme.colorTextFeed,
                    ),
                  ],
                ), */
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final themeProvider = watch(themeNotifierProvider);
      customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.speciality),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: customAppTheme.kWhite,
            ),
          ),
          elevation: 0,
        ),
        backgroundColor: customAppTheme.kBackgroundColorFinal,
        body: ListView(
          padding: FxSpacing.fromLTRB(0, 0, 0, 70),
          children: [
            FxSpacing.height(24),
            if (!load) Center(child: CircularProgressIndicator()),
            if (asData)
              Padding(
                padding: FxSpacing.horizontal(0),
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: userDoctors.length,
                  itemBuilder: ((context, index) {
                    return _buildSingleDoctor(userDoctors[index]);
                  }),
                ),
              ),
            if (!asData)
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "PAS DE DOCTEUR POUR CETTE SPECIALITE",
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
    });
  }
}
