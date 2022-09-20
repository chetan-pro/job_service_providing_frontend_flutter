class ActiveSubscriptionDetailsModel {
  int? count;
  List<ActiveSubscriptionDetail>? activeSubscriptionDetails;

  ActiveSubscriptionDetailsModel({this.count, this.activeSubscriptionDetails});

  ActiveSubscriptionDetailsModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      activeSubscriptionDetails = <ActiveSubscriptionDetail>[];
      json['rows'].forEach((v) {
        activeSubscriptionDetails!
            .add(ActiveSubscriptionDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (activeSubscriptionDetails != null) {
      data['rows'] = activeSubscriptionDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActiveSubscriptionDetail {
  int? id;
  int? userId;
  int? planId;
  int? jobLimit;
  int? emailLimit;
  int? cvLimit;
  String? planType;
  int? freePlanId;
  String? startDate;
  String? expiryDate;
  int? status;
  int? availableJobLimits;
  int? availableEmailLimits;
  int? availableCvlLimits;
  String? createdAt;
  String? updatedAt;
  SubscriptionPlans? subscriptionPlans;

  ActiveSubscriptionDetail(
      {this.id,
      this.userId,
      this.planId,
      this.jobLimit,
      this.emailLimit,
      this.cvLimit,
      this.planType,
      this.freePlanId,
      this.startDate,
      this.expiryDate,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.availableJobLimits,
      this.availableEmailLimits,
      this.availableCvlLimits,
      this.subscriptionPlans});

  ActiveSubscriptionDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    planId = json['plan_id'];
    jobLimit = json['job_limit'];
    emailLimit = json['email_limit'];
    cvLimit = json['cv_limit'];
    planType = json['plan_type'];
    freePlanId = json['free_plan_id'];
    startDate = json['start_date'];
    expiryDate = json['expiry_date'];
    status = json['status'];
    availableJobLimits = json['AvailableJobLimits'];
    availableEmailLimits = json['AvailableEmailLimits'];
    availableCvlLimits = json['AvailableCvlLimits'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['SubscriptionPlan'] != null) {
      subscriptionPlans =  SubscriptionPlans.fromJson(json['SubscriptionPlan'] );
      }
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['plan_id'] = planId;
    data['job_limit'] = jobLimit;
    data['email_limit'] = emailLimit;
    data['cv_limit'] = cvLimit;
    data['plan_type'] = planType;
    data['free_plan_id'] = freePlanId;
    data['start_date'] = startDate;
    data['expiry_date'] = expiryDate;
    data['status'] = status;
    data['AvailableJobLimits'] = availableJobLimits;
    data['AvailableEmailLimits'] = availableEmailLimits;
    data['AvailableCvlLimits'] = availableCvlLimits;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (subscriptionPlans != null) {
      data['SubscriptionPlan'] =
          subscriptionPlans;
    }
    return data;
  }
}

class SubscriptionPlans {
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

  SubscriptionPlans(
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

  SubscriptionPlans.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['amount'] = amount;
    data['expiry_days'] = expiryDays;
    data['user_role_type'] = userRoleType;
    data['offer'] = offer;
    data['offer_type'] = offerType;
    data['discounted_amount'] = discountedAmount;
    data['job_limit'] = jobLimit;
    data['description_limit'] = descriptionLimit;
    data['plan_type'] = planType;
    data['plan_type_area'] = planTypeArea;
    data['plan_sub_type'] = planSubType;
    data['job_boosting'] = jobBoosting;
    data['job_boosting_days'] = jobBoostingDays;
    data['connected_plan_id'] = connectedPlanId;
    data['email_limit'] = emailLimit;
    data['cv_limit'] = cvLimit;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
