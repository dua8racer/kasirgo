import 'payment_model.dart';
import 'transaction_item_model.dart';

class TransactionModel {
  String? id;
  String? storeId;
  String? sessionId;
  String? userId;
  String? queueNumber;
  String? customerName;
  double? subtotal;
  String? discountId;
  double? discountAmount;
  String? taxId;
  double? taxAmount;
  double? total;
  String? status;
  String? notes;
  List<TransactionItemModel>? items;
  PaymentModel? payment;
  String? createdAt;

  TransactionModel({
    this.id,
    this.storeId,
    this.sessionId,
    this.userId,
    this.queueNumber,
    this.customerName,
    this.subtotal,
    this.discountId,
    this.discountAmount,
    this.taxId,
    this.taxAmount,
    this.total,
    this.status,
    this.notes,
    this.items,
    this.payment,
    this.createdAt,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    sessionId = json['session_id'];
    userId = json['user_id'];
    queueNumber = json['queue_number'];
    customerName = json['customer_name'];
    subtotal = json['subtotal']?.toDouble();
    discountId = json['discount_id'];
    discountAmount = json['discount_amount']?.toDouble();
    taxId = json['tax_id'];
    taxAmount = json['tax_amount']?.toDouble();
    total = json['total']?.toDouble();
    status = json['status'];
    notes = json['notes'];
    if (json['items'] != null) {
      items = <TransactionItemModel>[];
      json['items'].forEach((v) {
        items!.add(TransactionItemModel.fromJson(v));
      });
    }
    payment =
        json['payment'] != null ? PaymentModel.fromJson(json['payment']) : null;
    createdAt = json['created_at'];
  }
}
