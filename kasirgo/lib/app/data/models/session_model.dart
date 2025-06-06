class SessionModel {
  String? id;
  String? storeId;
  String? userId;
  double? startCash;
  double? endCash;
  double? totalSales;
  double? totalCashSales;
  double? totalNonCash;
  String? status;
  String? startedAt;
  String? closedAt;

  SessionModel({
    this.id,
    this.storeId,
    this.userId,
    this.startCash,
    this.endCash,
    this.totalSales,
    this.totalCashSales,
    this.totalNonCash,
    this.status,
    this.startedAt,
    this.closedAt,
  });

  SessionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    userId = json['user_id'];
    startCash = json['start_cash']?.toDouble();
    endCash = json['end_cash']?.toDouble();
    totalSales = json['total_sales']?.toDouble();
    totalCashSales = json['total_cash_sales']?.toDouble();
    totalNonCash = json['total_non_cash']?.toDouble();
    status = json['status'];
    startedAt = json['started_at'];
    closedAt = json['closed_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['start_cash'] = startCash;
    return data;
  }
}
