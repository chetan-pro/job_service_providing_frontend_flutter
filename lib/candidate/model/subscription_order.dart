// class SubscriptionOrder {
//   int? id;
//   String? orderId;
//   String? amount;
//   String? planId;
//   String? currency;
//   String? paymentStatus;
//   int? status;
//   String? updatedAt;
//   String? createdAt;

//   SubscriptionOrder(
//       {this.id,
//       this.orderId,
//       this.amount,
//       this.planId,
//       this.currency,
//       this.paymentStatus,
//       this.status,
//       this.updatedAt,
//       this.createdAt});

//   SubscriptionOrder.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     orderId = json['order_id'];
//     amount = json['amount'].toString();
//     planId = json['plan_id'];
//     currency = json['currency'];
//     paymentStatus = json['payment_status'];
//     status = json['status'];
//     updatedAt = json['updatedAt'];
//     createdAt = json['createdAt'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['order_id'] = this.orderId;
//     data['amount'] = this.amount;
//     data['plan_id'] = this.planId;
//     data['currency'] = this.currency;
//     data['payment_status'] = this.paymentStatus;
//     data['status'] = this.status;
//     data['updatedAt'] = this.updatedAt;
//     data['createdAt'] = this.createdAt;
//     return data;
//   }
// }


class SubscriptionOrder {
  int? id;
  String? orderId;
  String? totalAmount;
  String? walletAmount;
  String? eAmount;
  String? planId;
  String? currency;
  String? paymentType;
  String? updatedAt;
  String? createdAt;

  SubscriptionOrder(
      {this.id,
      this.orderId,
      this.totalAmount,
      this.walletAmount,
      this.eAmount,
      this.planId,
      this.currency,
      this.paymentType,
      this.updatedAt,
      this.createdAt});

  SubscriptionOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    totalAmount = json['total_amount'].toString();
    walletAmount = json['wallet_amount'].toString();
    eAmount = json['e_amount'].toString();
    planId = json['plan_id'];
    currency = json['currency'];
    paymentType = json['payment_type'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['total_amount'] = this.totalAmount;
    data['wallet_amount'] = this.walletAmount;
    data['e_amount'] = this.eAmount;
    data['plan_id'] = this.planId;
    data['currency'] = this.currency;
    data['payment_type'] = this.paymentType;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
