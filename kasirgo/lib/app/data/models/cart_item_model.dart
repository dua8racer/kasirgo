class CartItemModel {
  String? productId;
  String? productName;
  double? price;
  int? quantity;
  String? image;
  List<SelectedModifier>? modifiers;
  String? notes;

  CartItemModel({
    this.productId,
    this.productName,
    this.price,
    this.quantity = 1,
    this.image,
    this.modifiers,
    this.notes,
  });

  double get subtotal {
    double total = (price ?? 0) * (quantity ?? 1);
    if (modifiers != null) {
      for (var modifier in modifiers!) {
        total += (modifier.price ?? 0) * (quantity ?? 1);
      }
    }
    return total;
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'modifiers': modifiers?.map((e) => e.toJson()).toList(),
      'notes': notes,
    };
  }
}

class SelectedModifier {
  String? name;
  double? price;

  SelectedModifier({this.name, this.price});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}
