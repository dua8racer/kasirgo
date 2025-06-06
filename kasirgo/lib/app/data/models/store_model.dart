class StoreModel {
  String? id;
  String? name;
  String? address;
  String? phone;
  String? logo;
  String? receiptHeader;
  String? receiptFooter;

  StoreModel({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.logo,
    this.receiptHeader,
    this.receiptFooter,
  });

  StoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    logo = json['logo'];
    receiptHeader = json['receipt_header'];
    receiptFooter = json['receipt_footer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['phone'] = phone;
    data['logo'] = logo;
    data['receipt_header'] = receiptHeader;
    data['receipt_footer'] = receiptFooter;
    return data;
  }
}
