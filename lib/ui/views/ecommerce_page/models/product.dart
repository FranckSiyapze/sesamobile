import 'package:sesa/ui/widgets/generator.dart';

class Product {
  final String name, description, image;
  final double price, discountedPrice;

  Product(this.name, this.description, this.image, this.price,
      this.discountedPrice);

  static List<Product> getList() {
    return [
      Product("Orange Fresh Juice", Generator.getDummyText(8),
          "assets/images/product_2.png", 3000, 2000),
      Product("Fresh Carrot", Generator.getDummyText(8),
          "assets/images/product_2.png", 1500, 1000),
      Product("Juicy Grapes", Generator.getDummyText(8),
          "assets/images/product_2.png", 500, 500),
      Product("Green Broccoli", Generator.getDummyText(8),
          "assets/images/product_2.png", 3999, 2999),
      Product("Cauliflower", Generator.getDummyText(8),
          "assets/images/product_2.png", 2500, 2500),
    ];
  }
}
