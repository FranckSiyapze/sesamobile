import 'package:flutter/cupertino.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';

class Category {
  final String image, title;
  final Color color;

  Category(this.image, this.title, this.color);

  static List<Category> getList() {
    return [
      Category("./assets/images/customapps/grocery/strawberry.png", "Fruit",
          CustomAppTheme.lightCustomAppTheme.red.withAlpha(50)),
      Category("./assets/images/customapps/grocery/bread.png", "Bread",
          CustomAppTheme.lightCustomAppTheme.orange.withAlpha(60)),
      Category("./assets/images/customapps/grocery/broccoli.png", "Veggie",
          CustomAppTheme.lightCustomAppTheme.green.withAlpha(50)),
      Category("./assets/images/customapps/grocery/cheese.png", "Dairy",
          CustomAppTheme.lightCustomAppTheme.yellow.withAlpha(70)),
    ];
  }
}
