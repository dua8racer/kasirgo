class TransactionItemModel {
  String? id;
  String? transactionId;
  String? productId;
  String? productName;
  double? price;
  int? quantity;
  String? modifiers;
  String? notes;
  double? subtotal;

  TransactionItemModel({
    this.id,
    this.transactionId,
    this.productId,
    this.productName,
    this.price,
    this.quantity,
    this.modifiers,
    this.notes,
    this.subtotal,
  });

  TransactionItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    price = json['price']?.toDouble();
    quantity = json['quantity'];
    modifiers = json['modifiers'];
    notes = json['notes'];
    subtotal = json['subtotal']?.toDouble();
  }
}
