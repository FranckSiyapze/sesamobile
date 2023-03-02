class Cart {
  final String name, image;
  final double price, discountedPrice;
  final int quantity;

  Cart(this.name, this.image, this.price, this.discountedPrice, this.quantity);

  static List<Cart> getList() {
    return [
      Cart("Orange Fresh Juice", "assets/images/product_2.png", 5999, 4999, 2),
      Cart("Fresh Carrot", "assets/images/product_2.png", 1999, 1999, 4),
    ];
  }
}
