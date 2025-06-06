import 'dart:convert';

class ProductModifierModel {
  String? id;
  String? productId;
  String? name;
  List<ModifierOption>? options;
  bool? isRequired;
  int? maxSelect;

  ProductModifierModel({
    this.id,
    this.productId,
    this.name,
    this.options,
    this.isRequired,
    this.maxSelect,
  });

  ProductModifierModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    name = json['name'];
    if (json['options'] != null) {
      if (json['options'] is String) {
        final optionsList = jsonDecode(json['options']) as List;
        options = optionsList.map((e) => ModifierOption.fromJson(e)).toList();
      } else if (json['options'] is List) {
        options = (json['options'] as List)
            .map((e) => ModifierOption.fromJson(e))
            .toList();
      }
    }
    isRequired = json['is_required'];
    maxSelect = json['max_select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['product_id'] = productId;
    data['name'] = name;
    if (options != null) {
      data['options'] = jsonEncode(options!.map((v) => v.toJson()).toList());
    }
    data['is_required'] = isRequired;
    data['max_select'] = maxSelect;
    return data;
  }
}

class ModifierOption {
  String? name;
  double? price;

  ModifierOption({this.name, this.price});

  ModifierOption.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}
