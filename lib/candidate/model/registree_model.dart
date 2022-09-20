import 'package:hindustan_job/candidate/model/user_model.dart';

class RegistreeModel {
  int? count;
  List<Registree>? registree;

  RegistreeModel({this.count, this.registree});

  RegistreeModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      registree = <Registree>[];
      json['rows'].forEach((v) {
        registree!.add(Registree.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (registree != null) {
      data['rows'] = registree!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Registree {
  int? id;
  String? dateRegistered;
  int? noSubscriptionPurchased;
  String? lastSubscriptionPurchaseDate;
  UserData? registeredUser;

  Registree(
      {this.id,
      this.dateRegistered,
      this.noSubscriptionPurchased,
      this.lastSubscriptionPurchaseDate,
      this.registeredUser});

  Registree.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateRegistered = json['date_registered'];
    noSubscriptionPurchased = json['no_subscription_purchased'];
    lastSubscriptionPurchaseDate = json['last_subscription_purchase_date'];
    registeredUser = json['registered_user'] != null
        ? UserData.fromJson(json['registered_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date_registered'] = dateRegistered;
    data['no_subscription_purchased'] = noSubscriptionPurchased;
    data['last_subscription_purchase_date'] = lastSubscriptionPurchaseDate;
    if (registeredUser != null) {
      data['registered_user'] = registeredUser!.toJson();
    }
    return data;
  }
}
