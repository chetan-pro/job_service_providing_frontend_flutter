class RegistreeDetailsModel {
  int? userId;
  int? refUserId;
  int? id;
  RegisteredBy? registeredBy;
  RegisteredUser? registeredUser;

  RegistreeDetailsModel(
      {this.userId,
      this.refUserId,
      this.id,
      this.registeredBy,
      this.registeredUser});

  RegistreeDetailsModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    refUserId = json['ref_user_id'];
    id = json['id'];
    registeredBy = json['registered_by'] != null
        ?  RegisteredBy.fromJson(json['registered_by'])
        : null;
    registeredUser = json['registered_user'] != null
        ? RegisteredUser.fromJson(json['registered_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['ref_user_id'] = refUserId;
    data['id'] = id;
    if (registeredBy != null) {
      data['registered_by'] = registeredBy!.toJson();
    }
    if (registeredUser != null) {
      data['registered_user'] = registeredUser!.toJson();
    }
    return data;
  }
}

class RegisteredBy {
  int? id;
  List<WalletTransactions>? walletTransactions;

  RegisteredBy({this.id, this.walletTransactions});

  RegisteredBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['WalletTransactions'] != null) {
      walletTransactions = <WalletTransactions>[];
      json['WalletTransactions'].forEach((v) {
        walletTransactions!.add(WalletTransactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (walletTransactions != null) {
      data['WalletTransactions'] =
          walletTransactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalletTransactions {
  String? myCommission;
  List<SubscribedUsers>? subscribedUsers;

  WalletTransactions({this.myCommission, this.subscribedUsers});

  WalletTransactions.fromJson(Map<String, dynamic> json) {
    myCommission = json['my_commission'];
    if (json['SubscribedUsers'] != null) {
      subscribedUsers = <SubscribedUsers>[];
      json['SubscribedUsers'].forEach((v) {
        subscribedUsers!.add(SubscribedUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['my_commission'] = myCommission;
    if (subscribedUsers != null) {
      data['SubscribedUsers'] =
          subscribedUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubscribedUsers {
  String? date;
  SubscriptionPlan? subscriptionPlan;

  SubscribedUsers({this.date, this.subscriptionPlan});

  SubscribedUsers.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    subscriptionPlan = json['SubscriptionPlan'] != null
        ? SubscriptionPlan.fromJson(json['SubscriptionPlan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    if (subscriptionPlan != null) {
      data['SubscriptionPlan'] = subscriptionPlan!.toJson();
    }
    return data;
  }
}

class SubscriptionPlan {
  String? subscriptionPurchased;
  int? subscriptionCharge;

  SubscriptionPlan({this.subscriptionPurchased, this.subscriptionCharge});

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    subscriptionPurchased = json['subscription_purchased'];
    subscriptionCharge = json['subscription_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subscription_purchased'] = subscriptionPurchased;
    data['subscription_charge'] = subscriptionCharge;
    return data;
  }
}

class RegisteredUser {
  int? id;
  int? noSubscriptionPurchased;
  String? lastSubscriptionPurchaseDate;
  String? roleRegisteredFor;
  String? dateRegistered;
  String? image;
  String? name;
  String? mobile;

  RegisteredUser(
      {this.id,
      this.noSubscriptionPurchased,
      this.lastSubscriptionPurchaseDate,
      this.roleRegisteredFor,
      this.dateRegistered,
      this.image,
      this.name,
      this.mobile});

  RegisteredUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noSubscriptionPurchased = json['no_subscription_purchased'];
    lastSubscriptionPurchaseDate = json['last_subscription_purchase_date'];
    roleRegisteredFor = json['role_registered_for'];
    dateRegistered = json['date_registered'];
    image = json['image'];
    name = json['name'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['no_subscription_purchased'] = noSubscriptionPurchased;
    data['last_subscription_purchase_date'] = lastSubscriptionPurchaseDate;
    data['role_registered_for'] = roleRegisteredFor;
    data['date_registered'] = dateRegistered;
    data['image'] = image;
    data['name'] = name;
    data['mobile'] = mobile;
    return data;
  }
}
