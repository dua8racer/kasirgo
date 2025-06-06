class CategoryModel {
  String? id;
  String? storeId;
  String? name;
  String? icon;
  int? order;
  bool? isActive;

  CategoryModel({
    this.id,
    this.storeId,
    this.name,
    this.icon,
    this.order,
    this.isActive,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    name = json['name'];
    icon = json['icon'];
    order = json['order'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['store_id'] = storeId;
    data['name'] = name;
    data['icon'] = icon;
    data['order'] = order;
    data['is_active'] = isActive;
    return data;
  }
}
