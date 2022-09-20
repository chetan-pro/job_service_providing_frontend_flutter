class SubscriptionList {
  int? count;
  List<Subscription>? subscription;

  SubscriptionList({this.count, this.subscription});

  SubscriptionList.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      subscription = <Subscription>[];
      json['rows'].forEach((v) {
        subscription!.add(new Subscription.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.subscription != null) {
      data['rows'] = this.subscription!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subscription {
  int? id;
  String? title;
  String? description;
  String? amount;
  int? expiryDays;
  String? userRoleType;
  String? offer;
  String? offerType;
  int? discountedAmount;
  int? jobLimit;
  int? descriptionLimit;
  String? planType;
  String? planTypeArea;
  String? planSubType;
  String? jobBoosting;
  int? jobBoostingDays;
  int? connectedPlanId;
  int? emailLimit;
  int? cvLimit;
  int? status;
  String? createdAt;
  String? updatedAt;

  Subscription(
      {this.id,
      this.title,
      this.description,
      this.amount,
      this.expiryDays,
      this.userRoleType,
      this.offer,
      this.offerType,
      this.discountedAmount,
      this.jobLimit,
      this.descriptionLimit,
      this.planType,
      this.planTypeArea,
      this.planSubType,
      this.jobBoosting,
      this.jobBoostingDays,
      this.connectedPlanId,
      this.emailLimit,
      this.cvLimit,
      this.status,
      this.createdAt,
      this.updatedAt});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    amount = json['amount'];
    expiryDays = json['expiry_days'];
    userRoleType = json['user_role_type'];
    offer = json['offer'];
    offerType = json['offer_type'];
    discountedAmount = json['discounted_amount'];
    jobLimit = json['job_limit'];
    descriptionLimit = json['description_limit'];
    planType = json['plan_type'];
    planTypeArea = json['plan_type_area'];
    planSubType = json['plan_sub_type'];
    jobBoosting = json['job_boosting'];
    jobBoostingDays = json['job_boosting_days'];
    connectedPlanId = json['connected_plan_id'];
    emailLimit = json['email_limit'];
    cvLimit = json['cv_limit'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['expiry_days'] = this.expiryDays;
    data['user_role_type'] = this.userRoleType;
    data['offer'] = this.offer;
    data['offer_type'] = this.offerType;
    data['discounted_amount'] = this.discountedAmount;
    data['job_limit'] = this.jobLimit;
    data['description_limit'] = this.descriptionLimit;
    data['plan_type'] = this.planType;
    data['plan_type_area'] = this.planTypeArea;
    data['plan_sub_type'] = this.planSubType;
    data['job_boosting'] = this.jobBoosting;
    data['job_boosting_days'] = this.jobBoostingDays;
    data['connected_plan_id'] = this.connectedPlanId;
    data['email_limit'] = this.emailLimit;
    data['cv_limit'] = this.cvLimit;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
