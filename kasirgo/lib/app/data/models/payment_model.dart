class PaymentModel {
  String? id;
  String? transactionId;
  String? method;
  double? amount;
  double? amountReceived;
  double? change;
  String? reference;
  String? status;

  PaymentModel({
    this.id,
    this.transactionId,
    this.method,
    this.amount,
    this.amountReceived,
    this.change,
    this.reference,
    this.status,
  });

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    method = json['method'];
    amount = json['amount']?.toDouble();
    amountReceived = json['amount_received']?.toDouble();
    change = json['change']?.toDouble();
    reference = json['reference'];
    status = json['status'];
  }
}
