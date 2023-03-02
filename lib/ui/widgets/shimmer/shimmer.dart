import 'package:flutter/material.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/SizeConfig.dart';
import '../../utils/spacing.dart';
import '../container/container.dart';

Widget shimmerForum(
    {required BuildContext context, required CustomAppTheme customAppTheme}) {
  return Container(
    margin: Spacing.fromLTRB(5, 0, 0, 16),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: customAppTheme.kBackgroundColor,
    ),
    child: Row(
      children: [
        Shimmer.fromColors(
          child: FxContainer(
            paddingAll: 0,
            borderRadiusAll: 8,
            color: customAppTheme.kBackgroundColor,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image(
                width: 72,
                height: 72,
                image: AssetImage("assets/images/profile.png"),
              ),
            ),
          ),
          baseColor: Colors.grey.shade100,
          highlightColor: Colors.grey,
        ),
        FxSpacing.width(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              child: Container(
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: customAppTheme.kBackgroundColor,
                ),
                //color: COlors,
              ),
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.grey,
            ),
            FxSpacing.height(8),
            Row(
              children: [
                Shimmer.fromColors(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width / 2.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: customAppTheme.kBackgroundColor,
                    ),
                    //color: COlors,
                  ),
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.grey,
                ),
              ],
            ),
            FxSpacing.height(8),
            Row(
              children: [
                Shimmer.fromColors(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width / 2.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: customAppTheme.kBackgroundColor,
                    ),
                    //color: COlors,
                  ),
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.grey,
                ),
              ],
            )
          ],
        )
      ],
    ),
  );
}

Widget shimmerCategory(
    {required BuildContext context, required CustomAppTheme customAppTheme}) {
  return Container(
    //margin: Spacing.fromLTRB(24, 10, 24, 0),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: customAppTheme.kBackgroundColor,
    ),
    child: Row(
      children: [
        Shimmer.fromColors(
          child: FxContainer(
            paddingAll: 0,
            borderRadiusAll: 8,
            color: customAppTheme.kBackgroundColor,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image(
                width: 72,
                height: 72,
                image: AssetImage("assets/images/profile.png"),
              ),
            ),
          ),
          baseColor: Colors.grey.shade100,
          highlightColor: Colors.grey,
        ),
      ],
    ),
  );
}

Widget shimmerFeed(
    {required BuildContext context, required CustomAppTheme customAppTheme}) {
  return Container(
    //margin: Spacing.fromLTRB(24, 10, 24, 0),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(8),
        //color: customAppTheme.kBackgroundColor,
        ),
    child: Column(
      children: [
        Row(
          children: [
            Shimmer.fromColors(
              child: FxContainer(
                paddingAll: 0,
                borderRadiusAll: 8,
                color: customAppTheme.kBackgroundColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Image(
                    width: 72,
                    height: 72,
                    image: AssetImage("assets/images/profile.png"),
                  ),
                ),
              ),
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.grey,
            ),
            FxSpacing.width(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: customAppTheme.kBackgroundColor,
                    ),
                    //color: COlors,
                  ),
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.grey,
                ),
                FxSpacing.height(8),
                Row(
                  children: [
                    Shimmer.fromColors(
                      child: Container(
                        padding: EdgeInsets.all(3),
                        width: MediaQuery.of(context).size.width / 2.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: customAppTheme.kBackgroundColor,
                        ),
                        //color: COlors,
                      ),
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.grey,
                    ),
                  ],
                ),
                FxSpacing.height(8),
                Row(
                  children: [
                    Shimmer.fromColors(
                      child: Container(
                        padding: EdgeInsets.all(3),
                        width: MediaQuery.of(context).size.width / 2.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: customAppTheme.kBackgroundColor,
                        ),
                        //color: COlors,
                      ),
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.grey,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
        FxSpacing.height(10),
        Shimmer.fromColors(
          child: FxContainer(
            paddingAll: 0,
            borderRadiusAll: 8,
            color: CustomAppTheme.darkCustomAppTheme.kBackgroundColor,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image(
                width: MediaQuery.of(context).size.width,
                height: 240,
                image: AssetImage("assets/images/profile.png"),
              ),
            ),
          ),
          baseColor: Colors.grey.shade100,
          highlightColor: Colors.grey,
        ),
      ],
    ),
  );
}

Widget shimmerMedFacilitities(
    {required BuildContext context, required CustomAppTheme customAppTheme}) {
  return Container(
    //margin: Spacing.fromLTRB(24, 10, 24, 0),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(8),
        //color: customAppTheme.kBackgroundColor,
        ),
    child: Column(
      children: [
        Shimmer.fromColors(
          child: FxContainer(
            paddingAll: 0,
            borderRadiusAll: 8,
            color: CustomAppTheme.darkCustomAppTheme.kBackgroundColor,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image(
                width: MediaQuery.of(context).size.width,
                height: 180,
                image: AssetImage("assets/images/profile.png"),
              ),
            ),
          ),
          baseColor: Colors.grey.shade100,
          highlightColor: Colors.grey,
        ),
        FxSpacing.height(10),
        Row(
          children: [
            //FxSpacing.width(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: customAppTheme.kBackgroundColor,
                    ),
                    //color: COlors,
                  ),
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.grey,
                ),
                FxSpacing.height(8),
                Row(
                  children: [
                    Shimmer.fromColors(
                      child: Container(
                        padding: EdgeInsets.all(3),
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: customAppTheme.kBackgroundColor,
                        ),
                        //color: COlors,
                      ),
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.grey,
                    ),
                  ],
                ),
                FxSpacing.height(8),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      child: Container(
                        padding: EdgeInsets.all(3),
                        width: MediaQuery.of(context).size.width / 1.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: customAppTheme.kBackgroundColor,
                        ),
                        //color: COlors,
                      ),
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.grey,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ],
    ),
  );
}

Widget shimmerMyAppointment(
    {required BuildContext context, required CustomAppTheme customAppTheme}) {
  return Container(
    margin: Spacing.fromLTRB(0, 0, 0, 16),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: customAppTheme.kBackgroundColor,
    ),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              child: Container(
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: customAppTheme.kBackgroundColor,
                ),
                //color: COlors,
              ),
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.grey,
            ),
            FxSpacing.height(8),
            Row(
              children: [
                Shimmer.fromColors(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width / 2.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: customAppTheme.kBackgroundColor,
                    ),
                    //color: COlors,
                  ),
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.grey,
                ),
              ],
            ),
            FxSpacing.height(8),
            Row(
              children: [
                Shimmer.fromColors(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width / 2.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: customAppTheme.kBackgroundColor,
                    ),
                    //color: COlors,
                  ),
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.grey,
                ),
              ],
            )
          ],
        )
      ],
    ),
  );
}
