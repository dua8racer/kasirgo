import 'category_model.dart';
import 'product_modifier_model.dart';

class ProductModel {
  String? id;
  String? storeId;
  String? categoryId;
  String? sku;
  String? name;
  String? description;
  double? price;
  String? image;
  int? stock;
  int? minStock;
  bool? isActive;
  CategoryModel? category;
  List<ProductModifierModel>? modifiers;

  ProductModel({
    this.id,
    this.storeId,
    this.categoryId,
    this.sku,
    this.name,
    this.description,
    this.price,
    this.image,
    this.stock,
    this.minStock,
    this.isActive,
    this.category,
    this.modifiers,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    categoryId = json['category_id'];
    sku = json['sku'];
    name = json['name'];
    description = json['description'];
    price = json['price']?.toDouble();
    image = json['image'];
    stock = json['stock'];
    minStock = json['min_stock'];
    isActive = json['is_active'];
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
    if (json['modifiers'] != null) {
      modifiers = <ProductModifierModel>[];
      json['modifiers'].forEach((v) {
        modifiers!.add(ProductModifierModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['store_id'] = storeId;
    data['category_id'] = categoryId;
    data['sku'] = sku;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['image'] = image;
    data['stock'] = stock;
    data['min_stock'] = minStock;
    data['is_active'] = isActive;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (modifiers != null) {
      data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
