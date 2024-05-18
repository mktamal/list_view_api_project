class ProductModel {
  String? id;
  String? image;
  String? productCode;
  String? productName;
  String? quantity;
  String? totalPrice;
  String? unitPrice;

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    image = json['Img'];
    productCode = json['ProductCode'];
    productName = json['ProductName'];
    quantity = json['Qty'];
    totalPrice = json['TotalPrice'];
    unitPrice = json['UnitPrice'];
  }
}
