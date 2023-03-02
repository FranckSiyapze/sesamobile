import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sesa/core/models/doctors/user.dart';
import 'package:sesa/ui/utils/SizeConfig.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/styles/style.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/text_style.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/doctor_page/doctor_page.dart';
import 'package:sesa/ui/widgets/card/card.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/text/text.dart';
import 'package:sesa/ui/widgets/text_field/text_field.dart';

class SearchPage extends StatefulWidget {
  final List<UserDoctor> doctors;
  const SearchPage({
    Key? key,
    required this.doctors,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late CustomAppTheme customAppTheme;
  List<UserDoctor> doctors = [];
  @override
  void initState() {
    // TODO: implement initState
    doctors.addAll(widget.doctors);
    super.initState();
  }

  void filteredSearch(String query) {
    List<UserDoctor> dummySearchList = [];
    dummySearchList.addAll(widget.doctors);
    if (query.isNotEmpty) {
      List<UserDoctor> dummyListData = [];
      dummySearchList.forEach((element) {
        if (element.lastName.toLowerCase().contains(query) ||
            element.firstName.toLowerCase().contains(query)) {
          dummyListData.add(element);
        }
      });
      setState(() {
        doctors.clear();
        doctors.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        doctors.clear();
        doctors.addAll(widget.doctors);
      });
    }
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
                  "Specialité : " + doctor.speciality.name,
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
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        return Scaffold(
          backgroundColor: customAppTheme.kBackgroundColorFinal,
          appBar: AppBar(
            backgroundColor: kPrimary,
            title: Text("Recherche"),
            centerTitle: true,
            automaticallyImplyLeading: true,
          ),
          body: ListView(
            children: [
              FxSpacing.height(20),
              Padding(
                padding: FxSpacing.horizontal(24),
                child: FxTextField(
                  focusedBorderColor: AppTheme.customTheme.medicarePrimary,
                  cursorColor: AppTheme.customTheme.medicarePrimary,
                  onChanged: (value) {
                    filteredSearch(value);
                  },
                  textFieldStyle: FxTextFieldStyle.outlined,
                  labelText: 'Search a doctor',
                  labelStyle: FxTextStyle.caption(
                      color: customAppTheme.colorTextFeed, xMuted: true),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: customAppTheme.kBackgroundColor,
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.customTheme.medicarePrimary,
                    size: 20,
                  ),
                ),
              ),
              FxSpacing.height(20),
              ListView.separated(
                shrinkWrap: true,
                itemCount: doctors.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return _buildSingleDoctor(doctors[index]);
                },
                separatorBuilder: (context, index) {
                  return Container(
                    margin: Spacing.fromLTRB(75, 0, 0, 10),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
