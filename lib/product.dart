class Product {
  String id;
  String image;
  String productCode;
  String productName;
  String quantity;
  String totalPrice;
  String unitPrice;

  Product({
    required this.id,
    required this.productName,
    required this.productCode,
    required this.image,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
  });
}