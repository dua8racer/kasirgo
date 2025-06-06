import 'store_model.dart';

class UserModel {
  String? id;
  String? storeId;
  String? username;
  String? fullName;
  String? role;
  bool? isActive;
  StoreModel? store;

  UserModel({
    this.id,
    this.storeId,
    this.username,
    this.fullName,
    this.role,
    this.isActive,
    this.store,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    username = json['username'];
    fullName = json['full_name'];
    role = json['role'];
    isActive = json['is_active'];
    store = json['store'] != null ? StoreModel.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['store_id'] = storeId;
    data['username'] = username;
    data['full_name'] = fullName;
    data['role'] = role;
    data['is_active'] = isActive;
    if (store != null) {
      data['store'] = store!.toJson();
    }
    return data;
  }
}
